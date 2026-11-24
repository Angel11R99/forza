import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:forza/app/localization/generated/app_localizations.dart';
import 'package:forza/app/localization/locale_controller.dart';
import 'package:forza/app/localization/locale_preferences.dart';
import 'package:forza/app/localization/locale_repository.dart';
import 'package:forza/app/theme/app_theme.dart';
import 'package:forza/data/repositories/profile_settings_repository.dart';
import 'package:forza/ui/features/profile/models/profile_settings.dart';
import 'package:forza/ui/features/profile/views/profile_view.dart';

void main() {
  testWidgets('profile summary reflects preferences loaded from storage', (
    WidgetTester tester,
  ) async {
    final storage = _MemoryProfilePreferencesStorage();
    final repository = ProfileSettingsRepository(storage: storage);
    await repository.saveAppPreferences(
      const AppPreferences(
        weightUnit: 'lb',
        weekStartsOn: 'Domingo',
        hapticsEnabled: false,
      ),
    );
    await repository.saveNotifications(
      const NotificationSettings(
        workoutReminders: true,
        reminderHour: 7,
        reminderMinute: 35,
      ),
    );
    await repository.savePrivacy(const PrivacySettings(privateProfile: false));
    final locale = LocaleController(
      repository: LocaleRepository(_MemoryLocalePreferences()),
    );

    await tester.pumpWidget(_app(repository, locale));
    await tester.pumpAndSettle();

    expect(find.textContaining('Weight lb'), findsOneWidget);
    expect(find.textContaining('week starts Sunday'), findsOneWidget);
    expect(find.textContaining('haptics off'), findsOneWidget);
    expect(find.text('Reminder at 07:35'), findsOneWidget);
    expect(find.text('Visible profile'), findsOneWidget);
    locale.dispose();
  });
}

Widget _app(ProfileSettingsRepository repository, LocaleController locale) =>
    MaterialApp(
      theme: AppTheme.light,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: [
        AppLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      home: ProfileView(
        trainingSettings: const TrainingSettings(),
        onTrainingSettingsChanged: (_) {},
        profileSettingsRepository: repository,
        themeMode: ThemeMode.system,
        onThemeModeChanged: (_) async {},
        onManageBackups: () {},
        localeController: locale,
      ),
    );

class _MemoryProfilePreferencesStorage implements ProfilePreferencesStorage {
  final Map<String, String> values = {};

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String value) async => values[key] = value;
}

class _MemoryLocalePreferences implements LocalePreferences {
  @override
  Future<String?> readLocale() async => null;

  @override
  Future<void> writeLocale(String? languageCode) async {}
}
