import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:forza/app/localization/generated/app_localizations.dart';
import 'package:forza/app/theme/app_theme.dart';
import 'package:forza/data/database/app_database.dart';
import 'package:forza/data/repositories/workout_log_repository.dart';
import 'package:forza/domain/use_cases/training_plan_builder.dart';
import 'package:forza/ui/features/onboarding/views/training_session_flow.dart';
import 'package:forza/ui/features/profile/models/profile_settings.dart';

void main() {
  testWidgets(
    'shows the active exercise first and opens a routine with future items inactive',
    (tester) async {
      tester.view.physicalSize = const Size(320, 720);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      final repository = WorkoutLogRepository(database: database);
      const settings = TrainingSettings();
      const planBuilder = TrainingPlanBuilder();
      final plannedSession = planBuilder
          .buildWeek(
            trainingDays: settings.trainingDays,
            sessionMinutes: settings.sessionMinutes,
            goal: settings.goal,
            experience: settings.experience,
            equipment: settings.equipment,
            avoidedExerciseIds: settings.avoidedExerciseIds,
          )
          .first;
      final firstExercise = plannedSession.exercises.first;
      final firstSetCount = firstExercise.prescription.startsWith('2 series')
          ? 2
          : 3;
      final scheduledDate = DateTime(2026, 11, 24);

      await tester.runAsync(() async {
        await database.customSelect('SELECT 1').get();
        await repository.saveActiveWorkout({
          'scheduledDate': scheduledDate.toIso8601String(),
          'planVersion': 1,
          'planSnapshot': plannedSession.toJson(),
          'currentExercise': 1,
          'elapsedSeconds': 75,
          'remainingRestSeconds': 0,
          'timedRemainingSeconds': 30,
          'cooldownIndex': 0,
          'resumeTimedSet': false,
          'resumeScreen': 'exerciseList',
          'sets': [
            for (var index = 0; index < firstSetCount; index++)
              {
                'exercisePosition': 0,
                'setIndex': index,
                'repetitions': 8,
                'loadKg': 12.0,
              },
          ],
          'completedSets': [
            for (var index = 0; index < firstSetCount; index++) '0:$index',
          ],
        });
      });

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('es'),
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: [
            AppLocalizations.delegate,
            ...GlobalMaterialLocalizations.delegates,
          ],
          home: TrainingSessionFlow(
            settings: settings,
            workoutLogRepository: repository,
            scheduledDate: scheduledDate,
            plannedSession: plannedSession,
          ),
        ),
      );

      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 100)),
      );
      await tester.pump();
      for (
        var attempt = 0;
        attempt < 30 && find.text('Continuar entrenamiento').evaluate().isEmpty;
        attempt++
      ) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      await tester.tap(find.text('Continuar entrenamiento'));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('active-exercise-name')), findsOneWidget);
      expect(find.byKey(const Key('routine-exercise-0')), findsNothing);
      expect(find.text('Ver rutina'), findsOneWidget);

      await tester.tap(find.text('Ver rutina'));
      await tester.pumpAndSettle();
      expect(find.text('Rutina de esta sesión'), findsOneWidget);

      final completed = tester.widget<ListTile>(
        find.byKey(const ValueKey('routine-exercise-0')),
      );
      final current = tester.widget<ListTile>(
        find.byKey(const ValueKey('routine-exercise-1')),
      );
      expect(completed.enabled, isTrue);
      expect(current.enabled, isTrue);

      final pending = find.byKey(const ValueKey('routine-exercise-2'));
      expect(pending, findsOneWidget);
      expect(
        find.descendant(of: pending, matching: find.byType(InkWell)),
        findsNothing,
      );

      await tester.tap(find.byTooltip('Cerrar rutina'));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('active-exercise-name')), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
