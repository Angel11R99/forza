import '../models/nutrition/nutrition_catalog.dart';
import '../models/nutrition/nutrition_models.dart';

enum MealPlanGenerationStatus { generated, noSafeRecipes, invalidConfiguration }

enum MealPlanSwapStatus { previewReady, blocked, notEquivalent }

class PlannedMeal {
  const PlannedMeal({
    required this.id,
    required this.recipeId,
    required this.titleEn,
    required this.titleEs,
    required this.servings,
    required this.ingredients,
    required this.nutrients,
  });

  final String id;
  final String recipeId;
  final String titleEn;
  final String titleEs;
  final double servings;
  final List<PlannedIngredient> ingredients;

  /// Null nutrient values mean at least one source ingredient lacks that data.
  final Map<String, double?> nutrients;
}

class PlannedIngredient {
  const PlannedIngredient({required this.foodId, required this.grams});

  final String foodId;
  final double grams;
}

class MealPlanDay {
  const MealPlanDay({
    required this.date,
    required this.isTrainingDay,
    required this.meals,
  });

  final DateTime date;
  final bool isTrainingDay;
  final List<PlannedMeal> meals;
}

class ShoppingListItem {
  const ShoppingListItem({required this.foodId, required this.grams});

  final String foodId;
  final double grams;
}

class NutritionWeekPlan {
  const NutritionWeekPlan({
    required this.id,
    required this.version,
    required this.createdAt,
    required this.profileVersion,
    required this.catalogVersion,
    required this.days,
    required this.shoppingList,
  });

  final String id;
  final int version;
  final DateTime createdAt;
  final int profileVersion;
  final String catalogVersion;
  final List<MealPlanDay> days;
  final List<ShoppingListItem> shoppingList;
}

class MealPlanGenerationResult {
  const MealPlanGenerationResult(this.status, {this.plan});

  final MealPlanGenerationStatus status;
  final NutritionWeekPlan? plan;
}

class MealPlanSwapPreview {
  const MealPlanSwapPreview(this.status, {this.plan});

  final MealPlanSwapStatus status;
  final NutritionWeekPlan? plan;
}

/// Deterministic offline planner over the locally curated catalog.
/// It never loosens restrictions or invents allergy/access/cost metadata.
class NutritionWeekPlanner {
  const NutritionWeekPlanner();

  /// Keeps prior days intact when a user regenerates the remaining week.
  /// Returns null when the two plans are not the same seven-day plan.
  NutritionWeekPlan? regenerateFutureDays({
    required NutritionWeekPlan existing,
    required NutritionWeekPlan regenerated,
    required DateTime fromDate,
    required DateTime createdAt,
  }) {
    if (existing.id != regenerated.id ||
        existing.days.length != 7 ||
        regenerated.days.length != 7 ||
        !List.generate(
          7,
          (index) => existing.days[index].date == regenerated.days[index].date,
        ).every((matches) => matches)) {
      return null;
    }
    final cutoff = DateTime(fromDate.year, fromDate.month, fromDate.day);
    final days = List<MealPlanDay>.generate(7, (index) {
      final oldDay = existing.days[index];
      return oldDay.date.isBefore(cutoff) ? oldDay : regenerated.days[index];
    }, growable: false);
    return NutritionWeekPlan(
      id: existing.id,
      version: existing.version + 1,
      createdAt: createdAt.toUtc(),
      profileVersion: regenerated.profileVersion,
      catalogVersion: regenerated.catalogVersion,
      days: List.unmodifiable(days),
      shoppingList: _shoppingList(days),
    );
  }

