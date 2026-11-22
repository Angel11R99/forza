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
  });

  final String id;
  final String title;
  final DateTime date;
  final int durationMinutes;
  final int exerciseCount;
  final int totalVolumeKg;
  final List<String> exercises;
  final bool completedOutsideApp;
}

class MeasurementEntry {
  const MeasurementEntry({
    required this.date,
    required this.weightKg,
    this.chestCm,
    this.waistCm,
    this.hipsCm,
    this.armCm,
  });

  final DateTime date;
  final double weightKg;
  final double? chestCm;
  final double? waistCm;
  final double? hipsCm;
  final double? armCm;
}

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
