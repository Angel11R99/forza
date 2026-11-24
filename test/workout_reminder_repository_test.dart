import 'package:flutter_test/flutter_test.dart';
import 'package:forza/data/repositories/workout_reminder_repository.dart';
import 'package:forza/data/services/local_notification_service.dart';
import 'package:forza/domain/models/scheduled_training_session.dart';
import 'package:forza/ui/features/profile/models/profile_settings.dart';
import 'package:timezone/data/latest.dart' as timezone_data;
import 'package:timezone/timezone.dart' as tz;

void main() {
  late tz.Location location;

  setUpAll(() {
    timezone_data.initializeTimeZones();
    location = tz.getLocation('America/New_York');
  });

  test(
    'schedules only upcoming pending sessions in the device time zone',
    () async {
      final notifications = _MemoryLocalNotifications();
      final repository = WorkoutReminderRepository(
        notifications: notifications,
        timeZoneProvider: _FixedTimeZoneProvider(location),
      );

      await repository.synchronize(
        settings: const NotificationSettings(
          workoutReminders: true,
          reminderHour: 18,
          reminderMinute: 15,
        ),
        sessions: [
          _session(DateTime(2026, 3, 8)),
          _session(DateTime(2026, 3, 9), status: 'skipped'),
          _session(DateTime(2026, 3, 10), status: 'completed'),
          _session(DateTime(2026, 3, 11)),
        ],
        title: 'Today’s workout',
        body: 'A session is waiting.',
        now: DateTime.utc(2026, 3, 7, 17),
      );

      expect(notifications.initialized, isTrue);
      expect(notifications.scheduled, hasLength(2));
      final first = notifications.scheduled.first;
      expect(first.scheduledDate, tz.TZDateTime(location, 2026, 3, 8, 18, 15));
      expect(first.scheduledDate.timeZoneOffset, const Duration(hours: -4));
      expect(first.title, 'Today’s workout');
      expect(first.payload, 'forza:workout:2026-03-08');
      expect(notifications.scheduled.last.id, 20260311);
    },
  );

  test('cancels only its own reminders when reminders are disabled', () async {
    final notifications = _MemoryLocalNotifications()
      ..pending.addAll([
        const PendingWorkoutNotification(
          id: 20261125,
          payload: 'forza:workout:2026-11-25',
        ),
        const PendingWorkoutNotification(id: 7, payload: 'another-feature'),
      ]);
    final repository = WorkoutReminderRepository(
      notifications: notifications,
      timeZoneProvider: _FixedTimeZoneProvider(location),
    );

    await repository.synchronize(
      settings: const NotificationSettings(),
      sessions: [_session(DateTime(2026, 11, 25))],
      title: 'Workout',
      body: 'Scheduled',
      now: DateTime.utc(2026, 11, 24),
    );

    expect(notifications.cancelledIds, [20261125]);
    expect(notifications.pending.single.id, 7);
    expect(notifications.scheduled, isEmpty);
    expect(notifications.permissionChecks, 0);
  });

  test('keeps at most fifty pending reminders for iOS limits', () async {
    final notifications = _MemoryLocalNotifications();
    final repository = WorkoutReminderRepository(
      notifications: notifications,
      timeZoneProvider: _FixedTimeZoneProvider(location),
    );

    await repository.synchronize(
      settings: const NotificationSettings(workoutReminders: true),
      sessions: [
        for (var day = 1; day <= 120; day++)
          _session(DateTime(2027, 1, 1).add(Duration(days: day))),
      ],
      title: 'Workout',
      body: 'Scheduled',
      now: DateTime.utc(2026, 12, 31),
    );

    expect(notifications.scheduled, hasLength(50));
    expect(notifications.scheduled.first.id, 20270102);
    expect(notifications.scheduled.last.id, 20270220);
  });
}

ScheduledTrainingSession _session(DateTime date, {String status = 'pending'}) =>
    ScheduledTrainingSession(
      id: date.toIso8601String(),
      scheduledDate: date,
      sessionIndex: 0,
      title: 'Workout',
      focus: 'Strength',
      durationMinutes: 45,
      exerciseCount: 5,
      status: status,
    );

class _FixedTimeZoneProvider implements DeviceTimeZoneProvider {
  const _FixedTimeZoneProvider(this.location);

  final tz.Location location;

  @override
  Future<tz.Location> getLocalLocation() async => location;
}

class _MemoryLocalNotifications implements LocalNotificationService {
  bool initialized = false;
  bool enabled = true;
  bool permissionGranted = true;
  int permissionChecks = 0;
  final List<int> cancelledIds = [];
  final List<PendingWorkoutNotification> pending = [];
  final List<_Scheduled> scheduled = [];

  @override
  Future<void> initialize() async => initialized = true;

  @override
  Future<bool> requestPermissions() async => permissionGranted;

  @override
  Future<bool> notificationsEnabled() async {
    permissionChecks++;
    return enabled;
  }

  @override
  Future<List<PendingWorkoutNotification>> pendingNotifications() async =>
      List.of(pending);

  @override
  Future<void> schedule({
    required int id,
    required tz.TZDateTime scheduledDate,
    required String title,
    required String body,
    required String payload,
  }) async {
    scheduled.add(
      _Scheduled(
        id: id,
        scheduledDate: scheduledDate,
        title: title,
        body: body,
        payload: payload,
      ),
    );
    pending.add(PendingWorkoutNotification(id: id, payload: payload));
  }

  @override
  Future<void> cancel(int id) async {
    cancelledIds.add(id);
    pending.removeWhere((notification) => notification.id == id);
  }
}

class _Scheduled {
  const _Scheduled({
    required this.id,
    required this.scheduledDate,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final tz.TZDateTime scheduledDate;
  final String title;
  final String body;
  final String payload;
}
