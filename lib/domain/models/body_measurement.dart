class BodyMeasurement {
  const BodyMeasurement({
    required this.date,
    required this.weightKg,
    this.chestCm,
    this.waistCm,
    this.hipsCm,
    this.armCm,
  });

  final DateTime date;
  final double weightKg;
  final double? chestCm;
  final double? waistCm;
  final double? hipsCm;
  final double? armCm;

  String get id => _dateKey(date);

  bool get hasValidValues =>
      _isValid(weightKg, 1, 500) &&
      _isOptionalValid(chestCm, 1, 300) &&
      _isOptionalValid(waistCm, 1, 300) &&
      _isOptionalValid(hipsCm, 1, 300) &&
      _isOptionalValid(armCm, 1, 150);

  static bool _isOptionalValid(double? value, double minimum, double maximum) =>
      value == null || _isValid(value, minimum, maximum);

  static bool _isValid(double value, double minimum, double maximum) =>
      value.isFinite && value >= minimum && value <= maximum;

  static String _dateKey(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  Map<String, Object?> toJson() => {
    'date': id,
    'weightKg': weightKg,
    'chestCm': chestCm,
    'waistCm': waistCm,
    'hipsCm': hipsCm,
    'armCm': armCm,
  };

  factory BodyMeasurement.fromJson(Map<String, Object?> json) {
    final dateValue = json['date'];
    final weight = json['weightKg'];
    final date = dateValue is String ? DateTime.tryParse(dateValue) : null;
    if (date == null || weight is! num) {
      throw const FormatException('La medida corporal no es válida.');
    }

    double? optional(String key) {
      final value = json[key];
      if (value == null) return null;
      if (value is! num) {
        throw const FormatException('La medida corporal no es válida.');
      }
      return value.toDouble();
    }

    final measurement = BodyMeasurement(
      date: date,
      weightKg: weight.toDouble(),
      chestCm: optional('chestCm'),
      waistCm: optional('waistCm'),
      hipsCm: optional('hipsCm'),
      armCm: optional('armCm'),
    );
    if (!measurement.hasValidValues || date.isAfter(DateTime.now())) {
      throw const FormatException('La medida corporal está fuera de rango.');
    }
    return measurement;
  }
}