  MealPlanSwapPreview previewIngredientSwap({
    required NutritionWeekPlan plan,
    required String mealId,
    required String currentFoodId,
    required String replacementFoodId,
    required NutritionCatalog catalog,
    required NutritionProfile profile,
  }) {
    MealPlanDay? selectedDay;
    PlannedMeal? selectedMeal;
    for (final day in plan.days) {
      for (final meal in day.meals) {
        if (meal.id == mealId) {
          selectedDay = day;
          selectedMeal = meal;
          break;
        }
      }
      if (selectedMeal != null) break;
    }
    if (selectedDay == null || selectedMeal == null) {
      return const MealPlanSwapPreview(MealPlanSwapStatus.blocked);
    }
    final index = selectedMeal.ingredients.indexWhere(
      (ingredient) => ingredient.foodId == currentFoodId,
    );
    if (index == -1) {
      return const MealPlanSwapPreview(MealPlanSwapStatus.blocked);
    }
    final currentFood = _findFood(catalog, currentFoodId);
    final replacement = _findFood(catalog, replacementFoodId);
    if (currentFood == null ||
        replacement == null ||
        !_foodAllowed(replacement, profile)) {
      return const MealPlanSwapPreview(MealPlanSwapStatus.blocked);
    }
    if (!_isEquivalentFood(currentFood, replacement)) {
      return const MealPlanSwapPreview(MealPlanSwapStatus.notEquivalent);
    }

    final ingredients = [...selectedMeal.ingredients];
    ingredients[index] = PlannedIngredient(
      foodId: replacement.id,
      grams: ingredients[index].grams,
    );
    final meal = PlannedMeal(
      id: selectedMeal.id,
      recipeId: selectedMeal.recipeId,
      titleEn: selectedMeal.titleEn,
      titleEs: selectedMeal.titleEs,
      servings: selectedMeal.servings,
      ingredients: List.unmodifiable(ingredients),
      nutrients: _nutrientTotalsForIngredients(ingredients, catalog),
    );
    final days = plan.days
        .map(
          (day) => day.date == selectedDay!.date
              ? MealPlanDay(
                  date: day.date,
                  isTrainingDay: day.isTrainingDay,
                  meals: List.unmodifiable(
                    day.meals
                        .map((old) => old.id == meal.id ? meal : old)
                        .toList(),
                  ),
                )
              : day,
        )
        .toList(growable: false);
    return MealPlanSwapPreview(
      MealPlanSwapStatus.previewReady,
      plan: NutritionWeekPlan(
        id: plan.id,
        version: plan.version,
        createdAt: plan.createdAt,
        profileVersion: plan.profileVersion,
        catalogVersion: plan.catalogVersion,
        days: List.unmodifiable(days),
        shoppingList: _shoppingList(days),
      ),
    );
  }

