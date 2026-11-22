import 'package:shared_preferences/shared_preferences.dart';

import '../../ui/features/profile/models/profile_settings.dart';

class TrainingSettingsRepository {
  TrainingSettingsRepository({SharedPreferencesAsync? preferences})
    : _preferences = preferences ?? SharedPreferencesAsync();

  static const _completeKey = 'training_setup_complete';
  static const _daysKey = 'training_days';
  static const _minutesKey = 'training_session_minutes';
  static const _goalKey = 'training_goal';
  static const _experienceKey = 'training_experience';
  static const _equipmentKey = 'training_equipment';

  final SharedPreferencesAsync _preferences;

  Future<bool> get setupComplete async =>
      await _preferences.getBool(_completeKey) ?? false;

  Future<TrainingSettings> load() async {
    const defaults = TrainingSettings();
    final savedDays = await _preferences.getStringList(_daysKey);
    final trainingDays = savedDays
        ?.map(int.tryParse)
        .whereType<int>()
        .where((day) => day >= DateTime.monday && day <= DateTime.sunday)
        .toSet();
    final savedEquipment = await _preferences.getStringList(_equipmentKey);
    final equipment = savedEquipment?.toSet();

    return TrainingSettings(
      trainingDays: trainingDays == null || trainingDays.isEmpty
          ? defaults.trainingDays
          : trainingDays,
      sessionMinutes:
          await _preferences.getInt(_minutesKey) ?? defaults.sessionMinutes,
      goal: await _preferences.getString(_goalKey) ?? defaults.goal,
      experience:
          await _preferences.getString(_experienceKey) ?? defaults.experience,
      equipment: equipment == null || equipment.isEmpty
          ? defaults.equipment
          : equipment,
    );
  }

  Future<void> save(TrainingSettings settings) async {
    await Future.wait<void>([
      _preferences.setStringList(
        _daysKey,
        settings.trainingDays.map((day) => day.toString()).toList()..sort(),
      ),
      _preferences.setInt(_minutesKey, settings.sessionMinutes),
      _preferences.setString(_goalKey, settings.goal),
      _preferences.setString(_experienceKey, settings.experience),
      _preferences.setStringList(
        _equipmentKey,
        settings.equipment.toList()..sort(),
      ),
    ]);
  }

  Future<void> completeSetup() => _preferences.setBool(_completeKey, true);
}
