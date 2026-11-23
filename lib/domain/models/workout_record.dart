class WorkoutRecord {
  const WorkoutRecord({
    required this.scheduledDate,
    required this.completedAt,
    required this.title,
    required this.goal,
    required this.durationMinutes,
    required this.exerciseCount,
    this.exercises = const [],
    this.completedOutsideApp = false,
    this.setResults = const [],
  });

  final DateTime scheduledDate;
  final DateTime completedAt;
  final String title;
  final String goal;
  final int durationMinutes;
  final int exerciseCount;
  final List<String> exercises;
  final bool completedOutsideApp;
  final List<WorkoutSetResult> setResults;

  DateTime get date =>
      DateTime(scheduledDate.year, scheduledDate.month, scheduledDate.day);

  Map<String, Object?> toJson() => {
    'scheduledDate': date.toIso8601String(),
    'completedAt': completedAt.toIso8601String(),
    'title': title,
    'goal': goal,
    'durationMinutes': durationMinutes,
    'exerciseCount': exerciseCount,
    'exercises': exercises,
    'completedOutsideApp': completedOutsideApp,
    'setResults': setResults.map((set) => set.toJson()).toList(),
  };

  factory WorkoutRecord.fromJson(Map<String, Object?> json) => WorkoutRecord(
    scheduledDate: DateTime.parse(json['scheduledDate']! as String),
    completedAt: DateTime.parse(json['completedAt']! as String),
    title: json['title'] as String? ?? 'Entrenamiento',
    goal: json['goal'] as String? ?? '',
    durationMinutes: json['durationMinutes']! as int,
    exerciseCount: json['exerciseCount']! as int,
    exercises: (json['exercises'] as List<Object?>? ?? const [])
        .whereType<String>()
        .toList(growable: false),
    completedOutsideApp: json['completedOutsideApp'] as bool? ?? false,
    setResults: (json['setResults'] as List<Object?>? ?? const [])
        .whereType<Map<String, Object?>>()
        .map(WorkoutSetResult.fromJson)
        .toList(growable: false),
  );
}

class WorkoutSetResult {
  const WorkoutSetResult({
    required this.exercisePosition,
    required this.setIndex,
    this.repetitions,
    this.loadKg,
    this.durationSeconds,
  });

  final int exercisePosition;
  final int setIndex;
  final int? repetitions;
  final double? loadKg;
  final int? durationSeconds;

  Map<String, Object?> toJson() => {
    'exercisePosition': exercisePosition,
    'setIndex': setIndex,
    'repetitions': repetitions,
    'loadKg': loadKg,
    'durationSeconds': durationSeconds,
  };

  factory WorkoutSetResult.fromJson(Map<String, Object?> json) =>
      WorkoutSetResult(
        exercisePosition: json['exercisePosition']! as int,
        setIndex: json['setIndex']! as int,
        repetitions: json['repetitions'] as int?,
        loadKg: (json['loadKg'] as num?)?.toDouble(),
        durationSeconds: json['durationSeconds'] as int?,
      );
}
