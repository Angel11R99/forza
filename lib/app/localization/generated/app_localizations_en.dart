// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get settingsLanguageTitle => 'App language';

  @override
  String get settingsLanguageDescription =>
      'Choose the language used throughout FORZA.';

  @override
  String get settingsLanguageAutomatic => 'Device language';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageSpanish => 'Español';

  @override
  String get settingsLanguageSystemDescription =>
      'Follow the language set on your device.';

  @override
  String get settingsLanguageSelection => 'Language';

  @override
  String get settingsLanguageAutomaticDescription =>
      'Use the language set on your device.';

  @override
  String get settingsAppearanceTitle => 'Appearance';

  @override
  String get settingsThemeTitle => 'Choose your theme';

  @override
  String get settingsThemeSystem => 'Use device setting';

  @override
  String get settingsThemeSystemDescription => 'Follow your system theme.';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String homeWelcome(Object name) {
    return 'Welcome, $name';
  }

  @override
  String workoutCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count workouts',
      one: '1 workout',
      zero: 'No workouts',
    );
    return '$_temp0';
  }
}