  MealPlanGenerationResult generate({
    required NutritionCatalog catalog,
    required NutritionProfile profile,
    required DateTime weekStart,
    required DateTime createdAt,
    required String planId,
    required Set<int> trainingWeekdays,
    List<NutritionCatalogRecipe> pinnedRecipes = const [],
    int? mealsPerDay,
  }) {
    final count = mealsPerDay ?? profile.mealsPerDay ?? 3;
    if (!catalog.isValid ||
        !profile.isValid ||
        planId.trim().isEmpty ||
        count < 1 ||
        count > 10 ||
        trainingWeekdays.any((day) => day < 1 || day > 7)) {
      return const MealPlanGenerationResult(
        MealPlanGenerationStatus.invalidConfiguration,
      );
    }

    final safePinned =
        pinnedRecipes
            .where(
              (recipe) => isRecipeAllowedForProfile(
                recipe: recipe,
                catalog: catalog,
                profile: profile,
              ),
            )
            .toList()
          ..sort((a, b) => a.id.compareTo(b.id));
    final pinnedIds = safePinned.map((recipe) => recipe.id).toSet();
    final candidates =
        catalog.recipes
            .where(
              (recipe) =>
                  !pinnedIds.contains(recipe.id) &&
                  _recipeAllowed(recipe, catalog, profile),
            )
            .toList()
          ..sort((a, b) => a.id.compareTo(b.id));
    if (candidates.isEmpty && safePinned.isNotEmpty) {
      candidates.addAll(safePinned);
    }
    if (candidates.isEmpty) {
      return const MealPlanGenerationResult(
        MealPlanGenerationStatus.noSafeRecipes,
      );
    }

    final firstDay = DateTime(weekStart.year, weekStart.month, weekStart.day);
    final days = <MealPlanDay>[];
    for (var dayIndex = 0; dayIndex < 7; dayIndex++) {
      final date = firstDay.add(Duration(days: dayIndex));
      final meals = <PlannedMeal>[];
      for (var slot = 0; slot < count; slot++) {
        // Rotate through sorted candidates. Repeats occur only when the
        // compatible recipe set is smaller than the requested meal count.
        final recipe = slot == 0 && safePinned.isNotEmpty
            ? safePinned[dayIndex % safePinned.length]
            : candidates[(dayIndex * count + slot) % candidates.length];
        final ingredients = recipe.ingredients
            .map(
              (ingredient) => PlannedIngredient(
                foodId: ingredient.foodId,
                grams: ingredient.grams,
              ),
            )
            .toList(growable: false);
        meals.add(
          PlannedMeal(
            id: '$planId-${date.toIso8601String().substring(0, 10)}-$slot',
            recipeId: recipe.id,
            titleEn: recipe.titleEn,
            titleEs: recipe.titleEs,
            servings: 1,
            ingredients: ingredients,
            nutrients: _nutrientTotals(recipe, catalog),
          ),
        );
      }
      days.add(
        MealPlanDay(
          date: date,
          isTrainingDay: trainingWeekdays.contains(date.weekday),
          meals: List.unmodifiable(meals),
        ),
      );
    }

    final plan = NutritionWeekPlan(
      id: planId,
      version: 1,
      createdAt: createdAt.toUtc(),
      profileVersion: profile.version,
      catalogVersion: catalog.version,
      days: List.unmodifiable(days),
      shoppingList: _shoppingList(days),
    );
    return MealPlanGenerationResult(
      MealPlanGenerationStatus.generated,
      plan: plan,
    );
  }

  bool _recipeAllowed(
    NutritionCatalogRecipe recipe,
    NutritionCatalog catalog,
    NutritionProfile profile,
  ) {
    if (profile.dietaryPattern != DietaryPattern.unrestricted &&
        !recipe.dietaryPatterns.contains(profile.dietaryPattern)) {
      return false;
    }
    final foods = recipe.ingredients
        .map(
          (ingredient) =>
              catalog.foods.firstWhere((food) => food.id == ingredient.foodId),
        )
        .toList(growable: false);
    final restrictedAllergens = profile.restrictions
        .where(
          (restriction) =>
              restriction.type == FoodRestrictionType.allergy ||
              restriction.type == FoodRestrictionType.intolerance,
        )
        .map((restriction) => restriction.value)
        .toSet();
    if (restrictedAllergens.isNotEmpty &&
        foods.any(
          (food) =>
              !food.isEligibleForAllergySensitivePlan(restrictedAllergens),
        )) {
      return false;
    }
    for (final restriction in profile.restrictions.where(
      (item) => item.type == FoodRestrictionType.excluded,
    )) {
      final query = _normalize(restriction.value);
      if (foods.any(
        (food) => [
          food.id,
          food.name,
          food.nameEs,
          ...food.aliases,
        ].any((value) => _normalize(value).contains(query)),
      )) {
        return false;
      }
    }
    return !foods.any((food) => profile.unavailableFoodIds.contains(food.id));
  }

  /// Exposes the planner's conservative eligibility check to recipe pinning.
  bool isRecipeAllowedForProfile({
    required NutritionCatalogRecipe recipe,
    required NutritionCatalog catalog,
    required NutritionProfile profile,
  }) =>
      catalog.isValid &&
      profile.isValid &&
      recipe.ingredients.every(
        (ingredient) =>
            catalog.foods.any((food) => food.id == ingredient.foodId),
      ) &&
      _recipeAllowed(recipe, catalog, profile);

