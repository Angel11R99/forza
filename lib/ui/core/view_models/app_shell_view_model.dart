import 'dart:async';
import 'dart:convert';

import 'package:material_ui/material_ui.dart';

import '../../../data/database/app_database.dart'
    hide BodyMeasurement, PersonalGoal, ScheduledTrainingSession;
import '../../../data/migrations/legacy_shared_preferences_migration.dart';
import '../../../data/repositories/training_settings_repository.dart';
import '../../../data/repositories/workout_log_repository.dart';
import '../../../data/repositories/training_schedule_repository.dart';
import '../../../data/repositories/personal_goal_repository.dart';
import '../../../data/repositories/body_measurement_repository.dart';
import '../../../data/repositories/backup_repository.dart';
import '../../../domain/models/workout_record.dart';
import '../../../domain/use_cases/workout_streak_calculator.dart';
import '../../../domain/models/scheduled_training_session.dart';
import '../../../domain/models/personal_goal.dart';
import '../../../domain/models/body_measurement.dart';
import '../../features/profile/models/profile_settings.dart';

class AppShellViewModel extends ChangeNotifier {
  AppShellViewModel({
    AppDatabase? database,
    TrainingSettingsRepository? settingsRepository,
    WorkoutLogRepository? workoutLogRepository,
    TrainingScheduleRepository? trainingScheduleRepository,
    PersonalGoalRepository? personalGoalRepository,
    BodyMeasurementRepository? bodyMeasurementRepository,
    BackupRepository? backupRepository,
  }) : _database = database ?? AppDatabase.instance,
       _settingsRepository =
           settingsRepository ??
           TrainingSettingsRepository(
             database: database ?? AppDatabase.instance,
           ),
       _workoutLogRepository =
           workoutLogRepository ??
           WorkoutLogRepository(database: database ?? AppDatabase.instance),
       _trainingScheduleRepository =
           trainingScheduleRepository ??
           TrainingScheduleRepository(
             database: database ?? AppDatabase.instance,
           ),
       _personalGoalRepository =
           personalGoalRepository ??
           PersonalGoalRepository(database: database ?? AppDatabase.instance) {
    _bodyMeasurementRepository =
        bodyMeasurementRepository ??
        BodyMeasurementRepository(database: _database);
    _backupRepository =
        backupRepository ??
        BackupRepository(
          database: _database,
          settingsRepository: _settingsRepository,
          workoutLogRepository: _workoutLogRepository,
          scheduleRepository: _trainingScheduleRepository,
          goalRepository: _personalGoalRepository,
          bodyMeasurementRepository: _bodyMeasurementRepository,
        );
  }

  final AppDatabase _database;
  final TrainingSettingsRepository _settingsRepository;
  final WorkoutLogRepository _workoutLogRepository;
  final TrainingScheduleRepository _trainingScheduleRepository;
  final PersonalGoalRepository _personalGoalRepository;
  late final BodyMeasurementRepository _bodyMeasurementRepository;
  late final BackupRepository _backupRepository;

  TrainingSettings _trainingSettings = const TrainingSettings();
  List<WorkoutRecord> _workoutRecords = const [];
  List<ScheduledTrainingSession> _scheduledSessions = const [];
  List<PersonalGoal> _personalGoals = const [];
  List<BodyMeasurement> _bodyMeasurements = const [];
  bool _isReady = false;
  bool _needsFirstRunSetup = false;
  bool _hasActiveWorkout = false;
  DateTime? _activeWorkoutDate;
  int _streakAnimationRevision = 0;
  int _streakAnimationFrom = 0;
  Timer? _streakRolloverTimer;

  TrainingSettings get trainingSettings => _trainingSettings;
  List<WorkoutRecord> get workoutRecords => _workoutRecords;
  List<ScheduledTrainingSession> get scheduledSessions => _scheduledSessions;
  List<PersonalGoal> get personalGoals => _personalGoals;
  List<BodyMeasurement> get bodyMeasurements => _bodyMeasurements;
  bool get isReady => _isReady;
  bool get needsFirstRunSetup => _needsFirstRunSetup;
  bool get hasActiveWorkout => _hasActiveWorkout;
  DateTime? get activeWorkoutDate => _activeWorkoutDate;
  WorkoutLogRepository get workoutLogRepository => _workoutLogRepository;
  ScheduledTrainingSession? get nextScheduledSession {
    if (_activeWorkoutDate != null) {
      for (final session in _scheduledSessions) {
        if (_sameDate(session.scheduledDate, _activeWorkoutDate!)) {
          return session;
        }
      }
    }
    final today = DateTime.now();
    for (final session in _scheduledSessions) {
      if (session.status == 'pending' &&
          !_dateOnly(session.scheduledDate).isBefore(_dateOnly(today))) {
        return session;
      }
    }
    return null;
  }

