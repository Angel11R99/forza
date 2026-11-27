import 'dart:convert';

import 'package:drift/drift.dart';

import '../../data/database/app_database.dart';
import '../../domain/models/health/imported_health_record.dart';

class HealthConnectionRepository {
  HealthConnectionRepository({required this.database});

  final AppDatabase database;

  Future<List<String>> loadEnabledTypes(String ownerScope) async {
    final row = await (database.select(database.healthConnectionSettings)
          ..where((table) => table.ownerScope.equals(ownerScope)))
        .getSingleOrNull();
    if (row == null) return const [];
    try {
      return (jsonDecode(row.enabledTypesJson) as List<dynamic>)
          .cast<String>();
    } on Object {
      return const [];
    }
  }

  Future<void> saveEnabledTypes(String ownerScope, List<String> types) async {
    final current = await (database.select(database.healthConnectionSettings)
          ..where((table) => table.ownerScope.equals(ownerScope)))
        .getSingleOrNull();
    await database.into(database.healthConnectionSettings).insertOnConflictUpdate(
      HealthConnectionSettingsCompanion.insert(
        ownerScope: ownerScope,
        enabledTypesJson: Value(jsonEncode(types)),
        lastImportAt: Value(current?.lastImportAt),
      ),
    );
  }

  Future<DateTime?> loadLastImport(String ownerScope) async {
    final row = await (database.select(database.healthConnectionSettings)
          ..where((table) => table.ownerScope.equals(ownerScope)))
        .getSingleOrNull();
    return row?.lastImportAt == null ? null : DateTime.tryParse(row!.lastImportAt!);
  }

  Future<void> saveLastImport(String ownerScope, DateTime value) async {
    final current = await (database.select(database.healthConnectionSettings)
          ..where((table) => table.ownerScope.equals(ownerScope)))
        .getSingleOrNull();
    await database.into(database.healthConnectionSettings).insertOnConflictUpdate(
      HealthConnectionSettingsCompanion.insert(
        ownerScope: ownerScope,
        enabledTypesJson: Value(current?.enabledTypesJson ?? '[]'),
        lastImportAt: Value(value.toIso8601String()),
      ),
    );
  }

  Future<int> count(String ownerScope) async {
    final count = database.healthRecords.id.count();
    final query = database.selectOnly(database.healthRecords)
      ..addColumns([count])
      ..where(database.healthRecords.ownerScope.equals(ownerScope));
    return await query.map((row) => row.read(count) ?? 0).getSingle();
  }

  Future<List<ImportedHealthRecord>> latest(String ownerScope) async {
    final rows = await (database.select(database.healthRecords)
          ..where((table) => table.ownerScope.equals(ownerScope))
          ..orderBy([(table) => OrderingTerm.desc(table.startAt)])
          ..limit(100))
        .get();
    return rows
        .map(
          (row) => ImportedHealthRecord(
            id: row.id,
            dataType: row.dataType,
            value: row.value,
            unit: row.unit,
            startAt: DateTime.parse(row.startAt),
            endAt: DateTime.parse(row.endAt),
            sourcePlatform: row.sourcePlatform,
            sourceId: row.sourceId,
            sourceName: row.sourceName,
            importedAt: DateTime.parse(row.importedAt),
          ),
        )
        .toList(growable: false);
  }

  Future<void> upsertRecords(
    String ownerScope,
    List<ImportedHealthRecord> records,
  ) async {
    final now = DateTime.now().toIso8601String();
    await database.batch((batch) {
      for (final record in records) {
        batch.insert(
          database.healthRecords,
          HealthRecordsCompanion.insert(
            id: '$ownerScope|${record.sourcePlatform}|${record.sourceId}|${record.id}',
            ownerScope: ownerScope,
            dataType: record.dataType,
            value: record.value,
            unit: record.unit,
            startAt: record.startAt.toUtc().toIso8601String(),
            endAt: record.endAt.toUtc().toIso8601String(),
            sourcePlatform: record.sourcePlatform,
            sourceId: record.sourceId,
            sourceName: record.sourceName,
            importedAt: now,
          ),
          onConflict: DoUpdate(
            (_) => HealthRecordsCompanion(
              value: Value(record.value),
              unit: Value(record.unit),
              startAt: Value(record.startAt.toUtc().toIso8601String()),
              endAt: Value(record.endAt.toUtc().toIso8601String()),
              sourceName: Value(record.sourceName),
              importedAt: Value(now),
            ),
          ),
        );
      }
    });
  }

  Future<int> deleteAll(String ownerScope) async {
    final deleted = await (database.delete(database.healthRecords)
          ..where((table) => table.ownerScope.equals(ownerScope)))
        .go();
    await (database.delete(database.healthConnectionSettings)
          ..where((table) => table.ownerScope.equals(ownerScope)))
        .go();
    return deleted;
  }
}
