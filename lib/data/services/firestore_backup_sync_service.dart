import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../database/app_database.dart';
import '../repositories/backup_repository.dart';
import '../repositories/profile_settings_repository.dart';

enum CloudSyncPhase {
  signedOut,
  consentRequired,
  syncing,
  synced,
  pending,
  offline,
  failed,
}

class CloudSyncStatus {
  const CloudSyncStatus(this.phase, {this.lastSyncedAt});

  final CloudSyncPhase phase;
  final DateTime? lastSyncedAt;
}

abstract interface class CloudSyncSettingsController implements Listenable {
  CloudSyncStatus get status;
  Future<void> retryNow();
  Future<void> deleteRemoteData();
  Future<bool> deleteRemoteNutritionData();
}

/// Keeps the local-first FORZA backup format mirrored in the signed-in user's
/// private Firestore account. Local values win when records share an ID.
class FirestoreBackupSyncService extends ChangeNotifier
    implements CloudSyncSettingsController {
  FirestoreBackupSyncService({
    required this.database,
    required this.backupRepository,
    required this.appearanceMode,
    required this.applyAppearance,
    required this.profileSettingsRepository,
    required this.appearanceChanges,
    this.onDataRestored,
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  }) : _auth = auth ?? FirebaseAuth.instance,
       _firestore = firestore ?? FirebaseFirestore.instance;

  static const _chunkByteLimit = 650000;
  static const _maxChunks = 32;
  static const _maxRetryDelay = Duration(minutes: 5);

  final AppDatabase database;
  final BackupRepository backupRepository;
  final String Function() appearanceMode;
  final Future<void> Function(String mode) applyAppearance;
  final ProfileSettingsRepository profileSettingsRepository;
  final Listenable appearanceChanges;
  final Future<void> Function()? onDataRestored;
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
  Timer? _retryTimer;
  bool _isApplyingCloud = false;
  bool _isSyncing = false;
  bool _rescheduleAfterSync = false;
  bool _isSwitchingLocalAccount = false;
  bool _isDisposed = false;
  int _retryAttempt = 0;
  CloudSyncStatus _status = const CloudSyncStatus(CloudSyncPhase.signedOut);

  @override
  CloudSyncStatus get status => _status;

  void start() {
    if (_isDisposed || _authSubscription != null) return;
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
      (_) => unawaited(_onProfileSettingsChanged()),
    );
    appearanceChanges.addListener(_scheduleUpload);
    _authSubscription = _auth.authStateChanges().listen(_onAuthChanged);
  }

  @override
  void dispose() {
    _isDisposed = true;
    _uploadTimer?.cancel();
    _retryTimer?.cancel();
    unawaited(_authSubscription?.cancel());
    unawaited(_databaseChanges?.cancel());
    unawaited(_profileSettingsChanges?.cancel());
    unawaited(_manifestChanges?.cancel());
    appearanceChanges.removeListener(_scheduleUpload);
    super.dispose();
  }

  Future<void> _onAuthChanged(User? user) async {
    await _manifestChanges?.cancel();
    _manifestChanges = null;
    _uploadTimer?.cancel();
    _retryTimer?.cancel();
    if (user == null || _isDisposed) {
      _setStatus(const CloudSyncStatus(CloudSyncPhase.signedOut));
      return;
    }

    try {
      await _switchLocalAccount(user.uid);
      if (!await profileSettingsRepository.isCloudSyncEnabled(user.uid)) {
        _setStatus(
          CloudSyncStatus(
            CloudSyncPhase.consentRequired,
            lastSyncedAt: await profileSettingsRepository.lastCloudSync(
              user.uid,
            ),
          ),
        );
        return;
      }
      final frequency = await profileSettingsRepository.cloudSyncFrequency(
        user.uid,
      );
      final allowUpload = switch (frequency) {
        CloudSyncFrequency.onChange => true,
        CloudSyncFrequency.manual => false,
        CloudSyncFrequency.daily => await _isDueForSync(
          user.uid,
          const Duration(days: 1),
        ),
        CloudSyncFrequency.weekly => await _isDueForSync(
          user.uid,
          const Duration(days: 7),
        ),
        CloudSyncFrequency.monthly => await _isDueForSync(
          user.uid,
          const Duration(days: 30),
        ),
      };
      await _syncInitial(user.uid, allowUpload: allowUpload);
    } on Object catch (error, stackTrace) {
      debugPrint('FORZA Firestore sync could not start: $error\n$stackTrace');
      await _markFailed(user.uid, error);
    }
  }

  Future<void> _switchLocalAccount(String uid) async {
    _isSwitchingLocalAccount = true;
    try {
      final owner = await profileSettingsRepository.cloudSyncOwner();
      if (owner == uid) return;
      if (owner == null || owner.isEmpty) {
        // Keep pre-account guest data local. It can be uploaded only after the
        // user explicitly accepts the sync consent in Profile.
        await profileSettingsRepository.setCloudSyncOwner(uid);
        return;
      }

      final previousBackup = await _exportLocal();
      await (database
          .into(database.localAccountBackups)
          .insertOnConflictUpdate(
            LocalAccountBackupsCompanion.insert(
              uid: owner,
              backupJson: previousBackup,
              updatedAt: DateTime.now().toUtc().toIso8601String(),
            ),
          ));
      final savedAccount = await (database.select(
        database.localAccountBackups,
      )..where((row) => row.uid.equals(uid))).getSingleOrNull();
      if (savedAccount == null) {
        await backupRepository.clearLocalData();
        await (database.delete(
          database.cloudSyncBaselines,
        )..where((row) => row.uid.equals(uid))).go();
        await applyAppearance('system');
      } else {
        final backup = backupRepository.validate(savedAccount.backupJson);
        await backupRepository.restore(backup);
        await applyAppearance(backup.appearanceMode);
      }
      await profileSettingsRepository.setCloudSyncOwner(uid);
      await onDataRestored?.call();
    } finally {
      _isSwitchingLocalAccount = false;
    }
  }

  Future<void> _onProfileSettingsChanged() async {
    final user = _auth.currentUser;
    if (user == null || _isDisposed || _isSwitchingLocalAccount || _isSyncing) {
      return;
    }
    if (!await profileSettingsRepository.isCloudSyncEnabled(user.uid)) {
      _uploadTimer?.cancel();
      _retryTimer?.cancel();
      await _manifestChanges?.cancel();
      _manifestChanges = null;
      _setStatus(
        CloudSyncStatus(
          CloudSyncPhase.consentRequired,
          lastSyncedAt: await profileSettingsRepository.lastCloudSync(user.uid),
        ),
      );
      return;
    }
    if (_manifestChanges == null) {
      await _syncInitial(user.uid);
    } else {
      _scheduleUpload();
    }
  }

  @override
  Future<void> retryNow() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null ||
        !await profileSettingsRepository.isCloudSyncEnabled(uid)) {
      return;
    }
    _retryTimer?.cancel();
    _retryAttempt = 0;
    await _syncInitial(uid);
  }

  Future<void> _syncInitial(String uid, {bool allowUpload = true}) async {
    if (_isSyncing || _isDisposed || _auth.currentUser?.uid != uid) return;
    _isSyncing = true;
    _setStatus(
      CloudSyncStatus(
        CloudSyncPhase.syncing,
        lastSyncedAt: await profileSettingsRepository.lastCloudSync(uid),
      ),
    );

    try {
      final manifest = _manifest(uid);
      final cloudDocument = await manifest.get(
        const GetOptions(source: Source.server),
      );
      final localJson = await _exportForCloud(uid);
      var completed = allowUpload;
      if (!cloudDocument.exists) {
        if (allowUpload) {
          await _upload(uid, localJson);
          await _saveBaseline(uid, localJson);
        }
      } else {
        final cloudJson = await _download(uid, cloudDocument.data()!);
        completed = await _mergeCloudIntoLocal(
          uid,
          localJson,
          cloudJson,
          allowUpload: allowUpload,
        );
      }

      if (_isDisposed || _auth.currentUser?.uid != uid) return;
      await _manifestChanges?.cancel();
      if (_isDisposed || _auth.currentUser?.uid != uid) return;
      _manifestChanges = manifest.snapshots().listen((snapshot) {
        final data = snapshot.data();
        if (!snapshot.metadata.isFromCache &&
            !snapshot.metadata.hasPendingWrites &&
            snapshot.exists && data != null && data['writer'] != _writerId) {
          unawaited(_handleRemoteSnapshot(uid, data));
        }
      });
      final hasRemoteOrUploadedCopy = allowUpload || cloudDocument.exists;
      if (hasRemoteOrUploadedCopy && completed) {
        await _markCompleted(uid);
      } else {
        await _markPending(uid);
        await _scheduleUploadIfAllowed();
      }
    } on Object catch (error, stackTrace) {
      debugPrint('FORZA Firestore sync could not start: $error\n$stackTrace');
      await _markFailed(uid, error);
    } finally {
      _finishSync();
    }
  }

  Future<void> _handleRemoteSnapshot(
    String uid,
    Map<String, dynamic> manifest,
  ) async {
    if (_isApplyingCloud ||
        _isSyncing ||
        _isDisposed ||
        _auth.currentUser?.uid != uid) {
      if (_isSyncing && !_isApplyingCloud) _rescheduleAfterSync = true;
      return;
    }
    try {
      _isSyncing = true;
      _setStatus(
        CloudSyncStatus(
          CloudSyncPhase.syncing,
          lastSyncedAt: await profileSettingsRepository.lastCloudSync(uid),
        ),
      );
      final cloudJson = await _download(uid, manifest);
      final localJson = await _exportForCloud(uid);
      final baseline = await _readBaselineForCloud(uid);
      final mergedJson = backupRepository.mergeJson(
        localJson,
        await _filterCloudSnapshot(uid, cloudJson),
        baselineSource: baseline,
      );
      final mergedBackup = backupRepository.validate(mergedJson);
      if (!_equivalent(localJson, mergedJson)) {
        _isApplyingCloud = true;
        try {
          await backupRepository.restore(
            mergedBackup,
            restoreNutrition: await _hasNutritionConsent(uid),
          );
          await applyAppearance(mergedBackup.appearanceMode);
          await onDataRestored?.call();
        } finally {
          _isApplyingCloud = false;
        }
      }
      final allowUpload =
          await profileSettingsRepository.cloudSyncFrequency(uid) !=
          CloudSyncFrequency.manual;
      final cloudComparable = await _filterCloudSnapshot(uid, cloudJson);
      if (allowUpload && !_equivalent(mergedJson, cloudComparable)) {
        await _upload(uid, mergedJson);
      }
      final complete = allowUpload || _equivalent(mergedJson, cloudComparable);
      await _saveBaseline(uid, complete ? mergedJson : cloudComparable);
      if (complete) {
        await _markCompleted(uid);
      } else {
        await _markPending(uid);
      }
    } on Object catch (error, stackTrace) {
      debugPrint(
        'FORZA Firestore sync could not apply remote data: $error\n$stackTrace',
      );
      await _markFailed(uid, error);
    } finally {
      _finishSync();
    }
  }

  Future<bool> _mergeCloudIntoLocal(
    String uid,
    String localJson,
    String cloudJson, {
    bool allowUpload = true,
  }) async {
    final includeNutrition = await _hasNutritionConsent(uid);
    final cloudSnapshot = await _filterCloudSnapshot(uid, cloudJson);
    final baseline = await _readBaselineForCloud(uid);
    final mergedJson = backupRepository.mergeJson(
      localJson,
      cloudSnapshot,
      baselineSource: baseline,
    );
    final mergedBackup = backupRepository.validate(mergedJson);
    if (!_equivalent(localJson, mergedJson)) {
      _isApplyingCloud = true;
      try {
        await backupRepository.restore(
          mergedBackup,
          restoreNutrition: includeNutrition,
        );
        await applyAppearance(mergedBackup.appearanceMode);
        await onDataRestored?.call();
      } finally {
        _isApplyingCloud = false;
      }
    }
    if (allowUpload && !_equivalent(mergedJson, cloudSnapshot)) {
      await _upload(uid, mergedJson);
    }
    await _saveBaseline(
      uid,
      allowUpload || _equivalent(mergedJson, cloudSnapshot)
          ? mergedJson
          : cloudSnapshot,
    );
    return allowUpload || _equivalent(mergedJson, cloudSnapshot);
  }

  void _scheduleUpload() {
    unawaited(_scheduleUploadIfAllowed());
  }

  Future<void> _scheduleUploadIfAllowed() async {
    if (_isApplyingCloud || _isSwitchingLocalAccount || _isDisposed) return;
    if (_isSyncing) {
      _rescheduleAfterSync = true;
      return;
    }
    final user = _auth.currentUser;
    if (user == null ||
        !await profileSettingsRepository.isCloudSyncEnabled(user.uid)) {
      return;
    }
    final frequency = await profileSettingsRepository.cloudSyncFrequency(
      user.uid,
    );
    await profileSettingsRepository.setPendingCloudSync(user.uid, true);
    _setStatus(
      CloudSyncStatus(
        CloudSyncPhase.pending,
        lastSyncedAt: await profileSettingsRepository.lastCloudSync(user.uid),
      ),
    );
    _uploadTimer?.cancel();
    final Duration? delay = switch (frequency) {
      CloudSyncFrequency.onChange => const Duration(seconds: 2),
      CloudSyncFrequency.daily => await _untilNextSync(
        user.uid,
        const Duration(days: 1),
      ),
      CloudSyncFrequency.weekly => await _untilNextSync(
        user.uid,
        const Duration(days: 7),
      ),
      CloudSyncFrequency.monthly => await _untilNextSync(
        user.uid,
        const Duration(days: 30),
      ),
      CloudSyncFrequency.manual => null,
    };
    if (delay == null) return;
    _uploadTimer = Timer(delay, () {
      unawaited(_uploadLocal());
    });
  }

  Future<Duration> _untilNextSync(String uid, Duration interval) async {
    final lastSync = await profileSettingsRepository.lastCloudSync(uid);
    if (lastSync == null) return const Duration(seconds: 2);
    final dueAt = lastSync.add(interval);
    final remaining = dueAt.difference(DateTime.now().toUtc());
    return remaining.isNegative ? const Duration(seconds: 2) : remaining;
  }

  Future<bool> _isDueForSync(String uid, Duration interval) async =>
      await _untilNextSync(uid, interval) <= const Duration(seconds: 2);

  Future<void> _uploadLocal() async {
    final user = _auth.currentUser;
    if (user == null || _isDisposed || _isApplyingCloud ||
        _isSwitchingLocalAccount) return;
    if (_isSyncing) {
      _rescheduleAfterSync = true;
      return;
    }
    _isSyncing = true;
    _setStatus(
      CloudSyncStatus(
        CloudSyncPhase.syncing,
        lastSyncedAt: await profileSettingsRepository.lastCloudSync(user.uid),
      ),
    );
    try {
      if (!await profileSettingsRepository.isCloudSyncEnabled(user.uid)) return;
      if (_auth.currentUser?.uid != user.uid || _isDisposed) return;
      final manifest = _manifest(user.uid);
      final cloudDocument = await manifest.get(
        const GetOptions(source: Source.server),
      );
      final localJson = await _exportForCloud(user.uid);
      final baseline = await _readBaselineForCloud(user.uid);
      String mergedJson;
      String? cloudJson;
      if (cloudDocument.exists) {
        final downloaded = await _download(user.uid, cloudDocument.data()!);
        cloudJson = await _filterCloudSnapshot(user.uid, downloaded);
        mergedJson = backupRepository.mergeJson(
          localJson,
          cloudJson,
          baselineSource: baseline,
        );
      } else {
        mergedJson = localJson;
      }
      if (!_equivalent(localJson, mergedJson)) {
        final backup = backupRepository.validate(mergedJson);
        _isApplyingCloud = true;
        try {
          await backupRepository.restore(
            backup,
            restoreNutrition: await _hasNutritionConsent(user.uid),
          );
          await applyAppearance(backup.appearanceMode);
          await onDataRestored?.call();
        } finally {
          _isApplyingCloud = false;
        }
      }
      if (cloudJson == null || !_equivalent(mergedJson, cloudJson)) {
        await _upload(user.uid, mergedJson);
      }
      await _saveBaseline(user.uid, mergedJson);
      await _markCompleted(user.uid);
    } on Object catch (error, stackTrace) {
      debugPrint(
        'FORZA Firestore sync could not upload local data: $error\n$stackTrace',
      );
      await _markFailed(user.uid, error);
    } finally {
      _finishSync();
    }
  }

  void _finishSync() {
    _isSyncing = false;
    if (_rescheduleAfterSync && !_isDisposed && !_isApplyingCloud) {
      _rescheduleAfterSync = false;
      _scheduleUpload();
    }
  }

  @override
  Future<void> deleteRemoteData() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw StateError('Se necesita una cuenta conectada.');
    _uploadTimer?.cancel();
    _retryTimer?.cancel();
    await _manifestChanges?.cancel();
    _manifestChanges = null;
    final manifest = _manifest(uid);
    final current = await manifest.get(const GetOptions(source: Source.server));
    final snapshotId = current.data()?['snapshotId'];
    if (snapshotId is String) {
      final chunks = await manifest
          .collection('snapshots')
          .doc(snapshotId)
          .collection('chunks')
          .get(const GetOptions(source: Source.server));
      for (var offset = 0; offset < chunks.docs.length; offset += 400) {
        final batch = _firestore.batch();
        for (final chunk in chunks.docs.skip(offset).take(400)) {
          batch.delete(chunk.reference);
        }
        await batch.commit();
      }
    }
    await manifest.delete();
    final userProfile = _firestore.collection('users').doc(uid);
    if ((await userProfile.get()).exists) await userProfile.delete();
    await (database.delete(
      database.cloudSyncBaselines,
    )..where((row) => row.uid.equals(uid))).go();
    await profileSettingsRepository.setNutritionCloudSyncEnabled(uid, false);
    await profileSettingsRepository.setCloudSyncEnabled(uid, false);
    await profileSettingsRepository.setPendingCloudSync(uid, false);
    _setStatus(
      CloudSyncStatus(
        CloudSyncPhase.consentRequired,
        lastSyncedAt: await profileSettingsRepository.lastCloudSync(uid),
      ),
    );
  }

  /// Removes only nutrition from the already uploaded account snapshot while
  /// preserving the remaining cloud backup and all local nutrition data.
  @override
  Future<bool> deleteRemoteNutritionData() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw StateError('Se necesita una cuenta conectada.');
    if (_isSyncing) throw StateError('La sincronización está ocupada.');
    _isSyncing = true;
    _uploadTimer?.cancel();
    _retryTimer?.cancel();
    try {
      await profileSettingsRepository.setNutritionCloudSyncEnabled(uid, false);
      final manifest = _manifest(uid);
      final current = await manifest.get(
        const GetOptions(source: Source.server),
      );
      if (!current.exists) return false;
      final downloaded = await _download(uid, current.data()!);
      final backup = backupRepository.validate(downloaded);
      if (!backup.nutritionSnapshotIncluded) return false;
      final stripped = backupRepository.withoutNutrition(downloaded);
      await _upload(uid, stripped, removeNutrition: true);
      await _saveBaseline(uid, stripped);
      return true;
    } finally {
      _finishSync();
    }
  }

  Future<String?> _readBaseline(String uid) async => (await (database.select(
    database.cloudSyncBaselines,
  )..where((row) => row.uid.equals(uid))).getSingleOrNull())?.backupJson;

  Future<String?> _readBaselineForCloud(String uid) async {
    final value = await _readBaseline(uid);
    return value == null ? null : _filterCloudSnapshot(uid, value);
  }

  Future<void> _saveBaseline(String uid, String json) async {
    final cloudJson = await _filterCloudSnapshot(uid, json);
    await (database
        .into(database.cloudSyncBaselines)
        .insertOnConflictUpdate(
          CloudSyncBaselinesCompanion.insert(
            uid: uid,
            backupJson: cloudJson,
            updatedAt: DateTime.now().toUtc().toIso8601String(),
          ),
        ));
  }

  Future<void> _markCompleted(String uid) async {
    _retryTimer?.cancel();
    _retryAttempt = 0;
    final timestamp = DateTime.now().toUtc();
    await profileSettingsRepository.markCloudSyncCompleted(uid, timestamp);
    _setStatus(CloudSyncStatus(CloudSyncPhase.synced, lastSyncedAt: timestamp));
  }

  Future<void> _markPending(String uid) async {
    await profileSettingsRepository.setPendingCloudSync(uid, true);
    _setStatus(
      CloudSyncStatus(
        CloudSyncPhase.pending,
        lastSyncedAt: await profileSettingsRepository.lastCloudSync(uid),
      ),
    );
  }

  Future<void> _markFailed(String uid, Object error) async {
    await profileSettingsRepository.setPendingCloudSync(uid, true);
    _setStatus(
      CloudSyncStatus(
        _isOfflineError(error) ? CloudSyncPhase.offline : CloudSyncPhase.failed,
        lastSyncedAt: await profileSettingsRepository.lastCloudSync(uid),
      ),
    );
    if (_isDisposed ||
        _auth.currentUser?.uid != uid ||
        await profileSettingsRepository.cloudSyncFrequency(uid) ==
            CloudSyncFrequency.manual) {
      return;
    }
    final delaySeconds = (1 << _retryAttempt.clamp(0, 8)).clamp(2, 300);
    _retryAttempt++;
    final delay = Duration(seconds: delaySeconds);
    _retryTimer?.cancel();
    _retryTimer = Timer(
      delay > _maxRetryDelay ? _maxRetryDelay : delay,
      () => unawaited(retryNow()),
    );
  }

  void _setStatus(CloudSyncStatus next) {
    if (_status.phase == next.phase &&
        _status.lastSyncedAt == next.lastSyncedAt) {
      return;
    }
    _status = next;
    if (!_isDisposed) notifyListeners();
  }

  bool _isOfflineError(Object error) =>
      error is FirebaseException &&
      const {
        'unavailable',
        'deadline-exceeded',
        'network-request-failed',
      }.contains(error.code);

  Future<String> _exportLocal() =>
      backupRepository.exportJson(appearanceMode: appearanceMode());

  Future<bool> _hasNutritionConsent(String uid) =>
      profileSettingsRepository.isNutritionCloudSyncEnabled(uid);

  Future<String> _exportForCloud(String uid) async =>
      backupRepository.exportJson(
        appearanceMode: appearanceMode(),
        includeNutrition: await _hasNutritionConsent(uid),
      );

  Future<String> _filterCloudSnapshot(String uid, String json) async =>
      await _hasNutritionConsent(uid)
      ? json
      : backupRepository.withoutNutrition(json);

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
        .get(const GetOptions(source: Source.server));
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

  Future<void> _upload(
    String uid,
    String json, {
    bool removeNutrition = false,
  }) async {
    final hasNutritionConsent = await _hasNutritionConsent(uid);
    if (!hasNutritionConsent || removeNutrition) {
      json = backupRepository.withoutNutrition(json);
    }
    backupRepository.validate(json);
    final manifest = _manifest(uid);
    final oldManifest = await manifest.get(
      const GetOptions(source: Source.server),
    );
    if (!hasNutritionConsent &&
        !removeNutrition &&
        oldManifest.exists &&
        oldManifest.data() != null) {
      final previous = await _download(uid, oldManifest.data()!);
      if (backupRepository.validate(previous).nutritionSnapshotIncluded) {
        json = backupRepository.retainRemoteNutrition(json, previous);
      }
    }
    backupRepository.validate(json);
    final contents = _splitChunks(json);
    if (contents.isEmpty || contents.length > _maxChunks) {
      throw const FormatException(
        'La copia supera el tamaño admitido por Firestore.',
      );
    }
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
          .get(const GetOptions(source: Source.server));
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
