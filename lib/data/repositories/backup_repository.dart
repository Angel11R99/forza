import 'dart:convert';

import 'package:drift/drift.dart';

import '../../domain/models/personal_goal.dart';
import '../../domain/models/body_measurement.dart';
import '../../domain/models/scheduled_training_session.dart';
import '../../domain/models/workout_record.dart';
import '../../domain/use_cases/training_plan_builder.dart';
import '../../ui/features/profile/models/profile_settings.dart';
import '../database/app_database.dart' as db;
import 'personal_goal_repository.dart';
import 'body_measurement_repository.dart';
import 'training_schedule_repository.dart';
import 'training_settings_repository.dart';
import 'workout_log_repository.dart';
import 'profile_settings_repository.dart';

class ValidatedForzaBackup {
  const ValidatedForzaBackup({
    required this.exportedAt,
    required this.settings,
    required this.planVersion,
    required this.records,
    required this.schedule,
    required this.goals,
    this.bodyMeasurements = const [],
    required this.appearanceMode,
    required this.activeWorkout,
    this.appPreferences = const AppPreferences(),
    this.notificationSettings = const NotificationSettings(),
    this.privacySettings = const PrivacySettings(),
    this.languageCode,
  });

  final DateTime exportedAt;
  final TrainingSettings settings;
  final int planVersion;
  final List<WorkoutRecord> records;
  final List<ScheduledTrainingSession> schedule;
  final List<PersonalGoal> goals;
  final List<BodyMeasurement> bodyMeasurements;
  final String appearanceMode;
  final Map<String, Object?>? activeWorkout;
  final AppPreferences appPreferences;
  final NotificationSettings notificationSettings;
  final PrivacySettings privacySettings;
  final String? languageCode;
}

class BackupRepository {
  BackupRepository({
    required this.database,
    required this.settingsRepository,
    required this.workoutLogRepository,
    required this.scheduleRepository,
    required this.goalRepository,
    BodyMeasurementRepository? bodyMeasurementRepository,
    ProfileSettingsRepository? profileSettingsRepository,
    this.readLanguageCode,
    this.writeLanguageCode,
  }) : bodyMeasurementRepository =
           bodyMeasurementRepository ??
           BodyMeasurementRepository(database: database),
       profileSettingsRepository =
           profileSettingsRepository ?? ProfileSettingsRepository();

  static const formatName = 'FORZA_BACKUP';
  static const version = 1;
  static const maxBackupBytes = 10 * 1024 * 1024;

  final db.AppDatabase database;
  final TrainingSettingsRepository settingsRepository;
  final WorkoutLogRepository workoutLogRepository;
  final TrainingScheduleRepository scheduleRepository;
  final PersonalGoalRepository goalRepository;
  final BodyMeasurementRepository bodyMeasurementRepository;
  final ProfileSettingsRepository profileSettingsRepository;
  final String? Function()? readLanguageCode;
  final Future<void> Function(String?)? writeLanguageCode;

  Future<String> exportJson({required String appearanceMode}) async {
    final activeDraft = await workoutLogRepository.loadActiveWorkout();
    return const JsonEncoder.withIndent('  ').convert({
      'format': formatName,
      'version': version,
      'exportedAt': DateTime.now().toIso8601String(),
      'languageCode': readLanguageCode?.call(),
      'trainingSettings': _settingsToJson(await settingsRepository.load()),
      'planVersion': await settingsRepository.currentPlanVersion,
      'workoutRecords': [
        for (final record in await workoutLogRepository.load()) record.toJson(),
      ],
      'scheduledSessions': [
        for (final session in await scheduleRepository.load())
          _scheduleToJson(session),
      ],
      'personalGoals': [
        for (final goal in await goalRepository.load()) _goalToJson(goal),
      ],
      'bodyMeasurements': [
        for (final measurement in await bodyMeasurementRepository.load())
          measurement.toJson(),
      ],
      'appearanceMode': appearanceMode,
      'activeWorkout': activeDraft == null ? null : jsonDecode(activeDraft),
      'appPreferences': _appPreferencesToJson(
        await profileSettingsRepository.loadAppPreferences(),
      ),
      'notificationSettings': _notificationSettingsToJson(
        await profileSettingsRepository.loadNotifications(),
      ),
      'privacySettings': _privacySettingsToJson(
        await profileSettingsRepository.loadPrivacy(),
      ),
    });
  }

