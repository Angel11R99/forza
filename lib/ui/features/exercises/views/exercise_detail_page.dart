import 'package:material_ui/material_ui.dart';

import '../../../../domain/models/exercise.dart';
import '../../../../domain/repositories/exercise_repository.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../core/widgets/app_surface_card.dart';
import '../widgets/exercise_list_card.dart';
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
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del ejercicio')),
      body: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = constraints.maxWidth < 380
                ? AppSpacing.x4
                : AppSpacing.x6;

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
                            _ExercisePreview(exercise: exercise),
                            const SizedBox(height: AppSpacing.x6),
                            Text(
                              exercise.name,
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                            const SizedBox(height: AppSpacing.x2),
                            Text(
                              exercise.summary,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: AppSpacing.x4),
                            Wrap(
                              spacing: AppSpacing.x2,
                              runSpacing: AppSpacing.x2,
                              children: [
                                _InfoChip(label: exercise.muscleGroup),
                                _InfoChip(label: exercise.equipment),
                                _InfoChip(label: exercise.level),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.x8),
                            Text(
                              'Cómo hacerlo',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: AppSpacing.x3),
                            for (
                              var i = 0;
                              i < exercise.instructions.length;
                              i++
                            ) ...[
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: AppSpacing.x2,
                                ),
                                child: _InstructionCard(
                                  index: i + 1,
                                  text: exercise.instructions[i],
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
            label: const Text('Ver alternativas'),
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
      height: 208,
      decoration: BoxDecoration(
        color: AppColors.textPrimary,
        borderRadius: BorderRadius.circular(AppRadius.large),
      ),
      child: Stack(
        children: [
          Center(
            child: Icon(
              exerciseGroupIcon(exercise.muscleGroup),
              size: 72,
              color: AppColors.inverseText,
            ),
          ),
          Positioned(
            left: AppSpacing.x4,
            bottom: AppSpacing.x4,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.x3,
                vertical: AppSpacing.x2,
              ),
              decoration: BoxDecoration(
                color: AppColors.inverseText.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: Text(
                'VISTA PREVIA ILUSTRATIVA',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.inverseText,
                  fontSize: 10,
                  letterSpacing: 1,
                ),
              ),
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
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppRadius.pill),
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
    return AppSurfaceCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.textPrimary,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$index',
              style: Theme.of(context).textTheme.labelLarge
                  ?.copyWith(color: AppColors.inverseText),
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
