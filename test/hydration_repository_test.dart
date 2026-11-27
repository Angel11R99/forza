import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:forza/data/repositories/hydration_repository.dart';
import 'package:forza/domain/models/nutrition/hydration_models.dart';

void main() {
  test(
    'quick records serialize concurrent taps without losing entries',
    () async {
      final storage = _MemoryHydrationStorage();
      final repository = HydrationRepository(storage: storage);
      final now = DateTime(2026, 11, 27, 9);

      await Future.wait([
        for (var i = 0; i < 20; i++)
          repository.save(
            HydrationEntry(
              id: 'water:$i',
              loggedAt: now.add(Duration(minutes: i)),
              amountMl: 250,
            ),
          ),
      ]);

      expect((await repository.load()).entries, hasLength(20));
    },
  );

  test('editing same id changes date and amount without duplication', () async {
    final repository = HydrationRepository(storage: _MemoryHydrationStorage());
    await repository.save(
      HydrationEntry(
        id: 'water:1',
        loggedAt: DateTime(2026, 11, 26, 8),
        amountMl: 250,
      ),
    );
    await repository.save(
      HydrationEntry(
        id: 'water:1',
        loggedAt: DateTime(2026, 11, 25, 10),
        amountMl: 400,
      ),
    );

    final entries = (await repository.load()).entries;
    expect(entries, hasLength(1));
    expect(entries.single.loggedAt.day, 25);
    expect(entries.single.amountMl, 400);
  });

  test(
    'preferences are optional and records distinguish no entry from zero',
    () async {
      final repository = HydrationRepository(
        storage: _MemoryHydrationStorage(),
      );
      final empty = await repository.load();
      expect(empty.entries, isEmpty);
      expect(empty.preferences.dailyGoalMl, isNull);

      await repository.savePreferences(
        const HydrationPreferences(
          glassMl: 300,
          bottleMl: 750,
          dailyGoalMl: 1800,
          showIndicator: false,
        ),
      );
      final restored = await repository.load();
      expect(restored.entries, isEmpty);
      expect(restored.preferences.glassMl, 300);
      expect(restored.preferences.showIndicator, isFalse);
    },
  );

  test('restore validates and replaces hydration history', () async {
    final repository = HydrationRepository(storage: _MemoryHydrationStorage());
    await repository.replaceAll([
      HydrationEntry(
        id: 'water:restored',
        loggedAt: DateTime(2026, 11, 20),
        amountMl: 1000,
      ),
    ], const HydrationPreferences(dailyGoalMl: 2000));

    final state = await repository.load();
    expect(state.entries.single.amountMl, 1000);
    expect(state.preferences.dailyGoalMl, 2000);
  });
}

class _MemoryHydrationStorage implements HydrationStorage {
  String? value;
  @override
  Future<String?> read() async => value;
  @override
  Future<void> write(String value) async {
    this.value = jsonEncode(jsonDecode(value));
  }
}
