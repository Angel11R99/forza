import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forza/data/database/app_database.dart' hide PersonalGoal;
import 'package:forza/data/migrations/legacy_shared_preferences_migration.dart';
import 'package:forza/data/repositories/backup_repository.dart';
import 'package:forza/data/repositories/personal_goal_repository.dart';
import 'package:forza/data/repositories/training_schedule_repository.dart';
import 'package:forza/data/repositories/training_settings_repository.dart';
import 'package:forza/data/repositories/workout_log_repository.dart';
import 'package:forza/domain/models/personal_goal.dart';
import 'package:forza/domain/models/workout_record.dart';
import 'package:forza/ui/features/profile/models/profile_settings.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('SQLite data survives close/reopen and backup restore', () async {
    final directory = await Directory.systemTemp.createTemp('forza-audit-');
    final databaseFile = File(
      '${directory.path}${Platform.pathSeparator}audit.db',
    );
    var database = AppDatabase(NativeDatabase(databaseFile));
    try {
      var settingsRepository = TrainingSettingsRepository(database: database);
      var scheduleRepository = TrainingScheduleRepository(database: database);
      var workoutRepository = WorkoutLogRepository(database: database);
      var goalRepository = PersonalGoalRepository(database: database);
      var backupRepository = BackupRepository(
        database: database,
        settingsRepository: settingsRepository,
        workoutLogRepository: workoutRepository,
        scheduleRepository: scheduleRepository,
        goalRepository: goalRepository,
      );
      const initialSettings = TrainingSettings(
        trainingDays: {DateTime.monday, DateTime.wednesday},
        sessionMinutes: 45,
        goal: 'Ganar fuerza',
        experience: 'Estoy empezando',
        equipment: {'Mancuernas'},
      );
      await settingsRepository.save(initialSettings);
      expect(await settingsRepository.currentPlanVersion, 1);
      await settingsRepository.save(initialSettings);
      expect(await settingsRepository.currentPlanVersion, 1);

      const updatedSettings = TrainingSettings(
        trainingDays: {DateTime.monday, DateTime.wednesday},
        sessionMinutes: 60,
        goal: 'Ganar músculo',
        experience: 'Tengo algo de experiencia',
        equipment: {'Mancuernas'},
      );
      await settingsRepository.save(updatedSettings);
      expect(await settingsRepository.currentPlanVersion, 2);
      await settingsRepository.completeSetup();

      final monday = DateTime(2026, 1, 5);
      final tuesday = DateTime(2026, 1, 6);
      final wednesday = DateTime(2026, 1, 7);
      await scheduleRepository.ensureUpcoming(
        updatedSettings,
        from: monday,
        daysAhead: 2,
      );
      expect(await scheduleRepository.move(monday, tuesday), isTrue);
      await scheduleRepository.setStatus(tuesday, 'skipped');
      await scheduleRepository.setStatus(wednesday, 'completed');

      final workout = WorkoutRecord(
        scheduledDate: wednesday,
        completedAt: DateTime(2026, 1, 7, 10),
        title: 'Sesión de prueba',
        goal: updatedSettings.goal,
        durationMinutes: 55,
        exerciseCount: 1,
        exercises: const ['Press de banca con barra'],
        exerciseIds: const ['0025'],
        setResults: const [
          WorkoutSetResult(
            exercisePosition: 0,
            setIndex: 0,
            repetitions: 8,
            loadKg: 50,
          ),
        ],
      );
      await workoutRepository.save(workout);
      await workoutRepository.save(
        WorkoutRecord(
          scheduledDate: wednesday,
          completedAt: DateTime(2026, 1, 7, 11),
          title: 'Sesión actualizada',
          goal: updatedSettings.goal,
          durationMinutes: 58,
          exerciseCount: 1,
          exercises: workout.exercises,
          exerciseIds: workout.exerciseIds,
          setResults: workout.setResults,
        ),
      );

      final goal = PersonalGoal(
        id: 'weekly-sessions',
        type: PersonalGoalType.sessionsPerWeek,
        targetValue: 3,
        createdAt: DateTime(2026, 1, 1),
      );
      await goalRepository.save(goal);
      await goalRepository.save(
        PersonalGoal(
          id: goal.id,
          type: goal.type,
          targetValue: 4,
          createdAt: goal.createdAt,
        ),
      );
      await goalRepository.save(
        PersonalGoal(
          id: 'temporary',
          type: PersonalGoalType.exerciseLoad,
          targetValue: 100,
          exerciseName: 'Press de banca con barra',
          createdAt: DateTime(2026, 1, 1),
        ),
      );
      await goalRepository.delete('temporary');

      final draft = <String, Object?>{
        'scheduledDate': tuesday.toIso8601String(),
        'currentExercise': 1,
        'elapsedSeconds': 42,
        'remainingRestSeconds': 0,
        'resumeScreen': 'exerciseList',
        'sets': <Object?>[],
      };
      await workoutRepository.saveActiveWorkout(draft);
      final backup = backupRepository.validate(
        await backupRepository.exportJson(appearanceMode: 'dark'),
      );
      expect(backup.planVersion, 2);
      expect(
        backup.schedule.any((session) => session.status == 'skipped'),
        isTrue,
      );

      await database.close();
      database = AppDatabase(NativeDatabase(databaseFile));
      settingsRepository = TrainingSettingsRepository(database: database);
      scheduleRepository = TrainingScheduleRepository(database: database);
      workoutRepository = WorkoutLogRepository(database: database);
      goalRepository = PersonalGoalRepository(database: database);
      backupRepository = BackupRepository(
        database: database,
        settingsRepository: settingsRepository,
        workoutLogRepository: workoutRepository,
        scheduleRepository: scheduleRepository,
        goalRepository: goalRepository,
      );

      final reopenedSettings = await settingsRepository.load();
      expect(reopenedSettings.goal, updatedSettings.goal);
      expect(reopenedSettings.experience, updatedSettings.experience);
      expect(reopenedSettings.sessionMinutes, updatedSettings.sessionMinutes);
      expect(reopenedSettings.trainingDays, updatedSettings.trainingDays);
      expect(reopenedSettings.equipment, updatedSettings.equipment);
      expect(await settingsRepository.currentPlanVersion, 2);
      expect(await settingsRepository.setupComplete, isTrue);
      expect(
        (await scheduleRepository.load())
            .singleWhere((s) => s.isSkipped)
            .scheduledDate,
        tuesday,
      );
      expect(
        (await workoutRepository.load()).single.title,
        'Sesión actualizada',
      );
      expect((await workoutRepository.load()).single.exerciseIds, ['0025']);
      expect(
        (await workoutRepository.load()).single.setResults.single.loadKg,
        50,
      );
      expect(jsonDecode((await workoutRepository.loadActiveWorkout())!), draft);
      expect((await goalRepository.load()).single.targetValue, 4);

      await settingsRepository.save(
        const TrainingSettings(
          trainingDays: {DateTime.friday},
          sessionMinutes: 30,
          goal: 'Crear el hábito',
          experience: 'Estoy empezando',
          equipment: {'Peso corporal'},
        ),
      );
      await workoutRepository.save(
        WorkoutRecord(
          scheduledDate: DateTime(2026, 1, 8),
          completedAt: DateTime(2026, 1, 8, 10),
          title: 'Registro adicional',
          goal: 'Crear el hábito',
          durationMinutes: 20,
          exerciseCount: 0,
        ),
      );
      await workoutRepository.clearActiveWorkout();
      await goalRepository.delete(goal.id);
      await backupRepository.restore(backup);

      final restoredSettings = await settingsRepository.load();
      expect(restoredSettings.goal, updatedSettings.goal);
      expect(restoredSettings.experience, updatedSettings.experience);
      expect(restoredSettings.sessionMinutes, updatedSettings.sessionMinutes);
      expect(restoredSettings.trainingDays, updatedSettings.trainingDays);
      expect(restoredSettings.equipment, updatedSettings.equipment);
      expect(await settingsRepository.currentPlanVersion, 2);
      expect((await workoutRepository.load()).map((r) => r.title), [
        'Sesión actualizada',
      ]);
      expect((await scheduleRepository.load()).any((s) => s.isSkipped), isTrue);
      expect((await goalRepository.load()).single.targetValue, 4);
      expect(jsonDecode((await workoutRepository.loadActiveWorkout())!), draft);
      expect(backup.appearanceMode, 'dark');
    } finally {
      await database.close();
      await directory.delete(recursive: true);
    }
  });

  test(
    'legacy migration is idempotent and does not overwrite a newer plan',
    () async {
      final database = AppDatabase(NativeDatabase.memory());
      final settingsRepository = TrainingSettingsRepository(database: database);
      final workoutRepository = WorkoutLogRepository(database: database);
      final shared = _MemoryLegacyPreferences({
        'training_days': ['1'],
        'training_session_minutes': 20,
        'training_goal': 'Ganar fuerza',
        'training_experience': 'Estoy empezando',
        'training_equipment': ['Mancuernas'],
        'training_setup_complete': true,
        'workout_records': [
          jsonEncode({
            'scheduledDate': '2026-01-05T00:00:00.000',
            'completedAt': '2026-01-05T10:00:00.000',
            'title': 'Registro heredado',
            'goal': 'Ganar fuerza',
            'durationMinutes': 30,
            'exerciseCount': 0,
          }),
        ],
      });
      try {
        final migration = LegacySharedPreferencesMigration(
          database: database,
          settingsRepository: settingsRepository,
          workoutLogRepository: workoutRepository,
          preferences: shared,
        );
        await migration.run();
        await migration.run();

        expect((await workoutRepository.load()).map((r) => r.title), [
          'Registro heredado',
        ]);
        expect(await settingsRepository.setupComplete, isTrue);
        expect((await settingsRepository.load()).sessionMinutes, 20);

        final newerSettings = TrainingSettings(
          trainingDays: const {DateTime.saturday},
          sessionMinutes: 75,
          goal: 'Ganar músculo',
          experience: 'Tengo algo de experiencia',
          equipment: const {'Banda elástica'},
        );
        await settingsRepository.save(newerSettings);
        await database.delete(database.appMetadata).go();
        await database
            .into(database.appMetadata)
            .insert(
              AppMetadataCompanion.insert(
                key: 'migration_shared_preferences_v1',
                value: 'false',
              ),
            );

        await migration.run();
        final loadedSettings = await settingsRepository.load();
        expect(loadedSettings.goal, newerSettings.goal);
        expect(loadedSettings.experience, newerSettings.experience);
        expect(loadedSettings.sessionMinutes, newerSettings.sessionMinutes);
        expect(loadedSettings.trainingDays, newerSettings.trainingDays);
        expect(loadedSettings.equipment, newerSettings.equipment);
      } finally {
        await database.close();
      }
    },
  );
}

class _MemoryLegacyPreferences implements LegacyPreferenceStore {
  _MemoryLegacyPreferences(this.values);

  final Map<String, Object> values;

  @override
  Future<bool?> getBool(String key) async => values[key] as bool?;

  @override
  Future<int?> getInt(String key) async => values[key] as int?;

  @override
  Future<String?> getString(String key) async => values[key] as String?;

  @override
  Future<List<String>?> getStringList(String key) async =>
      (values[key] as List<Object?>?)?.cast<String>();
}
