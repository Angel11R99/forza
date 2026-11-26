import 'workout_record.dart';

enum PersonalGoalType { sessionsPerWeek, exerciseLoad }

class PersonalGoal {
  const PersonalGoal({
    required this.id,
    required this.type,
    required this.targetValue,
    this.exerciseName,
    this.exerciseCatalogId,
    required this.createdAt,
  });

  final String id;
  final PersonalGoalType type;
  final double targetValue;
  final String? exerciseName;
  final String? exerciseCatalogId;
  final DateTime createdAt;

  String get unit =>
      type == PersonalGoalType.sessionsPerWeek ? 'sesiones' : 'kg';

  bool hasAmbiguousExerciseIdentity(List<WorkoutRecord> records) {
    if (type != PersonalGoalType.exerciseLoad || exerciseCatalogId != null) {
      return false;
    }
    final normalizedName = exerciseName?.trim().toLowerCase();
    if (normalizedName == null || normalizedName.isEmpty) return false;
    final catalogIds = <String>{};
    for (final record in records) {
      for (final set in record.setResults) {
        final position = set.exercisePosition;
        final index = _exerciseIndexForPosition(record, position);
        final name =
            set.exerciseName ??
            (index >= 0 && index < record.exercises.length
                ? record.exercises[index]
                : null);
        if (name?.trim().toLowerCase() != normalizedName) continue;
        final hasSetIdentity =
            set.exerciseName != null || set.exerciseCatalogId != null;
        final id =
            set.exerciseCatalogId ??
            (!hasSetIdentity && index >= 0 && index < record.exerciseIds.length
                ? record.exerciseIds[index]
                : null);
        if (id != null) catalogIds.add(id);
      }
    }
    return catalogIds.length > 1;
  }

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
    if (exerciseCatalogId == null &&
        (normalizedName == null || normalizedName.isEmpty)) {
      return 0;
    }
    final legacyCatalogIds = <String>{};
    final matchingSets = <({WorkoutRecord record, WorkoutSetResult set})>[];
    for (final record in records) {
      for (final set in record.setResults) {
        final position = set.exercisePosition;
        final index = _exerciseIndexForPosition(record, position);
        final hasSetIdentity =
            set.exerciseName != null || set.exerciseCatalogId != null;
        final recordExerciseId =
            !hasSetIdentity && index >= 0 && index < record.exerciseIds.length
            ? record.exerciseIds[index]
            : null;
        final catalogId = set.exerciseCatalogId ?? recordExerciseId;
        final recordedName =
            set.exerciseName ??
            (index >= 0 && index < record.exercises.length
                ? record.exercises[index]
                : null);
        final matches = exerciseCatalogId != null
            ? catalogId == exerciseCatalogId
            : normalizedName != null &&
                  recordedName?.trim().toLowerCase() == normalizedName;
        if (matches) {
          matchingSets.add((record: record, set: set));
          if (exerciseCatalogId == null && catalogId != null) {
            legacyCatalogIds.add(catalogId);
          }
        }
      }
    }
    // A legacy name that maps to multiple catalog identities is ambiguous.
    // Never combine records for distinct movements under one goal.
    if (exerciseCatalogId == null && legacyCatalogIds.length > 1) return 0;

    var bestLoad = 0.0;
    for (final match in matchingSets) {
      final load = match.set.loadKg ?? 0;
      if (load > bestLoad) bestLoad = load;
    }
    return bestLoad;
  }
}

int _exerciseIndexForPosition(WorkoutRecord record, int position) {
  if (record.exercisePositions.isEmpty) return position;
  return record.exercisePositions.indexOf(position);
}
