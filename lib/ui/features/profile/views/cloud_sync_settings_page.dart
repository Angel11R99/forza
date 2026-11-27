import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../app/localization/localization_extensions.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../data/repositories/profile_settings_repository.dart';
import '../../../../domain/models/account_identity.dart';
import '../../../../data/services/firestore_backup_sync_service.dart';
import '../../../core/widgets/app_surface_card.dart';

class CloudSyncSettingsPage extends StatefulWidget {
  const CloudSyncSettingsPage({
    super.key,
    required this.service,
    required this.settingsRepository,
    required this.uid,
    required this.account,
  });

  final FirestoreBackupSyncService service;
  final ProfileSettingsRepository settingsRepository;
  final String uid;
  final AccountIdentity account;

  @override
  State<CloudSyncSettingsPage> createState() => _CloudSyncSettingsPageState();
}

class _CloudSyncSettingsPageState extends State<CloudSyncSettingsPage> {
  bool _enabled = false;
  bool _busy = false;
  CloudSyncFrequency _frequency = CloudSyncFrequency.onChange;

  @override
  void initState() {
    super.initState();
    _loadEnabled();
  }

  Future<void> _loadEnabled() async {
    final values = await Future.wait<Object>([
      widget.settingsRepository.isCloudSyncEnabled(widget.uid),
      widget.settingsRepository.cloudSyncFrequency(widget.uid),
    ]);
    if (mounted) {
      setState(() {
        _enabled = values[0] as bool;
        _frequency = values[1] as CloudSyncFrequency;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.cloudSyncTitle)),
      body: SafeArea(
        bottom: false,
        child: ListenableBuilder(
          listenable: widget.service,
          builder: (context, _) => ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.x6,
              AppSpacing.x2,
              AppSpacing.x6,
              AppSpacing.x8,
            ),
            children: [
              const SizedBox(height: AppSpacing.x4),
              Text(
                context.l10n.cloudSyncDescription,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: AppSpacing.x6),
              AppSurfaceCard(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.account_circle_outlined),
                  title: Text(context.l10n.cloudSyncAccount),
                  subtitle: Text(widget.account.email),
                ),
              ),
              const SizedBox(height: AppSpacing.x3),
              AppSurfaceCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    SwitchListTile(
                      value: _enabled,
                      onChanged: _busy ? null : _changeSync,
                      title: Text(context.l10n.cloudSyncToggleTitle),
                      subtitle: Text(context.l10n.cloudSyncToggleDescription),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: Icon(
                        _statusIcon(widget.service.status.phase),
                        color: context.appColors.accent,
                      ),
                      title: Text(context.l10n.cloudSyncStatusHeading),
                      subtitle: Text(_statusLabel(context)),
                    ),
                    if (widget.service.status.lastSyncedAt != null) ...[
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.schedule_rounded),
                        title: Text(context.l10n.cloudSyncLastSync),
                        subtitle: Text(
                          DateFormat.yMMMd(
                            Localizations.localeOf(context).languageCode,
                          ).add_jm().format(
                            widget.service.status.lastSyncedAt!.toLocal(),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (_enabled) ...[
                const SizedBox(height: AppSpacing.x3),
                AppSurfaceCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButtonFormField<CloudSyncFrequency>(
                        initialValue: _frequency,
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: context.l10n.cloudSyncFrequency,
                        ),
                        items: [
                          DropdownMenuItem(
                            value: CloudSyncFrequency.onChange,
                            child: Text(context.l10n.cloudSyncFrequencyChanges),
                          ),
                          DropdownMenuItem(
                            value: CloudSyncFrequency.daily,
                            child: Text(context.l10n.cloudSyncFrequencyDaily),
                          ),
                          DropdownMenuItem(
                            value: CloudSyncFrequency.weekly,
                            child: Text(context.l10n.cloudSyncFrequencyWeekly),
                          ),
                          DropdownMenuItem(
                            value: CloudSyncFrequency.monthly,
                            child: Text(context.l10n.cloudSyncFrequencyMonthly),
                          ),
                          DropdownMenuItem(
                            value: CloudSyncFrequency.manual,
                            child: Text(context.l10n.cloudSyncFrequencyManual),
                          ),
                        ],
                        onChanged: _busy ? null : _changeFrequency,
                      ),
                      const SizedBox(height: AppSpacing.x2),
                      Text(
                        context.l10n.cloudSyncFrequencyNote,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.x3),
                OutlinedButton.icon(
                  onPressed:
                      _busy ||
                          widget.service.status.phase == CloudSyncPhase.syncing
                      ? null
                      : _syncNow,
                  icon: const Icon(Icons.sync_rounded),
                  label: Text(
                    widget.service.status.phase == CloudSyncPhase.pending ||
                            widget.service.status.phase ==
                                CloudSyncPhase.failed ||
                            widget.service.status.phase ==
                                CloudSyncPhase.offline
                        ? context.l10n.cloudSyncRetry
                        : context.l10n.cloudSyncNow,
                  ),
                ),
                const SizedBox(height: AppSpacing.x3),
                AppSurfaceCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.cloudSyncIncludedHeading,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: AppSpacing.x2),
                      Text(context.l10n.cloudSyncIncludedDescription),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.x8),
              Text(
                context.l10n.cloudSyncDeleteSection,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.x2),
              Text(
                context.l10n.cloudSyncDeleteDescription,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.x3),
              OutlinedButton.icon(
                onPressed: _busy ? null : _deleteRemoteData,
                icon: const Icon(Icons.delete_outline_rounded),
                label: Text(context.l10n.cloudSyncDeleteButton),
              ),
              if (_busy) ...[
                const SizedBox(height: AppSpacing.x4),
                const LinearProgressIndicator(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _changeFrequency(CloudSyncFrequency? value) async {
    if (value == null) return;
    final previous = _frequency;
    setState(() => _busy = true);
    try {
      await widget.settingsRepository.setCloudSyncFrequency(widget.uid, value);
      if (mounted) setState(() => _frequency = value);
    } on Object {
      if (mounted) {
        setState(() => _frequency = previous);
        _showFailure(context.l10n.cloudSyncFrequencySaveFailed);
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _syncNow() async {
    setState(() => _busy = true);
    try {
      await widget.service.retryNow();
    } on Object {
      if (mounted) _showFailure(context.l10n.cloudSyncStatusFailed);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _changeSync(bool enabled) async {
    if (!enabled) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(context.l10n.cloudSyncDisableTitle),
          content: Text(context.l10n.cloudSyncDisableDescription),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(context.l10n.commonCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(context.l10n.cloudSyncDisableButton),
            ),
          ],
        ),
      );
      if (confirmed != true) return;
      await widget.settingsRepository.setCloudSyncEnabled(widget.uid, false);
      if (mounted) setState(() => _enabled = false);
      return;
    }

    final accepted = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.cloudSyncConsentTitle),
        content: Text(context.l10n.cloudSyncConsentDescription),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n.cloudSyncConsentAccept),
          ),
        ],
      ),
    );
    if (accepted != true) return;
    setState(() => _busy = true);
    try {
      await widget.settingsRepository.setCloudSyncEnabled(widget.uid, true);
      if (mounted) setState(() => _enabled = true);
    } on Object {
      if (mounted) _showFailure(context.l10n.cloudSyncEnableFailed);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _deleteRemoteData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.cloudSyncDeleteTitle),
        content: Text(context.l10n.cloudSyncDeleteConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n.cloudSyncDeleteButton),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    setState(() => _busy = true);
    try {
      await widget.service.deleteRemoteData();
      if (mounted) {
        setState(() => _enabled = false);
        _showFailure(context.l10n.cloudSyncDeleteCompleted);
      }
    } on Object {
      if (mounted) _showFailure(context.l10n.cloudSyncDeleteFailed);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String _statusLabel(BuildContext context) =>
      switch (widget.service.status.phase) {
        CloudSyncPhase.signedOut => context.l10n.cloudSyncStatusSignedOut,
        CloudSyncPhase.consentRequired => context.l10n.cloudSyncStatusDisabled,
        CloudSyncPhase.syncing => context.l10n.cloudSyncStatusSyncing,
        CloudSyncPhase.synced => context.l10n.cloudSyncStatusSynced,
        CloudSyncPhase.pending => context.l10n.cloudSyncStatusPending,
        CloudSyncPhase.failed => context.l10n.cloudSyncStatusFailed,
        CloudSyncPhase.offline => context.l10n.cloudSyncStatusOffline,
      };

  IconData _statusIcon(CloudSyncPhase phase) => switch (phase) {
    CloudSyncPhase.signedOut ||
    CloudSyncPhase.consentRequired => Icons.cloud_off_outlined,
    CloudSyncPhase.syncing || CloudSyncPhase.pending => Icons.sync_rounded,
    CloudSyncPhase.synced => Icons.cloud_done_outlined,
    CloudSyncPhase.failed => Icons.cloud_off_outlined,
    CloudSyncPhase.offline => Icons.cloud_off_outlined,
  };

  void _showFailure(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
