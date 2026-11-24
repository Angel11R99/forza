import 'dart:math' as math;

import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../core/widgets/app_surface_card.dart';
import '../../../core/widgets/forza_brand.dart';
import '../../../core/widgets/section_heading.dart';
import '../../onboarding/views/training_session_flow.dart';
import '../../profile/models/profile_settings.dart';
import '../../../../domain/use_cases/training_plan_builder.dart';
import '../../../../domain/models/workout_record.dart';
import '../../../../data/repositories/workout_log_repository.dart';
import '../../../../domain/models/scheduled_training_session.dart';
import '../../../../app/localization/localization_extensions.dart';
import 'reschedule_session_page.dart';

class ActivityView extends StatefulWidget {
  const ActivityView({
    super.key,
    required this.settings,
    required this.records,
    required this.onWorkoutCompleted,
    required this.onSessionClosed,
    required this.workoutLogRepository,
    required this.scheduledSessions,
    required this.onRescheduleSession,
    required this.onSessionStarted,
    required this.onSkipSession,
    required this.onUndoSkipSession,
  });

  final TrainingSettings settings;
  final List<WorkoutRecord> records;
  final Future<void> Function(WorkoutRecord) onWorkoutCompleted;
  final Future<void> Function() onSessionClosed;
  final WorkoutLogRepository workoutLogRepository;
  final List<ScheduledTrainingSession> scheduledSessions;
  final Future<bool> Function(DateTime, DateTime) onRescheduleSession;
  final Future<void> Function(DateTime) onSessionStarted;
  final Future<bool> Function(DateTime) onSkipSession;
  final Future<bool> Function(DateTime) onUndoSkipSession;

  @override
  State<ActivityView> createState() => _ActivityViewState();
}

