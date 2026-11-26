import 'package:material_ui/material_ui.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../core/widgets/app_surface_card.dart';
import '../../../core/widgets/forza_brand.dart';
import '../../../core/widgets/section_heading.dart';
import '../../../../domain/models/workout_record.dart';
import '../../../../domain/models/personal_goal.dart';
import '../../../../domain/models/body_measurement.dart';
import '../models/progress_models.dart';
import '../models/personal_records.dart';
import 'progress_detail_pages.dart';
import 'personal_goal_editor_page.dart';
import '../../../../app/localization/localization_extensions.dart';

class ProgressView extends StatefulWidget {
  const ProgressView({
    super.key,
    required this.records,
    required this.onShowActivity,
    this.goals = const [],
    required this.onSaveGoal,
    required this.onDeleteGoal,
    required this.measurements,
    required this.onSaveMeasurement,
    required this.onDeleteMeasurement,
  });

  final List<WorkoutRecord> records;
  final VoidCallback onShowActivity;
  final List<PersonalGoal> goals;
  final Future<void> Function(PersonalGoal) onSaveGoal;
  final Future<void> Function(String) onDeleteGoal;
  final List<BodyMeasurement> measurements;
  final Future<void> Function(BodyMeasurement, {BodyMeasurement? previous})
  onSaveMeasurement;
  final Future<void> Function(DateTime) onDeleteMeasurement;

  @override
  State<ProgressView> createState() => _ProgressViewState();
}

class _ProgressViewState extends State<ProgressView> {
  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final cutoff = DateTime(today.year, today.month, today.day - 29);
    final sessions =
        widget.records
            .where((record) => !record.date.isBefore(cutoff))
            .map(WorkoutHistoryEntry.fromRecord)
            .toList(growable: false)
          ..sort((first, second) => second.date.compareTo(first.date));
    final totalMinutes = sessions.fold<int>(
      0,
      (total, session) => total + session.durationMinutes,
    );
    final loggedSetCount = sessions.fold<int>(
      0,
      (total, session) => total + session.loggedSets.length,
    );
    final measurements = widget.measurements.toList()
      ..sort((first, second) => second.date.compareTo(first.date));
    final latestMeasurement = measurements.firstOrNull;
    final previousMeasurement = measurements.length > 1
        ? measurements[1]
        : null;
    final personalRecords = buildPersonalRecords(widget.records)
      ..sort((first, second) => second.date.compareTo(first.date));
    final latestPersonalRecord = personalRecords.firstOrNull;
    final hasStrengthData = widget.records.any(
      (record) =>
          record.setResults.any((set) => set.loadKg != null && set.loadKg! > 0),
    );
    final horizontalPadding = AppSpacing.pageGutter(
      MediaQuery.sizeOf(context).width,
    );

