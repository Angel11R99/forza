import 'package:flutter_test/flutter_test.dart';
import 'package:forza/domain/models/workout_record.dart';
import 'package:forza/ui/features/progress/models/personal_records.dart';

void main() {
  test(
    'derives best load, repetitions and duration with the achieved date',
    () {
      final records = [
        _record(
          DateTime(2026, 6, 10),
          const ['Press de banca', 'Plancha frontal'],
          const ['bench', 'plank'],
          const [
            WorkoutSetResult(
              exercisePosition: 0,
              setIndex: 0,
              repetitions: 10,
              loadKg: 50,
            ),
            WorkoutSetResult(
              exercisePosition: 1,
              setIndex: 0,
              durationSeconds: 45,
            ),
          ],
        ),
        _record(
          DateTime(2026, 6, 2),
          const ['Press de banca', 'Plancha frontal'],
          const ['bench', 'plank'],
          const [
            WorkoutSetResult(
              exercisePosition: 0,
              setIndex: 0,
              repetitions: 8,
              loadKg: 50,
            ),
            WorkoutSetResult(
              exercisePosition: 1,
              setIndex: 0,
              durationSeconds: 30,
            ),
          ],
        ),
      ];

      final personalRecords = buildPersonalRecords(records);
      final benchLoad = personalRecords.singleWhere(
        (record) => record.exercise == 'Press de banca' && record.unit == 'kg',
      );
      expect(benchLoad.value, 50);
      expect(benchLoad.date, DateTime(2026, 6, 2));
      final benchReps = personalRecords.singleWhere(
        (record) => record.exercise == 'Press de banca' && record.unit == 'rep',
      );
      expect(benchReps.value, 10);
      expect(benchReps.date, DateTime(2026, 6, 10));
      final plankTime = personalRecords.singleWhere(
        (record) => record.exercise == 'Plancha frontal',
      );
      expect(plankTime.value, 45);
      expect(plankTime.unit, 's');
      expect(plankTime.date, DateTime(2026, 6, 10));
    },
  );

  test('returns no records for sessions without positive logged metrics', () {
    final records = [
      _record(
        DateTime(2026, 6, 10),
        const ['Press de banca'],
        const ['bench'],
        const [
          WorkoutSetResult(exercisePosition: 0, setIndex: 0, loadKg: 0),
          WorkoutSetResult(exercisePosition: 0, setIndex: 1),
          WorkoutSetResult(exercisePosition: 8, setIndex: 2, repetitions: 20),
        ],
      ),
    ];

    expect(buildPersonalRecords(records), isEmpty);
    expect(buildPersonalRecords(const []), isEmpty);
  });
}

WorkoutRecord _record(
  DateTime date,
  List<String> exercises,
  List<String?> exerciseIds,
  List<WorkoutSetResult> sets,
) => WorkoutRecord(
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
