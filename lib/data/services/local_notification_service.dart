import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class PendingWorkoutNotification {
  const PendingWorkoutNotification({required this.id, this.payload});

  final int id;
  final String? payload;
}

abstract interface class LocalNotificationService {
  Future<void> initialize();
  Future<bool> requestPermissions();
  Future<bool> notificationsEnabled();
  Future<List<PendingWorkoutNotification>> pendingNotifications();
  Future<void> schedule({
    required int id,
    required tz.TZDateTime scheduledDate,
    required String title,
    required String body,
    required String payload,
  });
  Future<void> cancel(int id);
}

class FlutterLocalNotificationService implements LocalNotificationService {
  FlutterLocalNotificationService({FlutterLocalNotificationsPlugin? plugin})
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;

  @override
  Future<void> initialize() => _plugin.initialize(
    settings: const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
        defaultPresentAlert: true,
        defaultPresentBanner: true,
        defaultPresentList: true,
        defaultPresentSound: true,
      ),
    ),
  );

  @override
  Future<bool> requestPermissions() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return await _plugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >()
              ?.requestNotificationsPermission() ??
          false;
    }
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return await _plugin
              .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin
              >()
              ?.requestPermissions(alert: true, sound: true, badge: false) ??
          false;
    }
    return false;
  }

  @override
  Future<bool> notificationsEnabled() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return await _plugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >()
              ?.areNotificationsEnabled() ??
          false;
    }
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      final status = await _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.checkPermissions();
      return status?.isEnabled ?? false;
    }
    return false;
  }

  @override
  Future<List<PendingWorkoutNotification>> pendingNotifications() async =>
      (await _plugin.pendingNotificationRequests())
          .map(
            (request) => PendingWorkoutNotification(
              id: request.id,
              payload: request.payload,
            ),
          )
          .toList(growable: false);

  @override
  Future<void> schedule({
    required int id,
    required tz.TZDateTime scheduledDate,
    required String title,
    required String body,
    required String payload,
  }) => _plugin.zonedSchedule(
    id: id,
    scheduledDate: scheduledDate,
    title: title,
    body: body,
    payload: payload,
    androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    notificationDetails: const NotificationDetails(
      android: AndroidNotificationDetails(
        'forza_workout_reminders',
        'Entrenamientos / Workouts',
        channelDescription:
            'Recordatorios locales de FORZA / FORZA workout reminders',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBanner: true,
        presentList: true,
        presentSound: true,
      ),
    ),
  );

  @override
  Future<void> cancel(int id) => _plugin.cancel(id: id);
}
