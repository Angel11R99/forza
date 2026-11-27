/// Framework-independent contracts for the local-first nutrition domain.
///
/// These models describe user data and curated catalog data. They deliberately
/// do not calculate calorie or macronutrient prescriptions.
enum NutritionGoal {
  generalWellbeing,
  supportTraining,
  gainWeight,
  loseWeight,
  maintainWeight,
}

enum FoodAvailability { unknown, commonlyAvailable, seasonal, hardToFind }

enum RelativeFoodCost { unknown, low, moderate, high }

enum DietaryPattern { unrestricted, vegetarian, vegan, pescatarian }

enum FoodRestrictionType { allergy, intolerance, preference, excluded }

class NutritionProfile {
  const NutritionProfile({
    required this.id,
    required this.version,
    required this.updatedAt,
    this.goal,
    this.countryCode,
    this.mealsPerDay,
    this.dietaryPattern = DietaryPattern.unrestricted,
    this.restrictions = const [],
    this.unavailableFoodIds = const [],
    this.kitchenMinutes,
    this.budget = RelativeFoodCost.moderate,
  });

  final String id;
  final int version;
  final DateTime updatedAt;
  final NutritionGoal? goal;
  final String? countryCode;
  final int? mealsPerDay;
  final DietaryPattern dietaryPattern;
  final List<FoodRestriction> restrictions;
  final List<String> unavailableFoodIds;
  final int? kitchenMinutes;
  final RelativeFoodCost budget;

  bool get isValid =>
      id.trim().isNotEmpty &&
      version > 0 &&
      (mealsPerDay == null || (mealsPerDay! >= 1 && mealsPerDay! <= 10)) &&
      (kitchenMinutes == null || kitchenMinutes! >= 0) &&
      (countryCode == null || RegExp(r'^[A-Za-z]{2}$').hasMatch(countryCode!));
}

class NutritionProvenance {
  const NutritionProvenance({
    required this.source,
    required this.version,
    this.sourceUrl,
    this.confidence,
    this.reviewedAt,
  });

  final String source;
  final String version;
  final String? sourceUrl;

  /// A source's confidence rating, when available; null means unknown.
  final double? confidence;
  final DateTime? reviewedAt;

  bool get isValid =>
      source.trim().isNotEmpty &&
      version.trim().isNotEmpty &&
      (confidence == null ||
          (confidence!.isFinite && confidence! >= 0 && confidence! <= 1));
}

class FoodAccess {
  const FoodAccess({
    this.availability = FoodAvailability.unknown,
    this.relativeCost = RelativeFoodCost.unknown,
    this.season,
    this.provenance,
  });

  final FoodAvailability availability;
  final RelativeFoodCost relativeCost;
  final String? season;
  final NutritionProvenance? provenance;

  bool get isValid => provenance?.isValid ?? true;
}

class Food {
  const Food({
    required this.id,
    required this.name,
    required this.catalogVersion,
    required this.provenance,
    this.access = const FoodAccess(),
    this.allergens = const [],
    this.dietaryPatterns = const {},
  });

  final String id;
  final String name;
  final String catalogVersion;
  final NutritionProvenance provenance;
  final FoodAccess access;
  final List<String> allergens;
  final Set<DietaryPattern> dietaryPatterns;

  bool get isValid =>
      id.trim().isNotEmpty &&
      name.trim().isNotEmpty &&
      catalogVersion.trim().isNotEmpty &&
      provenance.isValid &&
      access.isValid;
}

class Ingredient {
  const Ingredient({
    required this.foodId,
    required this.amount,
    required this.unit,
    this.optional = false,
  });

  final String foodId;
  final double amount;
  final String unit;
  final bool optional;

  bool get isValid =>
      foodId.trim().isNotEmpty &&
      amount.isFinite &&
      amount > 0 &&
      unit.trim().isNotEmpty;
}

class Recipe {
  const Recipe({
    required this.id,
    required this.title,
    required this.version,
    required this.ingredients,
    required this.provenance,
    this.servings = 1,
    this.preparationMinutes,
    this.instructions = const [],
  });

  final String id;
  final String title;
  final int version;
  final List<Ingredient> ingredients;
  final NutritionProvenance provenance;
  final int servings;
  final int? preparationMinutes;
  final List<String> instructions;

  bool get isValid =>
      id.trim().isNotEmpty &&
      title.trim().isNotEmpty &&
      version > 0 &&
      servings > 0 &&
      ingredients.isNotEmpty &&
      ingredients.every((item) => item.isValid) &&
      (preparationMinutes == null || preparationMinutes! >= 0) &&
      provenance.isValid;
}

/// Quantitative targets are accepted only from a professionally reviewed,
/// versioned source. Null values represent unspecified targets.
class NutritionTargets {
  const NutritionTargets({
    required this.id,
    required this.version,
    required this.effectiveAt,
    required this.provenance,
    this.energyKcal,
    this.proteinGrams,
    this.carbohydrateGrams,
    this.fatGrams,
  });

  final String id;
  final int version;
  final DateTime effectiveAt;
  final NutritionProvenance provenance;
  final double? energyKcal;
  final double? proteinGrams;
  final double? carbohydrateGrams;
  final double? fatGrams;

  bool get isValid =>
      id.trim().isNotEmpty &&
      version > 0 &&
      provenance.isValid &&
      [
        energyKcal,
        proteinGrams,
        carbohydrateGrams,
        fatGrams,
      ].whereType<double>().every((value) => value.isFinite && value >= 0);
}

class MealPlan {
  const MealPlan({
    required this.id,
    required this.version,
    required this.createdAt,
    required this.entries,
    this.targetsId,
    this.profileVersion,
    this.catalogVersion,
  });

  final String id;
  final int version;
  final DateTime createdAt;
  final List<MealEntry> entries;
  final String? targetsId;
  final int? profileVersion;
  final String? catalogVersion;

  bool get isValid =>
      id.trim().isNotEmpty &&
      version > 0 &&
      (profileVersion == null || profileVersion! > 0) &&
      entries.every((entry) => entry.isValid);
}

class MealEntry {
  const MealEntry({
    required this.id,
    required this.dateTime,
    this.recipeId,
    this.foodId,
    this.servings = 1,
    this.notes,
  });

  final String id;
  final DateTime dateTime;
  final String? recipeId;
  final String? foodId;
  final double servings;
  final String? notes;

  bool get isValid =>
      id.trim().isNotEmpty &&
      (recipeId?.trim().isNotEmpty == true ||
          foodId?.trim().isNotEmpty == true) &&
      servings.isFinite &&
      servings > 0;
}

class FoodRestriction {
  const FoodRestriction({required this.type, required this.value});

  final FoodRestrictionType type;
  final String value;

  bool get isValid => value.trim().isNotEmpty;
}
