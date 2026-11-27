import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/models/nutrition/nutrition_models.dart';

abstract interface class NutritionMealLogStorage {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
}

class SharedNutritionMealLogStorage implements NutritionMealLogStorage {
  SharedNutritionMealLogStorage({SharedPreferencesAsync? preferences})
    : _preferences = preferences ?? SharedPreferencesAsync();

  final SharedPreferencesAsync _preferences;

  @override
  Future<String?> read(String key) => _preferences.getString(key);

  @override
  Future<void> write(String key, String value) =>
      _preferences.setString(key, value);
}

/// Device-local, offline meal history. Writes are serialized to avoid lost
/// updates when a quick log and a plan action happen close together.
class NutritionMealLogRepository {
  NutritionMealLogRepository({NutritionMealLogStorage? storage})
    : _storage = storage ?? SharedNutritionMealLogStorage();

  static const storageKey = 'nutrition_meal_log_v1';
  final NutritionMealLogStorage _storage;
  Future<void> _writeQueue = Future<void>.value();
  final StreamController<void> _changes = StreamController<void>.broadcast();

  Stream<void> get changes => _changes.stream;

  Future<List<MealEntry>> loadAll() => _serialized(() async {
    final entries = await _readEntries();
    entries.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    return List.unmodifiable(entries);
  });

  Future<List<MealEntry>> loadForDay(DateTime date) async {
    final localDate = date.toLocal();
    final entries = await loadAll();
    return List.unmodifiable(
      entries.where((entry) {
        final eaten = entry.dateTime.toLocal();
        return eaten.year == localDate.year &&
            eaten.month == localDate.month &&
            eaten.day == localDate.day;
      }),
    );
  }

  Future<void> save(MealEntry entry) {
    if (!entry.isValid) {
      throw const FormatException('El registro de comida no es válido.');
    }
    return _serialized(() async {
      final entries = await _readEntries();
      final index = entries.indexWhere((item) => item.id == entry.id);
      if (index == -1) {
        entries.add(entry);
      } else {
        entries[index] = entry;
      }
      await _writeEntries(entries);
      if (!_changes.isClosed) _changes.add(null);
    });
  }

  Future<bool> delete(String id) => _serialized(() async {
    final entries = await _readEntries();
    final before = entries.length;
    entries.removeWhere((entry) => entry.id == id);
    if (entries.length == before) return false;
    await _writeEntries(entries);
    if (!_changes.isClosed) _changes.add(null);
    return true;
  });

  Future<void> clear() => _serialized(() async {
    await _storage.write(storageKey, '');
    if (!_changes.isClosed) _changes.add(null);
  });

  Future<List<MealEntry>> _readEntries() async {
    final value = await _storage.read(storageKey);
    if (value == null || value.isEmpty) return [];
    try {
      final decoded = jsonDecode(value);
      if (decoded is! Map ||
          decoded['version'] != 1 ||
          decoded['entries'] is! List) {
        throw const FormatException();
      }
      final rawEntries = decoded['entries'] as List;
      final entries = rawEntries.map((raw) {
        if (raw is! Map) throw const FormatException();
        return MealEntry.fromJson(Map<String, Object?>.from(raw));
      }).toList();
      if (entries.map((entry) => entry.id).toSet().length != entries.length) {
        throw const FormatException();
      }
      return entries;
    } on Object {
      throw const FormatException('El historial de comidas no se puede leer.');
    }
  }

  Future<void> _writeEntries(List<MealEntry> entries) => _storage.write(
    storageKey,
    jsonEncode({
      'version': 1,
      'entries': entries.map((entry) => entry.toJson()).toList(),
    }),
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
