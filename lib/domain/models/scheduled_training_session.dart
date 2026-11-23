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

  bool get isMoved => originalDate != null;
  bool get isInProgress => status == 'in_progress';
  bool get isCompleted => status == 'completed';
}
