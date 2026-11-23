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
import 'reschedule_session_page.dart';

class ActivityView extends StatefulWidget {
  const ActivityView({
    super.key,
    required this.settings,
    required this.records,
    required this.onWorkoutCompleted,
    required this.onSessionClosed,
    required this.workoutLogRepository,
  });

  final TrainingSettings settings;
  final List<WorkoutRecord> records;
  final Future<void> Function(WorkoutRecord) onWorkoutCompleted;
  final Future<void> Function() onSessionClosed;
  final WorkoutLogRepository workoutLogRepository;

  @override
  State<ActivityView> createState() => _ActivityViewState();
}

class _ActivityViewState extends State<ActivityView> {
  static const _planBuilder = TrainingPlanBuilder();
  late DateTime _selectedDate;
  late DateTime _visibleMonth;
  final Map<DateTime, _TrainingSession> _movedSessions = {};
  final Set<DateTime> _removedDefaultSessions = {};

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
          sessionTitle: session.title,
          sessionIcon: session.icon,
          availableDates: options,
        ),
      ),
    );
    if (!mounted || target == null) return;

    setState(() {
      _movedSessions.remove(source);
      _removedDefaultSessions.add(source);
      _movedSessions[target] = session;
      _selectedDate = target;
      _visibleMonth = DateTime(target.year, target.month);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sesión movida al ${_formatDate(target)}.')),
    );
  }

  Future<void> _startSession() async {
    final record = await Navigator.of(context).push<WorkoutRecord>(
      MaterialPageRoute<WorkoutRecord>(
        builder: (_) => TrainingSessionFlow(
          settings: widget.settings,
          workoutLogRepository: widget.workoutLogRepository,
          sessionIndex: _sessionIndexForDate(_selectedDate),
          scheduledDate: _selectedDate,
        ),
      ),
    );
    await widget.onSessionClosed();
    if (record == null || !mounted) return;
    await widget.onWorkoutCompleted(record);
  }

  Future<void> _markSessionCompleted() async {
    final session = _sessionForDate(_selectedDate);
    if (session == null) return;
    await widget.onWorkoutCompleted(
      WorkoutRecord(
        scheduledDate: _selectedDate,
        completedAt: DateTime.now(),
        title: session.title,
        goal: widget.settings.goal,
        durationMinutes: widget.settings.sessionMinutes,
        exerciseCount: session.exerciseCount,
        completedOutsideApp: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    'es_DO',
                  ).format(DateTime.now()),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'Actividad',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'Tu calendario de entrenamiento.',
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
                            locale: 'es_DO',
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
                  title: 'Detalle del día',
                  actionLabel: _isSameDay(_selectedDate, DateTime.now())
                      ? null
                      : 'Hoy',
                  onAction: _isSameDay(_selectedDate, DateTime.now())
                      ? null
                      : () => _selectDate(DateTime.now()),
                ),
                _DayDetailCard(
                  date: _selectedDate,
                  session: session,
                  isCompleted: widget.records.any(
                    (record) => _isSameDay(record.date, _selectedDate),
                  ),
                  canComplete: !_dateOnly(_selectedDate)
                      .isAfter(_dateOnly(DateTime.now())),
                  onReschedule: _reschedule,
                  onStart: _startSession,
                  onMarkCompleted: _markSessionCompleted,
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
    final movedSession = _movedSessions[normalizedDate];
    if (movedSession != null) return movedSession;
    if (_removedDefaultSessions.contains(normalizedDate)) return null;

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
      title: plannedSession.title,
      detail: plannedSession.focus,
      duration: '${plannedSession.durationMinutes} min',
      exerciseCount: plannedSession.exercises.length,
      icon: switch (date.weekday % 3) {
        0 => Icons.fitness_center_rounded,
        1 => Icons.directions_run_rounded,
        _ => Icons.bolt_rounded,
      },
    );
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
    required this.onPrevious,
    required this.onNext,
  });

  final DateTime month;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          tooltip: 'Mes anterior',
          onPressed: onPrevious,
          icon: const Icon(Icons.chevron_left_rounded),
        ),
        Expanded(
          child: Text(
            DateFormat.yMMMM('es_DO').format(month),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        IconButton(
          tooltip: 'Mes siguiente',
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
    required this.session,
    required this.isCompleted,
    required this.canComplete,
    required this.onReschedule,
    required this.onStart,
    required this.onMarkCompleted,
  });

  final DateTime date;
  final _TrainingSession? session;
  final bool isCompleted;
  final bool canComplete;
  final VoidCallback onReschedule;
  final VoidCallback onStart;
  final VoidCallback onMarkCompleted;

  @override
  Widget build(BuildContext context) {
    final dateLabel = _formatDate(date);

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
                    'Día de recuperación',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    'No hay sesión programada para este día.',
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
                '${session!.exerciseCount} ejercicios',
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
              child: const Row(
                children: [
                  Icon(Icons.check_circle_rounded, size: 19),
                  SizedBox(width: AppSpacing.x2),
                  Text('Sesión completada'),
                ],
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.x3),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: canComplete ? onStart : null,
              icon: const Icon(Icons.play_arrow_rounded, size: 18),
              label: Text(
                canComplete
                    ? isCompleted
                          ? 'Repetir entrenamiento'
                          : 'Empezar sesión'
                    : 'Sesión programada',
              ),
            ),
          ),
          if (!isCompleted && canComplete) ...[
            const SizedBox(height: AppSpacing.x2),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onMarkCompleted,
                icon: const Icon(Icons.check_rounded, size: 18),
                label: const Text('Ya entrené fuera de la app'),
              ),
            ),
            const SizedBox(height: AppSpacing.x2),
            SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                onPressed: onReschedule,
                icon: const Icon(Icons.event_repeat_rounded, size: 18),
                label: const Text('Cambiar día'),
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

String _formatDate(DateTime date) =>
    DateFormat("EEEE, d 'de' MMMM", 'es_DO').format(date);
