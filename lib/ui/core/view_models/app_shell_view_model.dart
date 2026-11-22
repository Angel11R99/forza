import 'package:material_ui/material_ui.dart';

import '../../../data/database/app_database.dart';
import '../../../data/migrations/legacy_shared_preferences_migration.dart';
import '../../../data/repositories/training_settings_repository.dart';
import '../../../data/repositories/workout_log_repository.dart';
import '../../../domain/models/workout_record.dart';
import '../../features/profile/models/profile_settings.dart';

class AppShellViewModel extends ChangeNotifier {
  AppShellViewModel({
    AppDatabase? database,
    TrainingSettingsRepository? settingsRepository,
    WorkoutLogRepository? workoutLogRepository,
  }) : _database = database ?? AppDatabase.instance,
       _settingsRepository =
           settingsRepository ??
           TrainingSettingsRepository(
             database: database ?? AppDatabase.instance,
           ),
       _workoutLogRepository =
           workoutLogRepository ??
           WorkoutLogRepository(database: database ?? AppDatabase.instance);

  final AppDatabase _database;
  final TrainingSettingsRepository _settingsRepository;
  final WorkoutLogRepository _workoutLogRepository;

  TrainingSettings _trainingSettings = const TrainingSettings();
  List<WorkoutRecord> _workoutRecords = const [];
  bool _isReady = false;
  bool _needsFirstRunSetup = false;

  TrainingSettings get trainingSettings => _trainingSettings;
  List<WorkoutRecord> get workoutRecords => _workoutRecords;
  bool get isReady => _isReady;
  bool get needsFirstRunSetup => _needsFirstRunSetup;

  Set<DateTime> get completedDates => {
    for (final record in _workoutRecords) record.date,
  };

  Future<void> restore() async {
    var settings = const TrainingSettings();
    var records = const <WorkoutRecord>[];
    var setupComplete = false;

    try {
      await LegacySharedPreferencesMigration(
        database: _database,
        settingsRepository: _settingsRepository,
        workoutLogRepository: _workoutLogRepository,
      ).run();
      settings = await _settingsRepository.load();
      setupComplete = await _settingsRepository.setupComplete;
    } on Object {
      // Preserve app access with defaults if local storage is unavailable.
    }
    try {
      records = await _workoutLogRepository.load();
    } on Object {
      // An empty history should not block startup.
    }

    _trainingSettings = settings;
    _workoutRecords = records;
    _needsFirstRunSetup = !setupComplete;
    _isReady = true;
    notifyListeners();
  }

  Future<void> saveTrainingSettings(TrainingSettings settings) async {
    await _settingsRepository.save(settings);
    _trainingSettings = settings;
    notifyListeners();
  }

  Future<void> completeFirstRun(TrainingSettings? settings) async {
    if (settings != null) await saveTrainingSettings(settings);
    await _settingsRepository.completeSetup();
    _needsFirstRunSetup = false;
    notifyListeners();
  }

  Future<void> recordWorkout(WorkoutRecord record) async {
    _workoutRecords = await _workoutLogRepository.save(record);
    notifyListeners();
  }
}
