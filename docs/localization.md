# Localization

FORZA uses Flutter's generated `gen-l10n` API, `flutter_localizations`, `intl`, and ARB catalogs. English (`en`) is the reference catalog and Spanish (`es`) is the second supported locale. The catalogs are currently consolidated in `lib/l10n/app_en.arb` and `lib/l10n/app_es.arb`; `l10n.yaml` writes generated code under `lib/app/localization/generated/`.

## Architecture

- `LocalePreferences` abstracts persistence. `SharedLocalePreferences` stores an optional language code using the app's existing `SharedPreferencesAsync` dependency.
- `LocaleRepository` is the small persistence boundary.
- `LocaleController` restores and updates the optional language code and notifies listeners. `null` means follow the device; unsupported saved values safely resolve to that mode.
- `LocalizationContext` exposes generated `AppLocalizations` through `context.l10n`.
- `ForzaApp` listens to both appearance and locale controllers and supplies generated delegates and supported locales to `MaterialApp`.

The user's selected language is independent of business data and currency. Locale aware display formatting should use the active `Localizations.localeOf(context)` with `DateFormat` or `NumberFormat`; do not use a locale to infer a transaction's currency.

Keep the device's country/region when resolving a supported language so regional conventions remain available even when the interface strings fall back to Spanish or English. Time values are stored as hour/minute integers. Display them with `formatDeviceTimeOfDay`: `MediaQuery.alwaysUse24HourFormat` takes priority when enabled; otherwise the regional time convention is used. `es_DO` uses a 12-hour time picker and `es_ES` retains 24 hours. The standard Material locale data marks `es_DO` as 24-hour, so `DominicanMaterialLocalizationsDelegate` supplies the regional 12-hour fallback while still allowing the device's 24-hour setting to override it.

## Adding localization to a new feature

1. Add feature-scoped keys to **both** ARB files. Prefix keys with the feature name, for example `workoutEmptyTitle`.
2. Add metadata for dynamic values, and keep placeholder names and types consistent across locales.
3. Run `flutter gen-l10n`.
4. Import `app/localization/localization_extensions.dart` and use `Text(context.l10n.workoutEmptyTitle)` in the widget. Use generated parameter methods for interpolated values rather than concatenating translated sentence fragments.
5. Run `python tool/validate_localization.py` and `flutter analyze`.

Example parameter and plural keys are included as `homeWelcome` and `workoutCount`. ARB plural syntax is ICU MessageFormat. Format dates and numbers with `DateFormat.yMMMd(localeName)` and `NumberFormat.decimalPattern(localeName)`, where `localeName` comes from `Localizations.localeOf(context).toLanguageTag()`.

## Add a language

Create `app_<language-code>.arb` with `@@locale` and every message from the English catalog, translate each value, then run the validator and `flutter gen-l10n`. Add the locale to `LocaleController.setLanguageCode` and `restore` so the settings selector can save it, and add its localized display name to the language page. New feature modules only add prefixed ARB keys and consume generated getters; they do not need changes to the localization core.

## Validation

Run:

```sh
python tool/validate_localization.py
flutter gen-l10n
flutter test
flutter analyze
```

The validator compares keys and named placeholders, checks empty values, and parses the ARB JSON. Generated sources must not be edited manually.

## Current coverage audit

The app's shipped interface is localized in English and Spanish across settings, navigation, home, activity, exercise library/details, progress, onboarding and training, profile/account, backup/restore, validation, and demo content. All 1,324 bundled exercises have English and Spanish names and ordered instructions; group and equipment labels are localized for display. Date and number formatting follows the active locale.

User-entered profile values and content imported from outside the bundled catalog are displayed as entered. They are not automatically translated, to avoid changing personal data or the meaning of externally supplied content. New interface strings must use the ARB catalogs; new exercise catalog imports must provide both languages as described in `third_party/exercises-dataset/SOURCE.md`.
