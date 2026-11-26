import 'package:material_ui/material_ui.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/localization/localization_extensions.dart';
import '../../../../domain/models/exercise.dart';
import '../../../core/widgets/app_surface_card.dart';
import 'exercise_animation.dart';
import '../models/exercise_localized_labels.dart';

class ExerciseListCard extends StatelessWidget {
  const ExerciseListCard({
    super.key,
    required this.exercise,
    required this.onTap,
    this.compact = false,
  });

  final Exercise exercise;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final accessibilityLabel = context.l10n.exerciseCardSemantics(
      localizedExerciseName(context, exercise),
      localizedExerciseMuscleGroup(context, exercise.muscleGroup),
      localizedExerciseEquipment(context, exercise.equipment),
    );

    return AppSurfaceCard(
      padding: EdgeInsets.zero,
      child: Semantics(
        button: true,
        label: accessibilityLabel,
        child: ExcludeSemantics(
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppRadius.medium),
            child: Padding(
              padding: EdgeInsets.all(compact ? AppSpacing.x2 : AppSpacing.x3),
              child: compact
                  ? _buildCompactCard(context)
                  : _buildListCard(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListCard(BuildContext context) => Row(
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.control),
        child: SizedBox(width: 68, height: 68, child: _animation(context)),
      ),
      const SizedBox(width: AppSpacing.x4),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              localizedExerciseName(context, exercise),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.x1),
            Text(
              '${localizedExerciseMuscleGroup(context, exercise.muscleGroup)}  ·  ${localizedExerciseEquipment(context, exercise.equipment)}',
              maxLines: 2,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
      const SizedBox(width: AppSpacing.x2),
      Icon(Icons.chevron_right_rounded, color: context.appColors.textSecondary),
    ],
  );

  Widget _buildCompactCard(BuildContext context) {
    final theme = Theme.of(context);
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final titleStyle = theme.textTheme.titleSmall;
    final categoryStyle = theme.textTheme.bodySmall;
    final titleHeight = (titleStyle?.fontSize ?? 14) * 2.8 * textScale;
    final categoryHeight = (categoryStyle?.fontSize ?? 12) * 1.5 * textScale;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Center(child: _animation(context))),
        const SizedBox(height: AppSpacing.x2),
        SizedBox(
          height: titleHeight,
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              localizedExerciseName(context, exercise),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: titleStyle,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.x1),
        SizedBox(
          height: categoryHeight,
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              localizedExerciseMuscleGroup(context, exercise.muscleGroup),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: categoryStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _animation(BuildContext context) => ExerciseAnimationView(
    exerciseId: exercise.id,
    animation: exercise.animation,
    label: localizedExerciseName(context, exercise),
    fallbackIcon: exerciseGroupIcon(exercise.muscleGroup),
  );
}

IconData exerciseGroupIcon(String group) => switch (group) {
  'Pecho' => Icons.fitness_center_rounded,
  'Espalda' => Icons.accessibility_new_rounded,
  'Piernas' => Icons.directions_run_rounded,
  'Hombros' => Icons.sports_martial_arts_rounded,
  'Core' => Icons.self_improvement_rounded,
  'Cuello' || 'Brazos' => Icons.accessibility_new_rounded,
  'Cardio' => Icons.favorite_border_rounded,
  _ => Icons.fitness_center_rounded,
};
