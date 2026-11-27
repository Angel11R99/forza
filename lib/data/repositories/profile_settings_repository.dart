import 'dart:convert';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

import '../../ui/features/profile/models/profile_settings.dart';

enum CloudSyncFrequency { onChange, daily, weekly, monthly, manual }

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
  static const _syncOwnerKey = 'profile_cloud_sync_owner_v1';
  static const _lastSyncKeyPrefix = 'profile_cloud_sync_last_';
  static const _syncEnabledKeyPrefix = 'profile_cloud_sync_enabled_';
  static const _pendingSyncKeyPrefix = 'profile_cloud_sync_pending_';
  static const _syncFrequencyKeyPrefix = 'profile_cloud_sync_frequency_';
  static const _displayNameKeyPrefix = 'profile_display_name_';

  final ProfilePreferencesStorage _storage;
  final StreamController<void> _changes = StreamController<void>.broadcast();

  Stream<void> get changes => _changes.stream;

  Future<String?> loadProfileDisplayName(String uid) async {
    final value = (await _storage.read(_uidKey(_displayNameKeyPrefix, uid)))
        ?.trim();
    return value == null || value.isEmpty ? null : value;
  }

  Future<void> saveProfileDisplayName(String uid, String? name) async {
    final normalized = name?.trim();
    if (normalized != null &&
        (normalized.isEmpty || normalized.runes.length > 80)) {
      throw const FormatException('El nombre de perfil no es válido.');
    }
    await _storage.write(_uidKey(_displayNameKeyPrefix, uid), normalized ?? '');
    if (!_changes.isClosed) _changes.add(null);
  }

  Future<bool> isCloudSyncEnabled(String uid) async =>
      (await _storage.read(_uidKey(_syncEnabledKeyPrefix, uid))) == 'true';

  Future<void> setCloudSyncEnabled(String uid, bool enabled) async {
    await _storage.write(_uidKey(_syncEnabledKeyPrefix, uid), '$enabled');
    if (!_changes.isClosed) _changes.add(null);
  }

  Future<String?> cloudSyncOwner() => _storage.read(_syncOwnerKey);

  Future<void> setCloudSyncOwner(String? uid) async {
    if (uid == null) {
      await _storage.write(_syncOwnerKey, '');
    } else {
      await _storage.write(_syncOwnerKey, uid);
    }
  }

  Future<bool> hasPendingCloudSync(String uid) async =>
      (await _storage.read(_uidKey(_pendingSyncKeyPrefix, uid))) == 'true';

  Future<void> setPendingCloudSync(String uid, bool pending) async {
    await _storage.write(_uidKey(_pendingSyncKeyPrefix, uid), '$pending');
  }

  Future<CloudSyncFrequency> cloudSyncFrequency(String uid) async {
    final value = await _storage.read(_uidKey(_syncFrequencyKeyPrefix, uid));
    return CloudSyncFrequency.values.firstWhere(
      (frequency) => frequency.name == value,
      orElse: () => CloudSyncFrequency.onChange,
    );
  }

  Future<void> setCloudSyncFrequency(
    String uid,
    CloudSyncFrequency frequency,
  ) async {
    await _storage.write(_uidKey(_syncFrequencyKeyPrefix, uid), frequency.name);
    if (!_changes.isClosed) _changes.add(null);
  }

  Future<DateTime?> lastCloudSync(String uid) async {
    final value = await _storage.read(_uidKey(_lastSyncKeyPrefix, uid));
    return value == null ? null : DateTime.tryParse(value);
  }

  Future<void> markCloudSyncCompleted(String uid, DateTime timestamp) async {
    await _storage.write(
      _uidKey(_lastSyncKeyPrefix, uid),
      timestamp.toUtc().toIso8601String(),
    );
    await setPendingCloudSync(uid, false);
  }

  String _uidKey(String prefix, String uid) =>
      '$prefix${base64Url.encode(utf8.encode(uid)).replaceAll('=', '')}';

  Future<AppPreferences> loadAppPreferences() async {
    final json = await _read(_appPreferencesKey);
    if (json == null) return const AppPreferences();
    final unit = json['weightUnit'];
    final weekStart = json['weekStartsOn'];
    final haptics = json['hapticsEnabled'];
    final showNavigationLabels = json['showNavigationLabels'];
    if (!const {'kg', 'lb'}.contains(unit) ||
        !const {'Lunes', 'Domingo'}.contains(weekStart) ||
        haptics is! bool ||
        (showNavigationLabels != null && showNavigationLabels is! bool)) {
      throw const FormatException(
        'Las preferencias de la aplicación no son válidas.',
      );
    }
    return AppPreferences(
      weightUnit: unit as String,
      weekStartsOn: weekStart as String,
      hapticsEnabled: haptics,
      showNavigationLabels: showNavigationLabels as bool? ?? true,
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
      'showNavigationLabels': preferences.showNavigationLabels,
    });
  }

  Future<NotificationSettings> loadNotifications() async {
    final json = await _read(_notificationSettingsKey);
    if (json == null) return const NotificationSettings();
    final workoutReminders = json['workoutReminders'];
    final hour = json['reminderHour'];
    final minute = json['reminderMinute'];
    if (workoutReminders is! bool ||
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

  Future<void> _write(String key, Map<String, Object?> value) async {
    await _storage.write(key, jsonEncode(value));
    if (!_changes.isClosed) _changes.add(null);
  }
}
