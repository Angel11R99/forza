import 'package:material_ui/material_ui.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/localization/localization_extensions.dart';
import '../../../core/widgets/app_surface_card.dart';
import '../../../../domain/use_cases/training_plan_builder.dart';
import '../../profile/models/profile_settings.dart';
import '../../exercises/models/exercise_localized_labels.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({
    super.key,
    this.initialSettings = const TrainingSettings(),
    this.isFirstRun = false,
  });

  final TrainingSettings initialSettings;
  final bool isFirstRun;

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  static const _planBuilder = TrainingPlanBuilder();
  int _step = 0;
  late String _goal = widget.initialSettings.goal;
  late String _experience = widget.initialSettings.experience;
  late final Set<int> _trainingDays = {...widget.initialSettings.trainingDays};
  late int _sessionMinutes = widget.initialSettings.sessionMinutes;
  late final Set<String> _equipment = {...widget.initialSettings.equipment};
  late final Set<String> _avoidedExerciseIds = {
    ...widget.initialSettings.avoidedExerciseIds,
  };
  bool _editingFromReview = false;

  static const _goals = ['Ganar fuerza', 'Ganar músculo', 'Crear el hábito'];
  static const _equipmentOptions = [
    'Peso corporal',
    'Mancuernas',
    'Barra',
    'Banda elástica',
    'Polea',
    'Máquina de palanca',
  ];
  static const _weekdays = <int, String>{
    DateTime.monday: 'Lun',
    DateTime.tuesday: 'Mar',
    DateTime.wednesday: 'Mié',
    DateTime.thursday: 'Jue',
    DateTime.friday: 'Vie',
    DateTime.saturday: 'Sáb',
    DateTime.sunday: 'Dom',
  };
  static const _experienceLevels = [
    'Estoy empezando',
    'Tengo algo de experiencia',
    'Entreno hace tiempo',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _step < 4
              ? context.l10n.onboardingCreatePlan
              : context.l10n.onboardingPreview,
        ),
        leading: IconButton(
          tooltip: _editingFromReview
              ? context.l10n.onboardingReturnToPreview
              : _step == 0
              ? context.l10n.onboardingBack
              : context.l10n.onboardingPreviousStep,
          onPressed: _editingFromReview
              ? _backFromCurrentStep
              : _step == 0
              ? () => Navigator.of(context).maybePop()
              : _backFromCurrentStep,
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final padding = AppSpacing.pageGutter(constraints.maxWidth);
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: padding),
                      child: _StepProgress(step: _step, totalSteps: 5),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(
                          padding,
                          AppSpacing.x6,
                          padding,
                          AppSpacing.x6,
                        ),
                        child: _buildStep(context),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        padding,
                        AppSpacing.x2,
                        padding,
                        AppSpacing.x4,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              onPressed: _step == 4
                                  ? (_canCreatePlan ? _finish : null)
                                  : _step == 3 && _equipment.isEmpty
                                  ? null
                                  : _next,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 13,
                                ),
                                child: Text(_actionLabel(context)),
                              ),
                            ),
                          ),
                          if (widget.isFirstRun)
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text(context.l10n.onboardingSkip),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String _actionLabel(BuildContext context) => _step == 4
      ? context.l10n.onboardingCreateMyPlan
      : context.l10n.onboardingContinue;

  bool get _canCreatePlan {
    final sessions = _planBuilder.buildWeek(
      trainingDays: _trainingDays,
      sessionMinutes: _sessionMinutes,
      goal: _goal,
      experience: _experience,
      equipment: _equipment,
      avoidedExerciseIds: _avoidedExerciseIds,
    );
    return sessions.isNotEmpty &&
        sessions.every((session) => session.exercises.isNotEmpty);
  }

  void _editSection(int step) {
    setState(() {
      _editingFromReview = true;
      _step = step;
    });
  }

  void _backFromCurrentStep() {
    setState(() {
      if (_editingFromReview) {
        _step = 4;
        _editingFromReview = false;
      } else {
        _step--;
      }
    });
  }

  Widget _buildStep(BuildContext context) {
    return switch (_step) {
      0 => _buildGoalStep(context),
      1 => _buildExperienceStep(context),
      2 => _buildScheduleStep(context),
      3 => _buildEquipmentStep(context),
      _ => _buildPersonalizedPlan(context),
    };
  }

  Widget _buildPersonalizedPlan(BuildContext context) {
    final sessions = _planBuilder.buildWeek(
      trainingDays: _trainingDays,
      sessionMinutes: _sessionMinutes,
      goal: _goal,
      experience: _experience,
      equipment: _equipment,
      avoidedExerciseIds: _avoidedExerciseIds,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.onboardingPreviewTitle,
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          context.l10n.onboardingPreviewDescription,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: AppSpacing.x6),
        SizedBox(
          width: double.infinity,
          child: AppSurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _goalLabel(context, _goal),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  context.l10n.profilePlanSummary(
                    _trainingDays.length,
                    _goalLabel(context, _goal),
                    _sessionMinutes,
                  ),
                  style: Theme.of(context).textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  context.l10n.onboardingProgressionTemplateNote,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  context.l10n.onboardingPlanExperience(
                    _experienceLabel(context, _experience),
                  ),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  context.l10n.onboardingPlanEquipment(
                    _equipment
                        .map(
                          (item) => localizedExerciseEquipment(context, item),
                        )
                        .join(', '),
                  ),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                if (_avoidedExerciseIds.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    context.l10n.onboardingAvoidedMovementSummary(
                      _planBuilder.exerciseOptions
                          .where(
                            (exercise) => _avoidedExerciseIds.contains(
                              exercise.catalogId,
                            ),
                          )
                          .map(
                            (exercise) => localizedTrainingExerciseName(
                              context,
                              exercise.name,
                            ),
                          )
                          .join(', '),
                    ),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    context.l10n.onboardingAvoidedMovementApplied,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
                const SizedBox(height: AppSpacing.x3),
                Wrap(
                  spacing: AppSpacing.x1,
                  runSpacing: AppSpacing.x1,
                  children: [
                    _editButton(context, context.l10n.onboardingEditGoal, 0),
                    _editButton(
                      context,
                      context.l10n.onboardingEditExperience,
                      1,
                    ),
                    _editButton(
                      context,
                      context.l10n.onboardingEditSchedule,
                      2,
                    ),
                    _editButton(
                      context,
                      context.l10n.onboardingEditEquipment,
                      3,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.x3),
        if (sessions.any((session) => session.exercises.isEmpty)) ...[
          AppSurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    Expanded(
                      child: Text(
                        context.l10n.onboardingEmptySessionConflict,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x2),
                _editButton(context, context.l10n.onboardingEditEquipment, 3),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
        ],
        _buildRecoveryGuidance(context),
        const SizedBox(height: AppSpacing.x4),
        for (final session in sessions) ...[
          SizedBox(
            width: double.infinity,
            child: AppSurfaceCard(
              padding: EdgeInsets.zero,
              child: ExpansionTile(
                title: Text(
                  '${DateFormat.E(Localizations.localeOf(context).toLanguageTag()).format(DateTime(2024, 1, session.weekday))} · ${_sessionTitle(context, session.title)}',
                ),
                subtitle: session.exercises.isEmpty
                    ? Text(context.l10n.onboardingNoCompatibleExercises)
                    : Text(
                        context.l10n.onboardingSessionSummary(
                          session.exercises.length,
                          session.durationMinutes,
                        ),
                      ),
                children: [
                  for (final exercise in session.exercises)
                    ListTile(
                      title: Text(
                        localizedTrainingExerciseName(context, exercise.name),
                      ),
                      subtitle: Text(_localizedPrescription(context, exercise)),
                      dense: true,
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
        ],
        const SizedBox(height: AppSpacing.x2),
        Text(
          context.l10n.onboardingSafetyNote,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _editButton(BuildContext context, String label, int step) =>
      TextButton.icon(
        onPressed: () => _editSection(step),
        icon: const Icon(Icons.edit_outlined, size: 18),
        label: Text(label),
      );

  String _localizedPrescription(
    BuildContext context,
    PlannedExercise exercise,
  ) {
    final sets = int.tryParse(exercise.prescription.split(' ').first) ?? 0;
    if (exercise.timed) {
      return context.l10n.onboardingTimedPrescription(sets);
    }
    final repetitions = switch (_goal) {
      'Ganar fuerza' => context.l10n.onboardingStrengthRepRange,
      'Ganar músculo' => context.l10n.onboardingMuscleRepRange,
      _ => context.l10n.onboardingHabitRepRange,
    };
    return context.l10n.onboardingRepPrescription(sets, repetitions);
  }

  Widget _buildEquipmentStep(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.onboardingEquipmentTitle,
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          context.l10n.onboardingEquipmentDescription,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: AppSpacing.x6),
        Wrap(
          spacing: AppSpacing.x2,
          runSpacing: AppSpacing.x2,
          children: [
            for (final equipment in _equipmentOptions)
              FilterChip(
                label: Text(localizedExerciseEquipment(context, equipment)),
                selected: _equipment.contains(equipment),
                onSelected: (selected) => setState(() {
                  if (selected) {
                    _equipment.add(equipment);
                  } else {
                    _equipment.remove(equipment);
                  }
                }),
              ),
          ],
        ),
        if (_equipment.isEmpty) ...[
          const SizedBox(height: AppSpacing.x3),
          Text(
            context.l10n.onboardingEquipmentRequired,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
        const SizedBox(height: AppSpacing.x8),
        const Divider(),
        const SizedBox(height: AppSpacing.x4),
        Text(
          context.l10n.onboardingAvoidMovementTitle,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          context.l10n.onboardingAvoidMovementDescription,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: AppSpacing.x3),
        Wrap(
          spacing: AppSpacing.x2,
          runSpacing: AppSpacing.x2,
          children: [
            for (final exercise in _planBuilder.exerciseOptions)
              FilterChip(
                label: Text(
                  localizedTrainingExerciseName(context, exercise.name),
                ),
                selected: _avoidedExerciseIds.contains(exercise.catalogId),
                onSelected: (selected) => setState(() {
                  if (selected) {
                    _avoidedExerciseIds.add(exercise.catalogId);
                  } else {
                    _avoidedExerciseIds.remove(exercise.catalogId);
                  }
                }),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildGoalStep(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.onboardingGoalTitle,
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          context.l10n.onboardingGoalDescription,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: AppSpacing.x6),
        for (final goal in _goals) ...[
          _ChoiceCard(
            title: _goalLabel(context, goal),
            subtitle: switch (goal) {
              'Ganar fuerza' => context.l10n.onboardingStrengthGoalDescription,
              'Ganar músculo' => context.l10n.onboardingMuscleGoalDescription,
              _ => context.l10n.onboardingHabitGoalDescription,
            },
            icon: switch (goal) {
              'Ganar fuerza' => Icons.bolt_rounded,
              'Ganar músculo' => Icons.fitness_center_rounded,
              _ => Icons.repeat_rounded,
            },
            selected: _goal == goal,
            onTap: () => setState(() => _goal = goal),
          ),
          const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }

  Widget _buildExperienceStep(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.onboardingExperienceTitle,
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          context.l10n.onboardingExperienceDescription,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: AppSpacing.x6),
        for (final level in _experienceLevels) ...[
          _ChoiceCard(
            title: _experienceLabel(context, level),
            subtitle: switch (level) {
              'Estoy empezando' =>
                context.l10n.onboardingExperienceBeginnerDescription,
              'Tengo algo de experiencia' =>
                context.l10n.onboardingExperienceSomeDescription,
              _ => context.l10n.onboardingExperienceLongDescription,
            },
            icon: Icons.trending_up_rounded,
            selected: _experience == level,
            onTap: () => setState(() => _experience = level),
          ),
          const SizedBox(height: AppSpacing.x3),
        ],
        Text(
          context.l10n.onboardingExperienceNote,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildScheduleStep(BuildContext context) {
    final days = _trainingDays.toList()..sort();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.onboardingScheduleTitle,
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          context.l10n.onboardingScheduleDescription,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: AppSpacing.x6),
        AppSurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.onboardingSessionsPerWeek(days.length),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.x3),
              Wrap(
                spacing: AppSpacing.x2,
                runSpacing: AppSpacing.x2,
                children: [
                  for (final entry in _weekdays.entries)
                    FilterChip(
                      key: ValueKey('training-day-${entry.key}'),
                      label: Text(
                        DateFormat.E(
                          Localizations.localeOf(context).toLanguageTag(),
                        ).format(DateTime(2024, 1, entry.key)),
                      ),
                      selected: _trainingDays.contains(entry.key),
                      onSelected: (selected) => setState(() {
                        if (selected) {
                          _trainingDays.add(entry.key);
                        } else if (_trainingDays.length > 1) {
                          _trainingDays.remove(entry.key);
                        }
                      }),
                    ),
                ],
              ),
              const Divider(height: AppSpacing.x8),
              _buildRecoveryGuidance(context),
              const Divider(height: AppSpacing.x8),
              Text(
                context.l10n.onboardingSessionTime,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                context.l10n.onboardingMinutes(_sessionMinutes),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Slider(
                value: _sessionMinutes.toDouble(),
                min: 20,
                max: 90,
                divisions: 14,
                label: context.l10n.onboardingMinutes(_sessionMinutes),
                onChanged: (value) =>
                    setState(() => _sessionMinutes = value.round()),
              ),
              Text(
                context.l10n.onboardingSessionBudgetNote,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecoveryGuidance(BuildContext context) {
    final guidance = switch (_trainingDays.length) {
      1 => context.l10n.onboardingRecoveryOnce,
      2 || 3 => context.l10n.onboardingRecoveryTwoToThree,
      4 => context.l10n.onboardingRecoveryFour,
      5 || 6 => context.l10n.onboardingRecoveryFiveToSix,
      _ => context.l10n.onboardingRecoverySeven,
    };

    return AppSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.onboardingRecoveryTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(guidance, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: AppSpacing.x1),
          TextButton.icon(
            onPressed: _openRecoverySource,
            icon: const Icon(Icons.open_in_new),
            label: Text(context.l10n.onboardingRecoverySource),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              alignment: Alignment.centerLeft,
              minimumSize: const Size(48, 48),
              tapTargetSize: MaterialTapTargetSize.padded,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openRecoverySource() async {
    final uri = Uri.parse('https://pmc.ncbi.nlm.nih.gov/articles/PMC12965823/');
    try {
      final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!opened && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.exerciseSourceOpenFailure)),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.exerciseSourceOpenFailure)),
        );
      }
    }
  }

  void _next() => setState(() {
    if (_editingFromReview) {
      _step = 4;
      _editingFromReview = false;
    } else {
      _step++;
    }
  });

  void _finish() {
    Navigator.of(context).pop(
      TrainingSettings(
        trainingDays: Set.unmodifiable(_trainingDays),
        sessionMinutes: _sessionMinutes,
        goal: _goal,
        experience: _experience,
        equipment: Set.unmodifiable(_equipment),
        avoidedExerciseIds: Set.unmodifiable(_avoidedExerciseIds),
      ),
    );
  }
}

class _StepProgress extends StatelessWidget {
  const _StepProgress({required this.step, required this.totalSteps});

  final int step;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    final progress = (step + 1) / totalSteps;
    return Semantics(
      label: context.l10n.onboardingStepLabel(step + 1, totalSteps),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.onboardingStepLabel(step + 1, totalSteps),
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: AppSpacing.x2),
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: progress),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutCubic,
            builder: (context, animatedProgress, _) => LinearProgressIndicator(
              value: animatedProgress,
              minHeight: 4,
              backgroundColor: context.appColors.surfaceMuted,
              color: context.appColors.accent,
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
          ),
        ],
      ),
    );
  }
}

String _goalLabel(BuildContext context, String goal) =>
    context.localizeTrainingGoal(goal);

String _experienceLabel(BuildContext context, String experience) =>
    switch (experience) {
      'Estoy empezando' => context.l10n.onboardingExperienceBeginner,
      'Tengo algo de experiencia' => context.l10n.onboardingExperienceSome,
      _ => context.l10n.onboardingExperienceLong,
    };

String _sessionTitle(BuildContext context, String title) => switch (title) {
  'Tren superior' => context.l10n.onboardingUpperBody,
  'Tren inferior' => context.l10n.onboardingLowerBody,
  _ => context.l10n.onboardingFullBody,
};

class _ChoiceCard extends StatelessWidget {
  const _ChoiceCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      padding: EdgeInsets.zero,
      borderColor: selected
          ? context.appColors.accent
          : context.appColors.divider,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Row(
            children: [
              Icon(icon, size: 22),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Icon(
                selected ? Icons.check_circle_rounded : Icons.circle_outlined,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