  Future<void> clearLocalData() async {
    final defaults = const TrainingSettings();
    await restore(
      validate(
        jsonEncode({
          'format': formatName,
          'version': version,
          'exportedAt': DateTime.now().toIso8601String(),
          'languageCode': null,
          'trainingSettings': _settingsToJson(defaults),
          'planVersion': 1,
          'workoutRecords': const <Object?>[],
          'scheduledSessions': const <Object?>[],
          'personalGoals': const <Object?>[],
          'bodyMeasurements': const <Object?>[],
          'appearanceMode': 'system',
          'activeWorkout': null,
          'appPreferences': _appPreferencesToJson(const AppPreferences()),
          'notificationSettings': _notificationSettingsToJson(
            const NotificationSettings(),
          ),
          'privacySettings': _privacySettingsToJson(const PrivacySettings()),
        }),
      ),
    );
  }

  /// Combines snapshots against the last shared baseline. Local edits win
  /// conflicts; a deletion on either side is propagated when the other side
  /// has not edited that record since the baseline.
  String mergeJson(
    String localSource,
    String cloudSource, {
    String? baselineSource,
  }) {
    final local = validate(localSource);
    final cloud = validate(cloudSource);
    final baseline = baselineSource == null ? null : validate(baselineSource);
    final records = _mergeKeyedLists(
      local.records.map((record) => record.toJson()),
      cloud.records.map((record) => record.toJson()),
      baseline?.records.map((record) => record.toJson()),
      (record) => _key(DateTime.parse(record['scheduledDate'] as String)),
    );
    final schedule = _mergeKeyedLists(
      local.schedule.map(_scheduleToJson),
      cloud.schedule.map(_scheduleToJson),
      baseline?.schedule.map(_scheduleToJson),
      (session) => _key(DateTime.parse(session['scheduledDate'] as String)),
    );
    final goals = _mergeKeyedLists(
      local.goals.map(_goalToJson),
      cloud.goals.map(_goalToJson),
      baseline?.goals.map(_goalToJson),
      (goal) => goal['id'] as String,
    );
    final measurements = _mergeKeyedLists(
      local.bodyMeasurements.map((item) => item.toJson()),
      cloud.bodyMeasurements.map((item) => item.toJson()),
      baseline?.bodyMeasurements.map((item) => item.toJson()),
      (item) => item['date'] as String,
    );

    final localSettings = _settingsToJson(local.settings);
    final remoteSettings = _settingsToJson(cloud.settings);
    final baseSettings = baseline == null
        ? null
        : _settingsToJson(baseline.settings);

    return jsonEncode({
      'format': formatName,
      'version': version,
      'exportedAt': DateTime.now().toIso8601String(),
      'languageCode': baseline == null
          ? local.languageCode ?? cloud.languageCode
          : _chooseThreeWay(
              local.languageCode,
              cloud.languageCode,
              baseline.languageCode,
              hasBaseline: true,
            ),
      'trainingSettings': _chooseThreeWay(
        localSettings,
        remoteSettings,
        baseSettings,
        hasBaseline: baseline != null,
      ),
      'planVersion': _chooseThreeWay(
        local.planVersion,
        cloud.planVersion,
        baseline?.planVersion,
        hasBaseline: baseline != null,
      ),
      'workoutRecords': records,
      'scheduledSessions': schedule,
      'personalGoals': goals,
      'bodyMeasurements': measurements,
      'appearanceMode': _chooseThreeWay(
        local.appearanceMode,
        cloud.appearanceMode,
        baseline?.appearanceMode,
        hasBaseline: baseline != null,
      ),
      'activeWorkout': baseline == null
          ? local.activeWorkout ?? cloud.activeWorkout
          : _chooseThreeWay(
              local.activeWorkout,
              cloud.activeWorkout,
              baseline.activeWorkout,
              hasBaseline: true,
            ),
      'appPreferences': _chooseThreeWay(
        _appPreferencesToJson(local.appPreferences),
        _appPreferencesToJson(cloud.appPreferences),
        baseline == null
            ? null
            : _appPreferencesToJson(baseline.appPreferences),
        hasBaseline: baseline != null,
      ),
      'notificationSettings': _chooseThreeWay(
        _notificationSettingsToJson(local.notificationSettings),
        _notificationSettingsToJson(cloud.notificationSettings),
        baseline == null
            ? null
            : _notificationSettingsToJson(baseline.notificationSettings),
        hasBaseline: baseline != null,
      ),
      'privacySettings': _chooseThreeWay(
        _privacySettingsToJson(local.privacySettings),
        _privacySettingsToJson(cloud.privacySettings),
        baseline == null
            ? null
            : _privacySettingsToJson(baseline.privacySettings),
        hasBaseline: baseline != null,
      ),
    });
  }

