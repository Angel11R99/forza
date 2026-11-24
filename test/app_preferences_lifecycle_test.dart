import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:forza/app/localization/locale_controller.dart';
import 'package:forza/app/localization/locale_preferences.dart';
import 'package:forza/app/localization/locale_repository.dart';
import 'package:forza/app/theme/appearance_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'appearance and language restore after controllers are recreated',
    () async {
      final appearancePreferences = _MemoryAppearancePreferences();
      final localePreferences = _MemoryLocalePreferences();
      final appearance = AppearanceController(
        preferences: appearancePreferences,
      );
      final locale = LocaleController(
        repository: LocaleRepository(localePreferences),
      );
      await appearance.setMode(ThemeMode.dark);
      await locale.setLanguageCode('es');
      appearance.dispose();
      locale.dispose();

      final restoredAppearance = AppearanceController(
        preferences: appearancePreferences,
      );
      final restoredLocale = LocaleController(
        repository: LocaleRepository(localePreferences),
      );
      await Future.wait([
        restoredAppearance.restore(),
        restoredLocale.restore(),
      ]);

      expect(restoredAppearance.mode, ThemeMode.dark);
      expect(restoredLocale.locale?.languageCode, 'es');
      restoredAppearance.dispose();
      restoredLocale.dispose();
    },
  );
}

class _MemoryAppearancePreferences implements AppearancePreferences {
  String? value;

  @override
  Future<String?> read(String key) async => value;

  @override
  Future<void> write(String key, String value) async => this.value = value;
}

class _MemoryLocalePreferences implements LocalePreferences {
  String? value;

  @override
  Future<String?> readLocale() async => value;

  @override
  Future<void> writeLocale(String? languageCode) async => value = languageCode;
}
