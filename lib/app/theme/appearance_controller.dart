import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppearanceController extends ChangeNotifier {
  static const _storageKey = 'appearance_theme_mode';
  final SharedPreferencesAsync _preferences = SharedPreferencesAsync();

  ThemeMode _mode = ThemeMode.system;
  ThemeMode get mode => _mode;

  Future<void> restore() async {
    String? saved;
    try {
      saved = await _preferences.getString(_storageKey);
    } on Object {
      // Keep following the system if local preferences are unavailable.
    }
    _mode = switch (saved) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
    notifyListeners();
  }

  Future<void> setMode(ThemeMode mode) async {
    if (_mode == mode) return;
    _mode = mode;
    notifyListeners();
    final value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    try {
      await _preferences.setString(_storageKey, value);
    } on Object {
      // Keep the selected appearance for this run if saving fails.
    }
  }
}