  List<Map<String, Object?>> _mergeKeyedLists(
    Iterable<Map<String, Object?>> local,
    Iterable<Map<String, Object?>> cloud,
    Iterable<Map<String, Object?>>? baseline,
    String Function(Map<String, Object?>) keyOf,
  ) {
    Map<String, Map<String, Object?>> index(
      Iterable<Map<String, Object?>> values,
    ) => {for (final value in values) keyOf(value): value};

    final localByKey = index(local);
    final cloudByKey = index(cloud);
    if (baseline == null) {
      return {...cloudByKey, ...localByKey}.values.toList(growable: false);
    }

    final baseByKey = index(baseline);
    final allKeys = {...localByKey.keys, ...cloudByKey.keys, ...baseByKey.keys};
    final result = <Map<String, Object?>>[];
    for (final key in allKeys) {
      final localValue = localByKey[key];
      final remoteValue = cloudByKey[key];
      final baseValue = baseByKey[key];
      final localChanged = !_sameValue(localValue, baseValue);
      final chosen = localChanged ? localValue : remoteValue;
      if (chosen != null) result.add(chosen);
    }
    return result;
  }

  Object? _chooseThreeWay(
    Object? local,
    Object? cloud,
    Object? baseline, {
    required bool hasBaseline,
  }) => hasBaseline && _sameValue(local, baseline) ? cloud : local;

  bool _sameValue(Object? first, Object? second) =>
      jsonEncode(_canonicalValue(first)) == jsonEncode(_canonicalValue(second));

  Object? _canonicalValue(Object? value) {
    if (value is Map) {
      final keys = value.keys.cast<String>().toList()..sort();
      return <String, Object?>{
        for (final key in keys) key: _canonicalValue(value[key]),
      };
    }
    if (value is List) return value.map(_canonicalValue).toList();
    return value;
  }

