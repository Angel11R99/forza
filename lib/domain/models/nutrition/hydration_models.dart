enum HydrationDrinkType { water, otherBeverage }

class HydrationEntry {
  const HydrationEntry({
    required this.id,
    required this.loggedAt,
    required this.amountMl,
    this.drinkType = HydrationDrinkType.water,
  });

  final String id;
  final DateTime loggedAt;
  final int amountMl;
  final HydrationDrinkType drinkType;

  bool get isValid => id.trim().isNotEmpty && amountMl > 0 && amountMl <= 10000;

  Map<String, Object?> toJson() => {
    'id': id,
    'loggedAt': loggedAt.toIso8601String(),
    'amountMl': amountMl,
    'drinkType': drinkType.name,
  };

  factory HydrationEntry.fromJson(Map<String, Object?> json) => HydrationEntry(
    id: json['id'] as String,
    loggedAt: DateTime.parse(json['loggedAt'] as String),
    amountMl: json['amountMl'] as int,
    drinkType: HydrationDrinkType.values.firstWhere(
      (type) => type.name == json['drinkType'],
      orElse: () => HydrationDrinkType.water,
    ),
  );
}

class HydrationPreferences {
  const HydrationPreferences({
    this.glassMl = 250,
    this.bottleMl = 500,
    this.dailyGoalMl,
    this.showIndicator = true,
  });

  final int glassMl;
  final int bottleMl;
  final int? dailyGoalMl;
  final bool showIndicator;

  bool get isValid =>
      glassMl >= 50 &&
      glassMl <= 2000 &&
      bottleMl >= 50 &&
      bottleMl <= 3000 &&
      (dailyGoalMl == null || (dailyGoalMl! >= 250 && dailyGoalMl! <= 10000));

  Map<String, Object?> toJson() => {
    'glassMl': glassMl,
    'bottleMl': bottleMl,
    'dailyGoalMl': dailyGoalMl,
    'showIndicator': showIndicator,
  };

  factory HydrationPreferences.fromJson(Map<String, Object?> json) =>
      HydrationPreferences(
        glassMl: json['glassMl'] as int? ?? 250,
        bottleMl: json['bottleMl'] as int? ?? 500,
        dailyGoalMl: json['dailyGoalMl'] as int?,
        showIndicator: json['showIndicator'] as bool? ?? true,
      );
}
