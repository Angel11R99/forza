import 'nutrition_models.dart';

const nutritionNutrientCodes = <String, String>{
  'energyKcal': 'kcal',
  'proteinG': 'g',
  'fatG': 'g',
  'carbohydrateG': 'g',
  'fiberG': 'g',
  'sugarsG': 'g',
  'sodiumMg': 'mg',
  'calciumMg': 'mg',
  'ironMg': 'mg',
  'potassiumMg': 'mg',
  'vitaminCMg': 'mg',
  'vitaminARaeUg': 'µg',
  'vitaminB12Ug': 'µg',
};

class NutritionCatalogSource {
  const NutritionCatalogSource({
    required this.id,
    required this.name,
    required this.version,
    required this.license,
    required this.url,
    required this.accessedAt,
    this.citation,
  });

  final String id;
  final String name;
  final String version;
  final String license;
  final String url;
  final DateTime accessedAt;
  final String? citation;

  bool get isValid =>
      id.trim().isNotEmpty &&
      name.trim().isNotEmpty &&
      version.trim().isNotEmpty &&
      license.trim().isNotEmpty &&
      Uri.tryParse(url)?.hasAbsolutePath == true;
}

class NutritionCatalogPortion {
  const NutritionCatalogPortion({required this.label, required this.grams});

  final String label;
  final double grams;

  bool get isValid => label.trim().isNotEmpty && grams.isFinite && grams > 0;
}

enum AllergenKnowledge { unknown, reviewed }

class NutritionCatalogFood {
  const NutritionCatalogFood({
    required this.id,
    required this.sourceId,
    required this.sourceRecordId,
    required this.name,
    required this.nameEs,
    required this.preparationState,
    required this.sourcePublicationDate,
    required this.nutrientsPer100g,
    required this.nutrientDataPoints,
    required this.aliases,
    required this.allergenKnowledge,
    required this.allergens,
    required this.access,
    this.dietaryPatterns = const {},
    this.portions = const [],
  });

  final String id;
  final String sourceId;
  final int sourceRecordId;
  final String name;
  final String nameEs;
  final String preparationState;
  final String sourcePublicationDate;

  /// Map values are numeric amounts per 100 g; null explicitly means unknown.
  final Map<String, double?> nutrientsPer100g;
  final Map<String, int> nutrientDataPoints;
  final List<String> aliases;
  final AllergenKnowledge allergenKnowledge;
  final List<String> allergens;
  final Set<DietaryPattern> dietaryPatterns;
  final List<NutritionCatalogPortion> portions;
  final FoodAccess access;

  bool get isValid =>
      id.trim().isNotEmpty &&
      sourceId.trim().isNotEmpty &&
      sourceRecordId > 0 &&
      name.trim().isNotEmpty &&
      nameEs.trim().isNotEmpty &&
      preparationState.trim().isNotEmpty &&
      DateTime.tryParse(sourcePublicationDate) != null &&
      access.isValid &&
      nutrientsPer100g.keys.every(nutritionNutrientCodes.containsKey) &&
      nutritionNutrientCodes.keys.every(
        (key) =>
            nutrientsPer100g.containsKey(key) &&
            (nutrientsPer100g[key] == null ||
                (nutrientsPer100g[key]!.isFinite &&
                    nutrientsPer100g[key]! >= 0)),
      ) &&
      portions.every((portion) => portion.isValid);

  double? nutrient(String code) => nutrientsPer100g[code];

  bool matches(String query) {
    final normalized = _normalize(query);
    if (normalized.isEmpty) return true;
    return [
      name,
      nameEs,
      ...aliases,
    ].any((value) => _normalize(value).contains(normalized));
  }

  /// Unknown allergen data is never treated as safe for a restrictive profile.
  bool isEligibleForAllergySensitivePlan(Set<String> restrictedAllergens) {
    if (restrictedAllergens.isEmpty) return true;
    if (allergenKnowledge != AllergenKnowledge.reviewed) return false;
    final known = allergens.map(_normalize).toSet();
    return restrictedAllergens
        .map(_normalize)
        .every((item) => !known.contains(item));
  }
}

class NutritionCatalogRecipeIngredient {
  const NutritionCatalogRecipeIngredient({
    required this.foodId,
    required this.grams,
  });

  final String foodId;
  final double grams;

  bool get isValid => foodId.trim().isNotEmpty && grams.isFinite && grams > 0;
}

class NutritionCatalogRecipe {
  const NutritionCatalogRecipe({
    required this.id,
    required this.version,
    required this.titleEn,
    required this.titleEs,
    required this.servings,
    required this.ingredients,
    required this.stepsEn,
    required this.stepsEs,
    this.dietaryPatterns = const {},
  });

  final String id;
  final int version;
  final String titleEn;
  final String titleEs;
  final int servings;
  final List<NutritionCatalogRecipeIngredient> ingredients;
  final List<String> stepsEn;
  final List<String> stepsEs;
  final Set<DietaryPattern> dietaryPatterns;

