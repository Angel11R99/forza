import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../../ui/features/profile/models/profile_settings.dart';

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

    return TrainingSettings(
      trainingDays: days.map((row) => row.weekday).toSet(),
      sessionMinutes: plan.sessionMinutes,
      goal: plan.goal,
      experience: plan.experience,
      equipment: equipment.map((row) => row.equipment).toSet(),
    );
  }

  Future<void> save(TrainingSettings settings) async {
    final now = DateTime.now().toIso8601String();
    await database.transaction(() async {
      final existing = await (database.select(
        database.trainingPlans,
      )..where((row) => row.id.equals(activePlanId))).getSingleOrNull();

      await database
          .into(database.trainingPlans)
          .insertOnConflictUpdate(
            TrainingPlansCompanion.insert(
              id: activePlanId,
              goal: settings.goal,
              experience: settings.experience,
              sessionMinutes: settings.sessionMinutes,
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
