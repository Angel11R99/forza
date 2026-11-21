import 'package:material_ui/material_ui.dart';

import '../../../../domain/models/exercise.dart';
import '../../../../domain/repositories/exercise_repository.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../widgets/exercise_list_card.dart';

class ExerciseAlternativesPage extends StatelessWidget {
  const ExerciseAlternativesPage({
    super.key,
    required this.exercise,
    required this.repository,
  });

  final Exercise exercise;
  final ExerciseRepository repository;

  @override
  Widget build(BuildContext context) {
    final alternatives = repository.alternativesFor(exercise);

    return Scaffold(
      appBar: AppBar(title: const Text('Alternativas')),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = constraints.maxWidth < 380
                ? AppSpacing.x4
                : AppSpacing.x6;
            final textScale = MediaQuery.textScalerOf(context).scale(1);
            final cardExtent =
                164 + ((textScale - 1).clamp(0, 2) * 52).toDouble();

            return CustomScrollView(
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
                        Text(
                          'Otras opciones',
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                                letterSpacing: 0,
                              ),
                        ),
                        const SizedBox(height: AppSpacing.x2),
                        Text(
                          'Alternativas a ${exercise.name}',
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        const SizedBox(height: AppSpacing.x2),
                        Text(
                          'Más ejercicios para trabajar un grupo muscular parecido.',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: AppSpacing.x6),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    0,
                    horizontalPadding,
                    AppSpacing.x8,
                  ),
                  sliver: SliverGrid.builder(
                    itemCount: alternatives.length,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 460,
                      mainAxisExtent: cardExtent,
                      crossAxisSpacing: AppSpacing.x3,
                      mainAxisSpacing: AppSpacing.x3,
                    ),
                    itemBuilder: (context, index) => ExerciseListCard(
                      exercise: alternatives[index],
                      onTap: () =>
                          Navigator.of(context).pop(alternatives[index]),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
