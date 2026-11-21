import 'dart:math' as math;

import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../core/widgets/app_surface_card.dart';
import '../../../core/widgets/section_heading.dart';
import '../../onboarding/views/training_session_flow.dart';
import 'reschedule_session_page.dart';

class ActivityView extends StatefulWidget {
  const ActivityView({super.key});

  @override
  State<ActivityView> createState() => _ActivityViewState();
}

class _ActivityViewState extends State<ActivityView> {
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
    final completed = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(builder: (_) => const TrainingSessionFlow()),
    );
    if (!mounted || completed != true) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Entrenamiento finalizado. No se guardó en el historial.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final session = _sessionForDate(_selectedDate);

    return CustomScrollView(
      key: const PageStorageKey<String>('activity-scroll'),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.x6,
            AppSpacing.x6,
            AppSpacing.x6,
            AppSpacing.x8,
          ),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TU PLAN DE ENTRENAMIENTO',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    letterSpacing: 1.3,
                  ),
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  'Actividad',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'Organiza tus sesiones y días de recuperación.',
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
                            eventLoader: (day) => _sessionForDate(day) == null
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
                                  .copyWith(color: AppColors.textSecondary),
                              weekendStyle: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(color: AppColors.textSecondary),
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
                              markerDecoration: const BoxDecoration(
                                color: AppColors.textPrimary,
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
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w700,
                                  ),
                              todayDecoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.textPrimary,
                                ),
                                shape: BoxShape.circle,
                              ),
                              selectedTextStyle: const TextStyle(
                                color: AppColors.inverseText,
                              ),
                              selectedDecoration: const BoxDecoration(
                                color: AppColors.textPrimary,
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
                  onReschedule: _reschedule,
                  onStart: _startSession,
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

    return switch (date.weekday) {
      DateTime.monday => const _TrainingSession(
        title: 'Fuerza de tren superior',
        detail: 'Pecho, espalda y hombros',
        duration: '45 min',
        exerciseCount: 6,
        icon: Icons.fitness_center_rounded,
      ),
      DateTime.wednesday => const _TrainingSession(
        title: 'Piernas y core',
        detail: 'Fuerza y estabilidad',
        duration: '50 min',
        exerciseCount: 7,
        icon: Icons.directions_run_rounded,
      ),
      DateTime.friday => const _TrainingSession(
        title: 'Fuerza total',
        detail: 'Trabajo de cuerpo completo',
        duration: '45 min',
        exerciseCount: 6,
        icon: Icons.bolt_rounded,
      ),
      _ => null,
    };
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
    required this.onReschedule,
    required this.onStart,
  });

  final DateTime date;
  final _TrainingSession? session;
  final VoidCallback onReschedule;
  final VoidCallback onStart;

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
          const SizedBox(height: AppSpacing.x3),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onStart,
              icon: const Icon(Icons.play_arrow_rounded, size: 18),
              label: const Text('Iniciar entrenamiento'),
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onReschedule,
              icon: const Icon(Icons.event_repeat_rounded, size: 18),
              label: const Text('Reprogramar sesión'),
            ),
          ),
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
    return Container(
      width: 48,
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppRadius.small),
      ),
      child: Icon(icon, size: 22, color: AppColors.textPrimary),
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
