import 'workout_record.dart';

enum PersonalGoalType { sessionsPerWeek, exerciseLoad }

class PersonalGoal {
  const PersonalGoal({
    required this.id,
    required this.type,
    required this.targetValue,
    this.exerciseName,
    required this.createdAt,
  });

  final String id;
  final PersonalGoalType type;
  final double targetValue;
  final String? exerciseName;
  final DateTime createdAt;

  String get unit =>
      type == PersonalGoalType.sessionsPerWeek ? 'sesiones' : 'kg';

  double currentValue(List<WorkoutRecord> records, {DateTime? today}) {
    if (type == PersonalGoalType.sessionsPerWeek) {
      final now = today ?? DateTime.now();
      final date = DateTime(now.year, now.month, now.day);
      final weekStart = date.subtract(Duration(days: date.weekday - 1));
      final weekEnd = weekStart.add(const Duration(days: 7));
      return records
          .where(
            (record) =>
                !record.date.isBefore(weekStart) &&
                record.date.isBefore(weekEnd),
          )
          .map((record) => record.date)
          .toSet()
          .length
          .toDouble();
    }

    final normalizedName = exerciseName?.trim().toLowerCase();
    if (normalizedName == null || normalizedName.isEmpty) return 0;
    var bestLoad = 0.0;
    for (final record in records) {
      for (final set in record.setResults) {
        if (set.exercisePosition < 0 ||
            set.exercisePosition >= record.exercises.length ||
            record.exercises[set.exercisePosition].trim().toLowerCase() !=
                normalizedName) {
          continue;
        }
        final load = set.loadKg ?? 0;
        if (load > bestLoad) bestLoad = load;
      }
    }
    return bestLoad;
  }
}
