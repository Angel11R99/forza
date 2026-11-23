import 'package:drift/drift.dart';

import 'dart:convert';

import '../database/app_database.dart';
import '../../domain/models/workout_record.dart';

class WorkoutLogRepository {
  WorkoutLogRepository({required this.database});

  final AppDatabase database;
  static const _activeWorkoutKey = 'active_workout_v1';

  Future<String?> loadActiveWorkout() async {
    final row = await (database.select(
      database.appMetadata,
    )..where((entry) => entry.key.equals(_activeWorkoutKey))).getSingleOrNull();
    return row?.value;
  }

  Future<void> saveActiveWorkout(Map<String, Object?> state) async {
    await database
        .into(database.appMetadata)
        .insertOnConflictUpdate(
          AppMetadataCompanion.insert(
            key: _activeWorkoutKey,
            value: jsonEncode(state),
          ),
        );
  }

  Future<void> clearActiveWorkout() async {
    await (database.delete(
      database.appMetadata,
    )..where((entry) => entry.key.equals(_activeWorkoutKey))).go();
  }

  Future<List<WorkoutRecord>> load() async {
    final sessions = await (database.select(
      database.workoutSessions,
    )..orderBy([(row) => OrderingTerm.asc(row.scheduledDate)])).get();
    final records = <WorkoutRecord>[];

    for (final session in sessions) {
      final exercises =
          await (database.select(database.workoutSessionExercises)
                ..where((row) => row.sessionId.equals(session.id))
                ..orderBy([(row) => OrderingTerm.asc(row.position)]))
              .get();
      final sets =
          await (database.select(database.workoutSetEntries)
                ..where((row) => row.sessionId.equals(session.id))
                ..orderBy([
                  (row) => OrderingTerm.asc(row.exercisePosition),
                  (row) => OrderingTerm.asc(row.setIndex),
                ]))
              .get();
      records.add(
        WorkoutRecord(
          scheduledDate: DateTime.parse(session.scheduledDate),
          completedAt: DateTime.parse(session.completedAt),
          title: session.title,
          goal: session.goal,
          durationMinutes: session.durationMinutes,
          exerciseCount: session.exerciseCount,
          exercises: exercises.map((row) => row.name).toList(growable: false),
          completedOutsideApp: session.completedOutsideApp,
          setResults: sets
              .map(
                (set) => WorkoutSetResult(
                  exercisePosition: set.exercisePosition,
                  setIndex: set.setIndex,
                  repetitions: set.repetitions,
                  loadKg: set.loadKg,
                  durationSeconds: set.durationSeconds,
                ),
              )
              .toList(growable: false),
        ),
      );
    }

    return List.unmodifiable(records);
  }

  Future<List<WorkoutRecord>> save(WorkoutRecord record) async {
    final date = record.date;
    final id = date.toIso8601String();
    await database.transaction(() async {
      final activePlan =
          await (database.select(database.trainingPlans)
                ..where((row) => row.id.equals(AppDatabase.activePlanId)))
              .getSingleOrNull();
      await (database.delete(
        database.workoutSessions,
      )..where((row) => row.id.equals(id))).go();
      await database
          .into(database.workoutSessions)
          .insert(
            WorkoutSessionsCompanion.insert(
              id: id,
              planId: Value(activePlan?.id),
              scheduledDate: date.toIso8601String(),
              completedAt: record.completedAt.toIso8601String(),
              title: record.title,
              goal: record.goal,
              durationMinutes: record.durationMinutes,
              exerciseCount: record.exerciseCount,
              completedOutsideApp: record.completedOutsideApp,
            ),
          );

      final exerciseNames = record.exercises;
      if (exerciseNames.isNotEmpty) {
        await database.batch((batch) {
          batch.insertAll(database.workoutSessionExercises, [
            for (var index = 0; index < exerciseNames.length; index++)
              WorkoutSessionExercisesCompanion.insert(
                sessionId: id,
                position: index,
                name: exerciseNames[index],
              ),
          ]);
        });
      }
      if (record.setResults.isNotEmpty) {
        await database.batch((batch) {
          batch.insertAll(database.workoutSetEntries, [
            for (final set in record.setResults)
              WorkoutSetEntriesCompanion.insert(
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
    });
    return load();
  }
}