  bool get isValid =>
      id.trim().isNotEmpty &&
      version > 0 &&
      titleEn.trim().isNotEmpty &&
      titleEs.trim().isNotEmpty &&
      servings > 0 &&
      ingredients.isNotEmpty &&
      ingredients.every((ingredient) => ingredient.isValid) &&
      stepsEn.isNotEmpty &&
      stepsEs.isNotEmpty &&
      stepsEn.every((step) => step.trim().isNotEmpty) &&
      stepsEs.every((step) => step.trim().isNotEmpty);
}

class NutritionCatalogScope {
  const NutritionCatalogScope({
    required this.nutrition,
    required this.regionalAccess,
    required this.price,
    required this.offline,
  });

  final String nutrition;
  final String regionalAccess;
  final String price;
  final bool offline;

  bool get isValid =>
      nutrition.trim().isNotEmpty &&
      regionalAccess.trim().isNotEmpty &&
      price.trim().isNotEmpty;
}

class NutritionCatalog {
  const NutritionCatalog({
    required this.version,
    required this.scope,
    required this.sources,
    required this.foods,
    required this.recipes,
  });

  final String version;
  final NutritionCatalogScope scope;
  final List<NutritionCatalogSource> sources;
  final List<NutritionCatalogFood> foods;
  final List<NutritionCatalogRecipe> recipes;

  factory NutritionCatalog.fromJson(Map<String, Object?> json) {
    final version = json['version'];
    final sourceData = json['sources'];
    final foodData = json['foods'];
    final recipeData = json['recipes'];
    final rawScope = json['scope'];
    if (version is! String ||
        sourceData is! List ||
        foodData is! List ||
        recipeData is! List ||
        rawScope is! Map) {
      throw const FormatException('El catálogo nutricional no es válido.');
    }
    final scopeJson = Map<String, Object?>.from(rawScope);
    final offline = scopeJson['offline'];
    if (offline is! bool) {
      throw const FormatException('El alcance del catálogo no es válido.');
    }
    final catalog = NutritionCatalog(
      version: version,
      scope: NutritionCatalogScope(
        nutrition: _string(scopeJson, 'nutrition'),
        regionalAccess: _string(scopeJson, 'regionalAccess'),
        price: _string(scopeJson, 'price'),
        offline: offline,
      ),
      sources: sourceData
          .map((item) {
            final map = _objectMap(item);
            final accessedAt = map['accessedAt'];
            if (accessedAt is! String ||
                DateTime.tryParse(accessedAt) == null) {
              throw const FormatException(
                'La procedencia del catálogo no es válida.',
              );
            }
            return NutritionCatalogSource(
              id: _string(map, 'id'),
              name: _string(map, 'name'),
              version: _string(map, 'version'),
              license: _string(map, 'license'),
              url: _string(map, 'url'),
              accessedAt: DateTime.parse(accessedAt),
              citation: map['citation'] as String?,
            );
          })
          .toList(growable: false),
      foods: foodData
          .map((item) {
            final map = _objectMap(item);
            final rawNutrients = _objectMap(map['nutrientsPer100g']);
            final nutrients = <String, double?>{};
            for (final entry in rawNutrients.entries) {
              final value = entry.value;
              if (value != null && value is! num) {
                throw const FormatException(
                  'Un nutriente del catálogo no es numérico.',
                );
              }
              nutrients[entry.key] = (value as num?)?.toDouble();
            }
            final rawAccess = _objectMap(map['access']);
            final accessSource = rawAccess['provenance'];
            NutritionProvenance? provenance;
            if (accessSource != null) {
              final sourceMap = _objectMap(accessSource);
              final reviewedAt = sourceMap['reviewedAt'];
              provenance = NutritionProvenance(
                source: _string(sourceMap, 'source'),
                version: _string(sourceMap, 'version'),
                sourceUrl: sourceMap['sourceUrl'] as String?,
                confidence: (sourceMap['confidence'] as num?)?.toDouble(),
                reviewedAt: reviewedAt is String
                    ? DateTime.tryParse(reviewedAt)
                    : null,
              );
            }
            final rawPortions = map['portions'];
            final rawAllergens = map['allergens'];
            final rawAliases = map['aliases'];
            if (rawPortions is! List ||
                rawAllergens is! List ||
                rawAliases is! List) {
              throw const FormatException(
                'Los metadatos del alimento no son válidos.',
              );
            }
            return NutritionCatalogFood(
              id: _string(map, 'id'),
              sourceId: _string(map, 'sourceId'),
              sourceRecordId: _int(map, 'sourceRecordId'),
              name: _string(map, 'name'),
              nameEs: _string(map, 'nameEs'),
              preparationState: _string(map, 'preparationState'),
              sourcePublicationDate: _string(map, 'sourcePublicationDate'),
              nutrientsPer100g: Map.unmodifiable(nutrients),
              nutrientDataPoints: _intMap(map['nutrientDataPoints']),
              aliases: rawAliases.whereType<String>().toList(growable: false),
              allergenKnowledge: AllergenKnowledge.values.firstWhere(
                (value) => value.name == map['allergenKnowledge'],
                orElse: () => AllergenKnowledge.unknown,
              ),
              allergens: rawAllergens.whereType<String>().toList(
                growable: false,
              ),
              dietaryPatterns: _dietaryPatterns(map['dietaryPatterns']),
              portions: rawPortions
                  .map((portion) {
                    final portionMap = _objectMap(portion);
                    return NutritionCatalogPortion(
                      label: _string(portionMap, 'label'),
                      grams: _number(portionMap, 'grams'),
                    );
                  })
                  .toList(growable: false),
              access: FoodAccess(
                availability: FoodAvailability.values.firstWhere(
                  (value) => value.name == rawAccess['availability'],
                  orElse: () => FoodAvailability.unknown,
                ),
                relativeCost: RelativeFoodCost.values.firstWhere(
                  (value) => value.name == rawAccess['relativeCost'],
                  orElse: () => RelativeFoodCost.unknown,
                ),
                season: rawAccess['season'] as String?,
                provenance: provenance,
              ),
            );
          })
          .toList(growable: false),
      recipes: recipeData
          .map((item) {
            final map = _objectMap(item);
            final rawIngredients = map['ingredients'];
            final rawStepsEn = map['stepsEn'];
            final rawStepsEs = map['stepsEs'];
            if (rawIngredients is! List ||
                rawStepsEn is! List ||
                rawStepsEs is! List) {
              throw const FormatException(
                'La receta del catálogo no es válida.',
              );
            }
            return NutritionCatalogRecipe(
              id: _string(map, 'id'),
              version: _int(map, 'version'),
              titleEn: _string(map, 'titleEn'),
              titleEs: _string(map, 'titleEs'),
              servings: _int(map, 'servings'),
              ingredients: rawIngredients
                  .map((ingredient) {
                    final ingredientMap = _objectMap(ingredient);
                    return NutritionCatalogRecipeIngredient(
                      foodId: _string(ingredientMap, 'foodId'),
                      grams: _number(ingredientMap, 'grams'),
                    );
                  })
                  .toList(growable: false),
              stepsEn: rawStepsEn.whereType<String>().toList(growable: false),
              stepsEs: rawStepsEs.whereType<String>().toList(growable: false),
              dietaryPatterns: _dietaryPatterns(map['dietaryPatterns']),
            );
          })
          .toList(growable: false),
    );
    if (!catalog.isValid) {
      throw const FormatException(
        'El catálogo contiene datos incompletos o repetidos.',
      );
    }
    return catalog;
  }