  bool _foodAllowed(NutritionCatalogFood food, NutritionProfile profile) {
    if (profile.dietaryPattern != DietaryPattern.unrestricted &&
        !food.dietaryPatterns.contains(profile.dietaryPattern)) {
      return false;
    }
    if (profile.unavailableFoodIds.contains(food.id)) return false;
    final allergens = profile.restrictions
        .where(
          (item) =>
              item.type == FoodRestrictionType.allergy ||
              item.type == FoodRestrictionType.intolerance,
        )
        .map((item) => item.value)
        .toSet();
    if (!food.isEligibleForAllergySensitivePlan(allergens)) return false;
    for (final restriction in profile.restrictions.where(
      (item) => item.type == FoodRestrictionType.excluded,
    )) {
      final needle = _normalize(restriction.value);
      if ([
        food.id,
        food.name,
        food.nameEs,
        ...food.aliases,
      ].any((value) => _normalize(value).contains(needle))) {
        return false;
      }
    }
    return true;
  }

  bool _isEquivalentFood(
    NutritionCatalogFood first,
    NutritionCatalogFood second,
  ) {
    var comparedNutrients = 0;
    for (final key in const ['energyKcal', 'proteinG', 'carbohydrateG']) {
      final a = first.nutrient(key);
      final b = second.nutrient(key);
      if (a == null && b == null) continue;
      if (a == null || b == null) return false;
      if (a == 0 || b == 0) {
        if (a != b) return false;
      } else if ((a - b).abs() / a > 0.2) {
        return false;
      }
      comparedNutrients++;
    }
    return comparedNutrients >= 2;
  }

  NutritionCatalogFood? _findFood(NutritionCatalog catalog, String id) {
    for (final food in catalog.foods) {
      if (food.id == id) return food;
    }
    return null;
  }

  Map<String, double?> _nutrientTotalsForIngredients(
    List<PlannedIngredient> ingredients,
    NutritionCatalog catalog,
  ) {
    final totals = <String, double?>{};
    for (final key in nutritionNutrientCodes.keys) {
      var sum = 0.0;
      var known = true;
      for (final ingredient in ingredients) {
        final food = _findFood(catalog, ingredient.foodId);
        final amount = food?.nutrient(key);
        if (amount == null) {
          known = false;
          break;
        }
        sum += amount * ingredient.grams / 100;
      }
      totals[key] = known ? sum : null;
    }
    return Map.unmodifiable(totals);
  }

  Map<String, double?> _nutrientTotals(
    NutritionCatalogRecipe recipe,
    NutritionCatalog catalog,
  ) {
    final result = <String, double?>{};
    for (final nutrient in nutritionNutrientCodes.keys) {
      var total = 0.0;
      var complete = true;
      for (final ingredient in recipe.ingredients) {
        final food = catalog.foods.firstWhere(
          (item) => item.id == ingredient.foodId,
        );
        final value = food.nutrient(nutrient);
        if (value == null) {
          complete = false;
          break;
        }
        total += value * ingredient.grams / 100;
      }
      result[nutrient] = complete ? total : null;
    }
    return Map.unmodifiable(result);
  }

  List<ShoppingListItem> _shoppingList(List<MealPlanDay> days) {
    final totals = <String, double>{};
    for (final meal in days.expand((day) => day.meals)) {
      for (final ingredient in meal.ingredients) {
        totals.update(
          ingredient.foodId,
          (grams) => grams + ingredient.grams,
          ifAbsent: () => ingredient.grams,
        );
      }
    }
    final items =
        totals.entries
            .map(
              (entry) =>
                  ShoppingListItem(foodId: entry.key, grams: entry.value),
            )
            .toList()
          ..sort((a, b) => a.foodId.compareTo(b.foodId));
    return List.unmodifiable(items);
  }
}

String _normalize(String value) => value
    .trim()
    .toLowerCase()
    .replaceAll('á', 'a')
    .replaceAll('é', 'e')
    .replaceAll('í', 'i')
    .replaceAll('ó', 'o')
    .replaceAll('ú', 'u')
    .replaceAll('ü', 'u')
    .replaceAll('ñ', 'n');
