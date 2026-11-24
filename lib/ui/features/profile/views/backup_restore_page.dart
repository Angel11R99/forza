import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../data/repositories/backup_repository.dart';
import '../../../../app/localization/localization_extensions.dart';
import '../../../core/widgets/app_surface_card.dart';
import '../../../core/widgets/forza_brand.dart';

class BackupRestorePage extends StatefulWidget {
  const BackupRestorePage({
    super.key,
    required this.exportBackup,
    this.saveBackupContents,
    required this.validateBackup,
    required this.restoreBackup,
    required this.resetUserData,
    required this.appearanceMode,
    required this.onAppearanceModeChanged,
  });

  final Future<String> Function(String appearanceMode) exportBackup;
  final Future<bool> Function(String contents)? saveBackupContents;
  final ValidatedForzaBackup Function(String contents) validateBackup;
  final Future<void> Function(ValidatedForzaBackup backup) restoreBackup;
  final Future<void> Function() resetUserData;
  final String appearanceMode;
  final ValueChanged<String> onAppearanceModeChanged;

  @override
  State<BackupRestorePage> createState() => _BackupRestorePageState();
}

class _BackupRestorePageState extends State<BackupRestorePage> {
  bool _busy = false;

  Future<void> _export() async {
    await _run(_saveBackupFile);
  }

  Future<bool> _saveBackupFile() async {
    final contents = await widget.exportBackup(widget.appearanceMode);
    final saved = widget.saveBackupContents != null
        ? await widget.saveBackupContents!(contents)
        : await _pickBackupDestination(contents);
    if (saved && mounted) _message(context.l10n.backupSaved);
    return saved;
  }

  Future<bool> _pickBackupDestination(String contents) async {
    final now = DateTime.now();
    final stamp = '${now.year}${_two(now.month)}${_two(now.day)}';
    final saved = await FilePicker.saveFile(
      fileName: 'forza_backup_$stamp.json',
      bytes: utf8.encode(contents),
      mimeType: 'application/json',
      dialogTitle: context.l10n.backupSaveDialog,
    );
    return saved != null;
  }

  Future<void> _import() async {
    await _run(() async {
      final file = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: const ['json'],
        dialogTitle: context.l10n.backupPickDialog,
      );
      if (file == null) return;
      final backup = widget.validateBackup(
        utf8.decode(await file.readAsBytes()),
      );
      if (!mounted) return;
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(context.l10n.backupConfirmTitle),
          content: Text(
            context.l10n.backupConfirmMessage(
              _date(backup.exportedAt),
              backup.goals.length,
              backup.bodyMeasurements.length,
              backup.records.length,
              backup.schedule.length,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(context.l10n.commonCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(context.l10n.backupReplace),
            ),
          ],
        ),
      );
      if (confirmed != true || !mounted) return;
      await widget.restoreBackup(backup);
      widget.onAppearanceModeChanged(backup.appearanceMode);
      if (mounted) _message(context.l10n.backupRestored);
    });
  }

  Future<void> _run(
    Future<void> Function() action, {
    String? failureMessage,
  }) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await action();
    } on Object catch (error) {
      if (mounted) {
        _message(
          error is FormatException
              ? context.l10n.backupInvalid
              : failureMessage ?? context.l10n.backupGenericError,
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _resetUserData() async {
    var saveBackupFirst = false;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(context.l10n.profileResetConfirmTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.l10n.profileResetConfirmMessage),
              const SizedBox(height: AppSpacing.x3),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: saveBackupFirst,
                onChanged: (value) =>
                    setDialogState(() => saveBackupFirst = value ?? false),
                title: Text(context.l10n.profileResetBackupOption),
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(context.l10n.commonCancel),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(context.l10n.profileResetConfirmButton),
            ),
          ],
        ),
      ),
    );
    if (confirmed != true || !mounted) return;

    await _run(() async {
      if (saveBackupFirst && !await _saveBackupFile()) {
        if (mounted) _message(context.l10n.profileResetBackupCancelled);
        return;
      }
      await widget.resetUserData();
      if (!mounted) return;
      _message(context.l10n.profileResetCompleted);
      Navigator.of(context).pop();
    }, failureMessage: context.l10n.profileResetFailed);
  }

  void _message(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final gutter = AppSpacing.pageGutter(MediaQuery.sizeOf(context).width);
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.backupTitle)),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                gutter,
                AppSpacing.x6,
                gutter,
                AppSpacing.x8,
              ),
              children: [
                ForzaEyebrow(label: context.l10n.backupEyebrow),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  context.l10n.backupHeading,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: AppSpacing.x3),
                Text(
                  context.l10n.backupDescription,
                  style: Theme.of(context).textTheme.bodyLarge
                      ?.copyWith(color: context.appColors.textSecondary),
                ),
                const SizedBox(height: AppSpacing.x6),
                AppSurfaceCard(
                  padding: const EdgeInsets.all(AppSpacing.x4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.backupExport,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: AppSpacing.x2),
                      Text(context.l10n.backupExportDescription),
                      const SizedBox(height: AppSpacing.x4),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: _busy ? null : _export,
                          icon: const Icon(Icons.download_rounded),
                          label: Text(context.l10n.backupCreate),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.x4),
                AppSurfaceCard(
                  padding: const EdgeInsets.all(AppSpacing.x4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.backupRestore,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: AppSpacing.x2),
                      Text(context.l10n.backupRestoreDescription),
                      const SizedBox(height: AppSpacing.x4),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _busy ? null : _import,
                          icon: const Icon(Icons.upload_file_rounded),
                          label: Text(context.l10n.backupChooseFile),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.x4),
                AppSurfaceCard(
                  padding: const EdgeInsets.all(AppSpacing.x4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.profileResetSectionTitle,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: AppSpacing.x2),
                      Text(context.l10n.profileResetSectionDescription),
                      const SizedBox(height: AppSpacing.x4),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _busy ? null : _resetUserData,
                          icon: const Icon(Icons.delete_sweep_outlined),
                          label: Text(context.l10n.profileResetAction),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Theme.of(context)
                                .colorScheme
                                .error,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (_busy) ...[
                  const SizedBox(height: AppSpacing.x6),
                  const Center(child: CircularProgressIndicator()),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _two(int value) => value.toString().padLeft(2, '0');

String _date(DateTime value) =>
    '${_two(value.day)}/${_two(value.month)}/${value.year}';
