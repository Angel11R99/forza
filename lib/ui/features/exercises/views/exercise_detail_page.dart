import 'package:material_ui/material_ui.dart';

import '../../../../domain/models/exercise.dart';
import '../../../../domain/repositories/exercise_repository.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/localization/localization_extensions.dart';
import '../../../core/widgets/app_surface_card.dart';
import '../../../core/widgets/forza_brand.dart';
import '../widgets/exercise_list_card.dart';
import '../widgets/exercise_animation.dart';
import '../models/exercise_guide_notes.dart';
import '../models/exercise_localized_labels.dart';
import 'exercise_alternatives_page.dart';

class ExerciseDetailPage extends StatelessWidget {
  const ExerciseDetailPage({
    super.key,
    required this.exercise,
    required this.repository,
  });

  final Exercise exercise;
  final ExerciseRepository repository;

  @override
  Widget build(BuildContext context) {
    final guideNotes = ExerciseGuideNotes.forExercise(exercise);
    final exerciseName = localizedExerciseName(context, exercise);
    final instructions = localizedExerciseInstructions(context, exercise);
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.exerciseDetailTitle)),
      body: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = AppSpacing.pageGutter(
              constraints.maxWidth,
            );

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        AppSpacing.x2,
                        horizontalPadding,
                        AppSpacing.x8,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ForzaEyebrow(label: context.l10n.exerciseEyebrow),
                            const SizedBox(height: AppSpacing.x3),
                            _ExercisePreview(exercise: exercise),
                            const SizedBox(height: AppSpacing.x6),
                            Text(
                              exerciseName,
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                            if (exercise.summary case final summary?) ...[
                              const SizedBox(height: AppSpacing.x2),
                              Text(
                                summary,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                            const SizedBox(height: AppSpacing.x4),
                            Wrap(
                              spacing: AppSpacing.x2,
                              runSpacing: AppSpacing.x2,
                              children: [
                                _InfoChip(
                                  label: localizedExerciseMuscleGroup(
                                    context,
                                    exercise.muscleGroup,
                                  ),
                                ),
                                _InfoChip(
                                  label: localizedExerciseEquipment(
                                    context,
                                    exercise.equipment,
                                  ),
                                ),
                                if (exercise.level case final level?)
                                  _InfoChip(label: level),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.x8),
                            Text(
                              context.l10n.exerciseHowTo,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: AppSpacing.x3),
                            AppSurfaceCard(
                              padding: EdgeInsets.zero,
                              child: Column(
                                children: [
                                  for (
                                    var i = 0;
                                    i < instructions.length;
                                    i++
                                  ) ...[
                                    _InstructionCard(
                                      index: i + 1,
                                      text: instructions[i],
                                    ),
                                    if (i < instructions.length - 1)
                                      const Divider(height: 1, indent: 66),
                                  ],
                                ],
                              ),
                            ),
                            if (guideNotes != null) ...[
                              const SizedBox(height: AppSpacing.x8),
                              Text(
                                context.l10n.exerciseGuideHeading,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: AppSpacing.x3),
                              AppSurfaceCard(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      context.l10n.exerciseGuideVariantNote,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color:
                                                context.appColors.textSecondary,
                                          ),
                                    ),
                                    const SizedBox(height: AppSpacing.x3),
                                    for (final mistake
                                        in guideNotes.commonMistakesFor(
                                          context.l10n,
                                        ))
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: AppSpacing.x3,
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.warning_amber_rounded,
                                              size: 20,
                                              color: context
                                                  .appColors
                                                  .textSecondary,
                                            ),
                                            const SizedBox(
                                              width: AppSpacing.x2,
                                            ),
                                            Expanded(
                                              child: Text(
                                                mistake,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    Text(
                                      context.l10n.exerciseSourcePrefix(
                                        guideNotes.sourceFor(context.l10n),
                                      ),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall,
                                    ),
                                    const SizedBox(height: AppSpacing.x1),
                                    SelectableText(
                                      context.l10n.exerciseSourceLink(
                                        guideNotes.sourceUrl,
                                      ),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color:
                                                context.appColors.textSecondary,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            const SizedBox(height: AppSpacing.x4),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.x6,
            AppSpacing.x3,
            AppSpacing.x6,
            AppSpacing.x4,
          ),
          child: OutlinedButton.icon(
            onPressed: () => _openAlternatives(context),
            icon: const Icon(Icons.swap_horiz_rounded),
            label: Text(context.l10n.exerciseViewAlternatives),
          ),
        ),
      ),
    );
  }

  Future<void> _openAlternatives(BuildContext context) async {
    final selected = await Navigator.of(context).push<Exercise>(
      MaterialPageRoute<Exercise>(
        builder: (_) => ExerciseAlternativesPage(
          exercise: exercise,
          repository: repository,
        ),
      ),
    );
    if (!context.mounted || selected == null) return;

    Navigator.of(context).pushReplacement<void, void>(
      MaterialPageRoute<void>(
        builder: (_) =>
            ExerciseDetailPage(exercise: selected, repository: repository),
      ),
    );
  }
}

class _ExercisePreview extends StatelessWidget {
  const _ExercisePreview({required this.exercise});

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 248,
      padding: const EdgeInsets.all(AppSpacing.x3),
      decoration: BoxDecoration(
        color: AppColors.light.surfaceMuted,
        borderRadius: BorderRadius.circular(AppRadius.large),
      ),
      child: Stack(
        children: [
          Center(
            child: SizedBox(
              width: 220,
              height: 220,
              child: ExerciseAnimationView(
                exerciseId: exercise.id,
                animation: exercise.animation,
                label: localizedExerciseName(context, exercise),
                fallbackIcon: exerciseGroupIcon(exercise.muscleGroup),
                showControls: true,
              ),
            ),
          ),
          Positioned(
            left: AppSpacing.x3,
            bottom: AppSpacing.x2,
            child: Text(
              exercise.animation == null
                  ? context.l10n.exerciseAnimationUnavailable
                  : context.l10n.exerciseAnimationIllustrative,
              style: Theme.of(context).textTheme.labelSmall
                  ?.copyWith(color: AppColors.light.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x2,
      ),
      decoration: BoxDecoration(
        color: context.appColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppRadius.control),
      ),
      child: Text(label, style: Theme.of(context).textTheme.labelLarge),
    );
  }
}

class _InstructionCard extends StatelessWidget {
  const _InstructionCard({required this.index, required this.text});

  final int index;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: context.appColors.accentSoft,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$index',
              style: Theme.of(context).textTheme.labelLarge
                  ?.copyWith(color: context.appColors.accent),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: AppSpacing.x1),
              child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
            ),
          ),
        ],
      ),
    );
  }
}
