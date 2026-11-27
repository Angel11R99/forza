import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:forza/data/repositories/private_nutrition_recipe_repository.dart';
import 'package:forza/domain/models/nutrition/private_nutrition_recipe.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.withData({});
  });

  test(
    'persists private recipes, favorites, edits and deletion offline',
    () async {
      final repository = PrivateNutritionRecipeRepository(
        preferences: SharedPreferencesAsync(),
      );
      final recipe = PrivateNutritionRecipe(
        id: 'private-1',
        title: 'Avena',
        ingredients: const [PrivateRecipeIngredient(foodId: 'oats', grams: 80)],
        servings: 2,
        updatedAt: DateTime.utc(2026, 11, 27),
        instructions: const ['Mezclar'],
        isFavorite: true,
      );
      await repository.save(recipe);
      await repository.save(recipe);
      final restored = await PrivateNutritionRecipeRepository(
        preferences: SharedPreferencesAsync(),
      ).loadAll();
      expect(restored, hasLength(1));
      expect(restored.single.isFavorite, isTrue);
      expect(restored.single.ingredients.single.grams, 80);

      await repository.save(
        PrivateNutritionRecipe(
          id: recipe.id,
          title: 'Avena editada',
          ingredients: recipe.ingredients,
          servings: 3,
          updatedAt: DateTime.utc(2026, 11, 28),
        ),
      );
      expect((await repository.loadAll()).single.servings, 3);
      await repository.delete(recipe.id);
      expect(await repository.loadAll(), isEmpty);
    },
  );

  test('rejects invalid recipes and corrupted private library data', () async {
    final repository = PrivateNutritionRecipeRepository(
      preferences: SharedPreferencesAsync(),
    );
    expect(
      () => repository.save(
        PrivateNutritionRecipe(
          id: 'bad',
          title: 'Bad',
          ingredients: const [],
          servings: 0,
          updatedAt: DateTime.utc(2026),
        ),
      ),
      throwsFormatException,
    );
    await SharedPreferencesAsync().setString(
      PrivateNutritionRecipeRepository.storageKey,
      '{broken',
    );
    expect(repository.loadAll, throwsFormatException);
  });

  test('serializes concurrent recipe saves without losing favorites', () async {
    final repository = PrivateNutritionRecipeRepository(
      preferences: SharedPreferencesAsync(),
    );
    await Future.wait([
      for (var index = 0; index < 5; index++)
        repository.save(
          PrivateNutritionRecipe(
            id: 'recipe-$index',
            title: 'Recipe $index',
            ingredients: const [
              PrivateRecipeIngredient(foodId: 'food', grams: 50),
            ],
            servings: 1,
            updatedAt: DateTime.utc(2026, 11, 27),
            isFavorite: index.isEven,
          ),
        ),
    ]);
    final recipes = await repository.loadAll();
    expect(recipes, hasLength(5));
    expect(recipes.where((recipe) => recipe.isFavorite), hasLength(3));
  });

  test('keeps public catalog favorites in their own preference list', () async {
    final repository = PrivateNutritionRecipeRepository(
      preferences: SharedPreferencesAsync(),
    );
    expect(await repository.toggleCatalogFavorite('public-recipe-1'), {
      'public-recipe-1',
    });
    expect(await repository.loadAll(), isEmpty);
    expect(await repository.toggleCatalogFavorite('public-recipe-1'), isEmpty);
  });
}
