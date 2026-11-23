# Localization

FORZA uses Flutter's generated `gen-l10n` API, `flutter_localizations`, `intl`, and ARB catalogs. English (`en`) is the reference catalog and Spanish (`es`) is the second supported locale. The catalogs are currently consolidated in `lib/l10n/app_en.arb` and `lib/l10n/app_es.arb`; `l10n.yaml` writes generated code under `lib/app/localization/generated/`.

## Architecture

- `LocalePreferences` abstracts persistence. `SharedLocalePreferences` stores an optional language code using the app's existing `SharedPreferencesAsync` dependency.
- `LocaleRepository` is the small persistence boundary.
- `LocaleController` restores and updates the optional language code and notifies listeners. `null` means follow the device; unsupported saved values safely resolve to that mode.
- `LocalizationContext` exposes generated `AppLocalizations` through `context.l10n`.
- `ForzaApp` listens to both appearance and locale controllers and supplies generated delegates and supported locales to `MaterialApp`.

The user's selected language is independent of business data and currency. Locale aware display formatting should use the active `Localizations.localeOf(context)` with `DateFormat` or `NumberFormat`; do not use a locale to infer a transaction's currency.

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

The initial catalog supports the language and appearance settings flow, plus sample parameter and plural messages. The rest of the existing app has not yet been migrated: the home, activity, exercise, progress, onboarding/training, profile/account, backup/restore, shared navigation, form validation, accessibility, and demo content still contain user facing Spanish strings. Some date formatting is explicitly pinned to `es_DO`. Therefore this change establishes the infrastructure and selector but does **not** claim complete bilingual coverage; those strings need feature by feature ARB migration before the app meets the full coverage requirement. Server or imported user content also needs a content contract before it can be translated safely.
