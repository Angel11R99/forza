// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get settingsLanguageTitle => 'Idioma de la aplicación';

  @override
  String get settingsLanguageDescription =>
      'Elige el idioma que se usa en FORZA.';

  @override
  String get settingsLanguageAutomatic => 'Idioma del dispositivo';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageSpanish => 'Español';

  @override
  String get settingsLanguageSystemDescription =>
      'Usa el idioma configurado en tu dispositivo.';

  @override
  String get settingsLanguageSelection => 'Idioma';

  @override
  String get settingsLanguageAutomaticDescription =>
      'Sigue el idioma configurado en tu dispositivo.';

  @override
  String get settingsAppearanceTitle => 'Apariencia';

  @override
  String get settingsThemeTitle => 'Elige tu tema';

  @override
  String get settingsThemeSystem => 'Según el dispositivo';

  @override
  String get settingsThemeSystemDescription => 'Sigue el tema del sistema.';

  @override
  String get settingsThemeLight => 'Claro';

  @override
  String get settingsThemeDark => 'Oscuro';

  @override
  String homeWelcome(Object name) {
    return 'Te damos la bienvenida, $name';
  }

  @override
  String workoutCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count entrenamientos',
      one: '1 entrenamiento',
      zero: 'Ningún entrenamiento',
    );
    return '$_temp0';
  }
}
