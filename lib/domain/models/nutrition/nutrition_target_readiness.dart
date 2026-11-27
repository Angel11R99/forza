import 'nutrition_models.dart';

/// The engine deliberately separates being allowed to train from being eligible
/// for an automated nutrition prescription.
enum NutritionTargetBlocker {
  under18,
  pregnancyOrLactation,
  eatingDisorderRisk,
  supervisedMedicalCondition,
  missingAge,
  missingHeight,
  missingWeight,
  missingActivityLevel,
  missingGoal,
  professionalReviewRequired,
}

class NutritionTargetAssessment {
  const NutritionTargetAssessment({
    required this.blockers,
    required this.trainingContext,
  });

  final List<NutritionTargetBlocker> blockers;

  /// Schedule context is informational only; it is never converted to calories.
  final NutritionTrainingContext trainingContext;

  bool get canGenerateTargets => blockers.isEmpty;
  NutritionTargets? get targets => null;
}

class NutritionTrainingContext {
  const NutritionTrainingContext({
    required this.trainingDaysPerWeek,
    required this.sessionMinutes,
    required this.isTrainingDay,
  });

  final int trainingDaysPerWeek;
  final int sessionMinutes;
  final bool isTrainingDay;
}

/// Inputs that do not belong in the persistently stored nutrition profile.
/// In particular, risk flags are ephemeral and need not store a diagnosis.
class NutritionTargetInputs {
  const NutritionTargetInputs({
    required this.profile,
    required this.weightKg,
    required this.trainingDaysPerWeek,
    required this.sessionMinutes,
    required this.isTrainingDay,
    this.activityLevelProvided = false,
    this.pregnantOrLactating = false,
    this.eatingDisorderRisk = false,
    this.requiresMedicalSupervision = false,
  });

  final NutritionProfile profile;
  final double? weightKg;
  final int trainingDaysPerWeek;
  final int sessionMinutes;
  final bool isTrainingDay;
  final bool activityLevelProvided;
  final bool pregnantOrLactating;
  final bool eatingDisorderRisk;
  final bool requiresMedicalSupervision;
}

/// Conservative, framework-independent gate for the future professionally
/// reviewed target calculator. No estimates or prescriptions are fabricated.
class NutritionTargetReadiness {
  const NutritionTargetReadiness();

  NutritionTargetAssessment assess(NutritionTargetInputs input) {
    final blockers = <NutritionTargetBlocker>[];
    final age = input.profile.ageYears;
    if (age == null) {
      blockers.add(NutritionTargetBlocker.missingAge);
    } else if (age < 18) {
      blockers.add(NutritionTargetBlocker.under18);
    }
    if (input.pregnantOrLactating) {
      blockers.add(NutritionTargetBlocker.pregnancyOrLactation);
    }
    if (input.eatingDisorderRisk) {
      blockers.add(NutritionTargetBlocker.eatingDisorderRisk);
    }
    if (input.requiresMedicalSupervision) {
      blockers.add(NutritionTargetBlocker.supervisedMedicalCondition);
    }
    if (input.profile.heightCm == null) {
      blockers.add(NutritionTargetBlocker.missingHeight);
    }
    final weight = input.weightKg;
    if (weight == null || !weight.isFinite || weight < 1 || weight > 500) {
      blockers.add(NutritionTargetBlocker.missingWeight);
    }
    if (!input.activityLevelProvided) {
      blockers.add(NutritionTargetBlocker.missingActivityLevel);
    }
    if (input.profile.goal == null) {
      blockers.add(NutritionTargetBlocker.missingGoal);
    }

    // Evidence and app history do not amount to a professionally reviewed,
    // versioned rule set. Until one is signed off, estimates stay unavailable.
    blockers.add(NutritionTargetBlocker.professionalReviewRequired);

    return NutritionTargetAssessment(
      blockers: List.unmodifiable(blockers),
      trainingContext: NutritionTrainingContext(
        trainingDaysPerWeek: input.trainingDaysPerWeek.clamp(0, 7).toInt(),
        sessionMinutes: input.sessionMinutes.clamp(0, 600).toInt(),
        isTrainingDay: input.isTrainingDay,
      ),
    );
  }
}
