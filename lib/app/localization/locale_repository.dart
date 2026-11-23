import 'locale_preferences.dart';

class LocaleRepository {
  const LocaleRepository(this._preferences);

  final LocalePreferences _preferences;

  Future<String?> loadLanguageCode() => _preferences.readLocale();
  Future<void> saveLanguageCode(String? languageCode) =>
      _preferences.writeLocale(languageCode);
}