  ValidatedForzaBackup validate(String source) {
    if (utf8.encode(source).length > maxBackupBytes) {
      throw const FormatException('El archivo supera el límite de 10 MB.');
    }
    try {
      final root = _map(jsonDecode(source), 'respaldo');
      if (root['format'] != formatName || root['version'] != version) {
        throw const FormatException(
          'El archivo no es un respaldo FORZA compatible.',
        );
      }
      final appearance = root['appearanceMode'];
      if (appearance is! String ||
          !const {'system', 'light', 'dark'}.contains(appearance)) {
        throw const FormatException('La apariencia del respaldo no es válida.');
      }
      final records = _list(
        root['workoutRecords'],
        'workoutRecords',
      ).map((value) => _record(value)).toList(growable: false);
      final recordDates = records.map((record) => _key(record.date)).toSet();
      if (recordDates.length != records.length) {
        throw const FormatException(
          'El respaldo contiene sesiones repetidas en una misma fecha.',
        );
      }
      final schedule = _list(
        root['scheduledSessions'],
        'scheduledSessions',
      ).map(_schedule).toList(growable: false);
      final scheduleDates = schedule
          .map((session) => _key(session.scheduledDate))
          .toSet();
      if (scheduleDates.length != schedule.length) {
        throw const FormatException(
          'El respaldo contiene sesiones de agenda duplicadas.',
        );
      }
      final goals = _list(
        root['personalGoals'],
        'personalGoals',
      ).map(_goal).toList(growable: false);
      if (goals.map((goal) => goal.id).toSet().length != goals.length) {
        throw const FormatException(
          'El respaldo contiene objetivos duplicados.',
        );
      }
      final measurements =
          (root['bodyMeasurements'] == null
                  ? const <Object?>[]
                  : _list(root['bodyMeasurements'], 'bodyMeasurements'))
              .map(
                (value) =>
                    BodyMeasurement.fromJson(_map(value, 'body measurement')),
              )
              .toList(growable: false);
      if (measurements.map((item) => item.id).toSet().length !=
          measurements.length) {
        throw const FormatException(
          'El respaldo contiene medidas corporales duplicadas.',
        );
      }
      final activeWorkout = root['activeWorkout'] == null
          ? null
          : _activeDraft(root['activeWorkout']);
      final planVersion = root['planVersion'] == null
          ? 1
          : _integer(root['planVersion'], 'planVersion');
      if (planVersion < 1) {
        throw const FormatException('La versión del plan no es válida.');
      }
      return ValidatedForzaBackup(
        exportedAt: DateTime.parse(_string(root['exportedAt'], 'exportedAt')),
        languageCode: _languageCode(root['languageCode']),
        settings: _settings(root['trainingSettings']),
        planVersion: planVersion,
        records: records,
        schedule: schedule,
        goals: goals,
        bodyMeasurements: measurements,
        appearanceMode: appearance,
        activeWorkout: activeWorkout,
        appPreferences: _appPreferences(root['appPreferences']),
        notificationSettings: _notificationSettings(
          root['notificationSettings'],
        ),
        privacySettings: _privacySettings(root['privacySettings']),
      );
    } on FormatException {
      rethrow;
    } on Object {
      throw const FormatException(
        'El archivo está dañado o contiene datos que FORZA no reconoce.',
      );
    }
  }

