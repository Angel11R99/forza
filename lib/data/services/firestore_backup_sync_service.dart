import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../database/app_database.dart';
import '../repositories/backup_repository.dart';
import '../repositories/profile_settings_repository.dart';

/// Keeps the local-first FORZA backup format mirrored in the signed-in user's
/// private Firestore account. Local values win when records share an ID.
class FirestoreBackupSyncService {
  FirestoreBackupSyncService({
    required this.database,
    required this.backupRepository,
    required this.appearanceMode,
    required this.applyAppearance,
    required this.profileSettingsRepository,
    required this.appearanceChanges,
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  }) : _auth = auth ?? FirebaseAuth.instance,
       _firestore = firestore ?? FirebaseFirestore.instance;

  static const _chunkByteLimit = 650000;
  static const _maxChunks = 32;

  final AppDatabase database;
  final BackupRepository backupRepository;
  final String Function() appearanceMode;
  final Future<void> Function(String mode) applyAppearance;
  final ProfileSettingsRepository profileSettingsRepository;
  final Listenable appearanceChanges;
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final String _writerId = DateTime.now().microsecondsSinceEpoch.toRadixString(
    36,
  );

  StreamSubscription<User?>? _authSubscription;
  StreamSubscription<dynamic>? _databaseChanges;
  StreamSubscription<void>? _profileSettingsChanges;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _manifestChanges;
  Timer? _uploadTimer;
  bool _isApplyingCloud = false;
  bool _isDisposed = false;

  void start() {
    _databaseChanges = database
        .customSelect(
          'SELECT 1',
          readsFrom: {
            database.trainingPlans,
            database.trainingPlanDays,
            database.trainingPlanEquipment,
            database.workoutSessions,
            database.workoutSessionExercises,
            database.workoutSetEntries,
            database.scheduledTrainingSessions,
            database.personalGoals,
            database.bodyMeasurements,
            database.appMetadata,
          },
        )
        .watch()
        .listen((_) => _scheduleUpload());
    _profileSettingsChanges = profileSettingsRepository.changes.listen(
      (_) => _scheduleUpload(),
    );
    appearanceChanges.addListener(_scheduleUpload);
    _authSubscription = _auth.authStateChanges().listen(_onAuthChanged);
  }

  Future<void> dispose() async {
    _isDisposed = true;
    _uploadTimer?.cancel();
    await _authSubscription?.cancel();
    await _databaseChanges?.cancel();
    await _profileSettingsChanges?.cancel();
    await _manifestChanges?.cancel();
    appearanceChanges.removeListener(_scheduleUpload);
  }

  Future<void> _onAuthChanged(User? user) async {
    await _manifestChanges?.cancel();
    _manifestChanges = null;
    _uploadTimer?.cancel();
    if (user == null || _isDisposed) return;

    try {
      final manifest = _manifest(user.uid);
      final cloudDocument = await manifest.get();
      final localJson = await _exportLocal();
      if (!cloudDocument.exists) {
        await _upload(user.uid, localJson);
      } else {
        final cloudJson = await _download(user.uid, cloudDocument.data()!);
        await _mergeCloudIntoLocal(user.uid, cloudJson);
      }

      if (_isDisposed || _auth.currentUser?.uid != user.uid) return;
      _manifestChanges = manifest.snapshots().listen((snapshot) {
        final data = snapshot.data();
        if (snapshot.exists && data != null && data['writer'] != _writerId) {
          unawaited(_handleRemoteSnapshot(user.uid, data));
        }
      });
    } on Object catch (error, stackTrace) {
      debugPrint('FORZA Firestore sync could not start: $error\n$stackTrace');
    }
  }

  Future<void> _handleRemoteSnapshot(
    String uid,
    Map<String, dynamic> manifest,
  ) async {
    if (_isApplyingCloud || _isDisposed || _auth.currentUser?.uid != uid) {
      return;
    }
    try {
      final cloudJson = await _download(uid, manifest);
      final localJson = await _exportLocal();
      if (_equivalent(localJson, cloudJson)) return;

      final mergedJson = backupRepository.mergeJson(localJson, cloudJson);
      final mergedBackup = backupRepository.validate(mergedJson);
      _isApplyingCloud = true;
      try {
        await backupRepository.restore(mergedBackup);
        await applyAppearance(mergedBackup.appearanceMode);
      } finally {
        _isApplyingCloud = false;
      }
      if (!_equivalent(mergedJson, cloudJson)) {
        await _upload(uid, mergedJson);
      }
    } on Object catch (error, stackTrace) {
      debugPrint(
        'FORZA Firestore sync could not apply remote data: $error\n$stackTrace',
      );
    }
  }

  Future<void> _mergeCloudIntoLocal(String uid, String cloudJson) async {
    final localJson = await _exportLocal();
    final mergedJson = backupRepository.mergeJson(localJson, cloudJson);
    final mergedBackup = backupRepository.validate(mergedJson);
    _isApplyingCloud = true;
    try {
      await backupRepository.restore(mergedBackup);
      await applyAppearance(mergedBackup.appearanceMode);
    } finally {
      _isApplyingCloud = false;
    }
    if (!_equivalent(mergedJson, cloudJson)) {
      await _upload(uid, mergedJson);
    }
  }

  void _scheduleUpload() {
    if (_isApplyingCloud || _isDisposed || _auth.currentUser == null) return;
    _uploadTimer?.cancel();
    _uploadTimer = Timer(const Duration(seconds: 2), () {
      unawaited(_uploadLocal());
    });
  }

