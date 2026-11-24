import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forza/data/database/app_database.dart';

void main() {
  test(
    'migration v6 creates body measurements for existing installations',
    () async {
      final database = AppDatabase(
        NativeDatabase.memory(
          setup: (database) {
            database.execute('PRAGMA user_version = 5');
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
      expect(version.read<int>('user_version'), 6);
      await database.close();
    },
  );
}
