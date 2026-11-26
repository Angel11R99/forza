import 'package:drift/drift.dart';

import '../../domain/models/personal_goal.dart';
import '../database/app_database.dart' as db;

class PersonalGoalRepository {
  PersonalGoalRepository({required this.database});

  final db.AppDatabase database;

  Future<List<PersonalGoal>> load() async {
    final rows = await (database.select(
      database.personalGoals,
    )..orderBy([(row) => OrderingTerm.asc(row.createdAt)])).get();
    return List.unmodifiable(
      rows.map(
        (row) => PersonalGoal(
          id: row.id,
          type: PersonalGoalType.values.firstWhere(
            (type) => type.name == row.type,
            orElse: () => PersonalGoalType.sessionsPerWeek,
          ),
          targetValue: row.targetValue,
          exerciseName: row.exerciseName,
          exerciseCatalogId: row.exerciseCatalogId,
          createdAt: DateTime.parse(row.createdAt),
        ),
      ),
    );
  }

  Future<void> save(PersonalGoal goal) async {
    await database
        .into(database.personalGoals)
        .insertOnConflictUpdate(
          db.PersonalGoalsCompanion.insert(
            id: goal.id,
            type: goal.type.name,
            targetValue: goal.targetValue,
            exerciseName: Value(goal.exerciseName),
            exerciseCatalogId: Value(goal.exerciseCatalogId),
            createdAt: goal.createdAt.toIso8601String(),
          ),
        );
  }

  Future<void> delete(String id) async {
    await (database.delete(
      database.personalGoals,
    )..where((row) => row.id.equals(id))).go();
  }
}
