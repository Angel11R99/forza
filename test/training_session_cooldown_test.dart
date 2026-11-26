import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:forza/app/localization/generated/app_localizations.dart';
import 'package:forza/app/theme/app_theme.dart';
import 'package:forza/data/database/app_database.dart';
import 'package:forza/data/repositories/workout_log_repository.dart';
import 'package:forza/domain/models/workout_record.dart';
import 'package:forza/domain/use_cases/training_plan_builder.dart';
import 'package:forza/ui/features/onboarding/views/training_session_flow.dart';
import 'package:forza/ui/features/profile/models/profile_settings.dart';

void main() {
  testWidgets('cool-down is optional and leaves the workout record unchanged', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    final repository = WorkoutLogRepository(database: database);
    final settings = const TrainingSettings();
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
    final currentExercise = plannedSession.exercises.length - 1;
    final current = plannedSession.exercises[currentExercise];
    final setCount = current.prescription.startsWith('2 series') ? 2 : 3;
    final setResults = [
      for (var index = 0; index < setCount; index++)
        WorkoutSetResult(
          exercisePosition: currentExercise,
          setIndex: index,
          repetitions: 8,
          loadKg: 12,
        ),
    ];
    await repository.saveActiveWorkout({
      'scheduledDate': DateTime(2026, 11, 24).toIso8601String(),
      'planVersion': 1,
      'planSnapshot': plannedSession.toJson(),
      'currentExercise': currentExercise,
      'elapsedSeconds': 125,
      'remainingRestSeconds': 0,
      'resumeScreen': 'completed',
      'sets': [for (final result in setResults) result.toJson()],
      'completedSets': [
        for (var index = 0; index < setCount; index++)
          '$currentExercise:$index',
      ],
    });

    WorkoutRecord? savedRecord;
    await tester.runAsync(() async {
      await database.customSelect('SELECT 1').get();
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
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: TextButton(
                onPressed: () async {
                  savedRecord = await Navigator.of(context).push<WorkoutRecord>(
                    MaterialPageRoute<WorkoutRecord>(
                      builder: (_) => TrainingSessionFlow(
                        settings: settings,
                        workoutLogRepository: repository,
                        scheduledDate: DateTime(2026, 11, 24),
                        plannedSession: plannedSession,
                      ),
                    ),
                  );
                },
                child: const Text('Abrir sesión'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Abrir sesión'));
    await tester.pump();
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
    await tester.pump();
    expect(find.text('Ver vuelta a la calma'), findsOneWidget);
    expect(find.text('Ver resumen de sesión'), findsOneWidget);

    await tester.tap(find.text('Ver vuelta a la calma'));
    await tester.pump();
    expect(find.text('Baja el ritmo a tu manera'), findsOneWidget);
    expect(
      find.text('Omitir vuelta a la calma e ir al resumen'),
      findsOneWidget,
    );

    await tester.tap(find.text('Omitir vuelta a la calma e ir al resumen'));
    await tester.pump();
    expect(find.text('Así fue tu sesión'), findsOneWidget);

    await tester.tap(find.text('Finalizar'));
    await tester.pumpAndSettle();
    expect(savedRecord, isNotNull);
    expect(savedRecord!.exerciseCount, 1);
    expect(savedRecord!.setResults, hasLength(setCount));
    expect(savedRecord!.setResults.first.repetitions, 8);
    expect(await repository.loadActiveWorkout(), isNull);

    await database.close();
  });
}
