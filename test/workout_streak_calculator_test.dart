import 'package:flutter_test/flutter_test.dart';
import 'package:forza/domain/models/workout_record.dart';
import 'package:forza/domain/use_cases/workout_streak_calculator.dart';

void main() {
  group('WorkoutStreakCalculator', () {
    final today = DateTime(2026, 11, 23, 12);

    test('returns zero when there is no completed workout', () {
      expect(WorkoutStreakCalculator.currentStreak([], now: today), 0);
    });

    test('counts one completed day', () {
      expect(
        WorkoutStreakCalculator.currentStreak([_record(today)], now: today),
        1,
      );
    });

    test('counts consecutive days and ignores duplicate workouts per day', () {
      final records = [
        for (var daysAgo = 0; daysAgo < 7; daysAgo++)
          _record(today.subtract(Duration(days: daysAgo))),
        _record(
          today.subtract(const Duration(days: 3)).add(const Duration(hours: 2)),
        ),
      ];
      expect(WorkoutStreakCalculator.currentStreak(records, now: today), 7);
    });

    test('counts longer consecutive runs', () {
      for (final length in [30, 100]) {
        final records = [
          for (var daysAgo = 0; daysAgo < length; daysAgo++)
            _record(today.subtract(Duration(days: daysAgo))),
        ];
        expect(
          WorkoutStreakCalculator.currentStreak(records, now: today),
          length,
        );
      }
    });

    test('keeps yesterday active but resets after a full missed day', () {
      expect(
        WorkoutStreakCalculator.currentStreak([
          _record(today.subtract(const Duration(days: 1))),
          _record(today.subtract(const Duration(days: 2))),
        ], now: today),
        2,
      );
      expect(
        WorkoutStreakCalculator.currentStreak([
          _record(today.subtract(const Duration(days: 2))),
        ], now: today),
        0,
      );
    });

    test('does not count future completed dates', () {
      expect(
        WorkoutStreakCalculator.currentStreak([
          _record(today.add(const Duration(days: 1))),
        ], now: today),
        0,
      );
    });
  });
}

WorkoutRecord _record(DateTime completedAt) => WorkoutRecord(
  scheduledDate: completedAt,
  completedAt: completedAt,
  title: 'Workout',
  goal: 'Strength',
  durationMinutes: 30,
  exerciseCount: 4,
);
