import 'package:drift/drift.dart';

import '../../domain/models/body_measurement.dart';
import '../database/app_database.dart' as db;

class BodyMeasurementRepository {
  BodyMeasurementRepository({required this.database});

  final db.AppDatabase database;

  Future<List<BodyMeasurement>> load() async {
    final rows = await (database.select(
      database.bodyMeasurements,
    )..orderBy([(row) => OrderingTerm.asc(row.measurementDate)])).get();
    return List.unmodifiable(
      rows.map(
        (row) => BodyMeasurement(
          date: DateTime.parse(row.measurementDate),
          weightKg: row.weightKg,
          chestCm: row.chestCm,
          waistCm: row.waistCm,
          hipsCm: row.hipsCm,
          armCm: row.armCm,
        ),
      ),
    );
  }

  Future<void> save(BodyMeasurement measurement) async {
    _validate(measurement);
    await database
        .into(database.bodyMeasurements)
        .insertOnConflictUpdate(
          db.BodyMeasurementsCompanion.insert(
            measurementDate: measurement.id,
            weightKg: measurement.weightKg,
            chestCm: Value(measurement.chestCm),
            waistCm: Value(measurement.waistCm),
            hipsCm: Value(measurement.hipsCm),
            armCm: Value(measurement.armCm),
          ),
        );
  }

  Future<void> delete(DateTime date) async {
    final key = _dateKey(date);
    await (database.delete(
      database.bodyMeasurements,
    )..where((row) => row.measurementDate.equals(key))).go();
  }

  Future<void> replaceAll(List<BodyMeasurement> measurements) async {
    for (final measurement in measurements) {
      _validate(measurement);
    }
    await database.delete(database.bodyMeasurements).go();
    if (measurements.isEmpty) return;
    await database.batch((batch) {
      batch.insertAll(
        database.bodyMeasurements,
        measurements.map(_companion).toList(growable: false),
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  db.BodyMeasurementsCompanion _companion(BodyMeasurement measurement) =>
      db.BodyMeasurementsCompanion.insert(
        measurementDate: measurement.id,
        weightKg: measurement.weightKg,
        chestCm: Value(measurement.chestCm),
        waistCm: Value(measurement.waistCm),
        hipsCm: Value(measurement.hipsCm),
        armCm: Value(measurement.armCm),
      );

  void _validate(BodyMeasurement measurement) {
    if (measurement.date.isAfter(DateTime.now()) ||
        !measurement.hasValidValues) {
      throw const FormatException('La medida corporal está fuera de rango.');
    }
  }

  String _dateKey(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}
