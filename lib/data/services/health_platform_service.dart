import 'package:flutter/foundation.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../domain/models/health/imported_health_record.dart';

class HealthPlatformService {
  HealthPlatformService({Health? health}) : _health = health ?? Health();

  final Health _health;

  static const availableTypes = <HealthDataType>[
    HealthDataType.STEPS,
    HealthDataType.WEIGHT,
    HealthDataType.SLEEP_SESSION,
    HealthDataType.WORKOUT,
  ];

  static const _typeByName = <String, HealthDataType>{
    'STEPS': HealthDataType.STEPS,
    'WEIGHT': HealthDataType.WEIGHT,
    'SLEEP_SESSION': HealthDataType.SLEEP_SESSION,
    'WORKOUT': HealthDataType.WORKOUT,
  };

  Future<void> configure() => _health.configure();

  Future<bool> get isAvailable async {
    if (kIsWeb) return false;
    return switch (defaultTargetPlatform) {
      TargetPlatform.android => await _health.isHealthConnectAvailable(),
      // HealthKit requires an entitlement and Info.plist usage strings. Keep
      // the feature unavailable until the iOS Runner has been configured.
      TargetPlatform.iOS => false,
      _ => false,
    };
  }

  Future<bool?> permissionGranted(HealthDataType type) async {
    if (defaultTargetPlatform == TargetPlatform.android &&
        type == HealthDataType.STEPS &&
        !(await Permission.activityRecognition.status).isGranted) {
      return false;
    }
    return _health.hasPermissions(
      [type],
      permissions: const [HealthDataAccess.READ],
    );
  }

  Future<List<String>> requestReadAccess(List<String> selectedNames) async {
    final allowedNames = [...selectedNames];
    if (defaultTargetPlatform == TargetPlatform.android &&
        allowedNames.contains(HealthDataType.STEPS.name)) {
      final status = await Permission.activityRecognition.request();
      if (!status.isGranted) allowedNames.remove(HealthDataType.STEPS.name);
    }
    final types = allowedNames
        .map((name) => _typeByName[name])
        .whereType<HealthDataType>()
        .toList(growable: false);
    if (types.isEmpty) {
      throw const HealthConnectionPermissionException(
        'No selected health data types are available to request.',
      );
    }
    await _health.requestAuthorization(
      types,
      permissions: List.filled(types.length, HealthDataAccess.READ),
    );
    return allowedNames;
  }

  Future<List<ImportedHealthRecord>> readRecent(
    List<String> selectedNames,
    DateTime start,
    DateTime end,
  ) async {
    final types = selectedNames
        .map((name) => _typeByName[name])
        .whereType<HealthDataType>()
        .toList(growable: false);
    if (types.isEmpty) return const [];
    final points = await _health.getHealthDataFromTypes(
      types: types,
      startTime: start,
      endTime: end,
    );
    final importedAt = DateTime.now();
    return points.map((point) {
      final value = point.type == HealthDataType.WORKOUT
          ? point.dateTo.difference(point.dateFrom).inSeconds.toString()
          : point.value is NumericHealthValue
          ? (point.value as NumericHealthValue).numericValue.toString()
          : point.value.toString();
      final identity = point.uuid.isNotEmpty
          ? point.uuid
          : '${point.type.name}|${point.sourceId}|'
                '${point.dateFrom.toUtc().millisecondsSinceEpoch}|'
                '${point.dateTo.toUtc().millisecondsSinceEpoch}';
      return ImportedHealthRecord(
        id: identity,
        dataType: point.type.name,
        value: value,
        unit: point.type == HealthDataType.WORKOUT
            ? 'SECOND'
            : point.unit.name,
        startAt: point.dateFrom,
        endAt: point.dateTo,
        sourcePlatform: point.sourcePlatform.name,
        sourceId: point.sourceId,
        sourceName: point.sourceName,
        importedAt: importedAt,
      );
    }).toList(growable: false);
  }

  Future<void> revokePermissions() => _health.revokePermissions();
}

class HealthConnectionPermissionException implements Exception {
  const HealthConnectionPermissionException(this.message);
  final String message;
}
