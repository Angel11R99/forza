import 'dart:convert';

import 'package:drift/native.dart';
import 'package:forza/data/database/app_database.dart' hide NutritionProfile;
import 'package:flutter_test/flutter_test.dart';
import 'package:forza/data/repositories/profile_settings_repository.dart';
import 'package:forza/domain/models/nutrition/nutrition_models.dart';
import 'package:forza/ui/features/profile/models/profile_settings.dart';

void main() {
  test(
    'nutrition profile persists locally and can be cleared for guests',
    () async {
      final storage = _MemoryProfilePreferencesStorage();
      final repository = ProfileSettingsRepository(storage: storage);
      expect(await repository.loadNutritionProfile(), isNull);

      final profile = NutritionProfile(
        id: 'local-profile',
        version: 1,
        updatedAt: DateTime.utc(2026, 11, 27),
        dietaryPattern: DietaryPattern.vegetarian,
        restrictions: const [
          FoodRestriction(type: FoodRestrictionType.allergy, value: 'peanut'),
        ],
      );
      await repository.saveNutritionProfile(profile);

      final restored = await repository.loadNutritionProfile();
      expect(restored?.dietaryPattern, DietaryPattern.vegetarian);
      expect(restored?.restrictions.single.type, FoodRestrictionType.allergy);
      await repository.clearNutritionProfile();
      expect(await repository.loadNutritionProfile(), isNull);
    },
  );

  test('imports the legacy nutrition profile into the Drift table', () async {
    final database = AppDatabase(NativeDatabase.memory());
    final storage = _MemoryProfilePreferencesStorage();
    final legacyProfile = NutritionProfile(
      id: 'legacy-profile',
      version: 2,
      updatedAt: DateTime.utc(2026, 11, 27),
      dietaryPattern: DietaryPattern.vegan,
    );
    storage.values['nutrition_profile_v1'] = jsonEncode(legacyProfile.toJson());
    final repository = ProfileSettingsRepository(
      database: database,
      storage: storage,
    );

    expect(
      (await repository.loadNutritionProfile())?.dietaryPattern,
      DietaryPattern.vegan,
    );
    expect(
      await database.select(database.nutritionProfiles).get(),
      hasLength(1),
    );
    await repository.clearNutritionProfile();
    expect(await repository.loadNutritionProfile(), isNull);
    await database.close();
  });

  test(
    'saves and restores every profile preference without writing defaults',
    () async {
      final storage = _MemoryProfilePreferencesStorage();
      final firstRepository = ProfileSettingsRepository(storage: storage);

      final defaultPreferences = await firstRepository.loadAppPreferences();
      expect(defaultPreferences.weightUnit, 'kg');
      expect(defaultPreferences.weekStartsOn, 'Lunes');
      expect(defaultPreferences.hapticsEnabled, isTrue);
      expect(defaultPreferences.showNavigationLabels, isTrue);
      final defaultNotifications = await firstRepository.loadNotifications();
      expect(defaultNotifications.workoutReminders, isFalse);
      expect(defaultNotifications.reminderHour, 18);
      expect(defaultNotifications.reminderMinute, 0);
      final defaultPrivacy = await firstRepository.loadPrivacy();
      expect(defaultPrivacy.privateProfile, isTrue);
      expect(defaultPrivacy.shareWorkoutActivity, isFalse);
      expect(storage.values, isEmpty);

      const appPreferences = AppPreferences(
        weightUnit: 'lb',
        weekStartsOn: 'Domingo',
        hapticsEnabled: false,
        showNavigationLabels: false,
      );
      const notifications = NotificationSettings(
        workoutReminders: true,
        reminderHour: 7,
        reminderMinute: 35,
      );
      const privacy = PrivacySettings(
        privateProfile: false,
        shareWorkoutActivity: true,
      );
      await firstRepository.saveAppPreferences(appPreferences);
      await firstRepository.saveNotifications(notifications);
      await firstRepository.savePrivacy(privacy);

      final reopenedRepository = ProfileSettingsRepository(storage: storage);
      final restoredAppPreferences = await reopenedRepository
          .loadAppPreferences();
      final restoredNotifications = await reopenedRepository
          .loadNotifications();
      final restoredPrivacy = await reopenedRepository.loadPrivacy();

      expect(restoredAppPreferences.weightUnit, 'lb');
      expect(restoredAppPreferences.weekStartsOn, 'Domingo');
      expect(restoredAppPreferences.hapticsEnabled, isFalse);
      expect(restoredAppPreferences.showNavigationLabels, isFalse);
      expect(restoredNotifications.workoutReminders, isTrue);
      expect(restoredNotifications.reminderHour, 7);
      expect(restoredNotifications.reminderMinute, 35);
      expect(restoredPrivacy.privateProfile, isFalse);
      expect(restoredPrivacy.shareWorkoutActivity, isTrue);
    },
  );

  test(
    'reads existing notification settings and ignores retired toggles',
    () async {
      final storage = _MemoryProfilePreferencesStorage()
        ..values['profile_notifications_v1'] =
            '{"workoutReminders":true,"weeklySummary":true,'
            '"personalRecordAlerts":true,"reminderHour":6,"reminderMinute":15}';
      final repository = ProfileSettingsRepository(storage: storage);

      final notifications = await repository.loadNotifications();

      expect(notifications.workoutReminders, isTrue);
      expect(notifications.reminderHour, 6);
      expect(notifications.reminderMinute, 15);
    },
  );

  test('older app preferences default navigation labels to visible', () async {
    final storage = _MemoryProfilePreferencesStorage()
      ..values['profile_app_preferences_v1'] =
          '{"weightUnit":"kg","weekStartsOn":"Lunes",'
          '"hapticsEnabled":true}';
    final repository = ProfileSettingsRepository(storage: storage);

    final preferences = await repository.loadAppPreferences();

    expect(preferences.showNavigationLabels, isTrue);
  });

  test('does not turn malformed saved preferences into defaults', () async {
    final storage = _MemoryProfilePreferencesStorage()
      ..values['profile_app_preferences_v1'] = '{invalid';
    final repository = ProfileSettingsRepository(storage: storage);

    await expectLater(repository.loadAppPreferences(), throwsFormatException);
    expect(storage.values['profile_app_preferences_v1'], '{invalid');
  });

  test('reports failed writes and validates reminder ranges', () async {
    final storage = _MemoryProfilePreferencesStorage()..failWrites = true;
    final repository = ProfileSettingsRepository(storage: storage);

    await expectLater(
      repository.saveAppPreferences(const AppPreferences(weightUnit: 'lb')),
      throwsStateError,
    );
    await expectLater(
      repository.saveNotifications(
        const NotificationSettings(reminderHour: 24),
      ),
      throwsArgumentError,
    );
    expect(storage.values, isEmpty);
  });

  test('cloud sync consent is opt-in and scoped to each account', () async {
    final storage = _MemoryProfilePreferencesStorage();
    final repository = ProfileSettingsRepository(storage: storage);

    expect(await repository.isCloudSyncEnabled('uid-a'), isFalse);
    expect(await repository.isNutritionCloudSyncEnabled('uid-a'), isFalse);
    expect(await repository.isNutritionCloudSyncEnabled('uid-b'), isFalse);
    await repository.setCloudSyncEnabled('uid-a', true);
    await repository.setNutritionCloudSyncEnabled('uid-a', true);
    expect(await repository.isCloudSyncEnabled('uid-a'), isTrue);
    expect(await repository.isCloudSyncEnabled('uid-b'), isFalse);
    expect(await repository.isNutritionCloudSyncEnabled('uid-a'), isTrue);
    expect(await repository.isNutritionCloudSyncEnabled('uid-b'), isFalse);

    await repository.setPendingCloudSync('uid-a', true);
    expect(await repository.hasPendingCloudSync('uid-a'), isTrue);
    await repository.markCloudSyncCompleted('uid-a', DateTime.utc(2026, 1, 1));
    expect(await repository.hasPendingCloudSync('uid-a'), isFalse);
    expect(await repository.lastCloudSync('uid-a'), DateTime.utc(2026, 1, 1));
  });

  test(
    'cloud sync frequency persists independently for each account',
    () async {
      final repository = ProfileSettingsRepository(
        storage: _MemoryProfilePreferencesStorage(),
      );

      expect(
        await repository.cloudSyncFrequency('uid-a'),
        CloudSyncFrequency.onChange,
      );
      await repository.setCloudSyncFrequency(
        'uid-a',
        CloudSyncFrequency.manual,
      );
      await repository.setCloudSyncFrequency(
        'uid-b',
        CloudSyncFrequency.weekly,
      );

      expect(
        await repository.cloudSyncFrequency('uid-a'),
        CloudSyncFrequency.manual,
      );
      expect(
        await repository.cloudSyncFrequency('uid-b'),
        CloudSyncFrequency.weekly,
      );
    },
  );
}

class _MemoryProfilePreferencesStorage implements ProfilePreferencesStorage {
  final Map<String, String> values = {};
  bool failWrites = false;

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String value) async {
    if (failWrites) throw StateError('write failed');
    values[key] = value;
  }
}
