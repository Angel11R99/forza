import 'package:flutter/widgets.dart';

import 'generated/app_localizations.dart';

extension LocalizationContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);

  String localizeTrainingGoal(String goal) => switch (goal) {
    'Ganar fuerza' => l10n.onboardingStrengthGoal,
    'Ganar músculo' => l10n.onboardingMuscleGoal,
    'Crear el hábito' => l10n.onboardingHabitGoal,
    _ => goal,
  };
}
