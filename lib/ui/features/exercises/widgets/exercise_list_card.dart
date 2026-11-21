import 'package:material_ui/material_ui.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../domain/models/exercise.dart';
import '../../../core/widgets/app_surface_card.dart';
import 'exercise_animation.dart';

class ExerciseListCard extends StatelessWidget {
  const ExerciseListCard({
    super.key,
    required this.exercise,
    required this.onTap,
  });

  final Exercise exercise;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accessibilityLabel = [
      exercise.name,
      exercise.muscleGroup,
      exercise.equipment,
    ].join(', ');

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
              padding: const EdgeInsets.all(AppSpacing.x3),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.control),
                    child: SizedBox(
                      width: 68,
                      height: 68,
                      child: ExerciseAnimationView(
                        exerciseId: exercise.id,
                        animation: exercise.animation,
                        label: exercise.name,
                        fallbackIcon: exerciseGroupIcon(exercise.muscleGroup),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x4),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          exercise.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: AppSpacing.x1),
                        Text(
                          '${exercise.muscleGroup}  ·  ${exercise.equipment}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
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
