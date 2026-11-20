import 'package:material_ui/material_ui.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../domain/models/exercise.dart';

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
      exercise.level,
    ].whereType<String>().join(', ');

    return Semantics(
      button: true,
      label: accessibilityLabel,
      child: ExcludeSemantics(
        child: Material(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.medium),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppRadius.medium),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.x4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.medium),
                border: Border.all(color: AppColors.divider),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceMuted,
                          borderRadius: BorderRadius.circular(AppRadius.small),
                        ),
                        child: Icon(
                          exerciseGroupIcon(exercise.muscleGroup),
                          color: AppColors.textPrimary,
                          size: 21,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.arrow_outward_rounded,
                        color: AppColors.textSecondary,
                        size: 18,
                      ),
                    ],
                  ),
                  const Spacer(),
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
