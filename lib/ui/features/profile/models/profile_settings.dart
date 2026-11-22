class ForzaProfile {
  const ForzaProfile({
    required this.fullName,
    required this.email,
    required this.goal,
  });

  final String fullName;
  final String email;
  final String goal;
}

class TrainingSettings {
  const TrainingSettings({
    this.trainingDays = const {
      DateTime.monday,
      DateTime.wednesday,
      DateTime.friday,
      DateTime.saturday,
    },
    this.sessionMinutes = 45,
    this.goal = 'Ganar fuerza',
    this.experience = 'Estoy empezando',
    this.equipment = const {'Mancuernas', 'Barra'},
  });

  final Set<int> trainingDays;
  final int sessionMinutes;
  final String goal;
  final String experience;
  final Set<String> equipment;

  int get daysPerWeek => trainingDays.length;
}

class AppPreferences {
  const AppPreferences({
    this.weightUnit = 'kg',
    this.weekStartsOn = 'Lunes',
    this.hapticsEnabled = true,
  });

  final String weightUnit;
  final String weekStartsOn;
  final bool hapticsEnabled;
}

class NotificationSettings {
  const NotificationSettings({
    this.workoutReminders = true,
    this.weeklySummary = true,
    this.personalRecordAlerts = false,
    this.reminderHour = 18,
    this.reminderMinute = 0,
  });

  final bool workoutReminders;
  final bool weeklySummary;
  final bool personalRecordAlerts;
  final int reminderHour;
  final int reminderMinute;
}

class PrivacySettings {
  const PrivacySettings({
    this.privateProfile = true,
    this.shareWorkoutActivity = false,
  });

  final bool privateProfile;
  final bool shareWorkoutActivity;
}
