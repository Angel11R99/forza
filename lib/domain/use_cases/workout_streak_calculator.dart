import '../models/workout_record.dart';

/// Calculates the current streak from completed workouts.
///
/// A local calendar day counts once when at least one workout was completed.
/// The streak remains active through today if the latest activity was today
/// or yesterday, and resets after a full missed day.
abstract final class WorkoutStreakCalculator {
  static int currentStreak(List<WorkoutRecord> records, {DateTime? now}) {
    final today = _dateOnly((now ?? DateTime.now()).toLocal());
    final activityDays = <DateTime>{
      for (final record in records) _dateOnly(record.completedAt.toLocal()),
    }..removeWhere((date) => date.isAfter(today));

    if (activityDays.isEmpty) return 0;

    var cursor = activityDays.contains(today)
        ? today
        : today.subtract(const Duration(days: 1));
    if (!activityDays.contains(cursor)) return 0;

    var streak = 0;
    while (activityDays.contains(cursor)) {
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return streak;
  }

  static DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);
}
