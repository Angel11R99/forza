import 'package:material_ui/material_ui.dart';

import '../../../../domain/models/exercise.dart';
import '../../../../app/localization/localization_extensions.dart';
import 'exercise_localized_labels.dart';

String exerciseBenefit(BuildContext context, Exercise exercise) {
  final target = exercise.target;
  if (target == null) return context.l10n.exerciseInfoBenefitUnavailable;
  if (target == 'cardiovascular system') {
    return context.l10n.exerciseInfoBenefitCardio;
  }

  final nameAndInstructions = [
    exercise.name,
    if (exercise.englishName != null) exercise.englishName!,
    ...exercise.instructions,
    ...exercise.englishInstructions,
  ].join(' ').toLowerCase();
  final isStretch =
      nameAndInstructions.contains('estiramiento') ||
      nameAndInstructions.contains('stretch');
  final muscle = localizedExerciseTargetMuscle(context, target);

  return isStretch
      ? context.l10n.exerciseInfoBenefitMobility(muscle)
      : context.l10n.exerciseInfoBenefitStrength(muscle);
}

List<String> exerciseSupportingMuscles(
  BuildContext context,
  Exercise exercise,
) {
  final target = exercise.target?.toLowerCase();
  final muscles = exercise.secondaryMuscles
      .where((muscle) => _canonicalMuscle(muscle) != _canonicalMuscle(target))
      .map((muscle) => localizedExerciseSupportingMuscle(context, muscle))
      .toSet()
      .toList();
  return muscles;
}

String? _canonicalMuscle(String? muscle) => switch (muscle?.toLowerCase()) {
  'abs' => 'abdominals',
  'delts' => 'deltoids',
  'lats' => 'latissimus dorsi',
  'quads' => 'quadriceps',
  'spine' => 'spinal erectors',
  'traps' => 'trapezius',
  _ => muscle?.toLowerCase(),
};
