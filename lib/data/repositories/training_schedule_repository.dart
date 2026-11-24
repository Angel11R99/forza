import 'dart:convert';

import 'package:drift/drift.dart';

import '../../domain/models/scheduled_training_session.dart';
import '../../domain/use_cases/training_plan_builder.dart';
import '../../ui/features/profile/models/profile_settings.dart';
import '../database/app_database.dart' as db;

class TrainingScheduleRepository {
  TrainingScheduleRepository({required this.database});

  final db.AppDatabase database;
  static const _builder = TrainingPlanBuilder();

  Future<List<ScheduledTrainingSession>> load() async {
    final rows = await (database.select(
      database.scheduledTrainingSessions,
    )..orderBy([(row) => OrderingTerm.asc(row.scheduledDate)])).get();
    return List.unmodifiable(rows.map(_toModel));
  }

  Future<void> ensureUpcoming(
    TrainingSettings settings, {
    required DateTime from,
    int daysAhead = 120,
  }) async {
    final start = _dateOnly(from);
    final weekdays = settings.trainingDays.toList()..sort();
    final sessions = _builder.buildWeek(
      trainingDays: settings.trainingDays,
      sessionMinutes: settings.sessionMinutes,
      goal: settings.goal,
      experience: settings.experience,
      equipment: settings.equipment,
    );
    final activePlan =
        await (database.select(database.trainingPlans)
              ..where((row) => row.id.equals(db.AppDatabase.activePlanId)))
            .getSingleOrNull();
    final planVersion = activePlan?.version ?? 1;
    await database.transaction(() async {
      for (var offset = 0; offset <= daysAhead; offset++) {
        final date = start.add(Duration(days: offset));
        final index = weekdays.indexOf(date.weekday);
        if (index < 0 || index >= sessions.length) continue;
        final session = sessions[index];
        final id = _key(date);
        final existing = await (database.select(
          database.scheduledTrainingSessions,
        )..where((row) => row.scheduledDate.equals(id))).getSingleOrNull();
        if (existing == null) {
          await database
              .into(database.scheduledTrainingSessions)
              .insert(
                _companion(
                  id: id,
                  date: date,
                  index: index,
                  title: session.title,
                  focus: session.focus,
                  duration: session.durationMinutes,
                  exerciseCount: session.exercises.length,
                  planVersion: planVersion,
                  planSnapshot: jsonEncode(session.toJson()),
                ),
              );
        } else if (existing.originalDate == null &&
            existing.status == 'pending') {
          await (database.update(
            database.scheduledTrainingSessions,
          )..where((row) => row.id.equals(existing.id))).write(
            db.ScheduledTrainingSessionsCompanion(
              sessionIndex: Value(index),
              title: Value(session.title),
              focus: Value(session.focus),
              durationMinutes: Value(session.durationMinutes),
              exerciseCount: Value(session.exercises.length),
              planVersion: Value(planVersion),
              planSnapshot: Value(jsonEncode(session.toJson())),
            ),
          );
        }
      }

      final obsolete =
          await (database.select(database.scheduledTrainingSessions)..where(
                (row) => row.scheduledDate.isBiggerOrEqualValue(_key(start)),
              ))
              .get();
      for (final row in obsolete) {
        if (row.originalDate == null &&
            row.status == 'pending' &&
            !settings.trainingDays.contains(
              DateTime.parse(row.scheduledDate).weekday,
            )) {
          await (database.delete(
            database.scheduledTrainingSessions,
          )..where((entry) => entry.id.equals(row.id))).go();
        }
      }
    });
  }

  Future<bool> move(DateTime from, DateTime to) async {
    final sourceKey = _key(from);
    final targetKey = _key(to);
    if (sourceKey == targetKey) return false;
    return database.transaction(() async {
      final source = await (database.select(
        database.scheduledTrainingSessions,
      )..where((row) => row.scheduledDate.equals(sourceKey))).getSingleOrNull();
      if (source == null || source.status != 'pending') return false;
      final target = await (database.select(
        database.scheduledTrainingSessions,
      )..where((row) => row.scheduledDate.equals(targetKey))).getSingleOrNull();
      if (target != null) return false;
      await (database.update(
        database.scheduledTrainingSessions,
      )..where((row) => row.id.equals(source.id))).write(
        db.ScheduledTrainingSessionsCompanion(
          id: Value(targetKey),
          scheduledDate: Value(targetKey),
          originalDate: Value(source.originalDate ?? sourceKey),
        ),
      );
      return true;
    });
  }

  Future<void> setStatus(DateTime date, String status) async {
    if (!const {
      'pending',
      'in_progress',
      'completed',
      'skipped',
    }.contains(status)) {
      throw ArgumentError.value(status, 'status', 'Unsupported session status');
    }
    await (database.update(database.scheduledTrainingSessions)
          ..where((row) => row.scheduledDate.equals(_key(date))))
        .write(db.ScheduledTrainingSessionsCompanion(status: Value(status)));
  }

  Future<bool> skip(DateTime date) async {
    final changed =
        await (database.update(database.scheduledTrainingSessions)..where(
              (row) =>
                  row.scheduledDate.equals(_key(date)) &
                  row.status.equals('pending'),
            ))
            .write(
              const db.ScheduledTrainingSessionsCompanion(
                status: Value('skipped'),
              ),
            );
    return changed == 1;
  }

  Future<bool> undoSkip(DateTime date) async {
    final changed =
        await (database.update(database.scheduledTrainingSessions)..where(
              (row) =>
                  row.scheduledDate.equals(_key(date)) &
                  row.status.equals('skipped'),
            ))
            .write(
              const db.ScheduledTrainingSessionsCompanion(
                status: Value('pending'),
              ),
            );
    return changed == 1;
  }

  Future<void> resetInProgress() async {
    await (database.update(
      database.scheduledTrainingSessions,
    )..where((row) => row.status.equals('in_progress'))).write(
      const db.ScheduledTrainingSessionsCompanion(status: Value('pending')),
    );
  }

  static ScheduledTrainingSession _toModel(db.ScheduledTrainingSession row) =>
      ScheduledTrainingSession(
        id: row.id,
        scheduledDate: DateTime.parse(row.scheduledDate),
        originalDate: row.originalDate == null
            ? null
            : DateTime.parse(row.originalDate!),
        sessionIndex: row.sessionIndex,
        title: row.title,
        focus: row.focus,
        durationMinutes: row.durationMinutes,
        exerciseCount: row.exerciseCount,
        status: row.status,
        planVersion: row.planVersion,
        planSnapshot: row.planSnapshot,
      );

  static db.ScheduledTrainingSessionsCompanion _companion({
    required String id,
    required DateTime date,
    required int index,
    required String title,
    required String focus,
    required int duration,
    required int exerciseCount,
    required int planVersion,
    required String planSnapshot,
  }) => db.ScheduledTrainingSessionsCompanion.insert(
    id: id,
    scheduledDate: _key(date),
    sessionIndex: index,
    title: title,
    focus: focus,
    durationMinutes: duration,
    exerciseCount: exerciseCount,
    planVersion: Value(planVersion),
    planSnapshot: Value(planSnapshot),
  );

  static DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);
  static String _key(DateTime date) => _dateOnly(date).toIso8601String();
}
