import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/models/nutrition/private_nutrition_recipe.dart';

/// Local-first storage for user-owned recipes, isolated from public catalog data.
class PrivateNutritionRecipeRepository {
  PrivateNutritionRecipeRepository({SharedPreferencesAsync? preferences})
    : _preferences = preferences ?? SharedPreferencesAsync();
  static const storageKey = 'nutrition_private_recipes_v1';
  static const catalogFavoritesKey = 'nutrition_catalog_recipe_favorites_v1';
  final SharedPreferencesAsync _preferences;
  Future<void> _writeQueue = Future<void>.value();

  Future<List<PrivateNutritionRecipe>> loadAll() => _serialized(_readAll);

  Future<List<PrivateNutritionRecipe>> _readAll() async {
    final raw = await _preferences.getString(storageKey);
    if (raw == null || raw.isEmpty) return const [];
    final decoded = jsonDecode(raw);
    if (decoded is! List) {
      throw const FormatException('La biblioteca no es válida.');
    }
    final recipes = decoded
        .map((item) {
          if (item is! Map) {
            throw const FormatException('La biblioteca no es válida.');
          }
          return PrivateNutritionRecipe.fromJson(
            Map<String, Object?>.from(item),
          );
        })
        .toList(growable: false);
    if (recipes.map((item) => item.id).toSet().length != recipes.length) {
      throw const FormatException('Hay recetas duplicadas.');
    }
    return List.unmodifiable(recipes);
  }

  Future<void> save(PrivateNutritionRecipe recipe) => _serialized(() async {
    if (!recipe.isValid) {
      throw const FormatException('La receta propia no es válida.');
    }
    final recipes = [...await _readAll()];
    final index = recipes.indexWhere((item) => item.id == recipe.id);
    if (index < 0) {
      recipes.add(recipe);
    } else {
      recipes[index] = recipe;
    }
    await _write(recipes);
  });

  Future<void> delete(String id) => _serialized(() async {
    final recipes = [...await _readAll()]..removeWhere((item) => item.id == id);
    await _write(recipes);
  });

  Future<Set<String>> loadCatalogFavorites() async => Set.unmodifiable(
    (await _preferences.getStringList(catalogFavoritesKey) ?? const <String>[])
        .toSet(),
  );

  Future<Set<String>> toggleCatalogFavorite(String id) => _serialized(() async {
    final favorites = {...await loadCatalogFavorites()};
    if (!favorites.add(id)) favorites.remove(id);
    await _preferences.setStringList(
      catalogFavoritesKey,
      favorites.toList()..sort(),
    );
    return Set.unmodifiable(favorites);
  });

  Future<void> _write(List<PrivateNutritionRecipe> recipes) =>
      _preferences.setString(
        storageKey,
        jsonEncode(recipes.map((item) => item.toJson()).toList()),
      );

  Future<T> _serialized<T>(Future<T> Function() action) async {
    final previous = _writeQueue;
    final release = Completer<void>();
    _writeQueue = release.future;
    await previous;
    try {
      return await action();
    } finally {
      release.complete();
    }
  }
}
