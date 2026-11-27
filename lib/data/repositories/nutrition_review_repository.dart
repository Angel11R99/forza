import 'dart:convert';

import '../../domain/models/nutrition/nutrition_models.dart';
import 'profile_settings_repository.dart';

class NutritionReviewRecord {
  const NutritionReviewRecord({
    this.lastReviewedAt,
    this.lastReviewedProfileVersion = 0,
    this.deferredUntil,
    this.feedback = const {},
    this.intervalDays = 14,
  });

  final DateTime? lastReviewedAt;
  final int lastReviewedProfileVersion;
  final DateTime? deferredUntil;
  final Map<String, String> feedback;
  final int? intervalDays;

  factory NutritionReviewRecord.fromJson(Map<String, Object?> json) {
    DateTime? date(String key) {
      final value = json[key];
      return value is String ? DateTime.tryParse(value) : null;
    }

    final version = json['lastReviewedProfileVersion'];
    final rawFeedback = json['feedback'];
    final feedback = <String, String>{};
    if (rawFeedback is Map) {
      for (final entry in rawFeedback.entries) {
        if (entry.key is String && entry.value is String) {
          feedback[entry.key as String] = entry.value as String;
        }
      }
    }
    return NutritionReviewRecord(
      lastReviewedAt: date('lastReviewedAt'),
      lastReviewedProfileVersion: version is int && version >= 0 ? version : 0,
      deferredUntil: date('deferredUntil'),
      feedback: Map.unmodifiable(feedback),
      intervalDays: !json.containsKey('intervalDays')
          ? 14
          : json['intervalDays'] == null
          ? null
          : const [14, 28].contains(json['intervalDays'])
          ? json['intervalDays'] as int
          : 14,
    );
  }

  Map<String, Object?> toJson() => {
    'lastReviewedAt': lastReviewedAt?.toUtc().toIso8601String(),
    'lastReviewedProfileVersion': lastReviewedProfileVersion,
    'deferredUntil': deferredUntil?.toUtc().toIso8601String(),
    'feedback': feedback,
    'intervalDays': intervalDays,
  };
}

/// Optional, local-only cadence and feedback for reviewing a meal plan.
class NutritionReviewRepository {
  NutritionReviewRepository({ProfilePreferencesStorage? storage})
    : _storage = storage ?? SharedProfilePreferencesStorage();

  static const storageKey = 'nutrition_review_v1';
  static const reviewInterval = Duration(days: 14);
  static const deferInterval = Duration(days: 7);

  final ProfilePreferencesStorage _storage;

  Future<NutritionReviewRecord> load() async {
    final raw = await _storage.read(storageKey);
    if (raw == null || raw.isEmpty) return const NutritionReviewRecord();
    final decoded = jsonDecode(raw);
    if (decoded is! Map) throw const FormatException('Invalid review data.');
    return NutritionReviewRecord.fromJson(Map<String, Object?>.from(decoded));
  }

  Future<bool> isDue(NutritionProfile profile, {DateTime? now}) async {
    final current = now ?? DateTime.now();
    final record = await load();
    if (record.intervalDays == null) return false;
    if (record.deferredUntil != null &&
        current.isBefore(record.deferredUntil!)) {
      return false;
    }
    final changedSinceReview =
        record.lastReviewedAt != null &&
        profile.version > record.lastReviewedProfileVersion;
    if (changedSinceReview) return true;
    final anchor = record.lastReviewedAt ?? profile.updatedAt;
    return !current.isBefore(anchor.add(Duration(days: record.intervalDays!)));
  }

  Future<void> defer({DateTime? now}) async {
    final record = await load();
    final current = now ?? DateTime.now();
    await _save(
      NutritionReviewRecord(
        lastReviewedAt: record.lastReviewedAt,
        lastReviewedProfileVersion: record.lastReviewedProfileVersion,
        deferredUntil: current.add(deferInterval),
        feedback: record.feedback,
        intervalDays: record.intervalDays,
      ),
    );
  }

  Future<void> complete({
    required NutritionProfile profile,
    required Map<String, String> feedback,
    DateTime? now,
  }) async {
    final previous = await load();
    await _save(
      NutritionReviewRecord(
        lastReviewedAt: now ?? DateTime.now(),
        lastReviewedProfileVersion: profile.version,
        feedback: Map.unmodifiable(feedback),
        intervalDays: previous.intervalDays,
      ),
    );
  }

  Future<void> setIntervalDays(int? days) async {
    if (days != null && days != 14 && days != 28) {
      throw ArgumentError.value(days, 'days');
    }
    final record = await load();
    await _save(
      NutritionReviewRecord(
        lastReviewedAt: record.lastReviewedAt,
        lastReviewedProfileVersion: record.lastReviewedProfileVersion,
        deferredUntil: record.deferredUntil,
        feedback: record.feedback,
        intervalDays: days,
      ),
    );
  }

  Future<void> _save(NutritionReviewRecord record) =>
      _storage.write(storageKey, jsonEncode(record.toJson()));
}
