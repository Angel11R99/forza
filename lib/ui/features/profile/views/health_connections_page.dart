import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:flutter/foundation.dart';

import '../../../../data/repositories/health_connection_repository.dart';
import '../../../../data/services/health_platform_service.dart';
import '../../../../domain/models/health/imported_health_record.dart';
import '../../../../app/localization/localization_extensions.dart';
import '../../../../app/theme/app_spacing.dart';

class HealthConnectionsPage extends StatefulWidget {
  const HealthConnectionsPage({
    required this.repository,
    required this.ownerScope,
    super.key,
  });

  final HealthConnectionRepository repository;
  final String ownerScope;

  @override
  State<HealthConnectionsPage> createState() => _HealthConnectionsPageState();
}

class _HealthConnectionsPageState extends State<HealthConnectionsPage>
    with WidgetsBindingObserver {
  final _platform = HealthPlatformService();
  static const _typeNames = ['STEPS', 'WEIGHT', 'SLEEP_SESSION', 'WORKOUT'];
  late List<String> _selected = [];
  late List<ImportedHealthRecord> _records = [];
  DateTime? _lastImport;
  Map<String, bool?> _permissions = const {};
  bool _available = false;
  bool _loading = true;
  bool _syncing = false;
  bool _hasConnection = false;
  bool _failed = false;
  int _recordCount = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    unawaited(_load());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) unawaited(_load());
  }

  Future<void> _load() async {
    if (mounted) setState(() => _loading = true);
    try {
      final available = await _platform.isAvailable;
      if (available) await _platform.configure();
      final storedSelected = await widget.repository.loadEnabledTypes(
        widget.ownerScope,
      );
      final selected = storedSelected.where(_typeNames.contains).toList();
      final lastImport = await widget.repository.loadLastImport(
        widget.ownerScope,
      );
      final records = await widget.repository.latest(widget.ownerScope);
      final recordCount = await widget.repository.count(widget.ownerScope);
      final permissions = <String, bool?>{};
      if (available) {
        for (final name in selected) {
          final type = HealthPlatformService.availableTypes.firstWhere(
            (candidate) => candidate.name == name,
          );
          permissions[name] = await _platform.permissionGranted(type);
        }
      }
      if (!mounted) return;
      setState(() {
        _available = available;
        _selected = selected.where(_typeNames.contains).toList();
        _lastImport = lastImport;
        _records = records;
        _recordCount = recordCount;
        _permissions = permissions;
        _hasConnection = lastImport != null || selected.isNotEmpty;
        _failed = false;
        _loading = false;
      });
    } on Object {
      if (mounted) setState(() { _failed = true; _loading = false; });
    }
  }

  Future<void> _setSelected(String type, bool selected) async {
    final next = [..._selected];
    if (selected && !next.contains(type)) next.add(type);
    if (!selected) next.remove(type);
    setState(() => _selected = next);
    await widget.repository.saveEnabledTypes(widget.ownerScope, next);
  }

  Future<void> _connectAndImport() async {
    if (_selected.isEmpty) {
      _message(context.l10n.healthSelectAtLeastOne);
      return;
    }
    final accepted = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.healthPermissionTitle),
        content: Text(context.l10n.healthPermissionExplanation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(context.l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(context.l10n.healthContinue),
          ),
        ],
      ),
    );
    if (accepted != true || !mounted) return;
    try {
      setState(() => _syncing = true);
      final allowedTypes = await _platform.requestReadAccess(_selected);
      final now = DateTime.now();
      final last = _lastImport;
      final floor = now.subtract(const Duration(days: 30));
      final incremental = last?.subtract(const Duration(days: 1));
      final start = incremental != null && incremental.isAfter(floor)
          ? incremental
          : floor;
      final imported = await _platform.readRecent(allowedTypes, start, now);
      await widget.repository.upsertRecords(widget.ownerScope, imported);
      await widget.repository.saveLastImport(widget.ownerScope, now);
      if (!mounted) return;
      setState(() {
        _records = [
          ...imported,
          ..._records.where((old) => !imported.any((item) => item.id == old.id)),
        ]..sort((a, b) => b.startAt.compareTo(a.startAt));
        _lastImport = now;
        _hasConnection = true;
        _syncing = false;
      });
      await _load();
      if (mounted) _message(context.l10n.healthImportComplete);
    } on Object {
      if (!mounted) return;
      setState(() => _syncing = false);
      _message(context.l10n.healthImportFailed);
    }
  }

  Future<void> _disconnect() async {
    final accepted = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.healthDisconnectTitle),
        content: Text(context.l10n.healthDisconnectExplanation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(context.l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(context.l10n.healthDisconnect),
          ),
        ],
      ),
    );
    if (accepted != true) return;
    try {
      await _platform.revokePermissions();
    } on Object {
      // Clearing local data remains available even if the platform revoke fails.
    }
    await widget.repository.deleteAll(widget.ownerScope);
    if (!mounted) return;
    setState(() {
      _selected = [];
      _records = [];
      _recordCount = 0;
      _permissions = const {};
      _lastImport = null;
      _hasConnection = false;
    });
    await _load();
  }

  void _message(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  String _typeLabel(BuildContext context, String type) => switch (type) {
    'STEPS' => context.l10n.healthSteps,
    'WEIGHT' => context.l10n.healthWeight,
    'SLEEP_SESSION' => context.l10n.healthSleep,
    'WORKOUT' => context.l10n.healthWorkouts,
    _ => type,
  };

  String _permissionStatus(BuildContext context, String type) {
    final status = _permissions[type];
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS && status == null) {
      return context.l10n.healthPermissionUnverifiable;
    }
    return status == true
        ? context.l10n.healthPermissionGranted
        : context.l10n.healthPermissionNotGranted;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.healthConnectionsTitle)),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: EdgeInsets.all(AppSpacing.pageGutter(
                  MediaQuery.sizeOf(context).width,
                )),
                children: [
                  Text(
                    context.l10n.healthConnectionsDescription,
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: AppSpacing.x4),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.x4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            const Icon(Icons.shield_outlined),
                            const SizedBox(width: AppSpacing.x2),
                            Expanded(child: Text(
                              context.l10n.healthLocalOnlyTitle,
                              style: theme.textTheme.titleMedium,
                            )),
                          ]),
                          const SizedBox(height: AppSpacing.x2),
                          Text(context.l10n.healthLocalOnlyDescription),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x4),
                  if (!_available || _failed)
                    Card(
                      child: ListTile(
                        leading: Icon(_failed ? Icons.error_outline : Icons.info_outline),
                        title: Text(_failed
                            ? context.l10n.healthStatusUnavailable
                            : !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS
                                ? context.l10n.healthIosPendingTitle
                                : context.l10n.healthDeviceUnsupported),
                        subtitle: Text(_failed
                            ? context.l10n.healthTryAgain
                            : !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS
                                ? context.l10n.healthIosPendingDescription
                                : context.l10n.healthDeviceUnsupportedDescription),
                        trailing: _failed
                            ? IconButton(
                                tooltip: context.l10n.commonRetry,
                                onPressed: _load,
                                icon: const Icon(Icons.refresh),
                              )
                            : null,
                      ),
                    )
                  else ...[
                    Text(context.l10n.healthChooseData, style: theme.textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.x2),
                    for (final type in _typeNames)
                      CheckboxListTile(
                        value: _selected.contains(type),
                        onChanged: _syncing ? null : (value) => _setSelected(type, value ?? false),
                        title: Text(_typeLabel(context, type)),
                        subtitle: Text(switch (type) {
                          'STEPS' => context.l10n.healthStepsReason,
                          'WEIGHT' => context.l10n.healthWeightReason,
                          'SLEEP_SESSION' => context.l10n.healthSleepReason,
                          _ => context.l10n.healthWorkoutReason,
                        }),
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                        minTileHeight: 56,
                      ),
                    if (_hasConnection && _selected.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: AppSpacing.x2),
                        child: Text(
                          !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS
                              ? context.l10n.healthIosPermissionCaveat
                              : _selected.map((type) => '${_typeLabel(context, type)}: ${_permissionStatus(context, type)}').join('\n'),
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                    const SizedBox(height: AppSpacing.x4),
                    FilledButton.icon(
                      onPressed: _syncing ? null : _connectAndImport,
                      icon: _syncing
                          ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.sync),
                      label: Text(_syncing
                          ? context.l10n.healthImporting
                          : _hasConnection
                              ? context.l10n.healthImportNow
                              : context.l10n.healthConnect),
                    ),
                    if (_lastImport != null) ...[
                      const SizedBox(height: AppSpacing.x3),
                      Text('${context.l10n.healthLastImport} ${_formatDate(_lastImport!)}'),
                      const SizedBox(height: AppSpacing.x1),
                      Text('${context.l10n.healthImportedRecordCount} $_recordCount'),
                    ],
                    if (_records.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.x6),
                      Text(context.l10n.healthRecentData, style: theme.textTheme.titleMedium),
                      const SizedBox(height: AppSpacing.x2),
                      for (final record in _records.take(12))
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(_typeLabel(context, record.dataType)),
                          subtitle: Text('${MaterialLocalizations.of(context).formatShortDate(record.startAt.toLocal())} · ${record.sourceName} · ${record.sourcePlatform}'),
                          trailing: Text('${record.value} ${record.unit}'),
                          dense: false,
                        ),
                    ],
                    if (_hasConnection) ...[
                      const SizedBox(height: AppSpacing.x4),
                      OutlinedButton.icon(
                        onPressed: _syncing ? null : _disconnect,
                        icon: const Icon(Icons.link_off),
                        label: Text(context.l10n.healthDisconnect),
                      ),
                    ],
                  ],
                ],
              ),
      ),
    );
  }

  String _formatDate(DateTime date) => MaterialLocalizations.of(context)
      .formatMediumDate(date.toLocal());
}
