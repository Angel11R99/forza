import 'dart:convert';

import 'package:flutter/services.dart';

import '../../domain/models/nutrition/nutrition_catalog.dart';

typedef NutritionCatalogAssetLoader = Future<String> Function();

class NutritionCatalogRepository {
  NutritionCatalogRepository({NutritionCatalogAssetLoader? loadAsset})
    : _loadAsset = loadAsset ?? _loadBundledAsset;

  static const assetPath = 'assets/data/nutrition_catalog.json';
  final NutritionCatalogAssetLoader _loadAsset;
  Future<NutritionCatalog>? _cached;

  Future<NutritionCatalog> load() => _cached ??= _read();

  Future<void> clearCache() async {
    _cached = null;
  }

  Future<NutritionCatalog> _read() async {
    final text = await _loadAsset();
    final decoded = jsonDecode(text);
    if (decoded is! Map) {
      throw const FormatException('El catálogo nutricional no es válido.');
    }
    return NutritionCatalog.fromJson(Map<String, Object?>.from(decoded));
  }

  static Future<String> _loadBundledAsset() => rootBundle.loadString(assetPath);
}
