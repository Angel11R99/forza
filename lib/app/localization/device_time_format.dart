import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

/// Formats a time with an explicit device 24-hour setting when available,
/// falling back to the locale's regional convention otherwise.
String formatDeviceTimeOfDay(BuildContext context, TimeOfDay time) {
  if (MediaQuery.alwaysUse24HourFormatOf(context)) {
    return time.format(context);
  }

  final locale = Localizations.localeOf(context);
  if (locale.languageCode == 'es' && locale.countryCode == 'DO') {
    return MaterialLocalizations.of(context).formatTimeOfDay(time);
  }

  return DateFormat.jm(locale.toLanguageTag())
      .format(DateTime(2000, 1, 1, time.hour, time.minute));
}

/// The stock es_DO Material time pattern is 24-hour. The locale's regional
/// fallback is 12-hour, while MediaQuery can still force 24-hour on the device.
class DominicanMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const DominicanMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      locale.languageCode == 'es' && locale.countryCode == 'DO';

  @override
  Future<MaterialLocalizations> load(Locale locale) async {
    final localeName = locale.toString();
    await initializeDateFormatting(localeName);
    return _DominicanMaterialLocalizations(
      localeName: localeName,
      fullYearFormat: DateFormat.y(localeName),
      compactDateFormat: DateFormat.yMd(localeName),
      shortDateFormat: DateFormat.yMMMd(localeName),
      mediumDateFormat: DateFormat.MMMEd(localeName),
      longDateFormat: DateFormat.yMMMMEEEEd(localeName),
      yearMonthFormat: DateFormat.yMMMM(localeName),
      shortMonthDayFormat: DateFormat.MMMd(localeName),
      decimalFormat: NumberFormat.decimalPattern(localeName),
      twoDigitZeroPaddedFormat: NumberFormat('00', localeName),
    );
  }

  @override
  bool shouldReload(DominicanMaterialLocalizationsDelegate old) => false;
}

class _DominicanMaterialLocalizations extends MaterialLocalizationEsDo {
  const _DominicanMaterialLocalizations({
    required super.localeName,
    required super.fullYearFormat,
    required super.compactDateFormat,
    required super.shortDateFormat,
    required super.mediumDateFormat,
    required super.longDateFormat,
    required super.yearMonthFormat,
    required super.shortMonthDayFormat,
    required super.decimalFormat,
    required super.twoDigitZeroPaddedFormat,
  });

  @override
  TimeOfDayFormat get timeOfDayFormatRaw => TimeOfDayFormat.h_colon_mm_space_a;
}