  Future<void> restore(ValidatedForzaBackup backup) async {
    final now = DateTime.now().toIso8601String();
    await database.transaction(() async {
      await database.delete(database.workoutSessions).go();
      await database.delete(database.scheduledTrainingSessions).go();
      await database.delete(database.personalGoals).go();
      await database.delete(database.trainingPlans).go();

      await database
          .into(database.trainingPlans)
          .insert(
            db.TrainingPlansCompanion.insert(
              id: db.AppDatabase.activePlanId,
              goal: backup.settings.goal,
              experience: backup.settings.experience,
              sessionMinutes: backup.settings.sessionMinutes,
              avoidedExerciseIds: Value(
                jsonEncode(backup.settings.avoidedExerciseIds.toList()..sort()),
              ),
              version: Value(backup.planVersion),
              createdAt: now,
              updatedAt: now,
              isActive: const Value(true),
            ),
          );
      final days = backup.settings.trainingDays.toList()..sort();
      await database.batch((batch) {
        batch.insertAll(database.trainingPlanDays, [
          for (var index = 0; index < days.length; index++)
            db.TrainingPlanDaysCompanion.insert(
              planId: db.AppDatabase.activePlanId,
              weekday: days[index],
              orderIndex: index,
            ),
        ]);
        batch.insertAll(database.trainingPlanEquipment, [
          for (final item in backup.settings.equipment.toList()..sort())
            db.TrainingPlanEquipmentCompanion.insert(
              planId: db.AppDatabase.activePlanId,
              equipment: item,
            ),
        ]);
      });

      for (final record in backup.records) {
        final id = _key(record.date);
        await database
            .into(database.workoutSessions)
            .insert(
              db.WorkoutSessionsCompanion.insert(
                id: id,
                planId: const Value(db.AppDatabase.activePlanId),
                scheduledDate: record.date.toIso8601String(),
                completedAt: record.completedAt.toIso8601String(),
                title: record.title,
                goal: record.goal,
                planVersion: Value(record.planVersion),
                planSnapshot: Value(
                  record.planSnapshot.isEmpty ? null : record.planSnapshot,
                ),
                durationMinutes: record.durationMinutes,
                exerciseCount: record.exerciseCount,
                completedOutsideApp: record.completedOutsideApp,
              ),
            );
        if (record.exercises.isNotEmpty) {
          await database.batch((batch) {
            batch.insertAll(database.workoutSessionExercises, [
              for (var index = 0; index < record.exercises.length; index++)
                db.WorkoutSessionExercisesCompanion.insert(
                  sessionId: id,
                  position: index < record.exercisePositions.length
                      ? record.exercisePositions[index]
                      : index,
                  name: record.exercises[index],
                  catalogId: Value(
                    index < record.exerciseIds.length
                        ? record.exerciseIds[index]
                        : null,
                  ),
                ),
            ]);
          });
        }
        if (record.setResults.isNotEmpty) {
          await database.batch((batch) {
            batch.insertAll(database.workoutSetEntries, [
              for (final set in record.setResults)
                db.WorkoutSetEntriesCompanion.insert(
                  sessionId: id,
                  exercisePosition: set.exercisePosition,
                  setIndex: set.setIndex,
                  repetitions: Value(set.repetitions),
                  loadKg: Value(set.loadKg),
                  durationSeconds: Value(set.durationSeconds),
                ),
            ]);
          });
        }
      }

      await database.batch((batch) {
        batch.insertAll(database.scheduledTrainingSessions, [
          for (final session in backup.schedule)
            db.ScheduledTrainingSessionsCompanion.insert(
              id: _key(session.scheduledDate),
              scheduledDate: _key(session.scheduledDate),
              originalDate: Value(
                session.originalDate == null
                    ? null
                    : _key(session.originalDate!),
              ),
              sessionIndex: session.sessionIndex,
              title: session.title,
              focus: session.focus,
              durationMinutes: session.durationMinutes,
              exerciseCount: session.exerciseCount,
              planVersion: Value(session.planVersion),
              planSnapshot: Value(session.planSnapshot),
              status: Value(session.status),
            ),
        ]);
        batch.insertAll(database.personalGoals, [
          for (final goal in backup.goals)
            db.PersonalGoalsCompanion.insert(
              id: goal.id,
              type: goal.type.name,
              targetValue: goal.targetValue,
              exerciseName: Value(goal.exerciseName),
              exerciseCatalogId: Value(goal.exerciseCatalogId),
              createdAt: goal.createdAt.toIso8601String(),
            ),
        ]);
      });

      await bodyMeasurementRepository.replaceAll(backup.bodyMeasurements);
      await profileSettingsRepository.saveAppPreferences(backup.appPreferences);
      await profileSettingsRepository.saveNotifications(
        backup.notificationSettings,
      );
      await profileSettingsRepository.savePrivacy(backup.privacySettings);
      await writeLanguageCode?.call(backup.languageCode);

      await database
          .into(database.appMetadata)
          .insertOnConflictUpdate(
            db.AppMetadataCompanion.insert(
              key: 'training_setup_complete',
              value: 'true',
            ),
          );
      await (database.delete(
        database.appMetadata,
      )..where((row) => row.key.equals('active_workout_v1'))).go();
      if (backup.activeWorkout != null) {
        await database
            .into(database.appMetadata)
            .insertOnConflictUpdate(
              db.AppMetadataCompanion.insert(
                key: 'active_workout_v1',
                value: jsonEncode(backup.activeWorkout),
              ),
            );
      }
    });
  }

  static WorkoutRecord _record(Object? value) {
    final record = WorkoutRecord.fromJson(_map(value, 'sesión'));
    if (record.title.trim().isEmpty ||
        record.durationMinutes < 1 ||
        record.durationMinutes > 1440 ||
        record.exerciseCount < 0 ||
        record.planVersion < 1 ||
        (record.exerciseIds.isNotEmpty &&
            record.exerciseIds.length != record.exercises.length) ||
        (record.exercisePositions.isNotEmpty &&
            (record.exercisePositions.length != record.exercises.length ||
                record.exercisePositions.any((position) => position < 0) ||
                record.exercisePositions.toSet().length !=
                    record.exercisePositions.length)) ||
        record.setResults.any(
          (set) =>
              set.exercisePosition < 0 ||
              (record.exercisePositions.isEmpty
                  ? set.exercisePosition >= record.exercises.length
                  : !record.exercisePositions.contains(set.exercisePosition)) ||
              set.setIndex < 0 ||
              (set.repetitions != null && set.repetitions! < 0) ||
              (set.loadKg != null &&
                  (!set.loadKg!.isFinite || set.loadKg! < 0)) ||
              (set.durationSeconds != null && set.durationSeconds! < 0),
        )) {
      throw const FormatException('Una sesión contiene datos fuera de rango.');
    }
    if (record.planSnapshot.isNotEmpty) {
      final snapshot = _map(jsonDecode(record.planSnapshot), 'planSnapshot');
      PlannedTrainingSession.fromJson(snapshot);
    }
    return record;
  }

