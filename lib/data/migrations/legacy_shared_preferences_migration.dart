import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/models/workout_record.dart';
import '../../ui/features/profile/models/profile_settings.dart';
import '../database/app_database.dart';
import '../repositories/training_settings_repository.dart';
import '../repositories/workout_log_repository.dart';

class LegacySharedPreferencesMigration {
  LegacySharedPreferencesMigration({
    required this.database,
    required this.settingsRepository,
    required this.workoutLogRepository,
    LegacyPreferenceStore? preferences,
  }) : _preferences =
           preferences ?? SharedLegacyPreferenceStore(SharedPreferencesAsync());

  static const _migrationKey = 'migration_shared_preferences_v1';
  static const _completeKey = 'training_setup_complete';
  static const _daysKey = 'training_days';
  static const _minutesKey = 'training_session_minutes';
  static const _goalKey = 'training_goal';
  static const _experienceKey = 'training_experience';
  static const _equipmentKey = 'training_equipment';
  static const _recordsKey = 'workout_records';

  final AppDatabase database;
  final TrainingSettingsRepository settingsRepository;
  final WorkoutLogRepository workoutLogRepository;
  final LegacyPreferenceStore _preferences;

  Future<void> run() async {
    final marker = await (database.select(
      database.appMetadata,
    )..where((row) => row.key.equals(_migrationKey))).getSingleOrNull();
    if (marker?.value == 'true') return;

    final savedDays = await _preferences.getStringList(_daysKey);
    final savedMinutes = await _preferences.getInt(_minutesKey);
    final savedGoal = await _preferences.getString(_goalKey);
    final savedExperience = await _preferences.getString(_experienceKey);
    final savedEquipment = await _preferences.getStringList(_equipmentKey);
    final hasSavedPlan =
        savedDays != null ||
        savedMinutes != null ||
        savedGoal != null ||
        savedExperience != null ||
        savedEquipment != null;
    final existingPlan =
        await (database.select(database.trainingPlans)..where(
              (plan) => plan.id.equals(TrainingSettingsRepository.activePlanId),
            ))
            .getSingleOrNull();

    if (hasSavedPlan && existingPlan == null) {
      final defaults = const TrainingSettings();
      final parsedDays = savedDays
          ?.map(int.tryParse)
          .whereType<int>()
          .where((day) => day >= DateTime.monday && day <= DateTime.sunday)
          .toSet();
      final minutes = savedMinutes == null
          ? defaults.sessionMinutes
          : savedMinutes.clamp(20, 90);
      await settingsRepository.save(
        TrainingSettings(
          trainingDays: parsedDays == null || parsedDays.isEmpty
              ? defaults.trainingDays
              : parsedDays,
          sessionMinutes: minutes,
          goal: savedGoal == null || savedGoal.isEmpty
              ? defaults.goal
              : savedGoal,
          experience: savedExperience == null || savedExperience.isEmpty
              ? defaults.experience
              : savedExperience,
          equipment: savedEquipment == null || savedEquipment.isEmpty
              ? defaults.equipment
              : savedEquipment.toSet(),
        ),
      );
    }

    final wasSetupComplete = await _preferences.getBool(_completeKey) ?? false;
    if (wasSetupComplete) await settingsRepository.completeSetup();

    final savedRecords = await _preferences.getStringList(_recordsKey);
    for (final encoded in savedRecords ?? const <String>[]) {
      try {
        final json = Map<String, Object?>.from(jsonDecode(encoded) as Map);
        await workoutLogRepository.save(WorkoutRecord.fromJson(json));
      } on Object {
        // Skip one malformed legacy record without blocking the rest.
      }
    }

    await database
        .into(database.appMetadata)
        .insertOnConflictUpdate(
          AppMetadataCompanion.insert(key: _migrationKey, value: 'true'),
        );
  }
}

abstract interface class LegacyPreferenceStore {
  Future<bool?> getBool(String key);
  Future<int?> getInt(String key);
  Future<String?> getString(String key);
  Future<List<String>?> getStringList(String key);
}

class SharedLegacyPreferenceStore implements LegacyPreferenceStore {
  const SharedLegacyPreferenceStore(this.preferences);

  final SharedPreferencesAsync preferences;

  @override
  Future<bool?> getBool(String key) => preferences.getBool(key);

  @override
  Future<int?> getInt(String key) => preferences.getInt(key);

  @override
  Future<String?> getString(String key) => preferences.getString(key);

  @override
  Future<List<String>?> getStringList(String key) =>
      preferences.getStringList(key);
}
