import 'package:flutter_test/flutter_test.dart';
import 'package:forza/app/localization/locale_controller.dart';
import 'package:forza/app/localization/locale_repository.dart';
import 'package:forza/app/localization/locale_preferences.dart';
import 'package:forza/app/localization/generated/app_localizations_en.dart';
import 'package:forza/app/localization/generated/app_localizations_es.dart';

class MemoryLocalePreferences implements LocalePreferences {
  String? value;
  @override
  Future<String?> readLocale() async => value;
  @override
  Future<void> writeLocale(String? languageCode) async => value = languageCode;
}

void main() {
  test('generated translations support parameters and plurals', () {
    final english = AppLocalizationsEn();
    final spanish = AppLocalizationsEs();
    expect(english.homeWelcome('Alex'), 'Welcome, Alex');
    expect(spanish.homeWelcome('Alex'), 'Te damos la bienvenida, Alex');
    expect(english.workoutCount(1), '1 workout');
    expect(spanish.workoutCount(2), '2 entrenamientos');
  });

  test('restores automatic mode when no preference is stored', () async {
    final preferences = MemoryLocalePreferences();
    final controller = LocaleController(
      repository: LocaleRepository(preferences),
    );
    await controller.restore();
    expect(controller.locale, isNull);
    controller.dispose();
  });

  test('changes and persists language, then restores it', () async {
    final preferences = MemoryLocalePreferences();
    final first = LocaleController(repository: LocaleRepository(preferences));
    await first.setLanguageCode('en');
    expect(first.locale?.languageCode, 'en');
    expect(preferences.value, 'en');
    first.dispose();

    final second = LocaleController(repository: LocaleRepository(preferences));
    await second.restore();
    expect(second.locale?.languageCode, 'en');
    await second.setLanguageCode(null);
    expect(preferences.value, isNull);
    second.dispose();
  });

  test('unsupported saved locales fall back to device locale', () async {
    final preferences = MemoryLocalePreferences()..value = 'fr';
    final controller = LocaleController(
      repository: LocaleRepository(preferences),
    );
    await controller.restore();
    expect(controller.locale, isNull);
    controller.dispose();
  });
}
