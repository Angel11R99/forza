import '../../../../domain/models/workout_record.dart';
import '../../../../domain/models/body_measurement.dart';

class WorkoutHistoryEntry {
  const WorkoutHistoryEntry({
    required this.id,
    required this.title,
    required this.date,
    required this.durationMinutes,
    required this.exerciseCount,
    required this.totalVolumeKg,
    required this.exercises,
    this.completedOutsideApp = false,
    this.totalRepetitions = 0,
    this.loggedSets = const [],
  });

  final String id;
  final String title;
  final DateTime date;
  final int durationMinutes;
  final int exerciseCount;
  final double totalVolumeKg;
  final int totalRepetitions;
  final List<String> exercises;
  final List<WorkoutSetResult> loggedSets;
  final bool completedOutsideApp;

  factory WorkoutHistoryEntry.fromRecord(WorkoutRecord record) {
    final loggedSets = record.setResults
        .where(
          (set) =>
              set.repetitions != null ||
              set.loadKg != null ||
              set.durationSeconds != null,
        )
        .toList(growable: false);
    final totalVolume = loggedSets.fold<double>(
      0,
      (sum, set) => sum + ((set.repetitions ?? 0) * (set.loadKg ?? 0)),
    );
    final repetitions = loggedSets.fold<int>(
      0,
      (sum, set) => sum + (set.repetitions ?? 0),
    );
    return WorkoutHistoryEntry(
      id: record.date.toIso8601String(),
      title: record.title,
      date: record.date,
      durationMinutes: record.durationMinutes,
      exerciseCount: record.exerciseCount,
      totalVolumeKg: totalVolume,
      totalRepetitions: repetitions,
      exercises: record.exercises,
      loggedSets: loggedSets,
      completedOutsideApp: record.completedOutsideApp,
    );
  }
}

typedef MeasurementEntry = BodyMeasurement;

class PersonalRecord {
  const PersonalRecord({
    required this.exercise,
    required this.value,
    required this.unit,
    required this.date,
  });

  final String exercise;
  final double value;
  final String unit;
  final DateTime date;
}
