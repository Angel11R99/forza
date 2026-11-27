import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:forza/data/repositories/nutrition_meal_log_repository.dart';
import 'package:forza/data/database/app_database.dart';
import 'package:forza/domain/models/nutrition/nutrition_models.dart';

void main() {
  test('stores local entries offline, updates by id, and deletes without duplicates', () async {
    final storage = _MemoryStorage();
    final firstRepository = NutritionMealLogRepository(storage: storage);
    final entry = MealEntry(
      id: 'consumed:planned-1',
      dateTime: DateTime(2026, 11, 27, 9),
      recipeId: 'breakfast',
      type: MealEntryType.consumedPlanned,
      plannedMealId: 'planned-1',
      nutrientEstimates: const {'energyKcal': null, 'proteinG': 12},
    );
    await firstRepository.save(entry);
    await firstRepository.save(entry);

    final relaunchedRepository = NutritionMealLogRepository(storage: storage);
    final restored = await relaunchedRepository.loadAll();
    expect(restored, hasLength(1));
    expect(restored.single.type, MealEntryType.consumedPlanned);
    expect(restored.single.nutrientEstimates['energyKcal'], isNull);
    expect(restored.single.nutrientEstimates['proteinG'], 12);

    final updated = MealEntry(
      id: entry.id,
      dateTime: entry.dateTime,
      recipeId: entry.recipeId,
      type: entry.type,
      plannedMealId: entry.plannedMealId,
      servings: 1.5,
    );
    await relaunchedRepository.save(updated);
    expect((await firstRepository.loadAll()).single.servings, 1.5);
    expect(await relaunchedRepository.delete(entry.id), isTrue);
    expect(await firstRepository.loadAll(), isEmpty);
    expect(await relaunchedRepository.delete(entry.id), isFalse);
  });

  test('serializes concurrent writes and rejects corrupt history', () async {
    final storage = _MemoryStorage();
    final repository = NutritionMealLogRepository(storage: storage);
    await Future.wait([
      repository.save(_manual('one', DateTime(2026, 11, 27, 8))),
      repository.save(_manual('two', DateTime(2026, 11, 27, 9))),
      repository.save(_manual('three', DateTime(2026, 11, 27, 10))),
    ]);

    expect(await repository.loadAll(), hasLength(3));
    expect(
      () => NutritionMealLogRepository(
        storage: _MemoryStorage()
          ..values[NutritionMealLogRepository.storageKey] = '{bad',
      ).loadAll(),
      throwsFormatException,
    );
  });

  test('filters by local calendar day rather than UTC date', () async {
    final repository = NutritionMealLogRepository(storage: _MemoryStorage());
    final localMoment = DateTime(2026, 11, 27, 0, 30);
    await repository.save(_manual('just-after-midnight', localMoment));
    await repository.save(
      _manual('previous-day', localMoment.subtract(const Duration(hours: 2))),
    );

    final entries = await repository.loadForDay(DateTime(2026, 11, 27, 23));
    expect(entries.map((entry) => entry.id), ['just-after-midnight']);
  });

  test(
    'moves the previous preference snapshot into individual Drift rows',
    () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      final oldEntry = _manual('legacy', DateTime(2026, 11, 27, 8));
      SharedPreferencesAsyncPlatform.instance =
          InMemorySharedPreferencesAsync.withData({
            NutritionMealLogRepository.storageKey: jsonEncode({
              'version': 1,
              'entries': [oldEntry.toJson()],
            }),
          });
      final database = AppDatabase(NativeDatabase.memory());
      final repository = NutritionMealLogRepository(
        storage: DriftNutritionMealLogStorage(
          database: database,
          legacyPreferences: SharedPreferencesAsync(),
        ),
      );

      final migrated = await repository.loadAll();
      expect(migrated.single.id, 'legacy');
      expect(
        await database.select(database.nutritionMealLogs).get(),
        hasLength(1),
      );
      await repository.clear();
      expect(await repository.loadAll(), isEmpty);
      expect(await database.select(database.nutritionMealLogs).get(), isEmpty);
      await database.close();
    },
  );
}

MealEntry _manual(String id, DateTime date) => MealEntry(
  id: id,
  dateTime: date,
  foodId: 'food-$id',
  type: MealEntryType.manual,
  quantityGrams: 100,
);

class _MemoryStorage implements NutritionMealLogStorage {
  final values = <String, String>{};

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String value) async => values[key] = value;
}
