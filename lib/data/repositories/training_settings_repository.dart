import 'dart:convert';

import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../../ui/features/profile/models/profile_settings.dart';
import '../../domain/use_cases/training_plan_builder.dart';

class TrainingSettingsRepository {
  TrainingSettingsRepository({required this.database});

  static const activePlanId = AppDatabase.activePlanId;
  static const _setupCompleteKey = 'training_setup_complete';

  final AppDatabase database;

  Future<bool> get setupComplete async {
    final saved = await (database.select(
      database.appMetadata,
    )..where((row) => row.key.equals(_setupCompleteKey))).getSingleOrNull();
    return saved?.value == 'true';
  }

  Future<TrainingSettings> load() async {
    final plan = await (database.select(
      database.trainingPlans,
    )..where((row) => row.id.equals(activePlanId))).getSingleOrNull();
    if (plan == null) return const TrainingSettings();

    final days =
        await (database.select(database.trainingPlanDays)
              ..where((row) => row.planId.equals(activePlanId))
              ..orderBy([(row) => OrderingTerm.asc(row.orderIndex)]))
            .get();
    final equipment = await (database.select(
      database.trainingPlanEquipment,
    )..where((row) => row.planId.equals(activePlanId))).get();
    final avoidedExerciseIds = (jsonDecode(plan.avoidedExerciseIds) as List)
        .whereType<String>()
        .toSet();

    return TrainingSettings(
      trainingDays: days.map((row) => row.weekday).toSet(),
      sessionMinutes: plan.sessionMinutes,
      goal: plan.goal,
      experience: plan.experience,
      equipment: equipment.map((row) => row.equipment).toSet(),
      avoidedExerciseIds: avoidedExerciseIds,
    );
  }

  Future<int> get currentPlanVersion async {
    final plan = await (database.select(
      database.trainingPlans,
    )..where((row) => row.id.equals(activePlanId))).getSingleOrNull();
    return plan?.version ?? 1;
  }

  Future<int> save(TrainingSettings settings) async {
    TrainingPlanBuilder.validateSettings(
      trainingDays: settings.trainingDays,
      sessionMinutes: settings.sessionMinutes,
      goal: settings.goal,
      experience: settings.experience,
      equipment: settings.equipment,
      avoidedExerciseIds: settings.avoidedExerciseIds,
    );
    final now = DateTime.now().toIso8601String();
    return database.transaction(() async {
      final existing = await (database.select(
        database.trainingPlans,
      )..where((row) => row.id.equals(activePlanId))).getSingleOrNull();
      final existingDays =
          (await (database.select(
                database.trainingPlanDays,
              )..where((row) => row.planId.equals(activePlanId))).get())
              .map((row) => row.weekday)
              .toSet();
      final existingEquipment =
          (await (database.select(
                database.trainingPlanEquipment,
              )..where((row) => row.planId.equals(activePlanId))).get())
              .map((row) => row.equipment)
              .toSet();
      final existingAvoidedExerciseIds = existing == null
          ? const <String>{}
          : (jsonDecode(existing.avoidedExerciseIds) as List)
                .whereType<String>()
                .toSet();
      final planChanged =
          existing == null ||
          existing.goal != settings.goal ||
          existing.experience != settings.experience ||
          existing.sessionMinutes != settings.sessionMinutes ||
          !existingDays.containsAll(settings.trainingDays) ||
          !settings.trainingDays.containsAll(existingDays) ||
          !existingEquipment.containsAll(settings.equipment) ||
          !settings.equipment.containsAll(existingEquipment);
      final exclusionsChanged =
          !existingAvoidedExerciseIds.containsAll(
            settings.avoidedExerciseIds,
          ) ||
          !settings.avoidedExerciseIds.containsAll(existingAvoidedExerciseIds);
      final version = existing == null
          ? 1
          : planChanged || exclusionsChanged
          ? existing.version + 1
          : existing.version;

      await database
          .into(database.trainingPlans)
          .insertOnConflictUpdate(
            TrainingPlansCompanion.insert(
              id: activePlanId,
              goal: settings.goal,
              experience: settings.experience,
              sessionMinutes: settings.sessionMinutes,
              avoidedExerciseIds: Value(
                jsonEncode(settings.avoidedExerciseIds.toList()..sort()),
              ),
              version: Value(version),
              createdAt: existing?.createdAt ?? now,
              updatedAt: now,
              isActive: const Value(true),
            ),
          );

      await (database.delete(
        database.trainingPlanDays,
      )..where((row) => row.planId.equals(activePlanId))).go();
      await (database.delete(
        database.trainingPlanEquipment,
      )..where((row) => row.planId.equals(activePlanId))).go();

      final days = settings.trainingDays.toList()..sort();
      await database.batch((batch) {
        batch.insertAll(database.trainingPlanDays, [
          for (var index = 0; index < days.length; index++)
            TrainingPlanDaysCompanion.insert(
              planId: activePlanId,
              weekday: days[index],
              orderIndex: index,
            ),
        ]);
        batch.insertAll(database.trainingPlanEquipment, [
          for (final item in settings.equipment.toList()..sort())
            TrainingPlanEquipmentCompanion.insert(
              planId: activePlanId,
              equipment: item,
            ),
        ]);
      });
      return version;
    });
  }

  Future<void> completeSetup() async {
    await database
        .into(database.appMetadata)
        .insertOnConflictUpdate(
          AppMetadataCompanion.insert(key: _setupCompleteKey, value: 'true'),
        );
  }
}
