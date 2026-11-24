import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:forza/app/localization/generated/app_localizations.dart';
import 'package:forza/app/theme/app_theme.dart';
import 'package:forza/ui/features/profile/models/profile_settings.dart';
import 'package:forza/ui/features/profile/views/profile_settings_pages.dart';

void main() {
  testWidgets('shows only the actionable workout reminder controls', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        localizationsDelegates: [
          AppLocalizations.delegate,
          ...GlobalMaterialLocalizations.delegates,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: const NotificationsSettingsPage(settings: NotificationSettings()),
      ),
    );

    expect(find.text('Workout reminders'), findsOneWidget);
    expect(find.text('Weekly summary'), findsNothing);
    expect(find.text('Personal records'), findsNothing);
    expect(find.text('Reminder time'), findsNothing);

    await tester.tap(find.text('Workout reminders'));
    await tester.pumpAndSettle();

    expect(find.text('Reminder time'), findsOneWidget);
  });
}