    return CustomScrollView(
      key: const PageStorageKey<String>('progress-scroll'),
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
                ForzaEyebrow(label: context.l10n.progressEyebrow),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  context.l10n.progressTitle,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  context.l10n.progressSubtitle,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: AppSpacing.x8),
                AppSurfaceCard(
                  padding: const EdgeInsets.all(AppSpacing.x6),
                  child: sessions.isEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.l10n.progressLast30Days,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: AppSpacing.x2),
                            Text(
                              context.l10n.progressEmptyDescription,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: AppSpacing.x3),
                            FilledButton.icon(
                              onPressed: widget.onShowActivity,
                              icon: const Icon(Icons.play_arrow_rounded),
                              label: Text(context.l10n.progressGoToActivity),
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.l10n.progressLast30Days,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: AppSpacing.x2),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${sessions.length}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall
                                      ?.copyWith(
                                        color: context.appColors.accent,
                                      ),
                                ),
                                const SizedBox(width: AppSpacing.x2),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: AppSpacing.x1,
                                  ),
                                  child: Text(
                                    context.l10n.progressSessions,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.x1),
                            Text(
                              context.l10n.progressLastWorkout(
                                _formatShortDate(
                                  sessions.first.date,
                                  Localizations.localeOf(context)
                                      .toLanguageTag(),
                                ),
                              ),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: AppSpacing.x4),
                            Row(
                              children: [
                                _SummaryValue(
                                  icon: Icons.schedule_rounded,
                                  label: context.l10n.progressTimeTotal(
                                    totalMinutes ~/ 60,
                                    totalMinutes % 60,
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.x6),
                                _SummaryValue(
                                  icon: Icons.fitness_center_rounded,
                                  label: context.l10n.progressExerciseCount(
                                    sessions.fold<int>(
                                      0,
                                      (sum, entry) => sum + entry.exerciseCount,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.x3),
                            Row(
                              children: [
                                _SummaryValue(
                                  icon: Icons.repeat_rounded,
                                  label: loggedSetCount == 0
                                      ? context.l10n.progressNoSetData
                                      : context.l10n.progressSetsAndReps(
                                          loggedSetCount,
                                          sessions.fold<int>(
                                            0,
                                            (sum, entry) =>
                                                sum + entry.totalRepetitions,
                                          ),
                                        ),
                                ),
                                const SizedBox(width: AppSpacing.x6),
                                _SummaryValue(
                                  icon: Icons.scale_outlined,
                                  label: _volumeLabel(
                                    context,
                                    sessions.fold<double>(
                                      0,
                                      (sum, entry) => sum + entry.totalVolumeKg,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.x2),
                            Text(
                              context.l10n.progressVolumeExplanation,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                ),
                const SizedBox(height: AppSpacing.x8),
                SectionHeading(
                  title: context.l10n.progressGoals,
                  actionLabel: context.l10n.progressAddGoal,
                  onAction: _openGoalEditor,
                ),
                if (widget.goals.isEmpty)
                  AppSurfaceCard(
                    child: Text(
                      context.l10n.progressGoalDescription,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  )
                else
                  for (final goal in widget.goals)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.x2),
                      child: _PersonalGoalCard(
                        goal: goal,
                        records: widget.records,
                        onEdit: () => _openGoalEditor(goal),
                        onDelete: () => _deleteGoal(goal),
                      ),
                    ),
                const SizedBox(height: AppSpacing.x8),
                SectionHeading(
                  title: context.l10n.progressBodyTrend,
                  actionLabel: context.l10n.progressRegisterMeasurements,
                  onAction: _openBodyEvolution,
                ),
                AppSurfaceCard(
                  padding: EdgeInsets.zero,
                  child: InkWell(
                    onTap: _openBodyEvolution,
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.x4),
                      child: latestMeasurement == null
                          ? Text(
                              context.l10n.progressMeasurementsEmpty,
                              style: Theme.of(context).textTheme.bodyMedium,
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${_formatShortDate(latestMeasurement.date, Localizations.localeOf(context).toLanguageTag())} · ${latestMeasurement.weightKg.toStringAsFixed(1)} kg',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium,
                                ),
                                if (previousMeasurement != null) ...[
                                  const SizedBox(height: AppSpacing.x1),
                                  Text(
                                    context.l10n.progressWeightChange(
                                      _signedDifference(
                                        latestMeasurement.weightKg -
                                            previousMeasurement.weightKg,
                                      ),
                                    ),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium,
                                  ),
                                ],
                              ],
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.x8),
                SectionHeading(title: context.l10n.progressStrengthEvolution),
                _ProgressDestinationCard(
                  icon: Icons.show_chart_rounded,
                  title: context.l10n.progressStrengthEvolution,
                  description: hasStrengthData
                      ? context.l10n.progressStrengthDescription
                      : context.l10n.progressStrengthEmpty,
                  onTap: _openStrengthEvolution,
                ),
                const SizedBox(height: AppSpacing.x8),
                SectionHeading(title: context.l10n.progressPersonalRecords),
                _ProgressDestinationCard(
                  icon: Icons.emoji_events_outlined,
                  title: context.l10n.progressPersonalRecords,
                  description: latestPersonalRecord == null
                      ? context.l10n.progressRecordsEmpty
                      : context.l10n.progressRecentRecord(
                          latestPersonalRecord.exercise,
                          _formatVolume(latestPersonalRecord.value),
                          latestPersonalRecord.unit,
                          _formatShortDate(
                            latestPersonalRecord.date,
                            Localizations.localeOf(context).toLanguageTag(),
                          ),
                        ),
                  onTap: _openPersonalRecords,
                ),
                const SizedBox(height: AppSpacing.x8),
                SectionHeading(title: context.l10n.progressHistory),
                if (sessions.isEmpty)
                  AppSurfaceCard(
                    child: Row(
                      children: [
                        const Icon(Icons.event_available_outlined, size: 26),
                        const SizedBox(width: AppSpacing.x3),
                        Expanded(
                          child: Text(
                            context.l10n.progressNoHistory,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  for (final session in sessions)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.x2),
                      child: _SessionHistoryCard(
                        session: session,
                        onTap: () => _openSession(context, session),
                      ),
                    ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _openSession(BuildContext context, WorkoutHistoryEntry session) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => SessionDetailPage(session: session),
      ),
    );
  }

  Future<void> _openStrengthEvolution() async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => StrengthEvolutionPage(records: widget.records),
      ),
    );
  }

  Future<void> _openPersonalRecords() async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => PersonalRecordsPage(records: widget.records),
      ),
    );
  }

  Future<void> _openBodyEvolution() async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => BodyEvolutionPage(
          measurements: widget.measurements,
          onSaveMeasurement: widget.onSaveMeasurement,
          onDeleteMeasurement: widget.onDeleteMeasurement,
        ),
      ),
    );
  }

  Future<void> _openGoalEditor([PersonalGoal? goal]) async {
    final updated = await Navigator.of(context).push<PersonalGoal>(
      MaterialPageRoute<PersonalGoal>(
        builder: (_) => PersonalGoalEditorPage(goal: goal),
      ),
    );
    if (!mounted || updated == null) return;
    await widget.onSaveGoal(updated);
  }

  Future<void> _deleteGoal(PersonalGoal goal) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.progressRemoveGoalTitle),
        content: Text(context.l10n.progressRemoveGoalBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n.commonRemove),
          ),
        ],
      ),
    );
    if (shouldDelete == true) await widget.onDeleteGoal(goal.id);
  }
}

