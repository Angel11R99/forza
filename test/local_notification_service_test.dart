import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forza/data/services/local_notification_service.dart';
import 'package:timezone/timezone.dart' as tz;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() => debugDefaultTargetPlatformOverride = null);

  test(
    'does not initialize mobile notifications on desktop platforms',
    () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.linux;
      final service = FlutterLocalNotificationService();

      await service.initialize();
      expect(await service.requestPermissions(), isFalse);
      expect(await service.notificationsEnabled(), isFalse);
      expect(await service.pendingNotifications(), isEmpty);
      await service.schedule(
        id: 1,
        scheduledDate: tz.TZDateTime.utc(2026, 1, 1),
        title: 'Workout',
        body: 'Reminder',
        payload: 'forza:workout:2026-01-01',
      );
      await service.cancel(1);
    },
  );
}
