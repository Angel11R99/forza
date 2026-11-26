import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppearanceController extends ChangeNotifier {
  AppearanceController({AppearancePreferences? preferences})
    : _preferences = preferences ?? SharedAppearancePreferences();

  static const _storageKey = 'appearance_theme_mode';
  final AppearancePreferences _preferences;

  ThemeMode _mode = ThemeMode.system;
  ThemeMode get mode => _mode;
  bool _isRestored = false;
  bool get isRestored => _isRestored;

  Future<void> restore() async {
    String? saved;
    try {
      saved = await _preferences.read(_storageKey);
    } on Object {
      // Keep following the system if local preferences are unavailable.
    }
    _mode = switch (saved) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
    _isRestored = true;
    notifyListeners();
  }

  Future<void> setMode(ThemeMode mode) async {
    if (_mode == mode) return;
    await commitMode(mode);
  }

  void previewMode(ThemeMode mode) {
    if (_mode == mode) return;
    _mode = mode;
    notifyListeners();
  }

  Future<void> commitMode(ThemeMode mode) async {
    final value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    await _preferences.write(_storageKey, value);
    _mode = mode;
    notifyListeners();
  }
}

abstract interface class AppearancePreferences {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
}

class SharedAppearancePreferences implements AppearancePreferences {
  SharedAppearancePreferences({SharedPreferencesAsync? preferences})
    : _preferences = preferences ?? SharedPreferencesAsync();

  final SharedPreferencesAsync _preferences;

  @override
  Future<String?> read(String key) => _preferences.getString(key);

  @override
  Future<void> write(String key, String value) =>
      _preferences.setString(key, value);
}
