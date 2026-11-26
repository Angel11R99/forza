import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:forza/domain/models/workout_record.dart';
import 'package:forza/domain/use_cases/training_plan_builder.dart';
import 'package:forza/domain/use_cases/training_progression_advisor.dart';

void main() {
  const advisor = TrainingProgressionAdvisor();
  const exercise = PlannedExercise(
    catalogId: '1700',
    name: 'Press con mancuernas',
    focus: 'Pecho',
    prescription: '2 series · 6–8 repeticiones',
    tracksExternalLoad: true,
  );
  const session = PlannedTrainingSession(
    weekday: DateTime.monday,
    title: 'Cuerpo completo',
    focus: 'Rutina de cuerpo completo',
    durationMinutes: 45,
    exercises: [exercise],
  );
  const timedExercise = PlannedExercise(
    catalogId: '0464',
    name: 'Plancha',
    focus: 'Core',
    prescription: '2 series · 20–40 segundos',
    timed: true,
  );
  const timedSession = PlannedTrainingSession(
    weekday: DateTime.monday,
    title: 'Cuerpo completo',
    focus: 'Rutina de cuerpo completo',
    durationMinutes: 45,
    exercises: [timedExercise],
  );
  const bodyweightExercise = PlannedExercise(
    catalogId: '0662',
    name: 'Flexiones',
    focus: 'Pecho',
    prescription: '2 series · 8–12 repeticiones',
  );
  const bodyweightSession = PlannedTrainingSession(
    weekday: DateTime.monday,
    title: 'Cuerpo completo',
    focus: 'Rutina de cuerpo completo',
    durationMinutes: 45,
    exercises: [bodyweightExercise],
  );

  test('beginners need three complete sessions at the top of the range', () {
    final twoSessions = _history(session, count: 2);
    final threeSessions = _history(session, count: 3);

    expect(
      advisor
          .evaluate(
            exercise: exercise,
            goal: 'Ganar fuerza',
            experience: 'Estoy empezando',
            history: twoSessions,
            asOf: DateTime(2026, 1, 10),
          )
          .status,
      TrainingProgressionStatus.keepBuilding,
    );
    expect(
      advisor
          .evaluate(
            exercise: exercise,
            goal: 'Ganar fuerza',
            experience: 'Estoy empezando',
            history: threeSessions,
            asOf: DateTime(2026, 1, 10),
          )
          .status,
      TrainingProgressionStatus.readyToIncrease,
    );
  });

  test('experienced users need two consecutive successful sessions', () {
    expect(
      advisor
          .evaluate(
            exercise: exercise,
            goal: 'Ganar fuerza',
            experience: 'Entreno hace tiempo',
            history: _history(session, count: 2),
            asOf: DateTime(2026, 1, 10),
          )
          .status,
      TrainingProgressionStatus.readyToIncrease,
    );
  });

  test('does not suggest a change before there is exercise history', () {
    expect(
      advisor
          .evaluate(
            exercise: exercise,
            goal: 'Ganar músculo',
            experience: 'Tengo algo de experiencia',
            history: const [],
            asOf: DateTime(2026, 1, 10),
          )
          .status,
      TrainingProgressionStatus.noHistory,
    );
  });

  test('holds progression after a month without logging the exercise', () {
    expect(
      advisor
          .evaluate(
            exercise: exercise,
            goal: 'Ganar fuerza',
            experience: 'Entreno hace tiempo',
            history: _history(session, count: 3),
            asOf: DateTime(2026, 3, 1),
          )
          .status,
      TrainingProgressionStatus.returningAfterBreak,
    );
  });

  test(
    'does not recommend more load when a set misses the target or load changes',
    () {
      final incompleteTarget = _history(
        session,
        count: 3,
        repetitionsBySession: const [
          [8, 8],
          [8, 8],
          [8, 7],
        ],
      );
      final changingLoads = _history(
        session,
        count: 3,
        setLoadsBySession: const [
          [10, 10],
          [10, 10],
          [10, 12],
        ],
      );

      for (final history in [incompleteTarget, changingLoads]) {
        expect(
          advisor
              .evaluate(
                exercise: exercise,
                goal: 'Ganar fuerza',
                experience: 'Tengo algo de experiencia',
                history: history,
                asOf: DateTime(2026, 1, 10),
              )
              .status,
          TrainingProgressionStatus.keepBuilding,
        );
      }
    },
  );

  test('habit plans emphasize consistency instead of increasing load', () {
    expect(
      advisor
          .evaluate(
            exercise: exercise,
            goal: 'Crear el hábito',
            experience: 'Entreno hace tiempo',
            history: _history(session, count: 3, goal: 'Crear el hábito'),
            asOf: DateTime(2026, 1, 10),
          )
          .status,
      TrainingProgressionStatus.habitFocus,
    );
  });

  test(
    'timed exercises only suggest a harder variation after consistent sets',
    () {
      final completedAtTarget = _history(
        timedSession,
        count: 3,
        goal: 'Ganar fuerza',
        setDurationsBySession: const [
          [40, 40],
          [40, 40],
          [40, 40],
        ],
        catalogId: '0464',
      );
      final belowTarget = _history(
        timedSession,
        count: 3,
        goal: 'Ganar fuerza',
        setDurationsBySession: const [
          [40, 40],
          [40, 40],
          [30, 40],
        ],
        catalogId: '0464',
      );

      expect(
        advisor
            .evaluate(
              exercise: timedExercise,
              goal: 'Ganar fuerza',
              experience: 'Estoy empezando',
              history: completedAtTarget,
              asOf: DateTime(2026, 1, 10),
            )
            .status,
        TrainingProgressionStatus.timedReadyToVary,
      );
      expect(
        advisor
            .evaluate(
              exercise: timedExercise,
              goal: 'Ganar fuerza',
              experience: 'Estoy empezando',
              history: belowTarget,
              asOf: DateTime(2026, 1, 10),
            )
            .status,
        TrainingProgressionStatus.timedKeepBuilding,
      );
    },
  );

  test(
    'bodyweight exercises suggest a harder variation without adding load',
    () {
      expect(
        advisor
            .evaluate(
              exercise: bodyweightExercise,
              goal: 'Ganar músculo',
              experience: 'Tengo algo de experiencia',
              history: _history(
                bodyweightSession,
                count: 2,
                goal: 'Ganar músculo',
                repetitions: const [12, 12],
                catalogId: '0662',
                recordLoad: false,
              ),
              asOf: DateTime(2026, 1, 10),
            )
            .status,
        TrainingProgressionStatus.readyToVary,
      );
    },
  );

  test('unquantified band resistance does not require a numeric load', () {
    const bandExercise = PlannedExercise(
      catalogId: '1254',
      name: 'Press con banda',
      focus: 'Pecho',
      prescription: '2 series · 8–12 repeticiones',
    );
    const bandSession = PlannedTrainingSession(
      weekday: DateTime.monday,
      title: 'Cuerpo completo',
      focus: 'Rutina de cuerpo completo',
      durationMinutes: 45,
      exercises: [bandExercise],
    );

    expect(
      advisor
          .evaluate(
            exercise: bandExercise,
            goal: 'Ganar músculo',
            experience: 'Tengo algo de experiencia',
            history: _history(
              bandSession,
              count: 2,
              goal: 'Ganar músculo',
              repetitions: const [12, 12],
              catalogId: '1254',
              recordLoad: false,
            ),
            asOf: DateTime(2026, 1, 10),
          )
          .status,
      TrainingProgressionStatus.readyToVary,
    );
  });
}

