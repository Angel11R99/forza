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
        'en' => const Locale('en'),
        'es' => const Locale('es'),
        _ => null,
      };
    } on Object {
      _locale = null;
    }
    notifyListeners();
  }

  Future<void> setLanguageCode(String? languageCode) async {
    final next = switch (languageCode) {
      'en' => const Locale('en'),
      'es' => const Locale('es'),
      _ => null,
    };
    if (_locale == next) return;
    _locale = next;
    notifyListeners();
    try {
      await _repository.saveLanguageCode(next?.languageCode);
    } on Object {
      // Keep the selection for the current run if storage is unavailable.
    }
  }
}