  bool get isValid {
    final foodIds = foods.map((food) => food.id).toSet();
    final recordIds = foods.map((food) => food.sourceRecordId).toSet();
    final sourceIds = sources.map((source) => source.id).toSet();
    return version.trim().isNotEmpty &&
        scope.isValid &&
        sources.isNotEmpty &&
        foods.isNotEmpty &&
        sources.every((source) => source.isValid) &&
        sourceIds.length == sources.length &&
        foodIds.length == foods.length &&
        recordIds.length == foods.length &&
        foods.every(
          (food) => food.isValid && sourceIds.contains(food.sourceId),
        ) &&
        recipes.map((recipe) => recipe.id).toSet().length == recipes.length &&
        recipes.every(
          (recipe) =>
              recipe.isValid &&
              recipe.ingredients.every(
                (ingredient) => foodIds.contains(ingredient.foodId),
              ),
        );
  }

  List<NutritionCatalogFood> search(String query) =>
      List.unmodifiable(foods.where((food) => food.matches(query)));
}

Set<DietaryPattern> _dietaryPatterns(Object? value) {
  if (value == null) return const {};
  if (value is! List || value.any((item) => item is! String)) {
    throw const FormatException('Los patrones de la receta no son válidos.');
  }
  return Set.unmodifiable(
    value.map(
      (name) => DietaryPattern.values.firstWhere(
        (pattern) => pattern.name == name,
        orElse: () => throw const FormatException(
          'Un patrón de la receta no es compatible.',
        ),
      ),
    ),
  );
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

Map<String, Object?> _objectMap(Object? value) {
  if (value is! Map) throw const FormatException('Se esperaba un objeto.');
  return Map<String, Object?>.from(value);
}

Map<String, int> _intMap(Object? value) {
  if (value == null) return const {};
  final map = _objectMap(value);
  if (map.values.any((item) => item is! int)) {
    throw const FormatException('La cantidad de observaciones no es válida.');
  }
  return map.map((key, item) => MapEntry(key, item as int));
}

String _string(Map<String, Object?> map, String key) {
  final value = map[key];
  if (value is! String) {
    throw const FormatException('Un texto del catálogo no es válido.');
  }
  return value;
}

int _int(Map<String, Object?> map, String key) {
  final value = map[key];
  if (value is! int) {
    throw const FormatException('Un identificador no es válido.');
  }
  return value;
}

double _number(Map<String, Object?> map, String key) {
  final value = map[key];
  if (value is! num) throw const FormatException('Una cantidad no es válida.');
  return value.toDouble();
}
