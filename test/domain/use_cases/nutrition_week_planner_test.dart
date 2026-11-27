import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:forza/domain/models/nutrition/nutrition_catalog.dart';
import 'package:forza/domain/models/nutrition/nutrition_models.dart';
import 'package:forza/domain/use_cases/nutrition_week_planner.dart';

Future<NutritionCatalog> loadCatalog() async {
  final decoded = jsonDecode(
    await File('assets/data/nutrition_catalog.json').readAsString(),
  ) as Map<String, Object?>;
  return NutritionCatalog.fromJson(decoded);
}

NutritionProfile profile({
  int? meals = 3,
  DietaryPattern pattern = DietaryPattern.unrestricted,
  List<FoodRestriction> restrictions = const [],
  List<String> unavailable = const [],
  RelativeFoodCost budget = RelativeFoodCost.moderate,
  String? countryCode,
}) => NutritionProfile(
  id: 'local',
  version: 2,
  updatedAt: DateTime.utc(2026, 11, 27),
  mealsPerDay: meals,
  dietaryPattern: pattern,
  restrictions: restrictions,
  unavailableFoodIds: unavailable,
  budget: budget,
  countryCode: countryCode,
);

void main() {
  const planner = NutritionWeekPlanner();
  final start = DateTime(2026, 12, 7); // Monday.

  test(
    'creates a deterministic offline seven day plan from bundled recipes',
    () async {
      final catalog = await loadCatalog();
      NutritionWeekPlan generate(String id) => planner
          .generate(
            catalog: catalog,
            profile: profile(meals: 4),
            weekStart: start,
            createdAt: DateTime.utc(2026, 11, 27),
            planId: id,
            trainingWeekdays: const {DateTime.monday, DateTime.friday},
          )
          .plan!;

      final first = generate('week-a');
      final second = generate('week-b');

      expect(first.days, hasLength(7));
      expect(first.days.every((day) => day.meals.length == 4), isTrue);
      expect(first.days.first.isTrainingDay, isTrue);
      expect(first.days[1].isTrainingDay, isFalse);
      expect(first.days[4].isTrainingDay, isTrue);
      expect(
        first.days
            .expand((day) => day.meals)
            .map((meal) => meal.recipeId)
            .toList(),
        second.days
            .expand((day) => day.meals)
            .map((meal) => meal.recipeId)
            .toList(),
      );
      expect(first.catalogVersion, catalog.version);
      expect(first.profileVersion, 2);
      expect(first.shoppingList, isNotEmpty);
      expect(first.shoppingList.every((item) => item.grams > 0), isTrue);
    },
  );

  test(
    'reserves each day first slot for compatible pinned recipes only',
    () async {
      final catalog = await loadCatalog();
      final source = catalog.recipes.first;
      final pinned = NutritionCatalogRecipe(
        id: 'private:pinned-test',
        version: 1,
        titleEn: 'Pinned meal',
        titleEs: 'Comida fijada',
        servings: source.servings,
        ingredients: source.ingredients,
        stepsEn: const [],
        stepsEs: const [],
        dietaryPatterns: source.dietaryPatterns,
      );
      final safe = planner
          .generate(
            catalog: catalog,
            profile: profile(meals: 2),
            weekStart: start,
            createdAt: DateTime.utc(2026, 11, 27),
            planId: 'pinned-safe',
            trainingWeekdays: const {},
            pinnedRecipes: [pinned],
          )
          .plan!;
      expect(
        safe.days.every((day) => day.meals.first.recipeId == pinned.id),
        isTrue,
      );

      final unsafe = planner
          .generate(
            catalog: catalog,
            profile: profile(
              meals: 2,
              unavailable: [source.ingredients.first.foodId],
            ),
            weekStart: start,
            createdAt: DateTime.utc(2026, 11, 27),
            planId: 'pinned-unsafe',
            trainingWeekdays: const {},
            pinnedRecipes: [pinned],
          )
          .plan;
      expect(
        unsafe?.days
            .expand((day) => day.meals)
            .any((meal) => meal.recipeId == pinned.id),
        isNot(true),
      );
      expect(
        planner.isRecipeAllowedForProfile(
          recipe: pinned,
          catalog: catalog,
          profile: profile(unavailable: [source.ingredients.first.foodId]),
        ),
        isFalse,
      );
    },
  );

  test('reports no safe plan when allergen data is unknown', () async {
    final result = planner.generate(
      catalog: await loadCatalog(),
      profile: profile(
        restrictions: const [
          FoodRestriction(type: FoodRestrictionType.allergy, value: 'peanut'),
        ],
      ),
      weekStart: start,
      createdAt: DateTime.utc(2026, 11, 27),
      planId: 'allergy-week',
      trainingWeekdays: const {},
    );

    expect(result.status, MealPlanGenerationStatus.noSafeRecipes);
    expect(result.plan, isNull);
  });

  test('diet pattern and explicit exclusions filter before planning', () async {
    final catalog = await loadCatalog();
    final vegan = planner.generate(
      catalog: catalog,
      profile: profile(pattern: DietaryPattern.vegan),
      weekStart: start,
      createdAt: DateTime.utc(2026, 11, 27),
      planId: 'vegan-week',
      trainingWeekdays: const {},
    );
    final vegetarian = planner.generate(
      catalog: catalog,
      profile: profile(pattern: DietaryPattern.vegetarian),
      weekStart: start,
      createdAt: DateTime.utc(2026, 11, 27),
      planId: 'vegetarian-week',
      trainingWeekdays: const {},
    );
    final withoutLentils = planner.generate(
      catalog: catalog,
      profile: profile(
        restrictions: const [
          FoodRestriction(type: FoodRestrictionType.excluded, value: 'lenteja'),
        ],
      ),
      weekStart: start,
      createdAt: DateTime.utc(2026, 11, 27),
      planId: 'no-lentils-week',
      trainingWeekdays: const {},
    );

    expect(vegan.status, MealPlanGenerationStatus.generated);
    expect(
      vegan.plan!.days
          .expand((day) => day.meals)
          .every(
            (meal) => catalog.recipes
                .firstWhere((recipe) => recipe.id == meal.recipeId)
                .dietaryPatterns
                .contains(DietaryPattern.vegan),
          ),
      isTrue,
    );
    expect(vegetarian.status, MealPlanGenerationStatus.generated);
    expect(
      vegetarian.plan!.days
          .expand((day) => day.meals)
          .every(
            (meal) => catalog.recipes
                .firstWhere((recipe) => recipe.id == meal.recipeId)
                .dietaryPatterns
                .contains(DietaryPattern.vegetarian),
          ),
      isTrue,
    );
    expect(withoutLentils.status, MealPlanGenerationStatus.generated);
    expect(
      withoutLentils.plan!.days
          .expand((day) => day.meals)
          .every((meal) => !meal.recipeId.contains('lentil')),
      isTrue,
    );
  });

  test(
    'does not invent local cost or availability and accepts offline budgets',
    () async {
      final catalog = await loadCatalog();
      expect(
        catalog.foods.every(
          (food) =>
              food.access.relativeCost == RelativeFoodCost.unknown &&
              food.access.availability == FoodAvailability.unknown,
        ),
        isTrue,
      );
      for (final budget in [
        RelativeFoodCost.low,
        RelativeFoodCost.moderate,
        RelativeFoodCost.unknown,
      ]) {
        expect(
          planner
              .generate(
                catalog: catalog,
                profile: profile(budget: budget),
                weekStart: start,
                createdAt: DateTime.utc(2026, 11, 27),
                planId: 'budget-${budget.name}',
                trainingWeekdays: const {},
              )
              .status,
          MealPlanGenerationStatus.generated,
        );
      }
      for (final country in ['AR', 'CO', 'DO', 'ES', 'MX']) {
        expect(
          planner
              .generate(
                catalog: catalog,
                profile: profile(countryCode: country),
                weekStart: start,
                createdAt: DateTime.utc(2026, 11, 27),
                planId: 'country-$country',
                trainingWeekdays: const {},
              )
              .status,
          MealPlanGenerationStatus.generated,
        );
      }
    },
  );

  test('rejects invalid meal count and invalid training weekdays', () async {
    final catalog = await loadCatalog();
    for (final result in [
      planner.generate(
        catalog: catalog,
        profile: profile(),
        weekStart: start,
        createdAt: DateTime.utc(2026, 11, 27),
        planId: 'bad-count',
        trainingWeekdays: const {},
        mealsPerDay: 11,
      ),
      planner.generate(
        catalog: catalog,
        profile: profile(),
        weekStart: start,
        createdAt: DateTime.utc(2026, 11, 27),
        planId: 'bad-weekday',
        trainingWeekdays: const {8},
      ),
    ]) {
      expect(result.status, MealPlanGenerationStatus.invalidConfiguration);
      expect(result.plan, isNull);
    }
  });

  test(
    'regenerates only future days and keeps past plan days intact',
    () async {
      final catalog = await loadCatalog();
      NutritionWeekPlan build(NutritionProfile nutritionProfile) => planner
          .generate(
            catalog: catalog,
            profile: nutritionProfile,
            weekStart: start,
            createdAt: DateTime.utc(2026, 11, 27),
            planId: 'same-plan',
            trainingWeekdays: const {DateTime.monday},
          )
          .plan!;
      final existing = build(profile());
      final replacement = build(profile(pattern: DietaryPattern.vegan));
      final updated = planner.regenerateFutureDays(
        existing: existing,
        regenerated: replacement,
        fromDate: DateTime(2026, 12, 10),
        createdAt: DateTime.utc(2026, 12, 10),
      );

      expect(updated, isNotNull);
      expect(updated!.version, 2);
      for (var index = 0; index < 3; index++) {
        expect(identical(updated.days[index], existing.days[index]), isTrue);
      }
      for (final day in updated.days.skip(3)) {
        expect(
          day.meals.every(
            (meal) => catalog.recipes
                .firstWhere((recipe) => recipe.id == meal.recipeId)
                .dietaryPatterns
                .contains(DietaryPattern.vegan),
          ),
          isTrue,
        );
      }
      expect(updated.shoppingList, isNotEmpty);
      expect(
        planner.regenerateFutureDays(
          existing: existing,
          regenerated: build(profile()),
          fromDate: DateTime(2026, 12, 10),
          createdAt: DateTime.utc(2026, 12, 10),
        ),
        isNotNull,
      );
    },
  );

  test(
    'ingredient swap is a safe preview and updates the shopping list',
    () async {
      final catalog = await loadCatalog();
      final nutritionProfile = profile();
      final plan = planner
          .generate(
            catalog: catalog,
            profile: nutritionProfile,
            weekStart: start,
            createdAt: DateTime.utc(2026, 11, 27),
            planId: 'swap-week',
            trainingWeekdays: const {},
          )
          .plan!;
      final meal = plan.days
          .expand((day) => day.meals)
          .firstWhere((item) => item.recipeId == 'forza-oats-banana');
      const oats = 'usda-foundation:2346396';
      const steelCutOats = 'usda-foundation:2346397';

      final preview = planner.previewIngredientSwap(
        plan: plan,
        mealId: meal.id,
        currentFoodId: oats,
        replacementFoodId: steelCutOats,
        catalog: catalog,
        profile: nutritionProfile,
      );
      final blockedByUnknownAllergen = planner.previewIngredientSwap(
        plan: plan,
        mealId: meal.id,
        currentFoodId: oats,
        replacementFoodId: steelCutOats,
        catalog: catalog,
        profile: profile(
          restrictions: const [
            FoodRestriction(type: FoodRestrictionType.allergy, value: 'peanut'),
          ],
        ),
      );

      expect(preview.status, MealPlanSwapStatus.previewReady);
      expect(
        preview.plan!.days
            .expand((day) => day.meals)
            .firstWhere((item) => item.id == meal.id)
            .ingredients
            .map((item) => item.foodId),
        contains(steelCutOats),
      );
      expect(meal.ingredients.map((item) => item.foodId), contains(oats));
      expect(
        preview.plan!.shoppingList.map((item) => item.foodId),
        contains(steelCutOats),
      );
      expect(blockedByUnknownAllergen.status, MealPlanSwapStatus.blocked);
    },
  );
}
