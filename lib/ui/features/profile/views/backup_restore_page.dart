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
    required this.validateBackup,
    required this.restoreBackup,
    required this.appearanceMode,
    required this.onAppearanceModeChanged,
  });

  final Future<String> Function(String appearanceMode) exportBackup;
  final ValidatedForzaBackup Function(String contents) validateBackup;
  final Future<void> Function(ValidatedForzaBackup backup) restoreBackup;
  final String appearanceMode;
  final ValueChanged<String> onAppearanceModeChanged;

  @override
  State<BackupRestorePage> createState() => _BackupRestorePageState();
}

class _BackupRestorePageState extends State<BackupRestorePage> {
  bool _busy = false;

  Future<void> _export() async {
    final savedMessage = context.l10n.backupSaved;
    final saveDialogTitle = context.l10n.backupSaveDialog;
    await _run(() async {
      final contents = await widget.exportBackup(widget.appearanceMode);
      final now = DateTime.now();
      final stamp = '${now.year}${_two(now.month)}${_two(now.day)}';
      final saved = await FilePicker.saveFile(
        fileName: 'forza_backup_$stamp.json',
        bytes: utf8.encode(contents),
        mimeType: 'application/json',
        dialogTitle: saveDialogTitle,
      );
      if (saved != null && mounted) _message(savedMessage);
    });
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
              backup.records.length,
              backup.schedule.length,
              backup.goals.length,
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

  Future<void> _run(Future<void> Function() action) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await action();
    } on Object catch (error) {
      if (mounted) _message(_errorMessage(error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String _errorMessage(Object error) {
    if (error is FormatException) return context.l10n.backupInvalid;
    return context.l10n.backupGenericError;
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