  Set<DateTime> get completedDates => {
    for (final record in _workoutRecords) record.date,
  };
  int get currentStreak =>
      WorkoutStreakCalculator.currentStreak(_workoutRecords);
  int get streakAnimationRevision => _streakAnimationRevision;
  int get streakAnimationFrom => _streakAnimationFrom;

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
    try {
      final draft = await _workoutLogRepository.loadActiveWorkout();
      _hasActiveWorkout = draft != null;
      _activeWorkoutDate = draft == null
          ? null
          : DateTime.parse(
              (jsonDecode(draft) as Map<String, Object?>)['scheduledDate']!
                  as String,
            );
    } on Object {
      _hasActiveWorkout = false;
      _activeWorkoutDate = null;
    }
    try {
      if (!_hasActiveWorkout) {
        await _trainingScheduleRepository.resetInProgress();
      }
      await _trainingScheduleRepository.ensureUpcoming(
        settings,
        from: _scheduleWindowStart(DateTime.now()),
      );
      _scheduledSessions = await _trainingScheduleRepository.load();
    } on Object {
      _scheduledSessions = const [];
    }
    try {
      _personalGoals = await _personalGoalRepository.load();
    } on Object {
      _personalGoals = const [];
    }
    try {
      _bodyMeasurements = await _bodyMeasurementRepository.load();
    } on Object {
      _bodyMeasurements = const [];
    }

