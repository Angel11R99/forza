import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:forza/data/database/app_database.dart' hide NutritionProfile;
import 'package:forza/data/repositories/backup_repository.dart';
import 'package:forza/data/repositories/body_measurement_repository.dart';
import 'package:forza/data/repositories/personal_goal_repository.dart';
import 'package:forza/data/repositories/profile_settings_repository.dart';
import 'package:forza/data/repositories/training_schedule_repository.dart';
import 'package:forza/data/repositories/training_settings_repository.dart';
import 'package:forza/data/repositories/workout_log_repository.dart';
import 'package:forza/domain/models/nutrition/nutrition_models.dart';
import 'package:forza/domain/models/nutrition/hydration_models.dart';
import 'package:forza/data/repositories/hydration_repository.dart';
import 'package:forza/ui/features/profile/models/profile_settings.dart';

void main() {
  late AppDatabase database;
  late BackupRepository repository;
  late ProfileSettingsRepository profileSettings;
  late HydrationRepository hydration;

  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    database = AppDatabase(NativeDatabase.memory());
    profileSettings = ProfileSettingsRepository(
      storage: _MemoryProfilePreferencesStorage(),
    );
    hydration = HydrationRepository(storage: _MemoryHydrationStorage());
    final workoutLog = WorkoutLogRepository(database: database);
    repository = BackupRepository(
      database: database,
      settingsRepository: TrainingSettingsRepository(database: database),
      workoutLogRepository: workoutLog,
      scheduleRepository: TrainingScheduleRepository(database: database),
      goalRepository: PersonalGoalRepository(database: database),
      bodyMeasurementRepository: BodyMeasurementRepository(database: database),
      profileSettingsRepository: profileSettings,
      hydrationRepository: hydration,
    );
  });

  tearDown(() => database.close());

  Future<String> emptyBackup() =>
      repository.exportJson(appearanceMode: 'system');

  test(
    'navigation label preference survives backup export and restore',
    () async {
      await profileSettings.saveAppPreferences(
        const AppPreferences(showNavigationLabels: false),
      );

      final backup = repository.validate(await emptyBackup());
      expect(backup.appPreferences.showNavigationLabels, isFalse);

      await profileSettings.saveAppPreferences(const AppPreferences());
      await repository.restore(backup);
      expect(
        (await profileSettings.loadAppPreferences()).showNavigationLabels,
        isFalse,
      );
    },
  );

  test(
    'hydration history and preferences survive an authorized backup',
    () async {
      await hydration.replaceAll([
        HydrationEntry(
          id: 'water:backup',
          loggedAt: DateTime(2026, 11, 26, 9),
          amountMl: 350,
          drinkType: HydrationDrinkType.otherBeverage,
        ),
      ], const HydrationPreferences(glassMl: 300, dailyGoalMl: 1800));

      final backup = repository.validate(await emptyBackup());
      await hydration.replaceAll(const [], const HydrationPreferences());
      await repository.restore(backup);

      final restored = await hydration.load();
      expect(restored.entries.single.amountMl, 350);
      expect(
        restored.entries.single.drinkType,
        HydrationDrinkType.otherBeverage,
      );
      expect(restored.preferences.glassMl, 300);
      expect(restored.preferences.dailyGoalMl, 1800);
    },
  );

  test(
    'hydration is excluded when nutrition backup consent is absent',
    () async {
      await hydration.replaceAll([
        HydrationEntry(
          id: 'water:private',
          loggedAt: DateTime(2026, 11, 26),
          amountMl: 250,
        ),
      ], const HydrationPreferences());

      final source = await repository.exportJson(appearanceMode: 'system');
      final filtered = jsonDecode(repository.withoutNutrition(source)) as Map;

      expect(filtered.containsKey('hydration'), isFalse);
      expect(repository.validate(source).nutritionSnapshotIncluded, isTrue);
    },
  );

  test(
    'a local deletion is propagated over an unchanged cloud record',
    () async {
      final baseline = jsonEncode(
        _withGoal(await emptyBackup(), targetValue: 3),
      );
      final local = _withGoal(await emptyBackup(), targetValue: 3)
        ..['personalGoals'] = <Object?>[];

      final merged = repository.mergeJson(
        jsonEncode(local),
        baseline,
        baselineSource: baseline,
      );

      expect(repository.validate(merged).goals, isEmpty);
    },
  );

  test('a cloud deletion is propagated when local data is unchanged', () async {
    final baseline = jsonEncode(_withGoal(await emptyBackup(), targetValue: 3));
    final cloud = _withGoal(await emptyBackup(), targetValue: 3)
      ..['personalGoals'] = <Object?>[];

    final merged = repository.mergeJson(
      baseline,
      jsonEncode(cloud),
      baselineSource: baseline,
    );

    expect(repository.validate(merged).goals, isEmpty);
  });

  test('local edits win simultaneous edits to the same record', () async {
    final baseline = jsonEncode(_withGoal(await emptyBackup(), targetValue: 3));
    final local = _withGoal(await emptyBackup(), targetValue: 5);
    final cloud = _withGoal(await emptyBackup(), targetValue: 6);

    final merged = repository.mergeJson(
      jsonEncode(local),
      jsonEncode(cloud),
      baselineSource: baseline,
    );

    expect(repository.validate(merged).goals.single.targetValue, 5);
  });

  test(
    'first hydration sync combines entries and adopts chosen preferences',
    () async {
      final source = await emptyBackup();
      final localEntry = HydrationEntry(
        id: 'water:local',
        loggedAt: DateTime(2026, 11, 26, 8),
        amountMl: 250,
      );
      final cloudEntry = HydrationEntry(
        id: 'drink:cloud',
        loggedAt: DateTime(2026, 11, 27, 12),
        amountMl: 330,
        drinkType: HydrationDrinkType.otherBeverage,
      );
      final local = Map<String, Object?>.from(jsonDecode(source) as Map)
        ..['hydration'] = {
          'entries': [localEntry.toJson()],
          'preferences': const HydrationPreferences().toJson(),
        };
      final cloud = Map<String, Object?>.from(jsonDecode(source) as Map)
        ..['hydration'] = {
          'entries': [cloudEntry.toJson()],
          'preferences': const HydrationPreferences(
            glassMl: 300,
            dailyGoalMl: 1800,
          ).toJson(),
        };

      final merged = repository.validate(
        repository.mergeJson(jsonEncode(local), jsonEncode(cloud)),
      );

      expect(merged.hydrationEntries.map((entry) => entry.id), {
        'water:local',
        'drink:cloud',
      });
      expect(
        merged.hydrationEntries
            .singleWhere((entry) => entry.id == 'drink:cloud')
            .drinkType,
        HydrationDrinkType.otherBeverage,
      );
      expect(merged.hydrationPreferences.glassMl, 300);
      expect(merged.hydrationPreferences.dailyGoalMl, 1800);
    },
  );

  test('unchanged local settings adopt updates made in the cloud', () async {
    final baseline = await emptyBackup();
    final local = Map<String, Object?>.from(jsonDecode(baseline) as Map);
    final cloud = Map<String, Object?>.from(jsonDecode(baseline) as Map)
      ..['appearanceMode'] = 'dark';

    final merged = repository.mergeJson(
      jsonEncode(local),
      jsonEncode(cloud),
      baselineSource: baseline,
    );

    expect(repository.validate(merged).appearanceMode, 'dark');
  });

  test(
    'new backup restores nutrition while legacy backup preserves it',
    () async {
      final profile = NutritionProfile(
        id: 'local',
        version: 2,
        updatedAt: DateTime.utc(2026, 11, 27),
        restrictions: const [
          FoodRestriction(type: FoodRestrictionType.allergy, value: 'peanut'),
        ],
      );
      final entry = MealEntry(
        id: 'manual:one',
        dateTime: DateTime(2026, 11, 27, 9),
        foodId: 'food-1',
        quantityGrams: 125,
        type: MealEntryType.manual,
      );
      await profileSettings.saveNutritionProfile(profile);
      await repository.nutritionMealLogRepository.save(entry);
      await hydration.replaceAll([
        HydrationEntry(
          id: 'water:legacy',
          loggedAt: DateTime(2026, 11, 27, 8),
          amountMl: 300,
        ),
      ], const HydrationPreferences());

      final exported = await repository.exportJson(appearanceMode: 'system');
      final parsed = repository.validate(exported);
      expect(parsed.nutritionSnapshotIncluded, isTrue);
      expect(parsed.nutritionProfile?.restrictions.single.value, 'peanut');
      expect(parsed.nutritionMealEntries.single.quantityGrams, 125);
      expect(parsed.hydrationEntries.single.amountMl, 300);

      await profileSettings.clearNutritionProfile();
      await repository.nutritionMealLogRepository.clear();
      await hydration.replaceAll(const [], const HydrationPreferences());
      await repository.restore(parsed);
      expect((await profileSettings.loadNutritionProfile())?.id, 'local');
      expect(
        (await repository.nutritionMealLogRepository.loadAll()).single.id,
        entry.id,
      );
      expect((await hydration.load()).entries.single.id, 'water:legacy');

      final legacyJson = Map<String, Object?>.from(jsonDecode(exported) as Map)
        ..remove('nutritionProfile')
        ..remove('nutritionMealEntries')
        ..remove('hydration');
      await repository.restore(repository.validate(jsonEncode(legacyJson)));
      expect((await profileSettings.loadNutritionProfile())?.id, 'local');
      expect(
        (await repository.nutritionMealLogRepository.loadAll()).single.id,
        entry.id,
      );
      expect((await hydration.load()).entries.single.id, 'water:legacy');
    },
  );

  test(
    'cloud snapshot can omit nutrition without altering a local backup',
    () async {
      await profileSettings.saveNutritionProfile(
        NutritionProfile(
          id: 'local',
          version: 1,
          updatedAt: DateTime.utc(2026, 11, 27),
        ),
      );
      await repository.nutritionMealLogRepository.save(
        MealEntry(
          id: 'manual:two',
          dateTime: DateTime(2026, 11, 27),
          foodId: 'food-2',
        ),
      );
      final local = await repository.exportJson(appearanceMode: 'system');

      final stripped = repository.withoutNutrition(local);
      final cloud = repository.validate(stripped);
      expect(cloud.nutritionSnapshotIncluded, isFalse);
      expect(cloud.nutritionProfile, isNull);
      expect(cloud.nutritionMealEntries, isEmpty);
      expect(repository.validate(local).nutritionProfile?.id, 'local');

      final retained = repository.validate(
        repository.retainRemoteNutrition(stripped, local),
      );
      expect(retained.nutritionProfile?.id, 'local');
      expect(retained.nutritionMealEntries, hasLength(1));

      await repository.restore(cloud, restoreNutrition: false);
      expect((await profileSettings.loadNutritionProfile())?.id, 'local');
      expect(
        await repository.nutritionMealLogRepository.loadAll(),
        hasLength(1),
      );
    },
  );
}

Map<String, Object?> _withGoal(String source, {required int targetValue}) {
  return Map<String, Object?>.from(jsonDecode(source) as Map)
    ..['personalGoals'] = [
      {
        'id': 'goal-1',
        'type': 'sessionsPerWeek',
        'targetValue': targetValue,
        'exerciseName': null,
        'exerciseCatalogId': null,
        'createdAt': '2026-01-01T00:00:00.000',
      },
    ];
}

class _MemoryProfilePreferencesStorage implements ProfilePreferencesStorage {
  final Map<String, String> values = {};

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String value) async => values[key] = value;
}

class _MemoryHydrationStorage implements HydrationStorage {
  String? value;
  @override
  Future<String?> read() async => value;
  @override
  Future<void> write(String value) async => this.value = value;
}
