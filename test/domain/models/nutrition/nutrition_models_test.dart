import 'package:flutter_test/flutter_test.dart';
import 'package:forza/domain/models/nutrition/nutrition_models.dart';

void main() {
  final provenance = NutritionProvenance(
    source: 'Revisión profesional',
    version: '2026.1',
    confidence: 0.9,
  );

  test('regional food access preserves unknown instead of guessing', () {
    const access = FoodAccess();

    expect(access.availability, FoodAvailability.unknown);
    expect(access.relativeCost, RelativeFoodCost.unknown);
    expect(access.isValid, isTrue);
  });

  test('nutrition profile validates optional and versioned data', () {
    final profile = NutritionProfile(
      id: 'local-profile',
      version: 2,
      updatedAt: DateTime.utc(2026),
      countryCode: 'VE',
      region: 'Miranda',
      mealsPerDay: 3,
    );

    expect(profile.isValid, isTrue);
    expect(
      NutritionProfile(
        id: '',
        version: 0,
        updatedAt: DateTime.utc(2026),
      ).isValid,
      isFalse,
    );
  });

  test('nutrition profile JSON round-trips optional sensitive preferences', () {
    final profile = NutritionProfile(
      id: 'local',
      version: 3,
      updatedAt: DateTime.utc(2026, 11, 27),
      ageYears: 30,
      heightCm: 170,
      countryCode: 'VE',
      region: 'Miranda',
      mealsPerDay: 4,
      restrictions: const [
        FoodRestriction(type: FoodRestrictionType.allergy, value: 'peanut'),
      ],
    );

    final restored = NutritionProfile.fromJson(profile.toJson());

    expect(restored.isValid, isTrue);
    expect(restored.ageYears, 30);
    expect(restored.heightCm, 170);
    expect(restored.region, 'Miranda');
    expect(restored.restrictions.single.type, FoodRestrictionType.allergy);
    expect(restored.restrictions.single.value, 'peanut');
  });

  test('catalog and recipes reject invalid provenance and amounts', () {
    final food = Food(
      id: 'oats',
      name: 'Avena',
      catalogVersion: '1',
      provenance: provenance,
    );
    final recipe = Recipe(
      id: 'porridge',
      title: 'Avena',
      version: 1,
      ingredients: const [Ingredient(foodId: 'oats', amount: 40, unit: 'g')],
      provenance: provenance,
    );

    expect(food.isValid, isTrue);
    expect(recipe.isValid, isTrue);
    expect(
      const Ingredient(foodId: 'oats', amount: -1, unit: 'g').isValid,
      isFalse,
    );
    expect(
      Food(
        id: 'x',
        name: 'X',
        catalogVersion: '1',
        provenance: const NutritionProvenance(source: '', version: ''),
      ).isValid,
      isFalse,
    );
  });

  test('targets accept unspecified values and validate numeric values', () {
    final unspecified = NutritionTargets(
      id: 'none',
      version: 1,
      effectiveAt: DateTime.utc(2026),
      provenance: provenance,
    );
    final invalid = NutritionTargets(
      id: 'bad',
      version: 1,
      effectiveAt: DateTime.utc(2026),
      provenance: provenance,
      energyKcal: double.infinity,
    );

    expect(unspecified.isValid, isTrue);
    expect(unspecified.energyKcal, isNull);
    expect(invalid.isValid, isFalse);
  });

  test('meal plan and entries require a food or recipe reference', () {
    final entry = MealEntry(
      id: 'meal-1',
      dateTime: DateTime.utc(2026),
      recipeId: 'porridge',
    );
    final plan = MealPlan(
      id: 'week-1',
      version: 1,
      createdAt: DateTime.utc(2026),
      entries: [entry],
      profileVersion: 2,
      catalogVersion: '2026.1',
    );

    expect(entry.isValid, isTrue);
    expect(plan.isValid, isTrue);
    expect(MealEntry(id: 'bad', dateTime: DateTime.utc(2026)).isValid, isFalse);
  });
}
