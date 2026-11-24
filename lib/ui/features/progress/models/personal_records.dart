import '../../../../domain/models/workout_record.dart';
import 'progress_models.dart';

/// Returns one best mark per exercise and measurement unit.
/// Equal marks keep the first date they were achieved.
List<PersonalRecord> buildPersonalRecords(List<WorkoutRecord> records) {
  final bestByMetric = <String, PersonalRecord>{};
  final orderedRecords = [...records]
    ..sort((first, second) => first.date.compareTo(second.date));

  for (final record in orderedRecords) {
    for (final set in record.setResults) {
      if (set.exercisePosition < 0 ||
          set.exercisePosition >= record.exercises.length) {
        continue;
      }
      final exercise = record.exercises[set.exercisePosition].trim();
      if (exercise.isEmpty) continue;
      final exerciseId = set.exercisePosition < record.exerciseIds.length
          ? record.exerciseIds[set.exercisePosition]
          : null;
      final exerciseKey = exerciseId == null || exerciseId.isEmpty
          ? exercise.toLowerCase()
          : exerciseId;
      final metrics = <(double?, String)>[
        (set.loadKg, 'kg'),
        (set.repetitions?.toDouble(), 'rep'),
        (set.durationSeconds?.toDouble(), 's'),
      ];
      for (final (value, unit) in metrics) {
        if (value == null || !value.isFinite || value <= 0) continue;
        final key = '$exerciseKey|$unit';
        final current = bestByMetric[key];
        if (current == null ||
            value > current.value ||
            (value == current.value && record.date.isBefore(current.date))) {
          bestByMetric[key] = PersonalRecord(
            exercise: exercise,
            value: value,
            unit: unit,
            date: record.date,
          );
        }
      }
    }
  }

  final result = bestByMetric.values.toList()
    ..sort((first, second) {
      final exerciseComparison = first.exercise.compareTo(second.exercise);
      if (exerciseComparison != 0) return exerciseComparison;
      return _unitOrder(first.unit).compareTo(_unitOrder(second.unit));
    });
  return result;
}

int _unitOrder(String unit) => switch (unit) {
  'kg' => 0,
  'rep' => 1,
  's' => 2,
  _ => 3,
};
