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
    this.scheduledSessions = const [],
  });

  final VoidCallback onShowActivity;
  final VoidCallback onShowProfile;
  final TrainingSettings settings;
  final VoidCallback onStartWorkout;
  final VoidCallback onEditPlan;
  final Set<DateTime> completedDates;
  final int streakDays;
  final int streakAnimationFrom;
  final int streakAnimationRevision;
  final bool hasActiveWorkout;
  final List<ScheduledTrainingSession> scheduledSessions;

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = AppSpacing.pageGutter(
      MediaQuery.sizeOf(context).width,
    );
    final now = DateTime.now();
    final activeSession = scheduledSessions
        .where((session) => session.isInProgress)
        .firstOrNull;
    final upcomingSession = scheduledSessions
        .where(
          (session) =>
              session.status == 'pending' &&
              !DateTime(
                session.scheduledDate.year,
                session.scheduledDate.month,
                session.scheduledDate.day,
              ).isBefore(DateTime(now.year, now.month, now.day)),
        )
        .firstOrNull;
    final plannedSession = activeSession ?? upcomingSession;
    final localeName = Localizations.localeOf(context).toLanguageTag();
    final nextTrainingDate =
        plannedSession?.scheduledDate ??
        _nextTrainingDate(settings.trainingDays, now);
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
                  title: _sameDate(nextTrainingDate, now)
                      ? context.l10n.homeTodayWorkout
                      : context.l10n.homeNextSession(
                          DateFormat.E(localeName).format(nextTrainingDate),
                        ),
                  actionLabel: context.l10n.homeAdjustPlan,
                  onAction: onEditPlan,
                ),
                _TodayWorkoutCard(
                  settings: settings,
                  onPressed: onStartWorkout,
                  sessionDate: nextTrainingDate,
                  hasActiveWorkout: hasActiveWorkout,
                  scheduledSession: plannedSession,
                ),
                const SizedBox(height: AppSpacing.x8),
                SectionHeading(
                  title: context.l10n.homeWeekTitle,
                  actionLabel: context.l10n.homeViewActivity,
                  onAction: onShowActivity,
                ),
                _WeeklySummary(
                  settings: settings,
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
  });

  final TrainingSettings settings;
  final VoidCallback onPressed;
  final DateTime sessionDate;
  final bool hasActiveWorkout;
  final ScheduledTrainingSession? scheduledSession;

  static const _planBuilder = TrainingPlanBuilder();

  @override
  Widget build(BuildContext context) {
    final localeName = Localizations.localeOf(context).toLanguageTag();
    final days = settings.trainingDays.toList()..sort();
    final todayIndex = days.indexOf(sessionDate.weekday);
    final exerciseCount =
        scheduledSession?.exerciseCount ??
        _planBuilder
            .buildSession(
              sessionIndex: todayIndex < 0 ? 0 : todayIndex,
              sessionMinutes: settings.sessionMinutes,
              goal: settings.goal,
              experience: settings.experience,
              equipment: settings.equipment,
            )
            .length;
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
              onPressed: onPressed,
              style: FilledButton.styleFrom(
                backgroundColor: context.appColors.inverseText,
                foregroundColor: context.appColors.accent,
              ),
              icon: const Icon(Icons.play_arrow_rounded),
              label: Text(
                hasActiveWorkout
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
    required this.completedDates,
    required this.scheduledSessions,
    required this.onTap,
  });

  final TrainingSettings settings;
  final Set<DateTime> completedDates;
  final List<ScheduledTrainingSession> scheduledSessions;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final localeName = Localizations.localeOf(context).toLanguageTag();
    final days = settings.trainingDays.toList()..sort();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekStart = today.subtract(Duration(days: today.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 7));
    final persistedWeek = scheduledSessions
        .where(
          (session) =>
              !session.scheduledDate.isBefore(weekStart) &&
              session.scheduledDate.isBefore(weekEnd),
        )
        .toList(growable: false);
    final completedCount = persistedWeek.isEmpty
        ? days.where((weekday) {
            final scheduled = weekStart.add(Duration(days: weekday - 1));
            return completedDates.any((date) => _sameDate(date, scheduled));
          }).length
        : persistedWeek
              .where(
                (session) =>
                    !session.isSkipped &&
                    (session.isCompleted ||
                        completedDates.any(
                          (date) => _sameDate(date, session.scheduledDate),
                        )),
              )
              .length;
    final weeklyTarget = persistedWeek.isEmpty
        ? days.length
        : persistedWeek.length;
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
              Row(
                children: [
                  Expanded(
                    child: Text(
                      context.l10n.homeWeeklySessionCount(
                        completedCount,
                        weeklyTarget,
                      ),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Text(
                    context.l10n.homeThisWeek,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
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
                    for (final session in persistedWeek)
                      Expanded(
                        child: _WeekdayProgress(
                          weekday: session.scheduledDate.weekday,
                          date: session.scheduledDate,
                          completedDates: completedDates,
                          isToday: _sameDate(session.scheduledDate, today),
                          localeName: localeName,
                        ),
                      )
                  else
                    for (final weekday in days)
                      Expanded(
                        child: _WeekdayProgress(
                          weekday: weekday,
                          date: weekStart.add(Duration(days: weekday - 1)),
                          completedDates: completedDates,
                          isToday: _sameDate(
                            weekStart.add(Duration(days: weekday - 1)),
                            today,
                          ),
                          localeName: localeName,
                        ),
                      ),
                ],
              ),
              const SizedBox(height: AppSpacing.x3),
              LinearProgressIndicator(
                value: days.isEmpty ? 0 : completedCount / days.length,
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
    required this.weekday,
    required this.date,
    required this.completedDates,
    required this.isToday,
    required this.localeName,
  });

  final int weekday;
  final DateTime date;
  final Set<DateTime> completedDates;
  final bool isToday;
  final String localeName;

  @override
  Widget build(BuildContext context) {
    final completed = completedDates.any((saved) => _sameDate(saved, date));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Semantics(
      label: context.l10n.homeWeekdayStatus(
        DateFormat.E(localeName).format(date),
        completed
            ? context.l10n.homeStatusCompleted
            : context.l10n.homeStatusPending,
      ),
      child: Column(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: completed ? context.appColors.accent : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                color: isToday || completed
                    ? context.appColors.accent
                    : isDark
                    ? const Color(0xFF777A80)
                    : context.appColors.divider,
                width: isToday && !completed ? 1.5 : 1,
              ),
            ),
            alignment: Alignment.center,
            child: Icon(
              completed ? Icons.check_rounded : Icons.circle,
              size: completed ? 18 : 6,
              color: completed
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

DateTime _nextTrainingDate(Set<int> trainingDays, DateTime from) {
  final today = DateTime(from.year, from.month, from.day);
  for (var offset = 0; offset < 7; offset++) {
    final candidate = today.add(Duration(days: offset));
    if (trainingDays.contains(candidate.weekday)) return candidate;
  }
  return today;
}
