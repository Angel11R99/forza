import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forza/data/database/app_database.dart'
    hide BodyMeasurement, PersonalGoal;
import 'package:forza/data/migrations/legacy_shared_preferences_migration.dart';
import 'package:forza/data/repositories/body_measurement_repository.dart';
import 'package:forza/data/repositories/personal_goal_repository.dart';
import 'package:forza/data/repositories/training_schedule_repository.dart';
import 'package:forza/data/repositories/training_settings_repository.dart';
import 'package:forza/data/repositories/workout_log_repository.dart';
import 'package:forza/domain/models/body_measurement.dart';
import 'package:forza/domain/models/personal_goal.dart';
import 'package:forza/domain/models/workout_record.dart';
import 'package:forza/ui/core/view_models/app_shell_view_model.dart';
import 'package:forza/ui/features/profile/models/profile_settings.dart';
import 'support/shared_preferences_async_test_setup.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setupSharedPreferencesAsyncForTest();

  test(
    'reset clears user data and prevents legacy records from returning',
    () async {
      final database = AppDatabase(NativeDatabase.memory());
      final settings = TrainingSettingsRepository(database: database);
      final workouts = WorkoutLogRepository(database: database);
      final schedule = TrainingScheduleRepository(database: database);
      final goals = PersonalGoalRepository(database: database);
      final measurements = BodyMeasurementRepository(database: database);
      final viewModel = AppShellViewModel(
        database: database,
        settingsRepository: settings,
        workoutLogRepository: workouts,
        trainingScheduleRepository: schedule,
        personalGoalRepository: goals,
        bodyMeasurementRepository: measurements,
      );

      try {
        await settings.save(const TrainingSettings(goal: 'Ganar músculo'));
        await settings.completeSetup();
        await schedule.ensureUpcoming(
          const TrainingSettings(),
          from: DateTime(2026, 1, 1),
        );
        await workouts.save(
          WorkoutRecord(
            scheduledDate: DateTime(2026, 1, 5),
            completedAt: DateTime(2026, 1, 5, 10),
            title: 'Entrenamiento guardado',
            goal: 'Ganar músculo',
            durationMinutes: 40,
            exerciseCount: 0,
          ),
        );
        await workouts.saveActiveWorkout({
          'scheduledDate': DateTime(2026, 1, 6).toIso8601String(),
          'sets': <Object?>[],
        });
        await goals.save(
          PersonalGoal(
            id: 'goal',
            type: PersonalGoalType.sessionsPerWeek,
            targetValue: 3,
            createdAt: DateTime(2026, 1, 1),
          ),
        );
        await measurements.save(
          BodyMeasurement(date: DateTime(2026, 1, 1), weightKg: 70),
        );
        await database
            .into(database.appMetadata)
            .insert(
              AppMetadataCompanion.insert(
                key: LegacySharedPreferencesMigration.migrationKey,
                value: 'true',
              ),
            );

        await viewModel.restore();
        expect(viewModel.hasActiveWorkout, isTrue);
        await viewModel.resetUserData();

        expect(await settings.setupComplete, isFalse);
        expect(await workouts.load(), isEmpty);
        expect(await workouts.loadActiveWorkout(), isNull);
        expect(await schedule.load(), isEmpty);
        expect(await goals.load(), isEmpty);
        expect(await measurements.load(), isEmpty);
        expect(viewModel.workoutRecords, isEmpty);
        expect(viewModel.scheduledSessions, isEmpty);
        expect(viewModel.personalGoals, isEmpty);
        expect(viewModel.bodyMeasurements, isEmpty);
        expect(viewModel.needsFirstRunSetup, isTrue);
        expect(viewModel.hasActiveWorkout, isFalse);
        expect(viewModel.trainingSettings.goal, const TrainingSettings().goal);
        final migrationMarker =
            await (database.select(database.appMetadata)..where(
                  (row) => row.key.equals(
                    LegacySharedPreferencesMigration.migrationKey,
                  ),
                ))
                .getSingle();
        expect(migrationMarker.value, 'true');
      } finally {
        viewModel.dispose();
        await database.close();
      }
    },
  );
}
