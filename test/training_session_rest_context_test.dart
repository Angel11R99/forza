import 'dart:convert';

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
    'adjusts and restores set rest, then shows the next exercise separately',
    (tester) async {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(() async => database.close());
      final repository = WorkoutLogRepository(database: database);
      const settings = TrainingSettings();
      const builder = TrainingPlanBuilder();
      final plannedSession = builder
          .buildWeek(
            trainingDays: settings.trainingDays,
            sessionMinutes: settings.sessionMinutes,
            goal: settings.goal,
            experience: settings.experience,
            equipment: settings.equipment,
            avoidedExerciseIds: settings.avoidedExerciseIds,
          )
          .first;
      final scheduledDate = DateTime(2026, 11, 24);
      await tester.runAsync(() async {
        await database.customSelect('SELECT 1').get();
      });

      await _showSession(
        tester,
        repository,
        settings,
        plannedSession,
        scheduledDate,
      );
      await _startSession(tester);
      await _enter(tester, 'set-0-repetitions', '8');
      await _tap(tester, find.byKey(const ValueKey('complete-set-0')));
      expect(find.text('Descanso entre series'), findsOneWidget);

      await _tap(tester, find.widgetWithText(ChoiceChip, '60 s'));
      var draft = await _loadDraft(repository);
      expect(draft['restContext'], 'betweenSets');
      expect(draft['restDurationSeconds'], 60);
      expect(draft['remainingRestSeconds'], 60);

      await _tap(tester, find.byTooltip('Pausar entrenamiento'));
      expect(find.text('Entrenamiento pausado'), findsAtLeastNWidgets(1));
      await _showSession(
        tester,
        repository,
        settings,
        plannedSession,
        scheduledDate,
      );
      await _resumeSession(tester);
      expect(find.text('Descanso entre series'), findsOneWidget);
      expect(
        tester
            .widget<ChoiceChip>(find.widgetWithText(ChoiceChip, '60 s'))
            .selected,
        isTrue,
      );
      await _skipRest(tester);

      final firstExerciseSetCount = _setCount(plannedSession.exercises.first);
      for (var setIndex = 1; setIndex < firstExerciseSetCount; setIndex++) {
        await _enter(tester, 'set-$setIndex-repetitions', '8');
        await _tap(tester, find.text('Completar serie').last);
        if (setIndex < firstExerciseSetCount - 1) await _skipRest(tester);
      }
      expect(find.text('Descanso entre series'), findsNothing);

      await _tap(tester, find.text('Completar ejercicio'));
      expect(find.text('Cambio de ejercicio'), findsOneWidget);
      draft = await _loadDraft(repository);
      expect(draft['restContext'], 'betweenExercises');
      expect(draft['currentExercise'], 1);
      expect(
        draft['completedSets'],
        containsAll([
          for (var setIndex = 0; setIndex < firstExerciseSetCount; setIndex++)
            '0:$setIndex',
        ]),
      );
      expect(draft['completedSets'], isNot(contains('1:0')));

      await _tap(tester, find.text('Empezar cuando estés listo'));
      expect(
        find.text('Ejercicio 2 de ${plannedSession.exercises.length}'),
        findsAtLeastNWidgets(1),
      );
      expect(
        find.text(
          '$firstExerciseSetCount de ${_totalSets(plannedSession)} series completadas',
        ),
        findsOneWidget,
      );
    },
  );
}

int _totalSets(PlannedTrainingSession session) => session.exercises.fold<int>(
  0,
  (total, exercise) => total + _setCount(exercise),
);

int _setCount(PlannedExercise exercise) =>
    exercise.prescription.startsWith('2 series') ? 2 : 3;

Future<Map<String, Object?>> _loadDraft(
  WorkoutLogRepository repository,
) async =>
    jsonDecode((await repository.loadActiveWorkout())!) as Map<String, Object?>;

Future<void> _showSession(
  WidgetTester tester,
  WorkoutLogRepository repository,
  TrainingSettings settings,
  PlannedTrainingSession plannedSession,
  DateTime scheduledDate,
) async {
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
        key: UniqueKey(),
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
    attempt < 30 &&
        find.text('Ver calentamiento').evaluate().isEmpty &&
        find.text('Continuar entrenamiento').evaluate().isEmpty;
    attempt++
  ) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

Future<void> _startSession(WidgetTester tester) async {
  await _tap(tester, find.text('Ver calentamiento'));
  await _tap(tester, find.text('Comenzar entrenamiento'));
}

Future<void> _resumeSession(WidgetTester tester) async {
  if (find.text('Continuar entrenamiento').evaluate().isEmpty) {
    for (var attempt = 0; attempt < 30; attempt++) {
      await tester.pump(const Duration(milliseconds: 100));
      if (find.text('Continuar entrenamiento').evaluate().isNotEmpty) break;
    }
  }
  await _tap(tester, find.text('Continuar entrenamiento'));
}

Future<void> _enter(WidgetTester tester, String key, String value) async {
  final finder = find.byKey(ValueKey(key));
  await tester.ensureVisible(finder);
  await tester.enterText(finder, value);
  await tester.pump();
}

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pump();
}

Future<void> _skipRest(WidgetTester tester) async {
  if (find.text('Saltar descanso').evaluate().isNotEmpty) {
    await _tap(tester, find.text('Saltar descanso'));
  }
}
