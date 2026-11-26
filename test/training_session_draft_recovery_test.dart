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
  testWidgets('restores the exact saved plan when the current plan changed', (
    tester,
  ) async {
    final harness = await _Harness.create(tester);
    addTearDown(harness.close);
    final currentPlan = harness.plan;
    final first = currentPlan.exercises.first;
    final oldExercises = [
      PlannedExercise(
        catalogId: first.catalogId,
        name: first.name,
        focus: first.focus,
        prescription: '2 series · 20–40 segundos',
        timed: true,
      ),
      ...currentPlan.exercises.skip(1),
    ];
    final savedPlan = PlannedTrainingSession(
      weekday: currentPlan.weekday,
      title: 'Rutina guardada original',
      focus: currentPlan.focus,
      durationMinutes: currentPlan.durationMinutes,
      exercises: oldExercises,
    );
    await harness.saveDraft(
      date: harness.date,
      plan: savedPlan,
      currentExercise: 0,
      sets: [
        const {'exercisePosition': 0, 'setIndex': 0, 'durationSeconds': 25},
      ],
      completedSets: const ['0:0'],
      resumeScreen: 'exerciseList',
    );

    await harness.show(plan: currentPlan);
    expect(find.text('Revisar entrenamiento guardado'), findsNothing);
    expect(
      find.textContaining('Se restauró la rutina original guardada'),
      findsOneWidget,
    );
    await _tap(tester, find.text('Continuar entrenamiento'));
    expect(find.byKey(const ValueKey('set-1-repetitions')), findsOneWidget);
    expect(find.byKey(const ValueKey('set-2-repetitions')), findsNothing);
    expect(
      find.text('1 de ${_totalSets(savedPlan)} series completadas'),
      findsOneWidget,
    );

    await tester.binding.handlePopRoute();
    await tester.pump();
    expect(find.text('Entrenamiento pausado'), findsAtLeastNWidgets(1));
  });

  testWidgets(
    'session-specific set count survives draft restore and can shrink',
    (tester) async {
      final harness = await _Harness.create(tester);
      addTearDown(harness.close);
      final baseExercise = harness.plan.exercises.first;
      final plan = PlannedTrainingSession(
        weekday: harness.plan.weekday,
        title: harness.plan.title,
        focus: harness.plan.focus,
        durationMinutes: harness.plan.durationMinutes,
        exercises: [
          PlannedExercise(
            catalogId: baseExercise.catalogId,
            name: baseExercise.name,
            focus: baseExercise.focus,
            prescription: '2 series · 8–12 repeticiones',
            tracksExternalLoad: baseExercise.tracksExternalLoad,
          ),
        ],
      );

      await harness.show(plan: plan);
      await _tap(tester, find.text('Ver calentamiento'));
      await _tap(tester, find.text('Comenzar entrenamiento'));
      await _tap(tester, find.byKey(const ValueKey('add-session-set')));
      expect(find.text('0 de 3 series completadas'), findsOneWidget);
      final draft = jsonDecode(
        (await harness.repository.loadActiveWorkout())!,
      ) as Map<String, Object?>;
      expect((draft['sessionSetCounts']! as Map<String, Object?>)['0'], 3);

      await harness.show(plan: plan);
      await _tap(tester, find.text('Continuar entrenamiento'));
      expect(find.text('0 de 3 series completadas'), findsOneWidget);
      expect(find.text('Serie adicional 3'), findsOneWidget);
      await _tap(tester, find.byKey(const ValueKey('remove-session-set')));
      expect(find.text('0 de 2 series completadas'), findsOneWidget);
      expect(find.text('Serie adicional 3'), findsNothing);
    },
  );

  testWidgets('asks before applying a legacy draft to the current plan', (
    tester,
  ) async {
    final harness = await _Harness.create(tester);
    addTearDown(harness.close);
    await harness.saveDraft(
      date: harness.date,
      plan: null,
      currentExercise: 0,
      sets: const [
        {
          'exercisePosition': 0,
          'setIndex': 0,
          'repetitions': 8,
          'loadKg': null,
        },
      ],
      completedSets: const ['0:0'],
      resumeScreen: 'exerciseList',
    );

    await harness.show(plan: harness.plan);
    expect(
      find.text('Revisar entrenamiento guardado'),
      findsAtLeastNWidgets(1),
    );
    await _tap(tester, find.text('Continuar con la rutina actual'));
    expect(
      find.textContaining('Se restauró la rutina original guardada'),
      findsOneWidget,
    );
    await _tap(tester, find.text('Continuar entrenamiento'));
    expect(_fieldText(tester, 'set-0-repetitions'), '8');
    expect(
      find.text('1 de ${_totalSets(harness.plan)} series completadas'),
      findsOneWidget,
    );
  });

  testWidgets('requires an explicit choice for a draft from another date', (
    tester,
  ) async {
    final harness = await _Harness.create(tester);
    addTearDown(harness.close);
    final previousDate = DateTime(2026, 11, 23);
    await harness.saveDraft(
      date: previousDate,
      plan: harness.plan,
      currentExercise: 0,
      sets: const [
        {'exercisePosition': 0, 'setIndex': 0, 'repetitions': 8},
      ],
      completedSets: const ['0:0'],
      resumeScreen: 'exerciseList',
    );

    await harness.show(plan: harness.plan);
    expect(
      find.text('Revisar entrenamiento guardado'),
      findsAtLeastNWidgets(1),
    );
    expect(
      find.textContaining('Hay un entrenamiento guardado del'),
      findsOneWidget,
    );
    await _tap(tester, find.text('Continuar entrenamiento guardado'));
    await _tap(tester, find.text('Continuar entrenamiento'));
    final restored = jsonDecode(
      (await harness.repository.loadActiveWorkout())!,
    ) as Map<String, Object?>;
    expect(restored['scheduledDate'], previousDate.toIso8601String());
    expect(restored['completedSets'], contains('0:0'));
  });

  testWidgets('explicitly discards stale draft before starting selected day', (
    tester,
  ) async {
    final harness = await _Harness.create(tester);
    addTearDown(harness.close);
    await harness.saveDraft(
      date: DateTime(2026, 11, 23),
      plan: harness.plan,
      currentExercise: 0,
      sets: const [],
      completedSets: const [],
      resumeScreen: 'exerciseList',
    );

    await harness.show(plan: harness.plan);
    await _tap(tester, find.text('Descartar borrador e iniciar esta sesión'));
    expect(find.text('Todo listo para empezar'), findsOneWidget);
    expect(await harness.repository.loadActiveWorkout(), isNull);
  });

  testWidgets(
    'keeps an unreadable draft until the user explicitly discards it',
    (tester) async {
      final harness = await _Harness.create(tester);
      addTearDown(harness.close);
      await harness.database
          .into(harness.database.appMetadata)
          .insertOnConflictUpdate(
            AppMetadataCompanion.insert(
              key: 'active_workout_v1',
              value: 'unreadable saved workout',
            ),
          );

      await harness.show(plan: harness.plan);
      expect(
        find.textContaining('No se puede leer el borrador guardado'),
        findsOneWidget,
      );
      expect(
        await harness.repository.loadActiveWorkout(),
        'unreadable saved workout',
      );
      await _tap(tester, find.text('Descartar borrador e iniciar esta sesión'));
      expect(await harness.repository.loadActiveWorkout(), isNull);
    },
  );
}

