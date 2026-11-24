import 'package:flutter_test/flutter_test.dart';
import 'package:forza/domain/models/workout_record.dart';
import 'package:forza/ui/features/progress/models/strength_evolution.dart';

void main() {
  final now = DateTime(2026, 11, 24);

  test('uses the heaviest positive logged load per exercise and workout', () {
    final series = buildStrengthEvolutionSeries(
      [
        _record(
          date: DateTime(2026, 9, 1),
          exercises: const ['Press de banca', 'Sentadilla con barra'],
          exerciseIds: const ['bench', 'squat'],
          sets: const [
            WorkoutSetResult(exercisePosition: 0, setIndex: 0, loadKg: 40),
            WorkoutSetResult(exercisePosition: 0, setIndex: 1, loadKg: 52.5),
            WorkoutSetResult(exercisePosition: 1, setIndex: 0, loadKg: 70),
            WorkoutSetResult(
              exercisePosition: 1,
              setIndex: 1,
              durationSeconds: 45,
            ),
          ],
        ),
        _record(
          date: DateTime(2026, 10, 5),
          exercises: const ['Press de banca'],
          exerciseIds: const ['bench'],
          sets: const [
            WorkoutSetResult(exercisePosition: 0, setIndex: 0, loadKg: 50),
          ],
        ),
        _record(
          date: DateTime(2026, 10, 12),
          exercises: const ['Press de banca'],
          exerciseIds: const ['bench'],
          sets: const [
            WorkoutSetResult(exercisePosition: 0, setIndex: 0, repetitions: 12),
          ],
        ),
      ],
      now: now,
      periodDays: 90,
    );

    final bench = series.singleWhere((item) => item.exerciseKey == 'id:bench');
    expect(bench.points.map((point) => point.loadKg), [52.5, 50]);
    expect(bench.points.map((point) => point.date), [
      DateTime(2026, 9, 1),
      DateTime(2026, 10, 5),
    ]);
    final squat = series.singleWhere((item) => item.exerciseKey == 'id:squat');
    expect(squat.points.single.loadKg, 70);
  });

  test('period filter excludes older workouts and missing loads', () {
    final series = buildStrengthEvolutionSeries(
      [
        _record(
          date: DateTime(2026, 6, 1),
          exercises: const ['Press de banca'],
          exerciseIds: const ['bench'],
          sets: const [
            WorkoutSetResult(exercisePosition: 0, setIndex: 0, loadKg: 80),
          ],
        ),
        _record(
          date: DateTime(2026, 11, 1),
          exercises: const ['Press de banca'],
          exerciseIds: const ['bench'],
          sets: const [
            WorkoutSetResult(
              exercisePosition: 0,
              setIndex: 0,
              durationSeconds: 60,
            ),
            WorkoutSetResult(exercisePosition: 0, setIndex: 1, loadKg: 0),
          ],
        ),
      ],
      now: now,
      periodDays: 30,
    );

    expect(series, isEmpty);
  });
}

WorkoutRecord _record({
  required DateTime date,
  required List<String> exercises,
  required List<String?> exerciseIds,
  required List<WorkoutSetResult> sets,
}) => WorkoutRecord(
  scheduledDate: date,
  completedAt: date.add(const Duration(hours: 1)),
  title: 'Sesión',
  goal: 'Fuerza',
  durationMinutes: 45,
  exerciseCount: exercises.length,
  exercises: exercises,
  exerciseIds: exerciseIds,
  setResults: sets,
);
