import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../data/repositories/backup_repository.dart';
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
    await _run(() async {
      final contents = await widget.exportBackup(widget.appearanceMode);
      final now = DateTime.now();
      final stamp = '${now.year}${_two(now.month)}${_two(now.day)}';
      final saved = await FilePicker.saveFile(
        fileName: 'forza_respaldo_$stamp.json',
        bytes: utf8.encode(contents),
        mimeType: 'application/json',
        dialogTitle: 'Guardar respaldo de FORZA',
      );
      if (saved != null && mounted) _message('Respaldo guardado.');
    });
  }

  Future<void> _import() async {
    await _run(() async {
      final file = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: const ['json'],
        dialogTitle: 'Seleccionar respaldo de FORZA',
      );
      if (file == null) return;
      final backup = widget.validateBackup(
        utf8.decode(await file.readAsBytes()),
      );
      if (!mounted) return;
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Restaurar respaldo'),
          content: Text(
            'Se reemplazarán los datos locales por los del respaldo del '
            '${_date(backup.exportedAt)}. Incluye ${backup.records.length} '
            'sesiones, ${backup.schedule.length} sesiones de agenda y '
            '${backup.goals.length} objetivos. Esta acción no se puede deshacer.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Reemplazar datos'),
            ),
          ],
        ),
      );
      if (confirmed != true || !mounted) return;
      await widget.restoreBackup(backup);
      widget.onAppearanceModeChanged(backup.appearanceMode);
      if (mounted) _message('Respaldo restaurado.');
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
    if (error is FormatException) return error.message;
    return 'No pudimos procesar el archivo. Inténtalo de nuevo.';
  }

  void _message(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final gutter = AppSpacing.pageGutter(MediaQuery.sizeOf(context).width);
    return Scaffold(
      appBar: AppBar(title: const Text('Exportar y restaurar')),
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
                const ForzaEyebrow(label: 'Tus datos'),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  'Un respaldo bajo tu control',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: AppSpacing.x3),
                Text(
                  'El archivo incluye tu plan, historial con series, agenda, objetivos, sesión activa y apariencia. Se guarda como JSON en la ubicación que elijas.',
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
                        'Exportar',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: AppSpacing.x2),
                      Text(
                        'Crea un archivo que puedes guardar o transferir a otro dispositivo.',
                      ),
                      const SizedBox(height: AppSpacing.x4),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: _busy ? null : _export,
                          icon: const Icon(Icons.download_rounded),
                          label: const Text('Crear respaldo'),
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
                        'Restaurar',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: AppSpacing.x2),
                      Text(
                        'Revisa el contenido y confirma antes de reemplazar los datos locales.',
                      ),
                      const SizedBox(height: AppSpacing.x4),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _busy ? null : _import,
                          icon: const Icon(Icons.upload_file_rounded),
                          label: const Text('Elegir archivo de respaldo'),
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