  Future<void> _uploadLocal() async {
    final user = _auth.currentUser;
    if (user == null || _isDisposed || _isApplyingCloud) return;
    try {
      await _upload(user.uid, await _exportLocal());
    } on Object catch (error, stackTrace) {
      debugPrint(
        'FORZA Firestore sync could not upload local data: $error\n$stackTrace',
      );
    }
  }

  Future<String> _exportLocal() =>
      backupRepository.exportJson(appearanceMode: appearanceMode());

  DocumentReference<Map<String, dynamic>> _manifest(String uid) =>
      _firestore.collection('users').doc(uid).collection('sync').doc('current');

  Future<String> _download(String uid, Map<String, dynamic> manifest) async {
    if (manifest['format'] != BackupRepository.formatName ||
        manifest['version'] != BackupRepository.version ||
        manifest['chunkCount'] is! int ||
        manifest['snapshotId'] is! String) {
      throw const FormatException('La copia de Firestore no es compatible.');
    }
    final chunkCount = manifest['chunkCount'] as int;
    if (chunkCount < 1 || chunkCount > _maxChunks) {
      throw const FormatException(
        'La copia de Firestore supera el tamaño permitido.',
      );
    }
    final snapshotId = manifest['snapshotId'] as String;
    final chunks = await _manifest(uid)
        .collection('snapshots')
        .doc(snapshotId)
        .collection('chunks')
        .get();
    final ordered = chunks.docs.toList()
      ..sort(
        (a, b) =>
            (a.data()['index'] as int).compareTo(b.data()['index'] as int),
      );
    if (ordered.length != chunkCount) {
      throw const FormatException('La copia de Firestore está incompleta.');
    }
    final result = StringBuffer();
    for (var index = 0; index < ordered.length; index++) {
      final data = ordered[index].data();
      if (data['index'] != index || data['content'] is! String) {
        throw const FormatException('La copia de Firestore está dañada.');
      }
      result.write(data['content'] as String);
    }
    final json = result.toString();
    backupRepository.validate(json);
    return json;
  }

  Future<void> _upload(String uid, String json) async {
    backupRepository.validate(json);
    final contents = _splitChunks(json);
    if (contents.isEmpty || contents.length > _maxChunks) {
      throw const FormatException(
        'La copia supera el tamaño admitido por Firestore.',
      );
    }

    final manifest = _manifest(uid);
    final oldManifest = await manifest.get();
    final snapshotId =
        '${_writerId}_${DateTime.now().microsecondsSinceEpoch.toRadixString(36)}';
    final chunks = manifest
        .collection('snapshots')
        .doc(snapshotId)
        .collection('chunks');
    for (var index = 0; index < contents.length; index++) {
      if (index % 10 == 0) {
        final batch = _firestore.batch();
        final end = (index + 10).clamp(0, contents.length);
        for (var chunkIndex = index; chunkIndex < end; chunkIndex++) {
          batch.set(chunks.doc(_chunkId(chunkIndex)), {
            'snapshotId': snapshotId,
            'index': chunkIndex,
            'content': contents[chunkIndex],
          });
        }
        await batch.commit();
      }
    }
    await manifest.set({
      'format': BackupRepository.formatName,
      'version': BackupRepository.version,
      'chunkCount': contents.length,
      'snapshotId': snapshotId,
      'writer': _writerId,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    final oldSnapshotId = oldManifest.data()?['snapshotId'];
    if (oldSnapshotId is String && oldSnapshotId != snapshotId) {
      final oldChunks = await manifest
          .collection('snapshots')
          .doc(oldSnapshotId)
          .collection('chunks')
          .get();
      for (var offset = 0; offset < oldChunks.docs.length; offset += 400) {
        final batch = _firestore.batch();
        for (final chunk in oldChunks.docs.skip(offset).take(400)) {
          batch.delete(chunk.reference);
        }
        await batch.commit();
      }
    }
  }

  List<String> _splitChunks(String value) {
    final chunks = <String>[];
    var current = StringBuffer();
    var currentBytes = 0;
    for (final rune in value.runes) {
      final character = String.fromCharCode(rune);
      final byteLength = utf8.encode(character).length;
      if (currentBytes + byteLength > _chunkByteLimit) {
        chunks.add(current.toString());
        current = StringBuffer();
        currentBytes = 0;
      }
      current.write(character);
      currentBytes += byteLength;
    }
    if (currentBytes > 0) chunks.add(current.toString());
    return chunks;
  }

  String _chunkId(int index) => 'chunk_${index.toString().padLeft(3, '0')}';

  bool _equivalent(String first, String second) {
    return jsonEncode(_canonicalSnapshot(first)) ==
        jsonEncode(_canonicalSnapshot(second));
  }

  Map<String, Object?> _canonicalSnapshot(String source) {
    final data = Map<String, Object?>.from(jsonDecode(source) as Map)
      ..remove('exportedAt');
    for (final entry in const {
      'workoutRecords': 'scheduledDate',
      'scheduledSessions': 'scheduledDate',
      'personalGoals': 'id',
      'bodyMeasurements': 'date',
    }.entries) {
      final values = data[entry.key];
      if (values is List) {
        values.sort((first, second) {
          final firstMap = Map<String, Object?>.from(first as Map);
          final secondMap = Map<String, Object?>.from(second as Map);
          return (firstMap[entry.value] as String).compareTo(
            secondMap[entry.value] as String,
          );
        });
      }
    }
    return _canonicalValue(data) as Map<String, Object?>;
  }

  Object? _canonicalValue(Object? value) {
    if (value is Map) {
      final keys = value.keys.cast<String>().toList()..sort();
      return <String, Object?>{
        for (final key in keys) key: _canonicalValue(value[key]),
      };
    }
    if (value is List) {
      return value.map(_canonicalValue).toList();
    }
    return value;
  }
}
