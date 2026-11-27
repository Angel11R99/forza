import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/models/nutrition/hydration_models.dart';

abstract interface class HydrationStorage {
  Future<String?> read();
  Future<void> write(String value);
}

class SharedPreferencesHydrationStorage implements HydrationStorage {
  SharedPreferencesHydrationStorage({SharedPreferencesAsync? preferences})
    : _preferences = preferences ?? SharedPreferencesAsync();
  final SharedPreferencesAsync _preferences;
  static const key = 'nutrition_hydration_v1';
  @override
  Future<String?> read() => _preferences.getString(key);
  @override
  Future<void> write(String value) => _preferences.setString(key, value);
}

/// Local-first hydration history. All mutations share a queue so repeated
/// quick actions cannot overwrite one another.
class HydrationRepository {
  HydrationRepository({HydrationStorage? storage})
    : _storage = storage ?? SharedPreferencesHydrationStorage();
  final HydrationStorage _storage;
  Future<void> _queue = Future<void>.value();

  Future<({List<HydrationEntry> entries, HydrationPreferences preferences})>
  load() => _serialized(() async {
    final root = await _read();
    final entries =
        (root['entries'] as List)
            .map(
              (item) => HydrationEntry.fromJson(
                Map<String, Object?>.from(item as Map),
              ),
            )
            .toList()
          ..sort((a, b) => b.loggedAt.compareTo(a.loggedAt));
    final prefs = HydrationPreferences.fromJson(
      Map<String, Object?>.from(root['preferences'] as Map),
    );
    return (
      entries: List<HydrationEntry>.unmodifiable(entries),
      preferences: prefs,
    );
  });

  Future<void> save(HydrationEntry entry) async {
    if (!entry.isValid) {
      throw const FormatException('El registro de hidratación no es válido.');
    }
    await _serialized(() async {
      final root = await _read();
      final entries = (root['entries'] as List)
          .map(
            (item) =>
                HydrationEntry.fromJson(Map<String, Object?>.from(item as Map)),
          )
          .toList();
      final index = entries.indexWhere((item) => item.id == entry.id);
      if (index < 0) {
        entries.add(entry);
      } else {
        entries[index] = entry;
      }
      await _write(
        entries,
        HydrationPreferences.fromJson(
          Map<String, Object?>.from(root['preferences'] as Map),
        ),
      );
    });
  }

  Future<bool> delete(String id) => _serialized(() async {
    final root = await _read();
    final entries = (root['entries'] as List)
        .map(
          (item) =>
              HydrationEntry.fromJson(Map<String, Object?>.from(item as Map)),
        )
        .toList();
    final before = entries.length;
    entries.removeWhere((item) => item.id == id);
    if (entries.length == before) return false;
    await _write(
      entries,
      HydrationPreferences.fromJson(
        Map<String, Object?>.from(root['preferences'] as Map),
      ),
    );
    return true;
  });

  Future<void> savePreferences(HydrationPreferences preferences) async {
    if (!preferences.isValid) {
      throw const FormatException(
        'Las preferencias de hidratación no son válidas.',
      );
    }
    await _serialized(() async {
      final root = await _read();
      final entries = (root['entries'] as List)
          .map(
            (item) =>
                HydrationEntry.fromJson(Map<String, Object?>.from(item as Map)),
          )
          .toList();
      await _write(entries, preferences);
    });
  }

  Future<void> replaceAll(
    Iterable<HydrationEntry> entries,
    HydrationPreferences preferences,
  ) async {
    final values = entries.toList(growable: false);
    if (!preferences.isValid ||
        values.any((item) => !item.isValid) ||
        values.map((item) => item.id).toSet().length != values.length) {
      throw const FormatException('El respaldo de hidratación no es válido.');
    }
    await _serialized(() => _write(values, preferences));
  }

  Future<Map<String, Object?>> _read() async {
    final value = await _storage.read();
    if (value == null || value.isEmpty) {
      return {
        'entries': <Object?>[],
        'preferences': const HydrationPreferences().toJson(),
      };
    }
    try {
      final root = jsonDecode(value);
      if (root is! Map ||
          root['version'] != 1 ||
          root['entries'] is! List ||
          root['preferences'] is! Map) {
        throw const FormatException();
      }
      return Map<String, Object?>.from(root);
    } on Object {
      throw const FormatException(
        'No se puede leer el historial de hidratación.',
      );
    }
  }

  Future<void> _write(
    List<HydrationEntry> entries,
    HydrationPreferences preferences,
  ) => _storage.write(
    jsonEncode({
      'version': 1,
      'entries': entries.map((item) => item.toJson()).toList(),
      'preferences': preferences.toJson(),
    }),
  );

  Future<T> _serialized<T>(Future<T> Function() action) async {
    final previous = _queue;
    final release = Completer<void>();
    _queue = release.future;
    await previous;
    try {
      return await action();
    } finally {
      release.complete();
    }
  }
}
