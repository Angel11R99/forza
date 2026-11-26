import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../app/localization/localization_extensions.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../data/repositories/profile_settings_repository.dart';
import '../../../../data/services/firestore_backup_sync_service.dart';
import '../../../core/widgets/app_surface_card.dart';

class CloudSyncSettingsPage extends StatefulWidget {
  const CloudSyncSettingsPage({
    super.key,
    required this.service,
    required this.settingsRepository,
    required this.uid,
  });

  final FirestoreBackupSyncService service;
  final ProfileSettingsRepository settingsRepository;
  final String uid;

  @override
  State<CloudSyncSettingsPage> createState() => _CloudSyncSettingsPageState();
}

class _CloudSyncSettingsPageState extends State<CloudSyncSettingsPage> {
  bool _enabled = false;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _loadEnabled();
  }

  Future<void> _loadEnabled() async {
    final enabled = await widget.settingsRepository.isCloudSyncEnabled(
      widget.uid,
    );
    if (mounted) setState(() => _enabled = enabled);
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
              if (widget.service.status.phase == CloudSyncPhase.pending ||
                  widget.service.status.phase == CloudSyncPhase.failed) ...[
                const SizedBox(height: AppSpacing.x3),
                OutlinedButton.icon(
                  onPressed: _busy ? null : widget.service.retryNow,
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text(context.l10n.cloudSyncRetry),
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
      };

  IconData _statusIcon(CloudSyncPhase phase) => switch (phase) {
    CloudSyncPhase.signedOut ||
    CloudSyncPhase.consentRequired => Icons.cloud_off_outlined,
    CloudSyncPhase.syncing || CloudSyncPhase.pending => Icons.sync_rounded,
    CloudSyncPhase.synced => Icons.cloud_done_outlined,
    CloudSyncPhase.failed => Icons.cloud_off_outlined,
  };

  void _showFailure(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
