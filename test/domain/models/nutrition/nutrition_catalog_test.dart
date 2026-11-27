import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forza/domain/models/nutrition/nutrition_catalog.dart';
import 'package:forza/domain/models/nutrition/nutrition_models.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'bundled USDA snapshot is valid, attributed, and explicit about gaps',
    () async {
      final text = await rootBundle.loadString(
        'assets/data/nutrition_catalog.json',
      );
      final json = jsonDecode(text) as Map<String, Object?>;
      final catalog = NutritionCatalog.fromJson(json);

      expect(catalog.isValid, isTrue);
      expect(catalog.foods.length, 31);
      expect(catalog.recipes.length, 11);
      expect(catalog.scope.offline, isTrue);
      expect(catalog.scope.regionalAccess, contains('unknown'));
      expect(catalog.sources.first.license, 'CC0 1.0');
      expect(catalog.sources.first.version, contains('2026-10-29'));
      expect(
        catalog.foods.every(
          (food) => nutritionNutrientCodes.keys.every(
            food.nutrientsPer100g.containsKey,
          ),
        ),
        isTrue,
      );
      expect(
        catalog.foods.every(
          (food) =>
              food.access.availability == FoodAvailability.unknown &&
              food.access.relativeCost == RelativeFoodCost.unknown &&
              food.allergenKnowledge == AllergenKnowledge.unknown,
        ),
        isTrue,
      );
    },
  );

  test('search matches Spanish aliases without accent sensitivity', () async {
    final catalog = await _loadCatalog();

    expect(catalog.search('chicharos').single.nameEs, contains('Garbanzos'));
    expect(
      catalog.search('HABICHUELAS NEGRAS').length,
      greaterThanOrEqualTo(2),
    );
    expect(catalog.search('no existe'), isEmpty);
  });

  test('unknown allergens cannot pass a restricted food filter', () async {
    final catalog = await _loadCatalog();
    final peanut = catalog.foods.singleWhere(
      (food) => food.sourceRecordId == 2515376,
    );
    final oats = catalog.foods.singleWhere(
      (food) => food.sourceRecordId == 2346396,
    );

    expect(peanut.isEligibleForAllergySensitivePlan({'peanut'}), isFalse);
    expect(oats.isEligibleForAllergySensitivePlan({'peanut'}), isFalse);
    expect(oats.isEligibleForAllergySensitivePlan(const {}), isTrue);
  });
}

Future<NutritionCatalog> _loadCatalog() async {
  final text = await rootBundle.loadString(
    'assets/data/nutrition_catalog.json',
  );
  return NutritionCatalog.fromJson(jsonDecode(text) as Map<String, Object?>);
}
