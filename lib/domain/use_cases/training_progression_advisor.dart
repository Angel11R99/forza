import 'dart:convert';

import '../models/workout_record.dart';
import 'training_plan_builder.dart';

enum TrainingProgressionStatus {
  noHistory,
  keepBuilding,
  readyToIncrease,
  readyToVary,
  habitFocus,
  returningAfterBreak,
  timedKeepBuilding,
  timedReadyToVary,
}

class TrainingProgressionAdvice {
  const TrainingProgressionAdvice({
    required this.status,
    required this.successfulSessions,
    required this.requiredSessions,
    required this.targetValue,
  });

  final TrainingProgressionStatus status;
  final int successfulSessions;
  final int requiredSessions;
  final int targetValue;
}

class TrainingProgressionAdvisor {
  const TrainingProgressionAdvisor();
  static const _planBuilder = TrainingPlanBuilder();

  TrainingProgressionAdvice evaluate({
    required PlannedExercise exercise,
    required String goal,
    required String experience,
    required Iterable<WorkoutRecord> history,
    DateTime? asOf,
  }) {
    final requiredSessions = experience == 'Estoy empezando' ? 3 : 2;
    final targetRange = _repetitionRange(exercise.prescription);
    final requiresLoad =
        exercise.tracksExternalLoad ||
        _planBuilder.exerciseOptions.any(
          (option) =>
              option.catalogId == exercise.catalogId &&
              option.tracksExternalLoad,
        );
    if (targetRange == null) {
      return TrainingProgressionAdvice(
        status: TrainingProgressionStatus.keepBuilding,
        successfulSessions: 0,
        requiredSessions: requiredSessions,
        targetValue: 0,
      );
    }

    final exposures = <_ExerciseExposure>[];
    for (final record in history.where((record) => record.goal == goal)) {
      final exposure = _exposureFor(record, exercise);
      if (exposure != null) exposures.add(exposure);
    }
    exposures.sort((a, b) => b.date.compareTo(a.date));

    if (exposures.isEmpty) {
      return TrainingProgressionAdvice(
        status: TrainingProgressionStatus.noHistory,
        successfulSessions: 0,
        requiredSessions: requiredSessions,
        targetValue: targetRange.$2,
      );
    }

    if (goal == 'Crear el hábito') {
      return TrainingProgressionAdvice(
        status: TrainingProgressionStatus.habitFocus,
        successfulSessions: 0,
        requiredSessions: requiredSessions,
        targetValue: targetRange.$2,
      );
    }

    if ((asOf ?? DateTime.now()).difference(exposures.first.date) >
        const Duration(days: 28)) {
      return TrainingProgressionAdvice(
        status: TrainingProgressionStatus.returningAfterBreak,
        successfulSessions: 0,
        requiredSessions: requiredSessions,
        targetValue: targetRange.$2,
      );
    }

    var successfulSessions = 0;
    double? consistentLoad;
    for (final exposure in exposures) {
      if (!exposure.isComplete ||
          exposure.sets.any(
            (set) => exercise.timed
                ? (set.durationSeconds ?? 0) < targetRange.$2
                : (set.repetitions ?? 0) < targetRange.$2 ||
                      (requiresLoad && (set.loadKg ?? 0) <= 0),
          )) {
        break;
      }
      if (!exercise.timed && requiresLoad) {
        final loads = exposure.sets.map((set) => set.loadKg!).toList();
        if (loads.any((load) => (load - loads.first).abs() > 0.001)) break;
        if (consistentLoad != null &&
            (loads.first - consistentLoad).abs() > 0.001) {
          break;
        }
        consistentLoad = loads.first;
      }
      successfulSessions++;
    }

    return TrainingProgressionAdvice(
      status: exercise.timed
          ? successfulSessions >= requiredSessions
                ? TrainingProgressionStatus.timedReadyToVary
                : TrainingProgressionStatus.timedKeepBuilding
          : successfulSessions >= requiredSessions
          ? requiresLoad
                ? TrainingProgressionStatus.readyToIncrease
                : TrainingProgressionStatus.readyToVary
          : TrainingProgressionStatus.keepBuilding,
      successfulSessions: successfulSessions,
      requiredSessions: requiredSessions,
      targetValue: targetRange.$2,
    );
  }

  _ExerciseExposure? _exposureFor(
    WorkoutRecord record,
    PlannedExercise currentExercise,
  ) {
    var position = -1;
    var expectedSets = 0;
    if (record.planSnapshot.isNotEmpty) {
      try {
        final decoded = jsonDecode(record.planSnapshot);
        if (decoded is Map) {
          final session = PlannedTrainingSession.fromJson(
            Map<String, Object?>.from(decoded),
          );
          position = session.exercises.indexWhere(
            (exercise) => exercise.catalogId == currentExercise.catalogId,
          );
          if (position >= 0) {
            expectedSets = _setCount(session.exercises[position].prescription);
          }
        }
      } on Object {
        return null;
      }
    }
    if (position < 0) {
      position = record.exerciseIds.indexOf(currentExercise.catalogId);
      expectedSets = _setCount(currentExercise.prescription);
    }
    if (position < 0 || expectedSets < 1) return null;

    final sets =
        record.setResults
            .where((set) => set.exercisePosition == position)
            .toList(growable: false)
          ..sort((a, b) => a.setIndex.compareTo(b.setIndex));
    return _ExerciseExposure(
      date: record.completedAt,
      sets: sets,
      expectedSets: expectedSets,
    );
  }

  int _setCount(String prescription) =>
      int.tryParse(
        RegExp(r'^(\d+)\s+series').firstMatch(prescription)?.group(1) ?? '',
      ) ??
      0;

  (int, int)? _repetitionRange(String prescription) {
    final match = RegExp(r'(\d+)\s*[–-]\s*(\d+)').firstMatch(prescription);
    if (match == null) return null;
    final minimum = int.tryParse(match.group(1)!);
    final maximum = int.tryParse(match.group(2)!);
    if (minimum == null || maximum == null || minimum > maximum) return null;
    return (minimum, maximum);
  }
}

class _ExerciseExposure {
  const _ExerciseExposure({
    required this.date,
    required this.sets,
    required this.expectedSets,
  });

  final DateTime date;
  final List<WorkoutSetResult> sets;
  final int expectedSets;

  bool get isComplete =>
      sets.length == expectedSets &&
      sets.asMap().entries.every((entry) => entry.key == entry.value.setIndex);
}
