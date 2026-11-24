import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:forza/domain/use_cases/training_plan_builder.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const builder = TrainingPlanBuilder();

  final catalogJson = File('assets/data/exercises.json').readAsStringSync();
  final catalog = (jsonDecode(catalogJson) as List<Object?>)
      .map((item) => (item! as Map<String, Object?>)['id'].toString())
      .toSet();

  test('all generated routines use existing catalog IDs across settings', () {
    const goals = ['Ganar fuerza', 'Ganar músculo', 'Crear el hábito'];
    const experiences = [
      'Estoy empezando',
      'Tengo algo de experiencia',
      'Entreno hace tiempo',
    ];
    const equipmentOptions = [
      {'Peso corporal'},
      {'Mancuernas'},
      {'Barra'},
      {'Banda elástica'},
      {'Polea'},
      {'Máquina de palanca'},
      {'Mancuernas', 'Barra', 'Banda elástica', 'Polea'},
    ];

    for (final goal in goals) {
      for (final experience in experiences) {
        for (final equipment in equipmentOptions) {
          for (final minutes in [20, 45, 90]) {
            final sessions = builder.buildWeek(
              trainingDays: const {DateTime.monday, DateTime.thursday},
              sessionMinutes: minutes,
              goal: goal,
              experience: experience,
              equipment: equipment,
            );

            expect(sessions, hasLength(2));
            for (final session in sessions) {
              expect(session.durationMinutes, minutes);
              expect(session.exercises, isNotEmpty);
              for (final exercise in session.exercises) {
                expect(catalog, contains(exercise.catalogId));
              }
              expect(
                session.exercises.map((exercise) => exercise.catalogId).toSet(),
                hasLength(session.exercises.length),
              );
            }
          }
        }
      }
    }
  });

  test('rejects invalid plan preferences', () {
    void build({
      Set<int> days = const {DateTime.monday},
      int minutes = 45,
      String goal = 'Ganar fuerza',
      String experience = 'Estoy empezando',
      Set<String> equipment = const {'Peso corporal'},
    }) => builder.buildWeek(
      trainingDays: days,
      sessionMinutes: minutes,
      goal: goal,
      experience: experience,
      equipment: equipment,
    );

    expect(() => build(days: {}), throwsFormatException);
    expect(() => build(days: {8}), throwsFormatException);
    expect(() => build(minutes: 19), throwsFormatException);
    expect(() => build(minutes: 91), throwsFormatException);
    expect(() => build(goal: 'Objetivo desconocido'), throwsFormatException);
    expect(
      () => build(experience: 'Experiencia desconocida'),
      throwsFormatException,
    );
    expect(() => build(equipment: {}), throwsFormatException);
    expect(
      () => build(equipment: {'Equipo desconocido'}),
      throwsFormatException,
    );
  });

  test('session snapshots survive JSON serialization', () {
    final session = builder
        .buildWeek(
          trainingDays: const {DateTime.monday},
          sessionMinutes: 45,
          goal: 'Ganar fuerza',
          experience: 'Estoy empezando',
          equipment: const {'Mancuernas'},
        )
        .single;

    final restored = PlannedTrainingSession.fromJson(
      jsonDecode(jsonEncode(session.toJson())) as Map<String, Object?>,
    );

    expect(restored.weekday, session.weekday);
    expect(restored.title, session.title);
    expect(
      restored.exercises.map((exercise) => exercise.catalogId),
      session.exercises.map((exercise) => exercise.catalogId),
    );
  });

  test('avoided movements are replaced with compatible catalog options', () {
    final sessions = builder.buildWeek(
      trainingDays: const {DateTime.monday},
      sessionMinutes: 45,
      goal: 'Ganar fuerza',
      experience: 'Estoy empezando',
      equipment: const {'Mancuernas'},
      avoidedExerciseIds: const {'1700'},
    );

    expect(sessions.single.exercises, isNotEmpty);
    expect(
      sessions.single.exercises.map((exercise) => exercise.catalogId),
      isNot(contains('1700')),
    );
    expect(
      sessions.single.exercises.every(
        (exercise) => builder.exerciseOptions.any(
          (option) =>
              option.catalogId == exercise.catalogId &&
              (option.equipment == null || option.equipment == 'Mancuernas'),
        ),
      ),
      isTrue,
    );
  });

  test('shows no alternatives when every catalog movement is avoided', () {
    final allAvoided = builder.exerciseOptions
        .map((exercise) => exercise.catalogId)
        .toSet();
    final sessions = builder.buildWeek(
      trainingDays: const {DateTime.monday},
      sessionMinutes: 45,
      goal: 'Ganar fuerza',
      experience: 'Estoy empezando',
      equipment: const {
        'Peso corporal',
        'Mancuernas',
        'Barra',
        'Banda elástica',
        'Polea',
        'Máquina de palanca',
      },
      avoidedExerciseIds: allAvoided,
    );

    expect(sessions.single.exercises, isEmpty);
    expect(
      () => builder.buildWeek(
        trainingDays: const {DateTime.monday},
        sessionMinutes: 45,
        goal: 'Ganar fuerza',
        experience: 'Estoy empezando',
        equipment: const {'Mancuernas'},
        avoidedExerciseIds: const {'unknown'},
      ),
      throwsFormatException,
    );
  });
}
