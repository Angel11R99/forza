import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:forza/app/localization/generated/app_localizations.dart';
import 'package:forza/data/repositories/profile_settings_repository.dart';
import 'package:forza/ui/features/profile/views/nutrition_profile_page.dart';

void main() {
  testWidgets(
    'country search and optional region persist at narrow large text',
    (tester) async {
      tester.view.physicalSize = const Size(320, 720);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final repository = ProfileSettingsRepository(storage: _MemoryStorage());
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(2)),
            child: child!,
          ),
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: FilledButton(
                  onPressed: () => Navigator.of(context).push<void>(
                    MaterialPageRoute<void>(
                      builder: (_) =>
                          NutritionProfilePage(repository: repository),
                    ),
                  ),
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      await tester.scrollUntilVisible(
        find.textContaining('Country of purchase'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.ensureVisible(find.textContaining('Country of purchase'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Country of purchase (ISO code)'));
      await tester.pumpAndSettle();
      expect(find.text('Search country'), findsOneWidget);
      await tester.enterText(
        find.byKey(const ValueKey('nutrition-country-search')),
        'mex',
      );
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<TextField>(
              find.byKey(const ValueKey('nutrition-country-search')),
            )
            .controller
            ?.text,
        'mex',
      );
      expect(find.text('No countries found'), findsNothing);
      await tester.scrollUntilVisible(
        find.text('Mexico'),
        200,
        scrollable: find.byType(Scrollable).last,
      );
      expect(find.text('Mexico'), findsOneWidget);
      await tester.tap(find.text('Mexico'));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Region or area (optional)'));
      await tester.enterText(
        find.byKey(const ValueKey('nutrition-profile-region')),
        'Jalisco',
      );
      await tester.scrollUntilVisible(
        find.text('Save'),
        250,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      final saved = await repository.loadNutritionProfile();
      expect(saved?.countryCode, 'MX');
      expect(saved?.region, 'Jalisco');
      expect(tester.takeException(), isNull);
    },
  );
}

class _MemoryStorage implements ProfilePreferencesStorage {
  final values = <String, String>{};

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String value) async => values[key] = value;
}
