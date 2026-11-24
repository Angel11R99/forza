import 'package:flutter/widgets.dart';

import 'locale_repository.dart';
import 'locale_preferences.dart';

class LocaleController extends ChangeNotifier {
  LocaleController({LocaleRepository? repository})
    : _repository = repository ?? LocaleRepository(SharedLocalePreferences());

  final LocaleRepository _repository;
  Locale? _locale;
  Locale? get locale => _locale;

  Future<void> restore() async {
    try {
      final code = await _repository.loadLanguageCode();
      _locale = switch (code) {
        'en' => _localeForLanguage('en'),
        'es' => _localeForLanguage('es'),
        _ => null,
      };
    } on Object {
      _locale = null;
    }
    notifyListeners();
  }

  Future<void> setLanguageCode(String? languageCode) async {
    final next = switch (languageCode) {
      'en' => _localeForLanguage('en'),
      'es' => _localeForLanguage('es'),
      _ => null,
    };
    if (_locale == next) return;
    await _repository.saveLanguageCode(next?.languageCode);
    _locale = next;
    notifyListeners();
  }

  Locale _localeForLanguage(String languageCode) {
    final countryCode = WidgetsFlutterBinding.ensureInitialized()
        .platformDispatcher
        .locale
        .countryCode;
    return Locale(
      languageCode,
      countryCode?.isEmpty == true ? null : countryCode,
    );
  }
}
