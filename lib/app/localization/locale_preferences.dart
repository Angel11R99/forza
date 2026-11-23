import 'package:shared_preferences/shared_preferences.dart';

abstract interface class LocalePreferences {
  Future<String?> readLocale();
  Future<void> writeLocale(String? languageCode);
}

class SharedLocalePreferences implements LocalePreferences {
  SharedLocalePreferences({SharedPreferencesAsync? preferences})
    : _preferences = preferences ?? SharedPreferencesAsync();

  static const _storageKey = 'app_locale_language_code';
  final SharedPreferencesAsync _preferences;

  @override
  Future<String?> readLocale() => _preferences.getString(_storageKey);

  @override
  Future<void> writeLocale(String? languageCode) async {
    if (languageCode == null) {
      await _preferences.remove(_storageKey);
    } else {
      await _preferences.setString(_storageKey, languageCode);
    }
  }
}
