/// A user-owned recipe. It is stored separately from the curated public
/// catalog so private content can never silently enter generated menus.
class PrivateNutritionRecipe {
  const PrivateNutritionRecipe({
    required this.id,
    required this.title,
    required this.ingredients,
    required this.servings,
    required this.updatedAt,
    this.instructions = const [],
    this.isFavorite = false,
    this.isPinned = false,
  });

  final String id;
  final String title;
  final List<PrivateRecipeIngredient> ingredients;
  final int servings;
  final DateTime updatedAt;
  final List<String> instructions;
  final bool isFavorite;
  final bool isPinned;

  bool get isValid =>
      id.trim().isNotEmpty &&
      title.trim().isNotEmpty &&
      servings > 0 &&
      ingredients.isNotEmpty &&
      ingredients.every((item) => item.isValid) &&
      instructions.every((step) => step.trim().isNotEmpty);

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'ingredients': ingredients.map((item) => item.toJson()).toList(),
    'servings': servings,
    'updatedAt': updatedAt.toUtc().toIso8601String(),
    'instructions': instructions,
    'isFavorite': isFavorite,
    'isPinned': isPinned,
  };

  factory PrivateNutritionRecipe.fromJson(Map<String, Object?> json) {
    final ingredients = json['ingredients'];
    final instructions = json['instructions'];
    final date = DateTime.tryParse(json['updatedAt'] as String? ?? '');
    if (ingredients is! List || instructions is! List || date == null) {
      throw const FormatException('La receta propia no es válida.');
    }
    final item = PrivateNutritionRecipe(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      ingredients: ingredients
          .map((raw) {
            if (raw is! Map) {
              throw const FormatException('Ingrediente no válido.');
            }
            return PrivateRecipeIngredient.fromJson(
              Map<String, Object?>.from(raw),
            );
          })
          .toList(growable: false),
      servings: json['servings'] is int ? json['servings']! as int : 0,
      updatedAt: date,
      instructions: instructions.whereType<String>().toList(growable: false),
      isFavorite: json['isFavorite'] == true,
      isPinned: json['isPinned'] == true,
    );
    if (!item.isValid) {
      throw const FormatException('La receta propia no es válida.');
    }
    return item;
  }
}

class PrivateRecipeIngredient {
  const PrivateRecipeIngredient({
    required this.foodId,
    required this.grams,
    this.amount,
    this.unit = 'g',
  });
  final String foodId;
  final double grams;
  final double? amount;
  final String unit;
  bool get isValid =>
      foodId.trim().isNotEmpty &&
      grams.isFinite &&
      grams > 0 &&
      (amount == null || (amount!.isFinite && amount! > 0)) &&
      unit.trim().isNotEmpty;
  Map<String, Object?> toJson() => {
    'foodId': foodId,
    'grams': grams,
    'amount': amount,
    'unit': unit,
  };
  factory PrivateRecipeIngredient.fromJson(Map<String, Object?> json) =>
      PrivateRecipeIngredient(
        foodId: json['foodId'] as String? ?? '',
        grams: (json['grams'] as num?)?.toDouble() ?? 0,
        amount: (json['amount'] as num?)?.toDouble(),
        unit: json['unit'] as String? ?? 'g',
      );
}
