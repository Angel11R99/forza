import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:forza/app/localization/generated/app_localizations.dart';
import 'package:forza/app/localization/locale_controller.dart';
import 'package:forza/app/localization/locale_preferences.dart';
import 'package:forza/app/localization/locale_repository.dart';
import 'package:forza/ui/features/profile/views/profile_settings_pages.dart';

class _MemoryLocalePreferences implements LocalePreferences {
  @override
  Future<String?> readLocale() async => null;
  @override
  Future<void> writeLocale(String? languageCode) async {}
}

void main() {
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
