import 'package:material_ui/material_ui.dart';

import '../../../../domain/models/exercise.dart';
import '../../../../domain/repositories/exercise_repository.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/localization/localization_extensions.dart';
import '../../../core/widgets/forza_brand.dart';
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
      appBar: AppBar(title: Text(context.l10n.exerciseAlternativesTitle)),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = AppSpacing.pageGutter(
              constraints.maxWidth,
            );
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
                        ForzaEyebrow(label: context.l10n.exerciseEyebrow),
                        const SizedBox(height: AppSpacing.x3),
                        Text(
                          context.l10n.exerciseAlternativesTo(exercise.name),
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        const SizedBox(height: AppSpacing.x2),
                        Text(
                          context.l10n.exerciseAlternativesDescription,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: AppSpacing.x6),
                      ],
                    ),
                  ),
                ),
                if (alternatives.isEmpty)
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: Text(context.l10n.exerciseAlternativesEmpty),
                    ),
                  ),
                if (alternatives.isNotEmpty)
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
