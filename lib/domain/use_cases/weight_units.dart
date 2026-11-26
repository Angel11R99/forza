const double poundsPerKilogram = 2.2046226218;

double weightToKilograms(double value, String unit) =>
    unit == 'lb' ? value / poundsPerKilogram : value;

double weightFromKilograms(double value, String unit) =>
    ((unit == 'lb' ? value * poundsPerKilogram : value) * 100).round() / 100.0;

DateTime startOfWeek(DateTime date, String weekStartsOn) {
  final normalized = DateTime(date.year, date.month, date.day);
  final firstWeekday = weekStartsOn == 'Domingo'
      ? DateTime.sunday
      : DateTime.monday;
  return normalized.subtract(
    Duration(days: (normalized.weekday - firstWeekday) % 7),
  );
}
