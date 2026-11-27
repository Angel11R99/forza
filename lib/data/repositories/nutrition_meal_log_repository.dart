import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../database/app_database.dart';
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

/// Stores each meal entry as a separate SQLite row and imports the previous
/// SharedPreferences snapshot once, without deleting that source until the
/// new database snapshot has been committed.
class DriftNutritionMealLogStorage implements NutritionMealLogStorage {
  DriftNutritionMealLogStorage({
    AppDatabase? database,
    SharedPreferencesAsync? legacyPreferences,
  }) : _database = database ?? AppDatabase.instance,
       _legacyPreferences = legacyPreferences ?? SharedPreferencesAsync();

  static const _migrationKey = 'migration_nutrition_meal_log_v1';
  final AppDatabase _database;
  final SharedPreferencesAsync _legacyPreferences;

  @override
  Future<String?> read(String key) async {
    if (key != NutritionMealLogRepository.storageKey) return null;
    await _migrateLegacySnapshot();
    final rows = await _database.select(_database.nutritionMealLogs).get();
    final entries = rows.map((row) => jsonDecode(row.entryJson)).toList();
    return jsonEncode({'version': 1, 'entries': entries});
  }

  @override
  Future<void> write(String key, String value) async {
    if (key != NutritionMealLogRepository.storageKey) return;
    final entries = _decodeSnapshot(value);
    await _database.transaction(() async {
      await _database.delete(_database.nutritionMealLogs).go();
      if (entries.isNotEmpty) {
        await _database.batch((batch) {
          batch.insertAll(
            _database.nutritionMealLogs,
            entries.map(
              (entry) => NutritionMealLogsCompanion.insert(
                id: entry.id,
                loggedAt: entry.dateTime.toIso8601String(),
                entryJson: jsonEncode(entry.toJson()),
              ),
            ),
          );
        });
      }
      await _database
          .into(_database.appMetadata)
          .insertOnConflictUpdate(
            AppMetadataCompanion.insert(key: _migrationKey, value: 'true'),
          );
    });
  }

  Future<void> _migrateLegacySnapshot() async {
    final marker = await (_database.select(
      _database.appMetadata,
    )..where((row) => row.key.equals(_migrationKey))).getSingleOrNull();
    if (marker?.value == 'true') return;
    final legacyJson = await _legacyPreferences.getString(
      NutritionMealLogRepository.storageKey,
    );
    final legacyEntries = legacyJson == null || legacyJson.isEmpty
        ? const <MealEntry>[]
        : _decodeSnapshot(legacyJson);
    await _database.transaction(() async {
      final existing = await _database
          .select(_database.nutritionMealLogs)
          .get();
      if (existing.isEmpty && legacyEntries.isNotEmpty) {
        await _database.batch((batch) {
          batch.insertAll(
            _database.nutritionMealLogs,
            legacyEntries.map(
              (entry) => NutritionMealLogsCompanion.insert(
                id: entry.id,
                loggedAt: entry.dateTime.toIso8601String(),
                entryJson: jsonEncode(entry.toJson()),
              ),
            ),
          );
        });
      }
      await _database
          .into(_database.appMetadata)
          .insertOnConflictUpdate(
            AppMetadataCompanion.insert(key: _migrationKey, value: 'true'),
          );
    });
  }

  List<MealEntry> _decodeSnapshot(String value) {
    try {
      final root = jsonDecode(value);
      if (root is! Map || root['version'] != 1 || root['entries'] is! List) {
        throw const FormatException();
      }
      return (root['entries'] as List)
          .map((raw) {
            if (raw is! Map) throw const FormatException();
            return MealEntry.fromJson(Map<String, Object?>.from(raw));
          })
          .toList(growable: false);
    } on Object {
      throw const FormatException('El historial de comidas no es válido.');
    }
  }
}

/// Device-local, offline meal history. Writes are serialized to avoid lost
/// updates when a quick log and a plan action happen close together.
class NutritionMealLogRepository {
  NutritionMealLogRepository({NutritionMealLogStorage? storage})
    : _storage = storage ?? DriftNutritionMealLogStorage();

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
    await _storage.write(
      storageKey,
      jsonEncode({'version': 1, 'entries': const <Object?>[]}),
    );
    if (!_changes.isClosed) _changes.add(null);
  });

  Future<void> replaceAll(Iterable<MealEntry> entries) => _serialized(() async {
    final validated = entries.toList(growable: false);
    if (validated.any((entry) => !entry.isValid) ||
        validated.map((entry) => entry.id).toSet().length != validated.length) {
      throw const FormatException('El historial de comidas no es válido.');
    }
    await _writeEntries(validated);
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