class _ActivityViewState extends State<ActivityView> {
  static const _planBuilder = TrainingPlanBuilder();
  late DateTime _selectedDate;
  late DateTime _visibleMonth;

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    _selectedDate = _dateOnly(today);
    _visibleMonth = DateTime(today.year, today.month);
  }

  void _moveMonth(int offset) {
    final nextMonth = DateTime(
      _visibleMonth.year,
      _visibleMonth.month + offset,
    );
    final lastDay = DateTime(nextMonth.year, nextMonth.month + 1, 0).day;

    setState(() {
      _visibleMonth = nextMonth;
      _selectedDate = DateTime(
        nextMonth.year,
        nextMonth.month,
        _selectedDate.day.clamp(1, lastDay).toInt(),
      );
    });
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = _dateOnly(date);
      _visibleMonth = DateTime(date.year, date.month);
    });
  }

  Future<void> _reschedule() async {
    final source = _dateOnly(_selectedDate);
    final session = _sessionForDate(source);
    if (session == null) return;
    final options = _availableDatesAfter(source);
    final target = await Navigator.of(context).push<DateTime>(
      MaterialPageRoute<DateTime>(
        builder: (_) => RescheduleSessionPage(
          sessionDate: source,
          sessionTitle: _localizedSessionTitle(context, session.title),
          sessionIcon: session.icon,
          availableDates: options,
        ),
      ),
    );
    if (!mounted || target == null) return;

    final moved = await widget.onRescheduleSession(source, target);
    if (!mounted) return;
    if (!moved) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.activityRescheduleConflict)),
      );
      return;
    }
    setState(() {
      _selectedDate = target;
      _visibleMonth = DateTime(target.year, target.month);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          context.l10n.activityRescheduled(
            _formatDate(
              target,
              Localizations.localeOf(context).toLanguageTag(),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _startSession() async {
    final planned = _scheduledForDate(_selectedDate);
    await widget.onSessionStarted(_selectedDate);
    if (!mounted) return;
    final record = await Navigator.of(context).push<WorkoutRecord>(
      MaterialPageRoute<WorkoutRecord>(
        builder: (_) => TrainingSessionFlow(
          settings: widget.settings,
          workoutLogRepository: widget.workoutLogRepository,
          sessionIndex:
              planned?.sessionIndex ?? _sessionIndexForDate(_selectedDate),
          scheduledDate: _selectedDate,
          plannedSession: planned?.plannedSession,
          planVersion: planned?.planVersion ?? 1,
        ),
      ),
    );
    if (!mounted) return;
    await widget.onSessionClosed();
    if (record == null || !mounted) return;
    await widget.onWorkoutCompleted(record);
  }

  Future<void> _markSessionCompleted() async {
    final session = _sessionForDate(_selectedDate);
    if (session == null) return;
    final scheduled = _scheduledForDate(_selectedDate);
    final planned = scheduled?.plannedSession;
    await widget.onWorkoutCompleted(
      WorkoutRecord(
        scheduledDate: _selectedDate,
        completedAt: DateTime.now(),
        title: session.title,
        goal: widget.settings.goal,
        durationMinutes: widget.settings.sessionMinutes,
        exerciseCount: session.exerciseCount,
        exercises: [
          for (final exercise in planned?.exercises ?? const []) exercise.name,
        ],
        exerciseIds: [
          for (final exercise in planned?.exercises ?? const [])
            exercise.catalogId,
        ],
        planVersion: scheduled?.planVersion ?? 1,
        planSnapshot: scheduled?.planSnapshot ?? '',
        completedOutsideApp: true,
      ),
    );
  }

  Future<void> _skipSession() async {
    final skipped = await widget.onSkipSession(_dateOnly(_selectedDate));
    if (!mounted || !skipped) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.activitySessionSkipped)),
    );
  }

  Future<void> _undoSkipSession() async {
    final restored = await widget.onUndoSkipSession(_dateOnly(_selectedDate));
    if (!mounted || !restored) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(context.l10n.activitySkipUndone)));
  }

  @override
  Widget build(BuildContext context) {
    final localeName = Localizations.localeOf(context).toLanguageTag();
    final session = _sessionForDate(_selectedDate);
    final horizontalPadding = AppSpacing.pageGutter(
      MediaQuery.sizeOf(context).width,
    );

    return CustomScrollView(
      key: const PageStorageKey<String>('activity-scroll'),
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            AppSpacing.x6,
            horizontalPadding,
            AppSpacing.x8,
          ),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ForzaEyebrow(
                  label: DateFormat(
                    'EEEE, d MMMM',
                    localeName,
                  ).format(DateTime.now()),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  context.l10n.activityTitle,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  context.l10n.activitySubtitle,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: AppSpacing.x8),
                AppSurfaceCard(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.x4,
                    AppSpacing.x2,
                    AppSpacing.x4,
                    AppSpacing.x4,
                  ),
                  child: Column(
                    children: [
                      _MonthHeader(
                        month: _visibleMonth,
                        localeName: localeName,
                        onPrevious: () => _moveMonth(-1),
                        onNext: () => _moveMonth(1),
                      ),
                      const SizedBox(height: AppSpacing.x2),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final textScale = MediaQuery.textScalerOf(context)
                              .scale(1);
                          final desiredRowHeight =
                              44 + (textScale - 1).clamp(0, 1) * 16;
                          final rowHeight = math
                              .min(desiredRowHeight, constraints.maxWidth / 7)
                              .clamp(44.0, 60.0)
                              .toDouble();

                          return TableCalendar<bool>(
                            firstDay: DateTime(2000, 1, 1),
                            lastDay: DateTime(2100, 12, 31),
                            focusedDay: _visibleMonth,
                            locale: localeName,
                            startingDayOfWeek: StartingDayOfWeek.monday,
                            calendarFormat: CalendarFormat.month,
                            headerVisible: false,
                            daysOfWeekHeight: 24 * textScale,
                            rowHeight: rowHeight,
                            sixWeekMonthsEnforced: true,
                            selectedDayPredicate: (day) =>
                                _isSameDay(day, _selectedDate),
                            eventLoader: (day) =>
                                _isSameDay(day, _selectedDate) ||
                                    _sessionForDate(day) == null
                                ? const []
                                : const [true],
                            onDaySelected: (selectedDay, focusedDay) {
                              setState(() {
                                _selectedDate = _dateOnly(selectedDay);
                                _visibleMonth = DateTime(
                                  focusedDay.year,
                                  focusedDay.month,
                                );
                              });
                            },
                            onPageChanged: (focusedDay) {
                              setState(() {
                                _visibleMonth = DateTime(
                                  focusedDay.year,
                                  focusedDay.month,
                                );
                              });
                            },
                            daysOfWeekStyle: DaysOfWeekStyle(
                              weekdayStyle: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                    color: context.appColors.textSecondary,
                                  ),
                              weekendStyle: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                    color: context.appColors.textSecondary,
                                  ),
                              dowTextFormatter: (date, locale) =>
                                  DateFormat.E(locale)
                                      .format(date)
                                      .substring(0, 1)
                                      .toUpperCase(),
                            ),
                            calendarStyle: CalendarStyle(
                              outsideDaysVisible: false,
                              cellMargin: const EdgeInsets.all(2),
                              markerSize: 4,
                              markersAnchor: 0.78,
                              markerDecoration: BoxDecoration(
                                color: context.appColors.accent,
                                shape: BoxShape.circle,
                              ),
                              defaultTextStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!,
                              weekendTextStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!,
                              todayTextStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color: context.appColors.accent,
                                    fontWeight: FontWeight.w700,
                                  ),
                              todayDecoration: BoxDecoration(
                                border: Border.all(
                                  color: context.appColors.accent,
                                ),
                                shape: BoxShape.circle,
                              ),
                              selectedTextStyle: TextStyle(
                                color: context.appColors.inverseText,
                              ),
                              selectedDecoration: BoxDecoration(
                                color: context.appColors.accent,
                                shape: BoxShape.circle,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.x8),
                SectionHeading(
                  title: context.l10n.activityTodayDetail,
                  actionLabel: _isSameDay(_selectedDate, DateTime.now())
                      ? null
                      : context.l10n.activityToday,
                  onAction: _isSameDay(_selectedDate, DateTime.now())
                      ? null
                      : () => _selectDate(DateTime.now()),
                ),
                _DayDetailCard(
                  date: _selectedDate,
                  localeName: localeName,
                  session: session,
                  isCompleted: widget.records.any(
                    (record) => _isSameDay(record.date, _selectedDate),
                  ),
                  isInProgress:
                      _scheduledForDate(_selectedDate)?.isInProgress ?? false,
                  isSkipped:
                      _scheduledForDate(_selectedDate)?.isSkipped ?? false,
                  canComplete: !_dateOnly(_selectedDate)
                      .isAfter(_dateOnly(DateTime.now())),
                  onReschedule: _reschedule,
                  onStart: _startSession,
                  onMarkCompleted: _markSessionCompleted,
                  onSkip: _skipSession,
                  onUndoSkip: _undoSkipSession,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _TrainingSession? _sessionForDate(DateTime date) {
    final normalizedDate = _dateOnly(date);
    final persisted = _scheduledForDate(normalizedDate);
    if (persisted != null) {
      return _TrainingSession(
        title: _localizedSessionTitle(context, persisted.title),
        detail: _localizedSessionFocus(context, persisted.focus),
        duration: '${persisted.durationMinutes} min',
        exerciseCount: persisted.exerciseCount,
        icon: switch (persisted.sessionIndex % 3) {
          0 => Icons.fitness_center_rounded,
          1 => Icons.directions_run_rounded,
          _ => Icons.bolt_rounded,
        },
      );
    }
    if (widget.scheduledSessions.any(
      (item) =>
          item.originalDate != null &&
          _isSameDay(item.originalDate!, normalizedDate),
    )) {
      return null;
    }

    final plannedSessions = _planBuilder
        .buildWeek(
          trainingDays: widget.settings.trainingDays,
          sessionMinutes: widget.settings.sessionMinutes,
          goal: widget.settings.goal,
          experience: widget.settings.experience,
          equipment: widget.settings.equipment,
        )
        .where((session) => session.weekday == date.weekday)
        .toList(growable: false);
    final plannedSession = plannedSessions.isEmpty
        ? null
        : plannedSessions.first;
    if (plannedSession == null) return null;

    return _TrainingSession(
      title: _localizedSessionTitle(context, plannedSession.title),
      detail: _localizedSessionFocus(context, plannedSession.focus),
      duration: '${plannedSession.durationMinutes} min',
      exerciseCount: plannedSession.exercises.length,
      icon: switch (date.weekday % 3) {
        0 => Icons.fitness_center_rounded,
        1 => Icons.directions_run_rounded,
        _ => Icons.bolt_rounded,
      },
    );
  }

  ScheduledTrainingSession? _scheduledForDate(DateTime date) {
    for (final session in widget.scheduledSessions) {
      if (_isSameDay(session.scheduledDate, date)) return session;
    }
    return null;
  }

  int _sessionIndexForDate(DateTime date) {
    final days = widget.settings.trainingDays.toList()..sort();
    final index = days.indexOf(date.weekday);
    return index < 0 ? 0 : index;
  }

  List<DateTime> _availableDatesAfter(DateTime date) {
    final dates = <DateTime>[];
    for (var offset = 1; offset <= 14 && dates.length < 4; offset++) {
      final candidate = DateTime(date.year, date.month, date.day + offset);
      if (_sessionForDate(candidate) == null) dates.add(candidate);
    }
    return dates;
  }

  static DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  static bool _isSameDay(DateTime first, DateTime second) =>
      first.year == second.year &&
      first.month == second.month &&
      first.day == second.day;
}

class _MonthHeader extends StatelessWidget {
  const _MonthHeader({
    required this.month,
    required this.localeName,
    required this.onPrevious,
    required this.onNext,
  });

  final DateTime month;
  final String localeName;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          tooltip: context.l10n.activityPreviousMonth,
          onPressed: onPrevious,
          icon: const Icon(Icons.chevron_left_rounded),
        ),
        Expanded(
          child: Text(
            DateFormat.yMMMM(localeName).format(month),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        IconButton(
          tooltip: context.l10n.activityNextMonth,
          onPressed: onNext,
          icon: const Icon(Icons.chevron_right_rounded),
        ),
      ],
    );
  }
}