List<WorkoutRecord> _history(
  PlannedTrainingSession session, {
  required int count,
  String goal = 'Ganar fuerza',
  List<int> repetitions = const [8, 8],
  List<List<int>>? repetitionsBySession,
  List<List<double>>? setLoadsBySession,
  List<List<int>>? setDurationsBySession,
  String catalogId = '1700',
  bool recordLoad = true,
}) => [
  for (var index = 0; index < count; index++)
    WorkoutRecord(
      scheduledDate: DateTime(2026, 1, index + 1),
      completedAt: DateTime(2026, 1, index + 1, 12),
      title: session.title,
      goal: goal,
      durationMinutes: 30,
      exerciseCount: 1,
      exerciseIds: [catalogId],
      planSnapshot: jsonEncode(session.toJson()),
      setResults: [
        for (
          var setIndex = 0;
          setIndex < (repetitionsBySession?[index] ?? repetitions).length;
          setIndex++
        )
          WorkoutSetResult(
            exercisePosition: 0,
            setIndex: setIndex,
            repetitions: setDurationsBySession == null
                ? (repetitionsBySession?[index] ?? repetitions)[setIndex]
                : null,
            loadKg: setDurationsBySession == null && recordLoad
                ? (setLoadsBySession?[index] ??
                      List<double>.filled(
                        (repetitionsBySession?[index] ?? repetitions).length,
                        10,
                      ))[setIndex]
                : null,
            durationSeconds: setDurationsBySession?[index][setIndex],
          ),
      ],
    ),
];