  static ScheduledTrainingSession _schedule(Object? value) {
    final json = _map(value, 'sesión programada');
    final date = _date(json['scheduledDate'], 'scheduledDate');
    final original = json['originalDate'] == null
        ? null
        : _date(json['originalDate'], 'originalDate');
    final status = _string(json['status'], 'status');
    final index = _integer(json['sessionIndex'], 'sessionIndex');
    final duration = _integer(json['durationMinutes'], 'durationMinutes');
    final count = _integer(json['exerciseCount'], 'exerciseCount');
    if (index < 0 ||
        index > 20 ||
        duration < 1 ||
        duration > 240 ||
        count < 0) {
      throw const FormatException('Una sesión programada no es válida.');
    }
    if (!const {
      'pending',
      'in_progress',
      'completed',
      'skipped',
    }.contains(status)) {
      throw const FormatException('El estado de una sesión no es válido.');
    }
    final planVersion = json['planVersion'] as int? ?? 1;
    final planSnapshot = json['planSnapshot'] as String? ?? '';
    if (planVersion < 1) {
      throw const FormatException('La versión de rutina no es válida.');
    }
    if (planSnapshot.isNotEmpty) {
      PlannedTrainingSession.fromJson(
        _map(jsonDecode(planSnapshot), 'planSnapshot'),
      );
    }
    return ScheduledTrainingSession(
      id: _string(json['id'], 'id'),
      scheduledDate: date,
      originalDate: original,
      sessionIndex: index,
      title: _string(json['title'], 'title'),
      focus: _string(json['focus'], 'focus'),
      durationMinutes: duration,
      exerciseCount: count,
      status: status,
      planVersion: planVersion,
      planSnapshot: planSnapshot,
    );
  }

  static PersonalGoal _goal(Object? value) {
    final json = _map(value, 'objetivo');
    final typeName = _string(json['type'], 'type');
    final type = PersonalGoalType.values.where((item) => item.name == typeName);
    if (type.isEmpty) {
      throw const FormatException('El tipo de objetivo no es válido.');
    }
    final target = _number(json['targetValue'], 'targetValue');
    final exercise = json['exerciseName'];
    final exerciseCatalogId = json['exerciseCatalogId'];
    if (target <= 0 ||
        (exerciseCatalogId != null &&
            (exerciseCatalogId is! String ||
                exerciseCatalogId.trim().isEmpty)) ||
        (type.first == PersonalGoalType.sessionsPerWeek &&
            (target > 7 || target != target.roundToDouble())) ||
        (type.first == PersonalGoalType.exerciseLoad &&
            (exercise is! String || exercise.trim().isEmpty))) {
      throw const FormatException('Un objetivo contiene datos fuera de rango.');
    }
    return PersonalGoal(
      id: _string(json['id'], 'id'),
      type: type.first,
      targetValue: target,
      exerciseName: exercise as String?,
      exerciseCatalogId: exerciseCatalogId as String?,
      createdAt: _date(json['createdAt'], 'createdAt'),
    );
  }

