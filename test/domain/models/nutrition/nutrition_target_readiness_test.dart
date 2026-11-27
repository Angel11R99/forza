import 'package:flutter_test/flutter_test.dart';
import 'package:forza/domain/models/nutrition/nutrition_models.dart';
import 'package:forza/domain/models/nutrition/nutrition_target_readiness.dart';

void main() {
  NutritionTargetInputs input({
    int? age = 30,
    double? height = 170,
    double? weight = 70,
    NutritionGoal? goal = NutritionGoal.supportTraining,
    bool activity = true,
    bool pregnancy = false,
    bool eatingDisorderRisk = false,
    bool medical = false,
    int days = 4,
    int minutes = 45,
    bool trainingDay = true,
  }) =>
      NutritionTargetInputs(
        profile: NutritionProfile(
          id: 'local',
          version: 1,
          updatedAt: DateTime.utc(2026),
          ageYears: age,
          heightCm: height,
          goal: goal,
        ),
        weightKg: weight,
        activityLevelProvided: activity,
        pregnantOrLactating: pregnancy,
        eatingDisorderRisk: eatingDisorderRisk,
        requiresMedicalSupervision: medical,
        trainingDaysPerWeek: days,
        sessionMinutes: minutes,
        isTrainingDay: trainingDay,
      );

  const readiness = NutritionTargetReadiness();

  test('does not prescribe before professional review, even with complete data', () {
    final result = readiness.assess(input());

    expect(result.canGenerateTargets, isFalse);
    expect(result.targets, isNull);
    expect(
      result.blockers,
      contains(NutritionTargetBlocker.professionalReviewRequired),
    );
  });

  test('missing critical data is enumerated instead of guessed', () {
    final result = readiness.assess(
      input(age: null, height: null, weight: null, goal: null, activity: false),
    );

    expect(
      result.blockers,
      containsAll([
        NutritionTargetBlocker.missingAge,
        NutritionTargetBlocker.missingHeight,
        NutritionTargetBlocker.missingWeight,
        NutritionTargetBlocker.missingActivityLevel,
        NutritionTargetBlocker.missingGoal,
      ]),
    );
  });

  test('underage profiles never receive automated nutrition targets', () {
    final result = readiness.assess(input(age: 17));

    expect(result.blockers, contains(NutritionTargetBlocker.under18));
    expect(result.targets, isNull);
  });

  test('pregnancy, eating disorder risk, and supervised conditions block targets', () {
    final result = readiness.assess(
      input(pregnancy: true, eatingDisorderRisk: true, medical: true),
    );

    expect(
      result.blockers,
      containsAll([
        NutritionTargetBlocker.pregnancyOrLactation,
        NutritionTargetBlocker.eatingDisorderRisk,
        NutritionTargetBlocker.supervisedMedicalCondition,
      ]),
    );
  });

  test('invalid weights are treated as missing', () {
    for (final weight in <double>[double.nan, double.infinity, 0, 501]) {
      expect(
        readiness
            .assess(input(weight: weight))
            .blockers,
        contains(NutritionTargetBlocker.missingWeight),
      );
    }
  });

  test('training and rest context is retained without estimating session calories', () {
    final training = readiness.assess(input());
    final rest = readiness.assess(input(trainingDay: false));

    expect(training.trainingContext.trainingDaysPerWeek, 4);
    expect(training.trainingContext.sessionMinutes, 45);
    expect(training.trainingContext.isTrainingDay, isTrue);
    expect(rest.trainingContext.isTrainingDay, isFalse);
    expect(training.targets, isNull);
    expect(rest.targets, isNull);
  });

  test('training context is bounded to valid units and weekly limits', () {
    final result = readiness.assess(input(days: 9, minutes: 900));

    expect(result.trainingContext.trainingDaysPerWeek, 7);
    expect(result.trainingContext.sessionMinutes, 600);
  });
}