class _Harness {
  _Harness(this.tester, this.database, this.repository, this.plan);

  final WidgetTester tester;
  final AppDatabase database;
  final WorkoutLogRepository repository;
  final PlannedTrainingSession plan;
  final settings = const TrainingSettings();
  final date = DateTime(2026, 11, 24);

  static Future<_Harness> create(WidgetTester tester) async {
    final database = AppDatabase(NativeDatabase.memory());
    final repository = WorkoutLogRepository(database: database);
    const settings = TrainingSettings();
    const builder = TrainingPlanBuilder();
    final plan = builder
        .buildWeek(
          trainingDays: settings.trainingDays,
          sessionMinutes: settings.sessionMinutes,
          goal: settings.goal,
          experience: settings.experience,
          equipment: settings.equipment,
          avoidedExerciseIds: settings.avoidedExerciseIds,
        )
        .first;
    await tester.runAsync(() async {
      await database.customSelect('SELECT 1').get();
    });
    return _Harness(tester, database, repository, plan);
  }

  Future<void> saveDraft({
    required DateTime date,
    required PlannedTrainingSession? plan,
    required int currentExercise,
    required List<Map<String, Object?>> sets,
    required List<String> completedSets,
    required String resumeScreen,
  }) => repository.saveActiveWorkout({
    'scheduledDate': date.toIso8601String(),
    if (plan != null) 'planVersion': 1,
    if (plan != null) 'planSnapshot': plan.toJson(),
    'currentExercise': currentExercise,
    'elapsedSeconds': 42,
    'remainingRestSeconds': 0,
    'resumeScreen': resumeScreen,
    'sets': sets,
    'completedSets': completedSets,
  });

  Future<void> show({required PlannedTrainingSession plan}) async {
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
          scheduledDate: date,
          plannedSession: plan,
        ),
      ),
    );
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );
    await tester.pump();
  }

  Future<void> close() => database.close();
}

int _totalSets(PlannedTrainingSession plan) => plan.exercises.fold<int>(
  0,
  (total, exercise) =>
      total + (exercise.prescription.startsWith('2 series') ? 2 : 3),
);

String _fieldText(WidgetTester tester, String key) => tester
    .widget<EditableText>(
      find.descendant(
        of: find.byKey(ValueKey(key)),
        matching: find.byType(EditableText),
      ),
    )
    .controller
    .text;

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pump();
}
