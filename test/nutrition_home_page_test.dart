import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:forza/app/localization/generated/app_localizations.dart';
import 'package:forza/app/theme/app_theme.dart';
import 'package:forza/data/repositories/profile_settings_repository.dart';
import 'package:forza/data/repositories/nutrition_catalog_repository.dart';
import 'package:forza/data/repositories/nutrition_meal_log_repository.dart';
import 'package:forza/data/repositories/hydration_repository.dart';
import 'package:forza/domain/models/nutrition/nutrition_models.dart';
import 'package:forza/domain/models/nutrition/hydration_models.dart';
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
                key: ValueKey('$locale-$dark'),
                profileRepository: repository,
                trainingSettings: const TrainingSettings(),
                mealLogRepository: NutritionMealLogRepository(
                  storage: _MealLogMemoryStorage(),
                ),
                catalogRepository: NutritionCatalogRepository(
                  loadAsset: () async => catalogJson,
                ),
                hydrationRepository: HydrationRepository(
                  storage: _HydrationMemoryStorage(),
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();

          expect(tester.takeException(), isNull);
          expect(
            find.text(
              locale.languageCode == 'es'
                  ? 'Agua y bebidas'
                  : 'Water and drinks',
            ),
            findsOneWidget,
          );
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
    final hydration = HydrationRepository(storage: _HydrationMemoryStorage());
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        localizationsDelegates: [
          ...AppLocalizations.localizationsDelegates,
          ...GlobalMaterialLocalizations.delegates,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: NutritionHomePage(
          profileRepository: repository,
          trainingSettings: const TrainingSettings(),
          mealLogRepository: NutritionMealLogRepository(
            storage: _MealLogMemoryStorage(),
          ),
          catalogRepository: NutritionCatalogRepository(
            loadAsset: () async => catalogJson,
          ),
          hydrationRepository: hydration,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Water and drinks'), findsOneWidget);
    await tester.tap(find.text('Glass · 250 ml'));
    await tester.pumpAndSettle();
    expect((await hydration.load()).entries, hasLength(1));
    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();
    expect(find.text('Set preferences'), findsOneWidget);
    await tester.tap(find.text('Set preferences'));
    await tester.pumpAndSettle();
    expect(find.text('Age (years)'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('records quick hydration and supports undo', (tester) async {
    final profile = ProfileSettingsRepository(storage: _MemoryStorage());
    await profile.saveNutritionProfile(
      NutritionProfile(
        id: 'water-test',
        version: 1,
        updatedAt: DateTime.utc(2026, 11, 27),
      ),
    );
    final hydration = HydrationRepository(storage: _HydrationMemoryStorage());
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        theme: AppTheme.light,
        localizationsDelegates: [
          ...AppLocalizations.localizationsDelegates,
          ...GlobalMaterialLocalizations.delegates,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: NutritionHomePage(
          profileRepository: profile,
          trainingSettings: const TrainingSettings(),
          catalogRepository: NutritionCatalogRepository(
            loadAsset: () async => _catalogJson,
          ),
          mealLogRepository: NutritionMealLogRepository(
            storage: _MealLogMemoryStorage(),
          ),
          hydrationRepository: hydration,
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Glass · 250 ml'));
    await tester.pumpAndSettle();
    expect((await hydration.load()).entries, hasLength(1));
    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();
    expect((await hydration.load()).entries, isEmpty);

    await tester.tap(find.text('Custom amount'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(DropdownButtonFormField<HydrationDrinkType>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Other beverage').last);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).last, '1250');
    await tester.tap(find.text('Save').last);
    await tester.pumpAndSettle();
    expect((await hydration.load()).entries.single.amountMl, 1250);
    expect(
      (await hydration.load()).entries.single.drinkType,
      HydrationDrinkType.otherBeverage,
    );
    expect(find.text('Added 1.25 L'), findsOneWidget);
    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();
    expect((await hydration.load()).entries, isEmpty);
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
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        localizationsDelegates: [
          ...AppLocalizations.localizationsDelegates,
          ...GlobalMaterialLocalizations.delegates,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: NutritionHomePage(
          profileRepository: repository,
          trainingSettings: const TrainingSettings(),
          hydrationRepository: HydrationRepository(
            storage: _HydrationMemoryStorage(),
          ),
          mealLogRepository: NutritionMealLogRepository(
            storage: _MealLogMemoryStorage(),
          ),
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

  testWidgets('logs an unplanned food and shows it in history', (tester) async {
    final repository = ProfileSettingsRepository(storage: _MemoryStorage());
    final historyStorage = _MealLogMemoryStorage();
    final mealLogRepository = NutritionMealLogRepository(
      storage: historyStorage,
    );
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        localizationsDelegates: [
          ...AppLocalizations.localizationsDelegates,
          ...GlobalMaterialLocalizations.delegates,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: NutritionHomePage(
          profileRepository: repository,
          trainingSettings: const TrainingSettings(),
          hydrationRepository: HydrationRepository(
            storage: _HydrationMemoryStorage(),
          ),
          catalogRepository: NutritionCatalogRepository(
            loadAsset: () async => _catalogJson,
          ),
          mealLogRepository: mealLogRepository,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Log another food'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).last, 'Banana');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Banana').last);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).last, '150');
    await tester.tap(find.text('Save').last);
    await tester.pumpAndSettle();

    final entries = await mealLogRepository.loadAll();
    expect(entries, hasLength(1));
    expect(
      entries.any(
        (entry) =>
            entry.type == MealEntryType.manual && entry.quantityGrams == 150,
      ),
      isTrue,
    );
    await tester.ensureVisible(find.text('History'));
    await tester.tap(find.text('History'));
    await tester.pumpAndSettle();
    expect(find.text('Banana'), findsOneWidget);
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

class _MealLogMemoryStorage implements NutritionMealLogStorage {
  final values = <String, String>{};

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String value) async => values[key] = value;
}

class _HydrationMemoryStorage implements HydrationStorage {
  String? value;

  @override
  Future<String?> read() async => value;

  @override
  Future<void> write(String value) async => this.value = value;
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