    _trainingSettings = settings;
    _workoutRecords = records;
    _needsFirstRunSetup = !setupComplete;
    _isReady = true;
    notifyListeners();
    _scheduleStreakRollover();
  }

  Future<void> saveTrainingSettings(TrainingSettings settings) async {
    await _settingsRepository.save(settings);
    await _trainingScheduleRepository.ensureUpcoming(
      settings,
      from: _scheduleWindowStart(DateTime.now()),
    );
    _trainingSettings = settings;
    _scheduledSessions = await _trainingScheduleRepository.load();
    notifyListeners();
  }

  Future<void> refreshScheduledSessions() async {
    await _trainingScheduleRepository.ensureUpcoming(
      _trainingSettings,
      from: _scheduleWindowStart(DateTime.now()),
    );
    _scheduledSessions = await _trainingScheduleRepository.load();
    notifyListeners();
  }

  Future<void> completeFirstRun(TrainingSettings? settings) async {
    if (settings != null) await saveTrainingSettings(settings);
    await _settingsRepository.completeSetup();
    _needsFirstRunSetup = false;
    notifyListeners();
  }

  Future<void> recordWorkout(WorkoutRecord record) async {
    final previousStreak = currentStreak;
    _workoutRecords = await _workoutLogRepository.save(record);
    final updatedStreak = currentStreak;
    final now = DateTime.now();
    final completedToday = _sameDate(record.completedAt.toLocal(), now);
    if (completedToday && updatedStreak > previousStreak) {
      _streakAnimationFrom = previousStreak;
      _streakAnimationRevision++;
    }
    await _trainingScheduleRepository.ensureUpcoming(
      _trainingSettings,
      from: record.date,
      daysAhead: 0,
    );
    await _trainingScheduleRepository.setStatus(
      record.scheduledDate,
      'completed',
    );
    _scheduledSessions = await _trainingScheduleRepository.load();
    _hasActiveWorkout = false;
    _activeWorkoutDate = null;
    notifyListeners();
  }

  Future<void> refreshActiveWorkout() async {
    final draft = await _workoutLogRepository.loadActiveWorkout();
    _hasActiveWorkout = draft != null;
    _activeWorkoutDate = draft == null
        ? null
        : DateTime.parse(
            (jsonDecode(draft) as Map<String, Object?>)['scheduledDate']!
                as String,
          );
    if (draft == null) await _trainingScheduleRepository.resetInProgress();
    _scheduledSessions = await _trainingScheduleRepository.load();
    notifyListeners();
  }

  Future<void> markSessionStarted(DateTime date) async {
    await _trainingScheduleRepository.ensureUpcoming(
      _trainingSettings,
      from: date,
      daysAhead: 0,
    );
    await _trainingScheduleRepository.setStatus(date, 'in_progress');
    _scheduledSessions = await _trainingScheduleRepository.load();
    notifyListeners();
  }

  Future<void> savePersonalGoal(PersonalGoal goal) async {
    await _personalGoalRepository.save(goal);
    _personalGoals = await _personalGoalRepository.load();
    notifyListeners();
  }

  Future<void> deletePersonalGoal(String id) async {
    await _personalGoalRepository.delete(id);
    _personalGoals = await _personalGoalRepository.load();
    notifyListeners();
  }

  Future<void> saveBodyMeasurement(
    BodyMeasurement measurement, {
    BodyMeasurement? previous,
  }) async {
    if (previous != null && previous.id != measurement.id) {
      await _bodyMeasurementRepository.delete(previous.date);
    }
    await _bodyMeasurementRepository.save(measurement);
    _bodyMeasurements = await _bodyMeasurementRepository.load();
    notifyListeners();
  }

  Future<void> deleteBodyMeasurement(DateTime date) async {
    await _bodyMeasurementRepository.delete(date);
    _bodyMeasurements = await _bodyMeasurementRepository.load();
    notifyListeners();
  }

  Future<bool> rescheduleSession(DateTime from, DateTime to) async {
    final moved = await _trainingScheduleRepository.move(from, to);
    if (moved) {
      await _trainingScheduleRepository.ensureUpcoming(
        _trainingSettings,
        from: _scheduleWindowStart(DateTime.now()),
      );
      _scheduledSessions = await _trainingScheduleRepository.load();
      notifyListeners();
    }
    return moved;
  }

  Future<bool> skipSession(DateTime date) async {
    final changed = await _trainingScheduleRepository.skip(date);
    if (!changed) return false;
    _scheduledSessions = await _trainingScheduleRepository.load();
    notifyListeners();
    return true;
  }

  Future<bool> undoSkipSession(DateTime date) async {
    final changed = await _trainingScheduleRepository.undoSkip(date);
    if (!changed) return false;
    _scheduledSessions = await _trainingScheduleRepository.load();
    notifyListeners();
    return true;
  }

  Future<String> exportBackup({required String appearanceMode}) =>
      _backupRepository.exportJson(appearanceMode: appearanceMode);

  ValidatedForzaBackup validateBackup(String contents) =>
      _backupRepository.validate(contents);

  Future<void> restoreBackup(ValidatedForzaBackup backup) async {
    await _backupRepository.restore(backup);
    _trainingSettings = backup.settings;
    _workoutRecords = backup.records;
    _streakAnimationRevision = 0;
    _streakAnimationFrom = WorkoutStreakCalculator.currentStreak(
      _workoutRecords,
    );
    _scheduledSessions = backup.schedule;
    _personalGoals = backup.goals;
    _bodyMeasurements = backup.bodyMeasurements;
    _needsFirstRunSetup = false;
    _hasActiveWorkout = backup.activeWorkout != null;
    _activeWorkoutDate = backup.activeWorkout == null
        ? null
        : DateTime.parse(backup.activeWorkout!['scheduledDate']! as String);
    notifyListeners();
  }

  void _scheduleStreakRollover() {
    _streakRolloverTimer?.cancel();
    final now = DateTime.now();
    final nextMidnight = DateTime(now.year, now.month, now.day + 1);
    _streakRolloverTimer = Timer(nextMidnight.difference(now), () {
      notifyListeners();
      _scheduleStreakRollover();
    });
  }

  @override
  void dispose() {
    _streakRolloverTimer?.cancel();
    super.dispose();
  }

  static DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  static DateTime _scheduleWindowStart(DateTime date) =>
      _dateOnly(date).subtract(Duration(days: date.weekday - DateTime.monday));

  static bool _sameDate(DateTime first, DateTime second) =>
      first.year == second.year &&
      first.month == second.month &&
      first.day == second.day;
}
