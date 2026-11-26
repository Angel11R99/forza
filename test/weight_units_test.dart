import 'package:flutter_test/flutter_test.dart';
import 'package:forza/domain/models/personal_goal.dart';
import 'package:forza/domain/models/workout_record.dart';
import 'package:forza/domain/use_cases/weight_units.dart';

void main() {
  test('converts pounds to canonical kilograms without changing kg values', () {
    expect(weightToKilograms(100, 'lb'), closeTo(45.359237, 0.000001));
    expect(weightFromKilograms(45.359237, 'lb'), 100);
    expect(weightToKilograms(50, 'kg'), 50);
    expect(weightFromKilograms(50, 'kg'), 50);
  });

  test('week boundaries follow the selected first day', () {
    final sunday = DateTime(2026, 11, 22);
    expect(startOfWeek(sunday, 'Lunes'), DateTime(2026, 11, 16));
    expect(startOfWeek(sunday, 'Domingo'), sunday);

    final monday = DateTime(2026, 11, 23);
    expect(startOfWeek(monday, 'Lunes'), monday);
    expect(startOfWeek(monday, 'Domingo'), sunday);
  });

  test('weekly session goal honors Sunday week boundary', () {
    final goal = PersonalGoal(
      id: 'weekly',
      type: PersonalGoalType.sessionsPerWeek,
      targetValue: 3,
      createdAt: DateTime(2026, 1, 1),
    );
    final records = [
      _record(DateTime(2026, 11, 21)),
      _record(DateTime(2026, 11, 22)),
    ];
    expect(goal.currentValue(records, today: DateTime(2026, 11, 22)), 2);
    expect(
      goal.currentValue(
        records,
        today: DateTime(2026, 11, 22),
        weekStartsOn: 'Domingo',
      ),
      1,
    );
    expect(goal.currentValue(records, today: DateTime(2026, 11, 23)), 0);
    expect(
      goal.currentValue(
        records,
        today: DateTime(2026, 11, 23),
        weekStartsOn: 'Domingo',
      ),
      1,
    );
  });
}

WorkoutRecord _record(DateTime date) => WorkoutRecord(
  scheduledDate: date,
  completedAt: date,
  title: 'Workout',
  goal: 'Strength',
  durationMinutes: 30,
  exerciseCount: 1,
  exercises: const ['Squat'],
);
