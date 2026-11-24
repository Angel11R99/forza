import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forza/data/database/app_database.dart';

void main() {
  test(
    'migration v5 adds plan versions and snapshots to v4 databases',
    () async {
      final executor = NativeDatabase.memory(
        setup: (database) {
          for (final table in [
            'training_plans',
            'workout_sessions',
            'workout_session_exercises',
            'scheduled_training_sessions',
          ]) {
            database.execute('CREATE TABLE $table (legacy_id TEXT)');
          }
          database.execute('PRAGMA user_version = 4');
        },
      );
      final database = AppDatabase(executor);

      await database.customSelect('PRAGMA table_info(training_plans)').get();
      final planColumns = await _columnNames(database, 'training_plans');
      final workoutColumns = await _columnNames(database, 'workout_sessions');
      final exerciseColumns = await _columnNames(
        database,
        'workout_session_exercises',
      );
      final scheduleColumns = await _columnNames(
        database,
        'scheduled_training_sessions',
      );

      expect(planColumns, contains('version'));
      expect(workoutColumns, containsAll(['plan_version', 'plan_snapshot']));
      expect(exerciseColumns, contains('catalog_id'));
      expect(scheduleColumns, containsAll(['plan_version', 'plan_snapshot']));

      await database.close();
    },
  );
}

Future<Set<String>> _columnNames(AppDatabase database, String table) async {
  final rows = await database.customSelect('PRAGMA table_info($table)').get();
  return rows.map((row) => row.read<String>('name')).toSet();
}
