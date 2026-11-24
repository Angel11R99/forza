import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:forza/app/localization/generated/app_localizations.dart';
import 'package:forza/app/localization/locale_controller.dart';
import 'package:forza/app/localization/locale_preferences.dart';
import 'package:forza/app/localization/locale_repository.dart';
import 'package:forza/app/theme/app_theme.dart';
import 'package:forza/ui/features/profile/views/profile_settings_pages.dart';
import 'package:forza/ui/features/profile/models/profile_settings.dart';
import 'package:forza/ui/features/home/views/home_view.dart';

class _MemoryLocalePreferences implements LocalePreferences {
  @override
  Future<String?> readLocale() async => null;
  @override
  Future<void> writeLocale(String? languageCode) async {}
}

void main() {
  testWidgets('home workout goal follows the selected app language', (
    WidgetTester tester,
  ) async {
    Widget app(Locale locale) => MaterialApp(
      locale: locale,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: [
        AppLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      home: HomeView(
        onShowActivity: () {},
        onShowProfile: () {},
        settings: const TrainingSettings(goal: 'Ganar fuerza'),
        onStartWorkout: (_) {},
        onEditPlan: () {},
        completedDates: const {},
      ),
    );

    await tester.pumpWidget(app(const Locale('en')));
    expect(find.text('Build strength'), findsOneWidget);
    expect(find.text('Ganar fuerza'), findsNothing);

    await tester.pumpWidget(app(const Locale('es')));
    expect(find.text('Ganar fuerza'), findsOneWidget);
  });

  testWidgets('language selection updates the visible settings immediately', (
    WidgetTester tester,
  ) async {
    final controller = LocaleController(
      repository: LocaleRepository(_MemoryLocalePreferences()),
    );

    await tester.pumpWidget(
      ListenableBuilder(
        listenable: controller,
        builder: (context, _) => MaterialApp(
          locale: controller.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: [
            AppLocalizations.delegate,
            ...GlobalMaterialLocalizations.delegates,
          ],
          home: AppLanguagePage(localeController: controller),
        ),
      ),
    );

    expect(find.text('App language'), findsOneWidget);
    await tester.tap(find.text('Español'));
    await tester.pumpAndSettle();
    expect(find.text('Idioma de la aplicación'), findsOneWidget);
    expect(controller.locale?.languageCode, 'es');
    controller.dispose();
  });
}
