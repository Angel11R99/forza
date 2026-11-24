import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as timezone_data;
import 'package:timezone/timezone.dart' as tz;

import '../../domain/models/scheduled_training_session.dart';
import '../../ui/features/profile/models/profile_settings.dart';
import '../services/local_notification_service.dart';

class WorkoutReminderSyncException implements Exception {
  const WorkoutReminderSyncException();
}

abstract interface class DeviceTimeZoneProvider {
  Future<tz.Location> getLocalLocation();
}

class PlatformDeviceTimeZoneProvider implements DeviceTimeZoneProvider {
  @override
  Future<tz.Location> getLocalLocation() async {
    timezone_data.initializeTimeZones();
    final timezone = await FlutterTimezone.getLocalTimezone();
    return tz.getLocation(timezone.identifier);
  }
}

class WorkoutReminderRepository {
  WorkoutReminderRepository({
    LocalNotificationService? notifications,
    DeviceTimeZoneProvider? timeZoneProvider,
  }) : _notifications = notifications ?? FlutterLocalNotificationService(),
       _timeZoneProvider = timeZoneProvider ?? PlatformDeviceTimeZoneProvider();

  static const _payloadPrefix = 'forza:workout:';
  static const _maximumScheduledReminders = 50;

  final LocalNotificationService _notifications;
  final DeviceTimeZoneProvider _timeZoneProvider;
  Future<void> _pendingOperation = Future<void>.value();
  bool _initialized = false;

  Future<bool> requestPermission() async {
    await _ensureInitialized();
    return _notifications.requestPermissions();
  }

  Future<void> synchronize({
    required NotificationSettings settings,
    required List<ScheduledTrainingSession> sessions,
    required String title,
    required String body,
    DateTime? now,
  }) {
    final operation = _pendingOperation.then(
      (_) => _synchronize(
        settings: settings,
        sessions: sessions,
        title: title,
        body: body,
        now: now ?? DateTime.now(),
      ),
    );
    _pendingOperation = operation.catchError((Object _) {});
    return operation;
  }

  Future<void> _synchronize({
    required NotificationSettings settings,
    required List<ScheduledTrainingSession> sessions,
    required String title,
    required String body,
    required DateTime now,
  }) async {
    await _ensureInitialized();
    await _cancelManagedNotifications();
    if (!settings.workoutReminders ||
        !await _notifications.notificationsEnabled()) {
      return;
    }

    final location = await _timeZoneProvider.getLocalLocation();
    final localNow = tz.TZDateTime.from(now, location);
    final upcoming =
        sessions.where((session) => session.status == 'pending').toList()..sort(
          (left, right) => left.scheduledDate.compareTo(right.scheduledDate),
        );
    var scheduledCount = 0;
    try {
      for (final session in upcoming) {
        final date = session.scheduledDate;
        final scheduled = tz.TZDateTime(
          location,
          date.year,
          date.month,
          date.day,
          settings.reminderHour,
          settings.reminderMinute,
        );
        if (!scheduled.isAfter(localNow)) continue;
        final dateKey = _dateKey(date);
        await _notifications.schedule(
          id: int.parse(dateKey.replaceAll('-', '')),
          scheduledDate: scheduled,
          title: title,
          body: body,
          payload: '$_payloadPrefix$dateKey',
        );
        scheduledCount++;
        if (scheduledCount == _maximumScheduledReminders) break;
      }
    } on Object {
      await _cancelManagedNotifications();
      rethrow;
    }
  }

  Future<void> _ensureInitialized() async {
    if (_initialized) return;
    await _notifications.initialize();
    _initialized = true;
  }

  Future<void> _cancelManagedNotifications() async {
    final pending = await _notifications.pendingNotifications();
    for (final notification in pending) {
      if (notification.payload?.startsWith(_payloadPrefix) ?? false) {
        await _notifications.cancel(notification.id);
      }
    }
  }

  String _dateKey(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}
