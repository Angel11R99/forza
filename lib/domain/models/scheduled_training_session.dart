import 'dart:convert';

import '../use_cases/training_plan_builder.dart';

class ScheduledTrainingSession {
  const ScheduledTrainingSession({
    required this.id,
    required this.scheduledDate,
    required this.sessionIndex,
    required this.title,
    required this.focus,
    required this.durationMinutes,
    required this.exerciseCount,
    this.originalDate,
    this.status = 'pending',
    this.planVersion = 1,
    this.planSnapshot = '',
  });

  final String id;
  final DateTime scheduledDate;
  final DateTime? originalDate;
  final int sessionIndex;
  final String title;
  final String focus;
  final int durationMinutes;
  final int exerciseCount;
  final String status;
  final int planVersion;
  final String planSnapshot;

  PlannedTrainingSession? get plannedSession {
    if (planSnapshot.isEmpty) return null;
    try {
      final decoded = jsonDecode(planSnapshot);
      if (decoded is! Map) return null;
      return PlannedTrainingSession.fromJson(
        Map<String, Object?>.from(decoded),
      );
    } on Object {
      return null;
    }
  }

  bool get isMoved => originalDate != null;
  bool get isInProgress => status == 'in_progress';
  bool get isCompleted => status == 'completed';
  bool get isSkipped => status == 'skipped';
}
