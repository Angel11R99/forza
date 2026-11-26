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
  testWidgets('logs, edits, unmarks, and restores independent rep sets', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(() async => database.close());
    final repository = WorkoutLogRepository(database: database);
    final settings = const TrainingSettings();
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
    final totalSets = plannedSession.exercises.fold<int>(
      0,
      (total, exercise) =>
          total + (exercise.prescription.startsWith('2 series') ? 2 : 3),
    );
    final scheduledDate = DateTime(2026, 11, 24);
    await tester.runAsync(() async {
      await database.customSelect('SELECT 1').get();
    });

    await _showSession(
      tester,
      settings,
      repository,
      scheduledDate,
      plannedSession,
    );
    await _startSession(tester);

    expect(find.text('0 de $totalSets series completadas'), findsOneWidget);
    await _enter(tester, 'set-0-repetitions', 'abc');
    expect(
      tester
          .widget<FilledButton>(find.byKey(const ValueKey('complete-set-0')))
          .onPressed,
      isNull,
    );

    await _enter(tester, 'set-0-repetitions', '8');
    // Load is optional for bodyweight exercise.
    await _tap(tester, find.byKey(const ValueKey('complete-set-0')));
    expect(find.text('1 de $totalSets series completadas'), findsOneWidget);
    expect(find.text('Descanso entre series'), findsOneWidget);
    await _skipRest(tester);

    await _enter(tester, 'set-1-repetitions', '9');
    await _enter(tester, 'set-1-load', '12');
    await _tap(tester, find.text('Completar serie').last);
    expect(find.text('2 de $totalSets series completadas'), findsOneWidget);
    await _skipRest(tester);

    await _enter(tester, 'set-0-repetitions', '');
    expect(find.text('1 de $totalSets series completadas'), findsOneWidget);
    expect(
      tester
          .widget<FilledButton>(find.byKey(const ValueKey('complete-set-0')))
          .onPressed,
      isNull,
    );
    await _enter(tester, 'set-0-repetitions', '10');
    await _tap(tester, find.byKey(const ValueKey('complete-set-0')));
    expect(find.text('2 de $totalSets series completadas'), findsOneWidget);
    await _skipRest(tester);
    expect(_fieldText(tester, 'set-1-repetitions'), '9');
    await _tap(tester, find.text('Desmarcar serie').first);
    expect(find.text('1 de $totalSets series completadas'), findsOneWidget);

    final savedDraft = jsonDecode(
      (await repository.loadActiveWorkout())!,
    ) as Map<String, Object?>;
    expect(savedDraft['completedSets'], contains('0:1'));
    expect(savedDraft['completedSets'], isNot(contains('0:0')));

    await _showSession(
      tester,
      settings,
      repository,
      scheduledDate,
      plannedSession,
    );
    await _resumeSession(tester);
    expect(_fieldText(tester, 'set-0-repetitions'), '10');
    expect(_fieldText(tester, 'set-1-repetitions'), '9');
    expect(find.text('1 de $totalSets series completadas'), findsOneWidget);
  });

  testWidgets('records timed sets in seconds and advances set progress', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(() async => database.close());
    final repository = WorkoutLogRepository(database: database);
    const settings = TrainingSettings();
    const plannedSession = PlannedTrainingSession(
      weekday: 2,
      title: 'Sesión de prueba',
      focus: 'Core',
      durationMinutes: 20,
      exercises: [
        PlannedExercise(
          catalogId: '3544',
          name: 'Plancha lateral inclinada',
          focus: 'Core',
          prescription: '2 series · 20–40 segundos',
          timed: true,
        ),
      ],
    );
    final scheduledDate = DateTime(2026, 11, 24);
    await tester.runAsync(() async {
      await database.customSelect('SELECT 1').get();
    });

    await _showSession(
      tester,
      settings,
      repository,
      scheduledDate,
      plannedSession,
    );
    await _startSession(tester);
    await _tap(tester, find.text('Iniciar serie de 30 segundos'));
    await _enter(tester, 'set-0-repetitions', '35');
    await _tap(tester, find.byKey(const ValueKey('complete-set-0')));

    expect(find.text('1 de 2 series completadas'), findsOneWidget);
    expect(find.text('Descanso entre series'), findsOneWidget);
    await _skipRest(tester);
    await tester.pump(const Duration(seconds: 31));
    expect(find.text('1 de 2 series completadas'), findsOneWidget);
    final savedDraft = jsonDecode(
      (await repository.loadActiveWorkout())!,
    ) as Map<String, Object?>;
    final savedSet = (savedDraft['sets'] as List<Object?>)
        .whereType<Map<String, Object?>>()
        .single;
    expect(savedSet['durationSeconds'], 35);
    expect(savedSet['repetitions'], isNull);
    expect(find.text('Iniciar serie de 30 segundos'), findsOneWidget);
  });
}

Future<void> _showSession(
  WidgetTester tester,
  TrainingSettings settings,
  WorkoutLogRepository repository,
  DateTime scheduledDate,
  PlannedTrainingSession plannedSession,
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

String _fieldText(WidgetTester tester, String key) => tester
    .widget<EditableText>(
      find.descendant(
        of: find.byKey(ValueKey(key)),
        matching: find.byType(EditableText),
      ),
    )
    .controller
    .text;

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

Future<void> _startSession(WidgetTester tester) async {
  if (find.text('Ver calentamiento').evaluate().isNotEmpty) {
    await tester.tap(find.text('Ver calentamiento'));
    await tester.pump();
    await tester.tap(find.text('Comenzar entrenamiento'));
  } else {
    await _resumeSession(tester);
  }
  await tester.pump();
}

Future<void> _resumeSession(WidgetTester tester) async {
  if (find.text('Continuar entrenamiento').evaluate().isEmpty) {
    for (var attempt = 0; attempt < 30; attempt++) {
      await tester.pump(const Duration(milliseconds: 100));
      if (find.text('Continuar entrenamiento').evaluate().isNotEmpty) break;
    }
  }
  await tester.tap(find.text('Continuar entrenamiento'));
  await tester.pump();
}
