import 'package:flutter_test/flutter_test.dart';
import 'package:forza/domain/models/personal_goal.dart';
import 'package:forza/domain/models/workout_record.dart';

void main() {
  final day = DateTime(2026, 11, 20);

  WorkoutRecord record({
    required List<String> exercises,
    required List<String?> exerciseIds,
    required List<WorkoutSetResult> sets,
    List<int> exercisePositions = const [],
  }) => WorkoutRecord(
    scheduledDate: day,
    completedAt: day,
    title: 'Strength',
    goal: 'Strength',
    durationMinutes: 30,
    exerciseCount: exercises.length,
    exercises: exercises,
    exerciseIds: exerciseIds,
    exercisePositions: exercisePositions,
    setResults: sets,
  );

  test(
    'catalog identity keeps localized variants and nonconsecutive sets apart',
    () {
      final goal = PersonalGoal(
        id: 'goal',
        type: PersonalGoalType.exerciseLoad,
        targetValue: 80,
        exerciseName: 'Press de banca',
        exerciseCatalogId: 'bench-press',
        createdAt: day,
      );
      final workout = record(
        exercises: ['Remo', 'Press de banca'],
        exerciseIds: ['row', 'bench-press'],
        exercisePositions: const [1, 4],
        sets: const [
          WorkoutSetResult(
            exercisePosition: 4,
            setIndex: 0,
            loadKg: 60,
            exerciseCatalogId: 'bench-press',
            exerciseName: 'Barbell bench press',
          ),
          WorkoutSetResult(
            exercisePosition: 1,
            setIndex: 1,
            loadKg: 120,
            exerciseCatalogId: 'chest-press-machine',
            exerciseName: 'Bench press',
          ),
        ],
      );

      expect(goal.currentValue([workout]), 60);
    },
  );

  test('legacy name goals refuse to combine duplicate catalog identities', () {
    final goal = PersonalGoal(
      id: 'legacy',
      type: PersonalGoalType.exerciseLoad,
      targetValue: 80,
      exerciseName: 'Press de banca',
      createdAt: day,
    );
    final workout = record(
      exercises: ['Press de banca', 'Press de banca'],
      exerciseIds: ['barbell-bench', 'machine-press'],
      sets: const [
        WorkoutSetResult(
          exercisePosition: 0,
          setIndex: 0,
          loadKg: 60,
          exerciseCatalogId: 'barbell-bench',
          exerciseName: 'Press de banca',
        ),
        WorkoutSetResult(
          exercisePosition: 1,
          setIndex: 0,
          loadKg: 100,
          exerciseCatalogId: 'machine-press',
          exerciseName: 'Press de banca',
        ),
      ],
    );

    expect(goal.hasAmbiguousExerciseIdentity([workout]), isTrue);
    expect(goal.currentValue([workout]), 0);
  });

  test('legacy name goals still work when historical identity is unique', () {
    final goal = PersonalGoal(
      id: 'legacy',
      type: PersonalGoalType.exerciseLoad,
      targetValue: 80,
      exerciseName: 'Press de banca',
      createdAt: day,
    );
    final workout = record(
      exercises: ['Press de banca'],
      exerciseIds: ['barbell-bench'],
      sets: const [
        WorkoutSetResult(
          exercisePosition: 0,
          setIndex: 0,
          loadKg: 60,
          exerciseCatalogId: 'barbell-bench',
          exerciseName: 'Press de banca',
        ),
      ],
    );

    expect(goal.hasAmbiguousExerciseIdentity([workout]), isFalse);
    expect(goal.currentValue([workout]), 60);
  });
}
