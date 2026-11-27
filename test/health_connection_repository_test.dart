import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forza/data/database/app_database.dart';
import 'package:forza/data/repositories/health_connection_repository.dart';
import 'package:forza/domain/models/health/imported_health_record.dart';

void main() {
  late AppDatabase database;
  late HealthConnectionRepository repository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = HealthConnectionRepository(database: database);
  });

  tearDown(() async => database.close());

  ImportedHealthRecord record({
    String id = 'sample-1',
    String sourceId = 'com.example.watch',
    String value = '4200',
  }) =>
      ImportedHealthRecord(
        id: id,
        dataType: 'STEPS',
        value: value,
        unit: 'COUNT',
        startAt: DateTime(2026, 11, 26, 8),
        endAt: DateTime(2026, 11, 26, 9),
        sourcePlatform: 'googleHealthConnect',
        sourceId: sourceId,
        sourceName: 'Example Watch',
        importedAt: DateTime(2026, 11, 27),
      );

  test('reimport updates the same source record instead of duplicating it', () async {
    await repository.upsertRecords('user-a', [record()]);
    await repository.upsertRecords('user-a', [record(value: '5000')]);

    expect(await repository.count('user-a'), 1);
    expect((await repository.latest('user-a')).single.value, '5000');
    expect((await repository.latest('user-a')).single.sourceName, 'Example Watch');
  });

  test('records from different sources are kept independently', () async {
    await repository.upsertRecords('user-a', [
      record(sourceId: 'watch-a'),
      record(sourceId: 'watch-b'),
    ]);

    expect(await repository.count('user-a'), 2);
  });

  test('records and preferences are isolated by owner scope', () async {
    await repository.upsertRecords('user-a', [record()]);
    await repository.saveEnabledTypes('user-a', ['STEPS']);
    await repository.saveLastImport('user-a', DateTime(2026, 11, 27));

    expect(await repository.count('user-b'), 0);
    expect(await repository.loadEnabledTypes('user-b'), isEmpty);
    expect(await repository.loadLastImport('user-b'), isNull);
  });

  test('disconnect removes only this owner’s records and settings', () async {
    await repository.upsertRecords('user-a', [record()]);
    await repository.upsertRecords('user-b', [record()]);
    await repository.saveEnabledTypes('user-a', ['STEPS']);

    expect(await repository.deleteAll('user-a'), 1);

    expect(await repository.count('user-a'), 0);
    expect(await repository.count('user-b'), 1);
    expect(await repository.loadEnabledTypes('user-a'), isEmpty);
  });
}
