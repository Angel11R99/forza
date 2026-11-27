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
import 'package:forza/ui/features/profile/models/profile_settings.dart';

void main() {
  late AppDatabase database;
  late BackupRepository repository;
  late ProfileSettingsRepository profileSettings;

  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    database = AppDatabase(NativeDatabase.memory());
    profileSettings = ProfileSettingsRepository(
      storage: _MemoryProfilePreferencesStorage(),
    );
    final workoutLog = WorkoutLogRepository(database: database);
    repository = BackupRepository(
      database: database,
      settingsRepository: TrainingSettingsRepository(database: database),
      workoutLogRepository: workoutLog,
      scheduleRepository: TrainingScheduleRepository(database: database),
      goalRepository: PersonalGoalRepository(database: database),
      bodyMeasurementRepository: BodyMeasurementRepository(database: database),
      profileSettingsRepository: profileSettings,
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

      final exported = await repository.exportJson(appearanceMode: 'system');
      final parsed = repository.validate(exported);
      expect(parsed.nutritionSnapshotIncluded, isTrue);
      expect(parsed.nutritionProfile?.restrictions.single.value, 'peanut');
      expect(parsed.nutritionMealEntries.single.quantityGrams, 125);

      await profileSettings.clearNutritionProfile();
      await repository.nutritionMealLogRepository.clear();
      await repository.restore(parsed);
      expect((await profileSettings.loadNutritionProfile())?.id, 'local');
      expect(
        (await repository.nutritionMealLogRepository.loadAll()).single.id,
        entry.id,
      );

      final legacyJson = Map<String, Object?>.from(jsonDecode(exported) as Map)
        ..remove('nutritionProfile')
        ..remove('nutritionMealEntries');
      await repository.restore(repository.validate(jsonEncode(legacyJson)));
      expect((await profileSettings.loadNutritionProfile())?.id, 'local');
      expect(
        (await repository.nutritionMealLogRepository.loadAll()).single.id,
        entry.id,
      );
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
