import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../ui/features/profile/models/profile_settings.dart';

abstract interface class ProfilePreferencesStorage {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
}

class SharedProfilePreferencesStorage implements ProfilePreferencesStorage {
  SharedProfilePreferencesStorage({SharedPreferencesAsync? preferences})
    : _preferences = preferences ?? SharedPreferencesAsync();

  final SharedPreferencesAsync _preferences;

  @override
  Future<String?> read(String key) => _preferences.getString(key);

  @override
  Future<void> write(String key, String value) =>
      _preferences.setString(key, value);
}

class ProfileSettingsRepository {
  ProfileSettingsRepository({ProfilePreferencesStorage? storage})
    : _storage = storage ?? SharedProfilePreferencesStorage();

  static const _appPreferencesKey = 'profile_app_preferences_v1';
  static const _notificationSettingsKey = 'profile_notifications_v1';
  static const _privacySettingsKey = 'profile_privacy_v1';

  final ProfilePreferencesStorage _storage;

  Future<AppPreferences> loadAppPreferences() async {
    final json = await _read(_appPreferencesKey);
    if (json == null) return const AppPreferences();
    final unit = json['weightUnit'];
    final weekStart = json['weekStartsOn'];
    final haptics = json['hapticsEnabled'];
    if (!const {'kg', 'lb'}.contains(unit) ||
        !const {'Lunes', 'Domingo'}.contains(weekStart) ||
        haptics is! bool) {
      throw const FormatException(
        'Las preferencias de la aplicación no son válidas.',
      );
    }
    return AppPreferences(
      weightUnit: unit as String,
      weekStartsOn: weekStart as String,
      hapticsEnabled: haptics,
    );
  }

  Future<void> saveAppPreferences(AppPreferences preferences) async {
    if (!const {'kg', 'lb'}.contains(preferences.weightUnit) ||
        !const {'Lunes', 'Domingo'}.contains(preferences.weekStartsOn)) {
      throw ArgumentError('Unsupported application preference value.');
    }
    await _write(_appPreferencesKey, {
      'weightUnit': preferences.weightUnit,
      'weekStartsOn': preferences.weekStartsOn,
      'hapticsEnabled': preferences.hapticsEnabled,
    });
  }

  Future<NotificationSettings> loadNotifications() async {
    final json = await _read(_notificationSettingsKey);
    if (json == null) return const NotificationSettings();
    final workoutReminders = json['workoutReminders'];
    final weeklySummary = json['weeklySummary'];
    final recordAlerts = json['personalRecordAlerts'];
    final hour = json['reminderHour'];
    final minute = json['reminderMinute'];
    if (workoutReminders is! bool ||
        weeklySummary is! bool ||
        recordAlerts is! bool ||
        hour is! int ||
        hour < 0 ||
        hour > 23 ||
        minute is! int ||
        minute < 0 ||
        minute > 59) {
      throw const FormatException(
        'Las preferencias de notificaciones no son válidas.',
      );
    }
    return NotificationSettings(
      workoutReminders: workoutReminders,
      weeklySummary: weeklySummary,
      personalRecordAlerts: recordAlerts,
      reminderHour: hour,
      reminderMinute: minute,
    );
  }

  Future<void> saveNotifications(NotificationSettings settings) async {
    if (settings.reminderHour < 0 ||
        settings.reminderHour > 23 ||
        settings.reminderMinute < 0 ||
        settings.reminderMinute > 59) {
      throw ArgumentError('Unsupported reminder time.');
    }
    await _write(_notificationSettingsKey, {
      'workoutReminders': settings.workoutReminders,
      'weeklySummary': settings.weeklySummary,
      'personalRecordAlerts': settings.personalRecordAlerts,
      'reminderHour': settings.reminderHour,
      'reminderMinute': settings.reminderMinute,
    });
  }

  Future<PrivacySettings> loadPrivacy() async {
    final json = await _read(_privacySettingsKey);
    if (json == null) return const PrivacySettings();
    final privateProfile = json['privateProfile'];
    final shareActivity = json['shareWorkoutActivity'];
    if (privateProfile is! bool || shareActivity is! bool) {
      throw const FormatException(
        'Las preferencias de privacidad no son válidas.',
      );
    }
    return PrivacySettings(
      privateProfile: privateProfile,
      shareWorkoutActivity: shareActivity,
    );
  }

  Future<void> savePrivacy(PrivacySettings settings) =>
      _write(_privacySettingsKey, {
        'privateProfile': settings.privateProfile,
        'shareWorkoutActivity': settings.shareWorkoutActivity,
      });

  Future<Map<String, Object?>?> _read(String key) async {
    final value = await _storage.read(key);
    if (value == null) return null;
    try {
      final decoded = jsonDecode(value);
      if (decoded is! Map) throw const FormatException();
      return Map<String, Object?>.from(decoded);
    } on Object {
      throw const FormatException(
        'Las preferencias guardadas no se pueden leer.',
      );
    }
  }

  Future<void> _write(String key, Map<String, Object?> value) =>
      _storage.write(key, jsonEncode(value));
}
