import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forza/data/database/app_database.dart' hide BodyMeasurement;
import 'package:forza/data/repositories/body_measurement_repository.dart';
import 'package:forza/domain/models/body_measurement.dart';

void main() {
  late AppDatabase database;
  late BodyMeasurementRepository repository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = BodyMeasurementRepository(database: database);
  });

  tearDown(() async => database.close());

  test(
    'saves, updates one entry per date, orders and deletes entries',
    () async {
      final earlier = BodyMeasurement(
        date: DateTime(2026, 1, 5),
        weightKg: 70,
        waistCm: 82,
      );
      final latest = BodyMeasurement(
        date: DateTime(2026, 1, 7),
        weightKg: 69.5,
        chestCm: 96,
      );
      await repository.save(latest);
      await repository.save(earlier);
      await repository.save(
        BodyMeasurement(date: latest.date, weightKg: 68.5, hipsCm: 94),
      );

      final loaded = await repository.load();
      expect(loaded.map((entry) => entry.date), [earlier.date, latest.date]);
      expect(loaded.last.weightKg, 68.5);
      expect(loaded.last.chestCm, isNull);
      expect(loaded.last.hipsCm, 94);

      await repository.delete(earlier.date);
      expect((await repository.load()).map((entry) => entry.id), [latest.id]);
    },
  );

  test('rejects impossible, non-finite, and future values', () async {
    final invalidMeasurements = [
      BodyMeasurement(date: DateTime(2026, 1, 1), weightKg: 0),
      BodyMeasurement(date: DateTime(2026, 1, 1), weightKg: double.nan),
      BodyMeasurement(date: DateTime(2026, 1, 1), weightKg: 70, waistCm: 301),
      BodyMeasurement(
        date: DateTime.now().add(const Duration(days: 1)),
        weightKg: 70,
      ),
    ];
    for (final measurement in invalidMeasurements) {
      await expectLater(repository.save(measurement), throwsFormatException);
    }
    expect(await repository.load(), isEmpty);
  });
}
