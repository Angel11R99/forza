import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

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
    this.sourceLinkLauncher,
  });

  final Exercise exercise;
  final ExerciseRepository repository;
  final Future<bool> Function(Uri uri)? sourceLinkLauncher;

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
                            for (var i = 0; i < instructions.length; i++) ...[
                              AppSurfaceCard(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${context.l10n.exerciseInstructionStep} ${i + 1}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            color:
                                                context.appColors.textPrimary,
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                    const SizedBox(height: AppSpacing.x2),
                                    Text(
                                      instructions[i],
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color:
                                                context.appColors.textSecondary,
                                            height: 1.45,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              if (i < instructions.length - 1)
                                const SizedBox(height: AppSpacing.x3),
                            ],
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
                                    TextButton.icon(
                                      onPressed: () => _openSource(
                                        context,
                                        guideNotes.sourceUrl,
                                      ),
                                      icon: const Icon(Icons.open_in_new),
                                      label: Text(
                                        context.l10n.exerciseSourceLink(
                                          guideNotes.sourceUrl,
                                        ),
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        alignment: Alignment.centerLeft,
                                        minimumSize: const Size(48, 48),
                                        tapTargetSize:
                                            MaterialTapTargetSize.padded,
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

  Future<void> _openSource(BuildContext context, String sourceUrl) async {
    final uri = Uri.tryParse(sourceUrl);
    if (uri == null || uri.scheme != 'https') return;
    try {
      final open =
          sourceLinkLauncher ??
          (uri) => launchUrl(uri, mode: LaunchMode.externalApplication);
      final opened = await open(uri);
      if (!opened && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.exerciseSourceOpenFailure)),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.exerciseSourceOpenFailure)),
        );
      }
    }
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
