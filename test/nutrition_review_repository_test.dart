import 'package:flutter_test/flutter_test.dart';
import 'package:forza/data/repositories/nutrition_review_repository.dart';
import 'package:forza/data/repositories/profile_settings_repository.dart';
import 'package:forza/domain/models/nutrition/nutrition_models.dart';

void main() {
  final now = DateTime.utc(2026, 11, 27, 12);
  final profile = NutritionProfile(
    id: 'profile',
    version: 1,
    updatedAt: now.subtract(const Duration(days: 15)),
  );

  test('review is optional until two weeks after profile setup', () async {
    final repository = NutritionReviewRepository(storage: _MemoryStorage());
    expect(
      await repository.isDue(
        profile.copyWithDate(now.subtract(const Duration(days: 13))),
        now: now,
      ),
      isFalse,
    );
    expect(await repository.isDue(profile, now: now), isTrue);
  });

  test(
    'can defer for a week and then complete without changing the profile',
    () async {
      final repository = NutritionReviewRepository(storage: _MemoryStorage());
      await repository.defer(now: now);
      expect(await repository.isDue(profile, now: now), isFalse);
      expect(
        await repository.isDue(profile, now: now.add(const Duration(days: 7))),
        isTrue,
      );

      await repository.complete(
        profile: profile,
        feedback: const {'energy': 'good'},
        now: now,
      );
      expect(await repository.isDue(profile, now: now), isFalse);
      expect(
        await repository.isDue(profile, now: now.add(const Duration(days: 13))),
        isFalse,
      );
      expect(
        await repository.isDue(profile, now: now.add(const Duration(days: 14))),
        isTrue,
      );
      expect((await repository.load()).feedback['energy'], 'good');
    },
  );

  test(
    'profile changes after a completed review make it due immediately',
    () async {
      final repository = NutritionReviewRepository(storage: _MemoryStorage());
      await repository.complete(profile: profile, feedback: const {}, now: now);
      expect(
        await repository.isDue(
          NutritionProfile(
            id: profile.id,
            version: profile.version + 1,
            updatedAt: now.add(const Duration(days: 1)),
          ),
          now: now.add(const Duration(days: 1)),
        ),
        isTrue,
      );
    },
  );

  test('review cadence is configurable and can be disabled', () async {
    final repository = NutritionReviewRepository(storage: _MemoryStorage());
    await repository.complete(profile: profile, feedback: const {}, now: now);
    await repository.setIntervalDays(28);
    expect(
      await repository.isDue(profile, now: now.add(const Duration(days: 20))),
      isFalse,
    );
    expect(
      await repository.isDue(profile, now: now.add(const Duration(days: 28))),
      isTrue,
    );
    await repository.setIntervalDays(null);
    expect(
      await repository.isDue(profile, now: now.add(const Duration(days: 60))),
      isFalse,
    );
  });
}

extension on NutritionProfile {
  NutritionProfile copyWithDate(DateTime date) => NutritionProfile(
    id: id,
    version: version,
    updatedAt: date,
    goal: goal,
    ageYears: ageYears,
    heightCm: heightCm,
    bodyType: bodyType,
    countryCode: countryCode,
    region: region,
    mealsPerDay: mealsPerDay,
    dietaryPattern: dietaryPattern,
    restrictions: restrictions,
    unavailableFoodIds: unavailableFoodIds,
    kitchenMinutes: kitchenMinutes,
    budget: budget,
  );
}

class _MemoryStorage implements ProfilePreferencesStorage {
  final values = <String, String>{};

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String value) async => values[key] = value;
}
