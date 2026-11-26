import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/localization/localization_extensions.dart';
import '../../../core/widgets/app_surface_card.dart';
import '../../../core/widgets/forza_brand.dart';
import '../../../core/widgets/section_heading.dart';
import '../../profile/models/profile_settings.dart';
import '../widgets/home_streak_indicator.dart';
import '../../../../domain/use_cases/training_plan_builder.dart';
import '../../../../domain/models/scheduled_training_session.dart';
import '../../../../domain/use_cases/weight_units.dart';

class HomeView extends StatelessWidget {
  const HomeView({
    super.key,
    required this.onShowActivity,
    required this.onShowProfile,
    required this.settings,
    required this.onStartWorkout,
    required this.onEditPlan,
    required this.completedDates,
    this.streakDays = 0,
    this.streakAnimationFrom = 0,
    this.streakAnimationRevision = 0,
    this.hasActiveWorkout = false,
    this.activeWorkoutDate,
    this.scheduledSessions = const [],
    this.weekStartsOn = 'Lunes',
  });

  final VoidCallback onShowActivity;
  final VoidCallback onShowProfile;
  final TrainingSettings settings;
  final ValueChanged<DateTime> onStartWorkout;
  final VoidCallback onEditPlan;
  final Set<DateTime> completedDates;
  final int streakDays;
  final int streakAnimationFrom;
  final int streakAnimationRevision;
  final bool hasActiveWorkout;
  final DateTime? activeWorkoutDate;
  final List<ScheduledTrainingSession> scheduledSessions;
  final String weekStartsOn;

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = AppSpacing.pageGutter(
      MediaQuery.sizeOf(context).width,
    );
    final now = DateTime.now();
    final activeSession = scheduledSessions
        .where((session) => session.isInProgress)
        .firstOrNull;
    final today = DateTime(now.year, now.month, now.day);
    final todaySession = scheduledSessions
        .where((session) => _sameDate(session.scheduledDate, today))
        .firstOrNull;
    final upcomingSession = scheduledSessions
        .where(
          (session) =>
              session.status == 'pending' &&
              DateTime(
                session.scheduledDate.year,
                session.scheduledDate.month,
                session.scheduledDate.day,
              ).isAfter(today),
        )
        .firstOrNull;
    final activeDate = activeWorkoutDate ?? activeSession?.scheduledDate;
    final active = hasActiveWorkout;
    final isCompletedToday =
        todaySession?.isCompleted == true ||
        completedDates.any((date) => _sameDate(date, today));
    final isSkippedToday = todaySession?.isSkipped == true;
    final plannedSession = active
        ? activeSession ?? todaySession ?? upcomingSession
        : todaySession?.status == 'pending'
        ? todaySession
        : upcomingSession;
    final localeName = Localizations.localeOf(context).toLanguageTag();
    final nextTrainingDate = active
        ? activeDate ?? plannedSession?.scheduledDate ?? today
        : plannedSession?.scheduledDate;
    final greeting = switch (now.hour) {
      < 12 => context.l10n.homeGreetingMorning,
      < 19 => context.l10n.homeGreetingAfternoon,
      _ => context.l10n.homeGreetingEvening,
    };