  static TrainingSettings _settings(Object? value) {
    final json = _map(value, 'trainingSettings');
    final days = _list(
      json['trainingDays'],
      'trainingDays',
    ).map((value) => _integer(value, 'trainingDays')).toList(growable: false);
    final equipment = _list(
      json['equipment'],
      'equipment',
    ).map((value) => _string(value, 'equipment')).toSet();
    final avoidedExerciseIds = json.containsKey('avoidedExerciseIds')
        ? _list(
            json['avoidedExerciseIds'],
            'avoidedExerciseIds',
          ).map((value) => _string(value, 'avoidedExerciseIds')).toSet()
        : <String>{};
    final minutes = _integer(json['sessionMinutes'], 'sessionMinutes');
    final goal = _string(json['goal'], 'goal');
    final experience = _string(json['experience'], 'experience');
    if (days.toSet().length != days.length ||
        (json['avoidedExerciseIds'] is List &&
            (json['avoidedExerciseIds'] as List).length !=
                avoidedExerciseIds.length) ||
        days.any((day) => day < 1 || day > 7) ||
        minutes < 20 ||
        minutes > 90 ||
        goal.isEmpty ||
        experience.isEmpty) {
      throw const FormatException('El plan contiene valores no válidos.');
    }
    TrainingPlanBuilder.validateSettings(
      trainingDays: days.toSet(),
      sessionMinutes: minutes,
      goal: goal,
      experience: experience,
      equipment: equipment,
      avoidedExerciseIds: avoidedExerciseIds,
    );
    return TrainingSettings(
      trainingDays: days.toSet(),
      sessionMinutes: minutes,
      goal: goal,
      experience: experience,
      equipment: equipment,
      avoidedExerciseIds: avoidedExerciseIds,
    );
  }

  static Map<String, Object?>? _activeDraft(Object? value) {
    final json = _map(value, 'activeWorkout');
    _date(json['scheduledDate'], 'scheduledDate');
    final current = _integer(json['currentExercise'], 'currentExercise');
    final elapsed = _integer(json['elapsedSeconds'], 'elapsedSeconds');
    final rest = _integer(json['remainingRestSeconds'], 'remainingRestSeconds');
    final screen = _string(json['resumeScreen'], 'resumeScreen');
    if (current < 0 ||
        elapsed < 0 ||
        rest < 0 ||
        rest > 3600 ||
        !const {
          'preparation',
          'warmup',
          'exerciseList',
          'rest',
          'confirmAbandon',
          'completed',
          'summary',
        }.contains(screen)) {
      throw const FormatException(
        'La sesión activa del respaldo no es válida.',
      );
    }
    final sets = _list(json['sets'], 'sets');
    for (final value in sets) {
      final set = WorkoutSetResult.fromJson(_map(value, 'serie'));
      if (set.exercisePosition < 0 ||
          set.setIndex < 0 ||
          (set.repetitions != null && set.repetitions! < 0) ||
          (set.loadKg != null && (!set.loadKg!.isFinite || set.loadKg! < 0)) ||
          (set.durationSeconds != null && set.durationSeconds! < 0)) {
        throw const FormatException(
          'Una serie de la sesión activa no es válida.',
        );
      }
    }
    return json;
  }

  static String? _languageCode(Object? value) {
    if (value == null) return null;
    if (value is String && const {'en', 'es'}.contains(value)) return value;
    throw const FormatException('El idioma del respaldo no es válido.');
  }

  static AppPreferences _appPreferences(Object? value) {
    if (value == null) return const AppPreferences();
    final json = _map(value, 'appPreferences');
    final unit = json['weightUnit'];
    final weekStartsOn = json['weekStartsOn'];
    final hapticsEnabled = json['hapticsEnabled'];
    final showNavigationLabels = json['showNavigationLabels'];
    if (!const {'kg', 'lb'}.contains(unit) ||
        !const {'Lunes', 'Domingo'}.contains(weekStartsOn) ||
        hapticsEnabled is! bool ||
        (showNavigationLabels != null && showNavigationLabels is! bool)) {
      throw const FormatException(
        'Las preferencias de la aplicación no son válidas.',
      );
    }
    return AppPreferences(
      weightUnit: unit as String,
      weekStartsOn: weekStartsOn as String,
      hapticsEnabled: hapticsEnabled,
      showNavigationLabels: showNavigationLabels as bool? ?? true,
    );
  }

  static NotificationSettings _notificationSettings(Object? value) {
    if (value == null) return const NotificationSettings();
    final json = _map(value, 'notificationSettings');
    final enabled = json['workoutReminders'];
    final hour = json['reminderHour'];
    final minute = json['reminderMinute'];
    if (enabled is! bool ||
        hour is! int ||
        hour < 0 ||
        hour > 23 ||
        minute is! int ||
        minute < 0 ||
        minute > 59) {
      throw const FormatException(
        'Los ajustes de notificaciones no son válidos.',
      );
    }
    return NotificationSettings(
      workoutReminders: enabled,
      reminderHour: hour,
      reminderMinute: minute,
    );
  }

