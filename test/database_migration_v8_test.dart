import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forza/data/database/app_database.dart';

void main() {
  test('migration v8 adds exercise identities without losing existing goals', () async {
    final database = AppDatabase(
      NativeDatabase.memory(
        setup: (database) {
          database.execute('PRAGMA user_version = 5');
          database.execute('''
              CREATE TABLE training_plans (
                id TEXT NOT NULL PRIMARY KEY,
                goal TEXT NOT NULL,
                experience TEXT NOT NULL,
                session_minutes INTEGER NOT NULL,
                version INTEGER NOT NULL DEFAULT 1,
                created_at TEXT NOT NULL,
                updated_at TEXT NOT NULL,
                is_active INTEGER NOT NULL DEFAULT 1
              )
            ''');
          database.execute('''
              INSERT INTO training_plans (
                id, goal, experience, session_minutes, version,
                created_at, updated_at, is_active
              ) VALUES (
                'active', 'Ganar fuerza', 'Estoy empezando', 45, 3,
                'created', 'updated', 1
              )
            ''');
          database.execute('''
              CREATE TABLE personal_goals (
                id TEXT NOT NULL PRIMARY KEY,
                type TEXT NOT NULL,
                target_value REAL NOT NULL,
                exercise_name TEXT,
                created_at TEXT NOT NULL
              )
            ''');
          database.execute('''
              INSERT INTO personal_goals (
                id, type, target_value, exercise_name, created_at
              ) VALUES (
                'legacy-goal', 'exerciseLoad', 60, 'Press de banca', 'created'
              )
            ''');
        },
      ),
    );

    final columns = await database
        .customSelect('PRAGMA table_info(body_measurements)')
        .get();
    expect(
      columns.map((row) => row.read<String>('name')),
      containsAll([
        'measurement_date',
        'weight_kg',
        'chest_cm',
        'waist_cm',
        'hips_cm',
        'arm_cm',
      ]),
    );
    final version = await database
        .customSelect('PRAGMA user_version')
        .getSingle();
    expect(version.read<int>('user_version'), 8);
    final planColumns = await database
        .customSelect('PRAGMA table_info(training_plans)')
        .get();
    expect(
      planColumns.map((row) => row.read<String>('name')),
      contains('avoided_exercise_ids'),
    );
    final defaultValue = planColumns.singleWhere(
      (row) => row.read<String>('name') == 'avoided_exercise_ids',
    );
    expect(defaultValue.read<String>('dflt_value'), "'[]'");
    final existingPlan = await database
        .customSelect(
          "SELECT avoided_exercise_ids FROM training_plans WHERE id = 'active'",
        )
        .getSingle();
    expect(existingPlan.read<String>('avoided_exercise_ids'), '[]');
    final existingGoal = await database
        .customSelect("SELECT goal FROM training_plans WHERE id = 'active'")
        .getSingle();
    expect(existingGoal.read<String>('goal'), 'Ganar fuerza');
    final goalColumns = await database
        .customSelect('PRAGMA table_info(personal_goals)')
        .get();
    expect(
      goalColumns.map((row) => row.read<String>('name')),
      contains('exercise_catalog_id'),
    );
    final existingLegacyGoal = await database
        .customSelect(
          "SELECT exercise_catalog_id FROM personal_goals WHERE id = 'legacy-goal'",
        )
        .getSingle();
    expect(
      existingLegacyGoal.readNullable<String>('exercise_catalog_id'),
      isNull,
    );
    await database.close();
  });
}