class _PersonalGoalCard extends StatelessWidget {
  const _PersonalGoalCard({
    required this.goal,
    required this.records,
    required this.onEdit,
    required this.onDelete,
  });

  final PersonalGoal goal;
  final List<WorkoutRecord> records;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final current = goal.currentValue(records);
    final progress = (current / goal.targetValue).clamp(0.0, 1.0);
    final isWeekly = goal.type == PersonalGoalType.sessionsPerWeek;
    final currentLabel = isWeekly
        ? current.toStringAsFixed(0)
        : _formatVolume(current);
    final targetLabel = isWeekly
        ? goal.targetValue.toStringAsFixed(0)
        : _formatVolume(goal.targetValue);
    return AppSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  isWeekly
                      ? context.l10n.progressWeeklySessions
                      : goal.exerciseName ?? context.l10n.progressLoadGoal,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              IconButton(
                tooltip: context.l10n.progressEditGoal,
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined),
              ),
              IconButton(
                tooltip: context.l10n.progressRemoveGoalTitle,
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline_rounded),
              ),
            ],
          ),
          Text(
            context.l10n.progressGoalCurrentTarget(
              currentLabel,
              targetLabel,
              goal.unit,
            ),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.x3),
          LinearProgressIndicator(value: progress),
          const SizedBox(height: AppSpacing.x2),
          Text(
            isWeekly
                ? context.l10n.progressWeeklyGoalDescription
                : context.l10n.progressLoadGoalDescription,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _SessionHistoryCard extends StatelessWidget {
  const _SessionHistoryCard({required this.session, required this.onTap});

  final WorkoutHistoryEntry session;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final localeName = Localizations.localeOf(context).toLanguageTag();
    return AppSurfaceCard(
      padding: EdgeInsets.zero,
      child: Semantics(
        button: true,
        label: context.l10n.progressSessionSemantics(
          _localizedSessionTitle(context, session.title),
          _formatShortDate(
            session.date,
            Localizations.localeOf(context).toLanguageTag(),
          ),
        ),
        child: ExcludeSemantics(
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppRadius.medium),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.x4),
              child: Row(
                children: [
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: Icon(
                      Icons.fitness_center_rounded,
                      color: context.appColors.accent,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x4),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _localizedSessionTitle(context, session.title),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: AppSpacing.x1),
                        Text(
                          context.l10n.progressHistorySummary(
                            _formatShortDate(session.date, localeName),
                            session.durationMinutes,
                            session.exerciseCount,
                            session.totalVolumeKg > 0
                                ? _volumeLabel(context, session.totalVolumeKg)
                                : '',
                          ),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  const Icon(Icons.chevron_right_rounded),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SummaryValue extends StatelessWidget {
  const _SummaryValue({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 18, color: context.appColors.accent),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}

class _ProgressDestinationCard extends StatelessWidget {
  const _ProgressDestinationCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => AppSurfaceCard(
    padding: EdgeInsets.zero,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.medium),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x4),
        child: Row(
          children: [
            Icon(icon, color: context.appColors.accent, size: 24),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.x2),
            Icon(
              Icons.chevron_right_rounded,
              color: context.appColors.textSecondary,
            ),
          ],
        ),
      ),
    ),
  );
}

String _formatShortDate(DateTime date, String localeName) =>
    DateFormat.MMMd(localeName).format(date);

String _volumeLabel(BuildContext context, double volume) => volume == 0
    ? context.l10n.progressNoLoadData
    : context.l10n.progressVolumeKg(_formatVolume(volume));

String _localizedSessionTitle(BuildContext context, String title) =>
    switch (title) {
      'Tren superior' => context.l10n.onboardingUpperBody,
      'Tren inferior' => context.l10n.onboardingLowerBody,
      'Cuerpo completo' => context.l10n.onboardingFullBody,
      'Fuerza total' => context.l10n.progressTotalStrength,
      'Piernas y core' => context.l10n.progressLegsCore,
      _ => title,
    };

String _formatVolume(double volume) => volume == volume.roundToDouble()
    ? volume.toStringAsFixed(0)
    : volume.toStringAsFixed(1);

String _signedDifference(double difference) =>
    '${difference > 0 ? '+' : ''}${difference.toStringAsFixed(1)}';