  static PrivacySettings _privacySettings(Object? value) {
    if (value == null) return const PrivacySettings();
    final json = _map(value, 'privacySettings');
    final privateProfile = json['privateProfile'];
    final shareActivity = json['shareWorkoutActivity'];
    if (privateProfile is! bool || shareActivity is! bool) {
      throw const FormatException('Los ajustes de privacidad no son válidos.');
    }
    return PrivacySettings(
      privateProfile: privateProfile,
      shareWorkoutActivity: shareActivity,
    );
  }

  static Map<String, Object?> _appPreferencesToJson(
    AppPreferences preferences,
  ) => {
    'weightUnit': preferences.weightUnit,
    'weekStartsOn': preferences.weekStartsOn,
    'hapticsEnabled': preferences.hapticsEnabled,
    'showNavigationLabels': preferences.showNavigationLabels,
  };

  static Map<String, Object?> _notificationSettingsToJson(
    NotificationSettings settings,
  ) => {
    'workoutReminders': settings.workoutReminders,
    'reminderHour': settings.reminderHour,
    'reminderMinute': settings.reminderMinute,
  };

  static Map<String, Object?> _privacySettingsToJson(
    PrivacySettings settings,
  ) => {
    'privateProfile': settings.privateProfile,
    'shareWorkoutActivity': settings.shareWorkoutActivity,
  };

  static Map<String, Object?> _settingsToJson(TrainingSettings settings) => {
    'trainingDays': settings.trainingDays.toList()..sort(),
    'sessionMinutes': settings.sessionMinutes,
    'goal': settings.goal,
    'experience': settings.experience,
    'equipment': settings.equipment.toList()..sort(),
    'avoidedExerciseIds': settings.avoidedExerciseIds.toList()..sort(),
  };

  static Map<String, Object?> _scheduleToJson(
    ScheduledTrainingSession session,
  ) => {
    'id': session.id,
    'scheduledDate': session.scheduledDate.toIso8601String(),
    'originalDate': session.originalDate?.toIso8601String(),
    'sessionIndex': session.sessionIndex,
    'title': session.title,
    'focus': session.focus,
    'durationMinutes': session.durationMinutes,
    'exerciseCount': session.exerciseCount,
    'planVersion': session.planVersion,
    'planSnapshot': session.planSnapshot,
    'status': session.status,
  };

  static Map<String, Object?> _goalToJson(PersonalGoal goal) => {
    'id': goal.id,
    'type': goal.type.name,
    'targetValue': goal.targetValue,
    'exerciseName': goal.exerciseName,
    'exerciseCatalogId': goal.exerciseCatalogId,
    'createdAt': goal.createdAt.toIso8601String(),
  };

  static Map<String, Object?> _map(Object? value, String label) {
    if (value is! Map) {
      throw FormatException('El campo $label debe ser un objeto.');
    }
    return Map<String, Object?>.from(value);
  }

  static List<Object?> _list(Object? value, String label) {
    if (value is! List<Object?>) {
      throw FormatException('El campo $label debe ser una lista.');
    }
    return value;
  }

  static String _string(Object? value, String label) {
    if (value is! String || value.trim().isEmpty) {
      throw FormatException('El campo $label debe ser un texto.');
    }
    return value;
  }

  static int _integer(Object? value, String label) {
    if (value is! int) {
      throw FormatException('El campo $label debe ser entero.');
    }
    return value;
  }

  static double _number(Object? value, String label) {
    if (value is! num || !value.isFinite) {
      throw FormatException('El campo $label debe ser numérico.');
    }
    return value.toDouble();
  }

  static DateTime _date(Object? value, String label) {
    final string = _string(value, label);
    final date = DateTime.tryParse(string);
    if (date == null) throw FormatException('La fecha $label no es válida.');
    return date;
  }

  static String _key(DateTime date) =>
      DateTime(date.year, date.month, date.day).toIso8601String();
}