class _DayDetailCard extends StatelessWidget {
  const _DayDetailCard({
    required this.date,
    required this.localeName,
    required this.session,
    required this.isCompleted,
    required this.isInProgress,
    required this.isSkipped,
    required this.canComplete,
    required this.onReschedule,
    required this.onStart,
    required this.onMarkCompleted,
    required this.onSkip,
    required this.onUndoSkip,
  });

  final DateTime date;
  final String localeName;
  final _TrainingSession? session;
  final bool isCompleted;
  final bool isInProgress;
  final bool isSkipped;
  final bool canComplete;
  final VoidCallback onReschedule;
  final VoidCallback onStart;
  final VoidCallback onMarkCompleted;
  final VoidCallback onSkip;
  final VoidCallback onUndoSkip;

  @override
  Widget build(BuildContext context) {
    final dateLabel = _formatDate(date, localeName);

    if (session == null) {
      return AppSurfaceCard(
        padding: const EdgeInsets.all(AppSpacing.x6),
        child: Row(
          children: [
            const _SessionIcon(icon: Icons.self_improvement_rounded),
            const SizedBox(width: AppSpacing.x4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dateLabel,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    context.l10n.activityRecoveryDay,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    context.l10n.activityNoSession,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return AppSurfaceCard(
      padding: const EdgeInsets.all(AppSpacing.x6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SessionIcon(icon: session!.icon),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dateLabel,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      session!.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      session!.detail,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          const Divider(height: 1),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              const Icon(Icons.schedule_rounded, size: 18),
              const SizedBox(width: AppSpacing.x2),
              Text(
                session!.duration,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(width: AppSpacing.x6),
              const Icon(Icons.fitness_center_rounded, size: 18),
              const SizedBox(width: AppSpacing.x2),
              Text(
                context.l10n.activityExerciseCount(session!.exerciseCount),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          if (isCompleted) ...[
            const SizedBox(height: AppSpacing.x4),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.x3),
              decoration: BoxDecoration(
                color: context.appColors.surfaceMuted,
                borderRadius: BorderRadius.circular(AppRadius.control),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_rounded, size: 19),
                  const SizedBox(width: AppSpacing.x2),
                  Text(context.l10n.activitySessionCompleted),
                ],
              ),
            ),
          ],
          if (isInProgress) ...[
            const SizedBox(height: AppSpacing.x4),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.x3),
              decoration: BoxDecoration(
                color: context.appColors.surfaceMuted,
                borderRadius: BorderRadius.circular(AppRadius.control),
              ),
              child: Row(
                children: [
                  const Icon(Icons.play_circle_outline_rounded, size: 19),
                  const SizedBox(width: AppSpacing.x2),
                  Text(context.l10n.activityWorkoutInProgress),
                ],
              ),
            ),
          ],
          if (isSkipped) ...[
            const SizedBox(height: AppSpacing.x4),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.x3),
              decoration: BoxDecoration(
                color: context.appColors.surfaceMuted,
                borderRadius: BorderRadius.circular(AppRadius.control),
              ),
              child: Row(
                children: [
                  const Icon(Icons.remove_circle_outline_rounded, size: 19),
                  const SizedBox(width: AppSpacing.x2),
                  Text(context.l10n.activitySessionSkipped),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.x3),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onUndoSkip,
                icon: const Icon(Icons.undo_rounded, size: 18),
                label: Text(context.l10n.activityUndoSkip),
              ),
            ),
          ] else ...[
            const SizedBox(height: AppSpacing.x3),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: canComplete ? onStart : null,
                icon: const Icon(Icons.play_arrow_rounded, size: 18),
                label: Text(
                  canComplete
                      ? isInProgress
                            ? context.l10n.activityContinueWorkout
                            : isCompleted
                            ? context.l10n.activityRepeatWorkout
                            : context.l10n.activityStartSession
                      : context.l10n.activityScheduledSession,
                ),
              ),
            ),
          ],
          if (!isCompleted && !isInProgress && !isSkipped) ...[
            if (canComplete) ...[
              const SizedBox(height: AppSpacing.x2),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: onMarkCompleted,
                  icon: const Icon(Icons.check_rounded, size: 18),
                  label: Text(context.l10n.activityCompletedOutside),
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.x2),
            SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                onPressed: onSkip,
                icon: const Icon(Icons.remove_circle_outline_rounded, size: 18),
                label: Text(context.l10n.activitySkipSession),
              ),
            ),
            const SizedBox(height: AppSpacing.x2),
            SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                onPressed: onReschedule,
                icon: const Icon(Icons.event_repeat_rounded, size: 18),
                label: Text(context.l10n.activityChangeDay),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SessionIcon extends StatelessWidget {
  const _SessionIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 48,
      child: Center(
        child: Icon(icon, size: 22, color: context.appColors.accent),
      ),
    );
  }
}

class _TrainingSession {
  const _TrainingSession({
    required this.title,
    required this.detail,
    required this.duration,
    required this.exerciseCount,
    required this.icon,
  });

  final String title;
  final String detail;
  final String duration;
  final int exerciseCount;
  final IconData icon;
}

String _formatDate(DateTime date, String localeName) =>
    DateFormat('EEEE, d MMMM', localeName).format(date);

String _localizedSessionTitle(BuildContext context, String title) =>
    switch (title) {
      'Tren superior' => context.l10n.onboardingUpperBody,
      'Tren inferior' => context.l10n.onboardingLowerBody,
      'Cuerpo completo' => context.l10n.onboardingFullBody,
      'Fuerza total' => context.l10n.progressTotalStrength,
      'Piernas y core' => context.l10n.progressLegsCore,
      _ => title,
    };

String _localizedSessionFocus(BuildContext context, String focus) =>
    switch (focus) {
      'Pecho, espalda y hombros' => context.l10n.activityFocusUpper,
      'Piernas y core' => context.l10n.activityFocusLower,
      'Rutina de cuerpo completo' => context.l10n.activityFocusFull,
      _ => focus,
    };