    return CustomScrollView(
      key: const PageStorageKey<String>('home-scroll'),
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            AppSpacing.x4,
            horizontalPadding,
            AppSpacing.x8,
          ),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const ForzaWordmark(),
                            Positioned(
                              right: 0,
                              child: IconButton.filled(
                                onPressed: onShowProfile,
                                tooltip: context.l10n.homeProfileTooltip,
                                style: IconButton.styleFrom(
                                  backgroundColor: context.appColors.accent,
                                  foregroundColor:
                                      context.appColors.inverseText,
                                ),
                                icon: const Icon(Icons.person_outline_rounded),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  _capitalize(
                    DateFormat('EEEE, d MMMM', localeName).format(now),
                  ),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.x6),
                Text(greeting, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: AppSpacing.x2),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final planTitle = Text(
                      context.l10n.homePlanTitle,
                      style: Theme.of(context).textTheme.displaySmall,
                    );
                    final streakIndicator = HomeStreakIndicator(
                      key: const ValueKey('home-streak-indicator'),
                      days: streakDays,
                      animationFrom: streakAnimationFrom,
                      animationRevision: streakAnimationRevision,
                    );
                    if (constraints.maxWidth >= 400) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(child: planTitle),
                          const SizedBox(width: AppSpacing.x3),
                          streakIndicator,
                        ],
                      );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        planTitle,
                        const SizedBox(height: AppSpacing.x2),
                        streakIndicator,
                      ],
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.x4),
                SectionHeading(
                  title:
                      active ||
                          (nextTrainingDate != null &&
                              _sameDate(nextTrainingDate, today))
                      ? context.l10n.homeTodayWorkout
                      : nextTrainingDate != null
                      ? context.l10n.homeNextSession(
                          DateFormat.E(localeName).format(nextTrainingDate),
                        )
                      : context.l10n.homeTodayWorkout,
                  actionLabel: context.l10n.homeAdjustPlan,
                  onAction: onEditPlan,
                ),
                _TodayWorkoutCard(
                  settings: settings,
                  onPressed: () => onStartWorkout(nextTrainingDate ?? today),
                  sessionDate: nextTrainingDate,
                  hasActiveWorkout: active,
                  scheduledSession: plannedSession,
                  isCompletedToday: isCompletedToday,
                  isSkippedToday: isSkippedToday,
                  onShowActivity: onShowActivity,
                  onEditPlan: onEditPlan,
                ),
                const SizedBox(height: AppSpacing.x8),
                SectionHeading(
                  title: context.l10n.homeWeekTitle,
                  actionLabel: context.l10n.homeViewActivity,
                  onAction: onShowActivity,
                ),
                _WeeklySummary(
                  settings: settings,
                  weekStartsOn: weekStartsOn,
                  completedDates: completedDates,
                  scheduledSessions: scheduledSessions,
                  onTap: onShowActivity,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TodayWorkoutCard extends StatelessWidget {
  const _TodayWorkoutCard({
    required this.settings,
    required this.onPressed,
    required this.sessionDate,
    required this.hasActiveWorkout,
    required this.scheduledSession,
    required this.isCompletedToday,
    required this.isSkippedToday,
    required this.onShowActivity,
    required this.onEditPlan,
  });

  final TrainingSettings settings;
  final VoidCallback onPressed;
  final DateTime? sessionDate;
  final bool hasActiveWorkout;
  final ScheduledTrainingSession? scheduledSession;
  final bool isCompletedToday;
  final bool isSkippedToday;
  final VoidCallback onShowActivity;
  final VoidCallback onEditPlan;

  static const _planBuilder = TrainingPlanBuilder();

  @override
  Widget build(BuildContext context) {
    final localeName = Localizations.localeOf(context).toLanguageTag();
    final today = DateTime.now();
    final sessionDate = this.sessionDate;
    if (isCompletedToday || isSkippedToday || sessionDate == null) {
      final title = isCompletedToday
          ? context.l10n.homeSessionCompleted
          : isSkippedToday
          ? context.l10n.homeSessionSkipped
          : context.l10n.homeRecoveryDay;
      final subtitle = isCompletedToday
          ? context.l10n.homeSessionCompletedDescription
          : isSkippedToday
          ? context.l10n.homeSessionSkippedDescription
          : context.l10n.homeRecoveryDescription;
      final icon = isCompletedToday
          ? Icons.check_circle_outline_rounded
          : isSkippedToday
          ? Icons.event_busy_rounded
          : Icons.self_improvement_rounded;
      return Container(
        padding: const EdgeInsets.all(AppSpacing.x6),
        decoration: BoxDecoration(
          color: context.appColors.accent,
          borderRadius: BorderRadius.circular(AppRadius.large),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: context.appColors.inverseText, size: 24),
            const SizedBox(height: AppSpacing.x3),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge
                  ?.copyWith(color: context.appColors.inverseText),
            ),
            const SizedBox(height: AppSpacing.x2),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: context.appColors.inverseText.withValues(alpha: 0.82),
              ),
            ),
            if (!isCompletedToday &&
                !isSkippedToday &&
                scheduledSession != null) ...[
              const SizedBox(height: AppSpacing.x3),
              Text(
                context.l10n.homeNextSession(
                  DateFormat.E(localeName)
                      .format(scheduledSession!.scheduledDate),
                ),
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(color: context.appColors.inverseText),
              ),
            ],
            const SizedBox(height: AppSpacing.x6),
            SizedBox(
              width: double.infinity,
              child: FilledButton.tonalIcon(
                onPressed: isCompletedToday ? onShowActivity : onEditPlan,
                style: FilledButton.styleFrom(
                  backgroundColor: context.appColors.inverseText,
                  foregroundColor: context.appColors.accent,
                ),
                icon: Icon(
                  isCompletedToday
                      ? Icons.history_rounded
                      : Icons.calendar_month_rounded,
                ),
                label: Text(
                  isCompletedToday
                      ? context.l10n.homeViewActivity
                      : context.l10n.homeAdjustPlan,
                ),
              ),
            ),
          ],
        ),
      );
    }
    final isFutureSession = DateTime(
      sessionDate.year,
      sessionDate.month,
      sessionDate.day,
    ).isAfter(DateTime(today.year, today.month, today.day));
    final generatedSession = _planBuilder
        .buildWeek(
          trainingDays: settings.trainingDays,
          sessionMinutes: settings.sessionMinutes,
          goal: settings.goal,
          experience: settings.experience,
          equipment: settings.equipment,
          avoidedExerciseIds: settings.avoidedExerciseIds,
        )
        .where((session) => session.weekday == sessionDate.weekday)
        .firstOrNull;
    final exerciseCount =
        scheduledSession?.exerciseCount ??
        generatedSession?.exercises.length ??
        0;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.x6),
      decoration: BoxDecoration(
        color: context.appColors.accent,
        borderRadius: BorderRadius.circular(AppRadius.large),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.fitness_center_rounded,
                color: context.appColors.inverseText,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.x2),
              Flexible(
                child: Text(
                  _sameDate(sessionDate, DateTime.now())
                      ? context.l10n.homeTodaySession
                      : context.l10n.homeNextSessionLabel(
                          DateFormat.E(localeName)
                              .format(sessionDate)
                              .toUpperCase(),
                        ),
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: context.appColors.inverseText.withValues(
                      alpha: 0.82,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Text(
            context.localizeTrainingGoal(settings.goal),
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(color: context.appColors.inverseText),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            context.l10n.homeDurationExercises(
              scheduledSession?.durationMinutes ?? settings.sessionMinutes,
              exerciseCount,
            ),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: context.appColors.inverseText.withValues(alpha: 0.82),
            ),
          ),
          const SizedBox(height: AppSpacing.x6),
          SizedBox(
            width: double.infinity,
            child: FilledButton.tonalIcon(
              onPressed: isFutureSession ? null : onPressed,
              style: FilledButton.styleFrom(
                backgroundColor: context.appColors.inverseText,
                foregroundColor: context.appColors.accent,
              ),
              icon: const Icon(Icons.play_arrow_rounded),
              label: Text(
                isFutureSession
                    ? context.l10n.homeSessionAvailableOn(
                        DateFormat.EEEE(localeName).format(sessionDate),
                      )
                    : hasActiveWorkout
                    ? context.l10n.homeContinueWorkout
                    : context.l10n.homeViewTodaySession,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WeeklySummary extends StatelessWidget {
  const _WeeklySummary({
    required this.settings,
    required this.weekStartsOn,
    required this.completedDates,
    required this.scheduledSessions,
    required this.onTap,
  });

  final TrainingSettings settings;
  final String weekStartsOn;
  final Set<DateTime> completedDates;
  final List<ScheduledTrainingSession> scheduledSessions;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final localeName = Localizations.localeOf(context).toLanguageTag();
    final days = settings.trainingDays.toList()..sort();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekStart = startOfWeek(today, weekStartsOn);
    final weekEnd = weekStart.add(const Duration(days: 7));
    final persistedWeek =
        scheduledSessions
            .where(
              (session) =>
                  !session.scheduledDate.isBefore(weekStart) &&
                  session.scheduledDate.isBefore(weekEnd),
            )
            .toList(growable: false)
          ..sort(
            (first, second) =>
                first.scheduledDate.compareTo(second.scheduledDate),
          );
    final sessionsByDay = <DateTime, ScheduledTrainingSession>{
      for (final session in persistedWeek)
        DateTime(
          session.scheduledDate.year,
          session.scheduledDate.month,
          session.scheduledDate.day,
        ): session,
    };
    final movedFrom = <DateTime>{
      for (final session in scheduledSessions)
        if (session.originalDate != null &&
            !_sameDate(session.originalDate!, session.scheduledDate) &&
            !session.originalDate!.isBefore(weekStart) &&
            session.originalDate!.isBefore(weekEnd))
          DateTime(
            session.originalDate!.year,
            session.originalDate!.month,
            session.originalDate!.day,
          ),
    };
    final movedOutOfWeek = scheduledSessions.any((session) {
      final original = session.originalDate;
      return original != null &&
          !_sameDate(original, session.scheduledDate) &&
          !original.isBefore(weekStart) &&
          original.isBefore(weekEnd) &&
          (session.scheduledDate.isBefore(weekStart) ||
              !session.scheduledDate.isBefore(weekEnd));
    });
    final completedDays = <DateTime>{
      for (final date in completedDates)
        if (!date.isBefore(weekStart) && date.isBefore(weekEnd))
          DateTime(date.year, date.month, date.day),
      for (final session in persistedWeek)
        if (session.isCompleted && !session.isSkipped)
          DateTime(
            session.scheduledDate.year,
            session.scheduledDate.month,
            session.scheduledDate.day,
          ),
    };
    final completedCount = completedDays.length;
    final weeklyTarget = days.length;
    final progress = weeklyTarget == 0
        ? 0.0
        : (completedCount / weeklyTarget).clamp(0.0, 1.0).toDouble();
    return AppSurfaceCard(
      padding: EdgeInsets.zero,
      borderColor: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF4A4D52)
          : context.appColors.divider,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  final count = Text(
                    context.l10n.homeWeeklySessionCount(
                      completedCount,
                      weeklyTarget,
                    ),
                    style: Theme.of(context).textTheme.titleMedium,
                  );
                  final period = Text(
                    context.l10n.homeThisWeek,
                    style: Theme.of(context).textTheme.bodySmall,
                  );
                  final stackLabels =
                      constraints.maxWidth < 340 ||
                      MediaQuery.textScalerOf(context).scale(1) > 1.3;
                  return stackLabels
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            count,
                            Align(
                              alignment: Alignment.centerRight,
                              child: period,
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            Expanded(child: count),
                            period,
                          ],
                        );
                },
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                context.l10n.homeWeeklyGoal(days.length),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.x4),
              Row(
                children: [
                  if (persistedWeek.isNotEmpty)
                    for (var offset = 0; offset < 7; offset++)
                      Expanded(
                        child: _WeekdayProgress(
                          date: weekStart.add(Duration(days: offset)),
                          session:
                              sessionsByDay[weekStart.add(
                                Duration(days: offset),
                              )],
                          isCompleted: completedDays.contains(
                            weekStart.add(Duration(days: offset)),
                          ),
                          isSkipped:
                              sessionsByDay[weekStart.add(
                                    Duration(days: offset),
                                  )]
                                  ?.isSkipped ??
                              false,
                          isRescheduled:
                              movedFrom.contains(
                                weekStart.add(Duration(days: offset)),
                              ) &&
                              !sessionsByDay.containsKey(
                                weekStart.add(Duration(days: offset)),
                              ),
                          isPlanned: days.contains(
                            weekStart.add(Duration(days: offset)).weekday,
                          ),
                          isToday: _sameDate(
                            weekStart.add(Duration(days: offset)),
                            today,
                          ),
                          localeName: localeName,
                        ),
                      ),
                ],
              ),
              if (movedFrom.isNotEmpty || movedOutOfWeek) ...[
                const SizedBox(height: AppSpacing.x2),
                Text(
                  context.l10n.homeRescheduledExplanation,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
              const SizedBox(height: AppSpacing.x3),
              LinearProgressIndicator(
                value: progress,
                minHeight: 4,
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF3A3D40)
                    : context.appColors.surfaceMuted,
                color: context.appColors.accent,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WeekdayProgress extends StatelessWidget {
  const _WeekdayProgress({
    required this.date,
    required this.session,
    required this.isCompleted,
    required this.isSkipped,
    required this.isRescheduled,
    required this.isPlanned,
    required this.isToday,
    required this.localeName,
  });

  final DateTime date;
  final ScheduledTrainingSession? session;
  final bool isCompleted;
  final bool isSkipped;
  final bool isRescheduled;
  final bool isPlanned;
  final bool isToday;
  final String localeName;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final status = isCompleted
        ? context.l10n.homeStatusCompleted
        : isSkipped
        ? context.l10n.homeStatusSkipped
        : isRescheduled
        ? context.l10n.homeStatusRescheduled
        : isPlanned || session != null
        ? context.l10n.homeStatusPending
        : context.l10n.homeStatusRest;
    return Semantics(
      label: context.l10n.homeWeekdayStatus(
        DateFormat.E(localeName).format(date),
        status,
      ),
      child: Column(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isCompleted
                  ? context.appColors.accent
                  : isSkipped
                  ? Theme.of(context).colorScheme.error
                  : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                color: isToday || isCompleted || isSkipped || isRescheduled
                    ? context.appColors.accent
                    : isDark
                    ? const Color(0xFF777A80)
                    : context.appColors.divider,
                width: isToday && !isCompleted ? 1.5 : 1,
              ),
            ),
            alignment: Alignment.center,
            child: Icon(
              isCompleted
                  ? Icons.check_rounded
                  : isSkipped
                  ? Icons.close_rounded
                  : isRescheduled
                  ? Icons.event_repeat_rounded
                  : Icons.circle,
              size: isCompleted || isSkipped || isRescheduled ? 18 : 6,
              color: isCompleted
                  ? context.appColors.inverseText
                  : isSkipped
                  ? context.appColors.inverseText
                  : isDark
                  ? const Color(0xFFB8BABD)
                  : context.appColors.divider,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            DateFormat.E(localeName).format(date),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

bool _sameDate(DateTime first, DateTime second) =>
    first.year == second.year &&
    first.month == second.month &&
    first.day == second.day;

String _capitalize(String text) =>
    text.isEmpty ? text : '${text[0].toUpperCase()}${text.substring(1)}';
