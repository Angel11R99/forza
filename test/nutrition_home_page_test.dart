import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:forza/app/localization/generated/app_localizations.dart';
import 'package:forza/app/theme/app_theme.dart';
import 'package:forza/data/repositories/profile_settings_repository.dart';
import 'package:forza/data/repositories/nutrition_catalog_repository.dart';
import 'package:forza/domain/models/nutrition/nutrition_models.dart';
import 'package:forza/ui/features/nutrition/views/nutrition_home_page.dart';
import 'package:forza/ui/features/profile/models/profile_settings.dart';

void main() {
  testWidgets(
    'nutrition tabs fit 320 dp at 2x text in both locales and themes',
    (tester) async {
      const catalogJson = _catalogJson;
      tester.view.physicalSize = const Size(320, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      for (final locale in [const Locale('es'), const Locale('en')]) {
        for (final dark in [false, true]) {
          final repository = ProfileSettingsRepository(
            storage: _MemoryStorage(),
          );
          await repository.saveNutritionProfile(
            NutritionProfile(
              id: 'test-profile',
              version: 1,
              updatedAt: DateTime.utc(2026, 11, 27),
              mealsPerDay: 3,
            ),
          );
          await tester.pumpWidget(
            MaterialApp(
              locale: locale,
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              themeMode: dark ? ThemeMode.dark : ThemeMode.light,
              localizationsDelegates: [
                ...AppLocalizations.localizationsDelegates,
                ...GlobalMaterialLocalizations.delegates,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: const TextScaler.linear(2)),
                child: child!,
              ),
              home: NutritionHomePage(
                profileRepository: repository,
                trainingSettings: const TrainingSettings(),
                catalogRepository: NutritionCatalogRepository(
                  loadAsset: () async => catalogJson,
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();

          expect(tester.takeException(), isNull);
          expect(
            find.text(
              locale.languageCode == 'es'
                  ? 'Plan semanal orientativo'
                  : 'Suggested weekly plan',
            ),
            findsOneWidget,
          );
          final shoppingTab = locale.languageCode == 'es'
              ? 'Compras'
              : 'Shopping';
          await tester.ensureVisible(find.text(shoppingTab));
          await tester.pumpAndSettle();
          await tester.tap(find.text(shoppingTab));
          await tester.pumpAndSettle();
          expect(find.byType(NutritionHomePage), findsOneWidget);
          expect(tester.takeException(), isNull);
        }
      }
    },
  );

  testWidgets('shows welcome and opens optional profile setup', (tester) async {
    const catalogJson = _catalogJson;
    final repository = ProfileSettingsRepository(storage: _MemoryStorage());
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: [
          ...AppLocalizations.localizationsDelegates,
          ...GlobalMaterialLocalizations.delegates,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: NutritionHomePage(
          profileRepository: repository,
          trainingSettings: const TrainingSettings(),
          catalogRepository: NutritionCatalogRepository(
            loadAsset: () async => catalogJson,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Set preferences'), findsOneWidget);
    await tester.tap(find.text('Set preferences'));
    await tester.pumpAndSettle();
    expect(find.text('Age (years)'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('does not show meals when a restricted allergen is unknown', (
    tester,
  ) async {
    final repository = ProfileSettingsRepository(storage: _MemoryStorage());
    await repository.saveNutritionProfile(
      NutritionProfile(
        id: 'allergy-profile',
        version: 1,
        updatedAt: DateTime.utc(2026, 11, 27),
        restrictions: const [
          FoodRestriction(type: FoodRestrictionType.allergy, value: 'peanut'),
        ],
      ),
    );
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: [
          ...AppLocalizations.localizationsDelegates,
          ...GlobalMaterialLocalizations.delegates,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: NutritionHomePage(
          profileRepository: repository,
          trainingSettings: const TrainingSettings(),
          catalogRepository: NutritionCatalogRepository(
            loadAsset: () async => _catalogJson,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text(
        'We can’t build a menu that meets your restrictions with the available data.',
      ),
      findsOneWidget,
    );
    expect(find.text('Banana bowl'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}

class _MemoryStorage implements ProfilePreferencesStorage {
  final values = <String, String>{};

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String value) async => values[key] = value;
}

const _catalogJson = '''
{
  "version":"test-1",
  "scope":{"nutrition":"test","regionalAccess":"unknown","price":"unknown","offline":true},
  "sources":[{"id":"source","name":"Fixture","version":"1","license":"test","url":"https://example.test/food","accessedAt":"2026-11-27T00:00:00Z"}],
  "foods":[{"id":"food-1","sourceId":"source","sourceRecordId":1,"name":"Banana","nameEs":"Banano","preparationState":"raw","sourcePublicationDate":"2026-01-01","nutrientsPer100g":{"energyKcal":90,"proteinG":1,"fatG":0.3,"carbohydrateG":20,"fiberG":2,"sugarsG":10,"sodiumMg":1,"calciumMg":5,"ironMg":0.3,"potassiumMg":300,"vitaminCMg":8,"vitaminARaeUg":3,"vitaminB12Ug":null},"nutrientDataPoints":{},"aliases":[],"allergenKnowledge":"unknown","allergens":[],"dietaryPatterns":["vegetarian","pescatarian","vegan"],"portions":[],"access":{"availability":"unknown","relativeCost":"unknown"}}],
  "recipes":[{"id":"recipe-1","version":1,"titleEn":"Banana bowl","titleEs":"Plato de banano","servings":1,"ingredients":[{"foodId":"food-1","grams":100}],"stepsEn":["Serve."],"stepsEs":["Sirve."],"dietaryPatterns":["vegetarian","pescatarian","vegan"]}]
}
''';
