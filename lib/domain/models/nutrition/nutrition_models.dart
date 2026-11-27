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

enum BodyType { ectomorph, mesomorph, endomorph, mixed, unknown }

enum FoodRestrictionType { allergy, intolerance, preference, excluded }

class NutritionProfile {
  const NutritionProfile({
    required this.id,
    required this.version,
    required this.updatedAt,
    this.goal,
    this.ageYears,
    this.heightCm,
    this.bodyType = BodyType.unknown,
    this.countryCode,
    this.region,
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
  final int? ageYears;
  final double? heightCm;
  final BodyType bodyType;
  final String? countryCode;
  final String? region;
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
      (ageYears == null || (ageYears! >= 13 && ageYears! <= 120)) &&
      (heightCm == null ||
          (heightCm!.isFinite && heightCm! >= 100 && heightCm! <= 250)) &&
      (kitchenMinutes == null || kitchenMinutes! >= 0) &&
      (countryCode == null ||
          RegExp(r'^[A-Za-z]{2}$').hasMatch(countryCode!)) &&
      (region == null || region!.trim().length <= 100);

  Map<String, Object?> toJson() => {
    'id': id,
    'version': version,
    'updatedAt': updatedAt.toUtc().toIso8601String(),
    'goal': goal?.name,
    'ageYears': ageYears,
    'heightCm': heightCm,
    'bodyType': bodyType.name,
    'countryCode': countryCode,
    'region': region,
    'mealsPerDay': mealsPerDay,
    'dietaryPattern': dietaryPattern.name,
    'restrictions': restrictions
        .map((item) => {'type': item.type.name, 'value': item.value})
        .toList(),
    'unavailableFoodIds': unavailableFoodIds,
    'kitchenMinutes': kitchenMinutes,
    'budget': budget.name,
  };

  factory NutritionProfile.fromJson(Map<String, Object?> json) {
    T? enumValue<T extends Enum>(List<T> values, Object? value) {
      if (value is! String) return null;
      for (final item in values) {
        if (item.name == value) return item;
      }
      return null;
    }

    final updatedAt = json['updatedAt'];
    final rawRestrictions = json['restrictions'];
    final rawUnavailable = json['unavailableFoodIds'];
    if (updatedAt is! String ||
        rawRestrictions is! List ||
        (rawUnavailable != null && rawUnavailable is! List)) {
      throw const FormatException('El perfil nutricional no es válido.');
    }
    final restrictions = <FoodRestriction>[];
    for (final raw in rawRestrictions) {
      if (raw is! Map) throw const FormatException('Restricción no válida.');
      final item = Map<String, Object?>.from(raw);
      final type = enumValue(FoodRestrictionType.values, item['type']);
      final value = item['value'];
      if (type == null || value is! String) {
        throw const FormatException('Restricción no válida.');
      }
      restrictions.add(FoodRestriction(type: type, value: value));
    }
    final date = DateTime.tryParse(updatedAt);
    final id = json['id'];
    final version = json['version'];
    final region = json['region'];
    final height = json['heightCm'];
    final age = json['ageYears'];
    final meals = json['mealsPerDay'];
    final kitchen = json['kitchenMinutes'];
    final unavailable = rawUnavailable == null
        ? const <String>[]
        : (rawUnavailable as List).whereType<String>().toList(growable: false);
    final profile = NutritionProfile(
      id: id is String ? id : '',
      version: version is int ? version : 0,
      updatedAt: date ?? DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      goal: enumValue(NutritionGoal.values, json['goal']),
      ageYears: age is int ? age : null,
      heightCm: height is num ? height.toDouble() : null,
      bodyType:
          enumValue(BodyType.values, json['bodyType']) ?? BodyType.unknown,
      countryCode: json['countryCode'] as String?,
      region: region is String ? region : null,
      mealsPerDay: meals is int ? meals : null,
      dietaryPattern:
          enumValue(DietaryPattern.values, json['dietaryPattern']) ??
          DietaryPattern.unrestricted,
      restrictions: List.unmodifiable(restrictions),
      unavailableFoodIds: List.unmodifiable(unavailable),
      kitchenMinutes: kitchen is int ? kitchen : null,
      budget:
          enumValue(RelativeFoodCost.values, json['budget']) ??
          RelativeFoodCost.moderate,
    );
    if (date == null || !profile.isValid) {
      throw const FormatException('El perfil nutricional no es válido.');
    }
    return profile;
  }
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
    this.type = MealEntryType.manual,
    this.plannedMealId,
    this.quantityGrams,
    this.nutrientEstimates = const {},
    this.catalogVersion,
  });

