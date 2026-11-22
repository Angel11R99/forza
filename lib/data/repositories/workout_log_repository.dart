import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/models/workout_record.dart';

class WorkoutLogRepository {
  WorkoutLogRepository({SharedPreferencesAsync? preferences})
    : _preferences = preferences ?? SharedPreferencesAsync();

  static const _recordsKey = 'workout_records';

  final SharedPreferencesAsync _preferences;

  Future<List<WorkoutRecord>> load() async {
    final savedRecords = await _preferences.getStringList(_recordsKey);
    if (savedRecords == null) return const [];
    return savedRecords
        .map(
          (record) => WorkoutRecord.fromJson(
            Map<String, Object?>.from(jsonDecode(record) as Map),
          ),
        )
        .toList(growable: false);
  }

  Future<List<WorkoutRecord>> save(WorkoutRecord record) async {
    final records = await load();
    final updated = [
      for (final saved in records)
        if (!_sameDate(saved.date, record.date)) saved,
      record,
    ]..sort((first, second) => first.date.compareTo(second.date));
    await _preferences.setStringList(
      _recordsKey,
      updated.map((record) => jsonEncode(record.toJson())).toList(),
    );
    return List.unmodifiable(updated);
  }

  static bool _sameDate(DateTime first, DateTime second) =>
      first.year == second.year &&
      first.month == second.month &&
      first.day == second.day;
}