  final String id;
  final DateTime dateTime;
  final String? recipeId;
  final String? foodId;
  final double servings;
  final String? notes;
  final MealEntryType type;
  final String? plannedMealId;
  final double? quantityGrams;
  final Map<String, double?> nutrientEstimates;
  final String? catalogVersion;

  Map<String, Object?> toJson() => {
    'id': id,
    'dateTime': dateTime.toIso8601String(),
    'recipeId': recipeId,
    'foodId': foodId,
    'servings': servings,
    'notes': notes,
    'type': type.name,
    'plannedMealId': plannedMealId,
    'quantityGrams': quantityGrams,
    'nutrientEstimates': nutrientEstimates,
    'catalogVersion': catalogVersion,
  };

  factory MealEntry.fromJson(Map<String, Object?> json) {
    final dateText = json['dateTime'];
    final date = dateText is String ? DateTime.tryParse(dateText) : null;
    final id = json['id'];
    final typeText = json['type'];
    final type = typeText == null
        ? MealEntryType.manual
        : MealEntryType.values
              .where((value) => value.name == typeText)
              .firstOrNull;
    final nutrients = json['nutrientEstimates'];
    if (id is! String ||
        date == null ||
        type == null ||
        (nutrients != null && nutrients is! Map)) {
      throw const FormatException('El registro de comida no es válido.');
    }
    final estimates = <String, double?>{};
    if (nutrients is Map) {
      for (final entry in nutrients.entries) {
        final value = entry.value;
        if (entry.key is! String || (value != null && value is! num)) {
          throw const FormatException(
            'La estimación del registro no es válida.',
          );
        }
        estimates[entry.key as String] = (value as num?)?.toDouble();
      }
    }
    final servings = json['servings'];
    final quantity = json['quantityGrams'];
    final item = MealEntry(
      id: id,
      dateTime: date,
      recipeId: json['recipeId'] as String?,
      foodId: json['foodId'] as String?,
      servings: servings is num ? servings.toDouble() : 1,
      notes: json['notes'] as String?,
      type: type,
      plannedMealId: json['plannedMealId'] as String?,
      quantityGrams: quantity is num ? quantity.toDouble() : null,
      nutrientEstimates: Map.unmodifiable(estimates),
      catalogVersion: json['catalogVersion'] as String?,
    );
    if (!item.isValid) {
      throw const FormatException('El registro de comida no es válido.');
    }
    return item;
  }

  bool get isValid =>
      id.trim().isNotEmpty &&
      (recipeId?.trim().isNotEmpty == true ||
          foodId?.trim().isNotEmpty == true) &&
      servings.isFinite &&
      servings > 0 &&
      (plannedMealId == null || plannedMealId!.trim().isNotEmpty) &&
      (quantityGrams == null ||
          (quantityGrams!.isFinite && quantityGrams! > 0)) &&
      (type != MealEntryType.consumedPlanned ||
          (plannedMealId?.trim().isNotEmpty == true &&
              recipeId?.trim().isNotEmpty == true)) &&
      nutrientEstimates.values.every(
        (value) => value == null || (value.isFinite && value >= 0),
      );
}

enum MealEntryType { planned, consumedPlanned, manual, imported }

class FoodRestriction {
  const FoodRestriction({required this.type, required this.value});

  final FoodRestrictionType type;
  final String value;

  bool get isValid => value.trim().isNotEmpty;
}
