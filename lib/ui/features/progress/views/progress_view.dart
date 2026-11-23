import 'package:material_ui/material_ui.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../core/widgets/app_surface_card.dart';
import '../../../core/widgets/forza_brand.dart';
import '../../../core/widgets/section_heading.dart';
import '../../../../domain/models/workout_record.dart';
import '../../../../domain/models/personal_goal.dart';
import '../models/progress_models.dart';
import 'progress_detail_pages.dart';
import 'personal_goal_editor_page.dart';

class ProgressView extends StatefulWidget {
  const ProgressView({
    super.key,
    required this.records,
    this.goals = const [],
    required this.onSaveGoal,
    required this.onDeleteGoal,
  });

  final List<WorkoutRecord> records;
  final List<PersonalGoal> goals;
  final Future<void> Function(PersonalGoal) onSaveGoal;
  final Future<void> Function(String) onDeleteGoal;

  @override
  State<ProgressView> createState() => _ProgressViewState();
}

class _ProgressViewState extends State<ProgressView> {
  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final cutoff = DateTime(today.year, today.month, today.day - 29);
    final sessions =
        widget.records
            .where((record) => !record.date.isBefore(cutoff))
            .map(WorkoutHistoryEntry.fromRecord)
            .toList(growable: false)
          ..sort((first, second) => second.date.compareTo(first.date));
    final totalMinutes = sessions.fold<int>(
      0,
      (total, session) => total + session.durationMinutes,
    );
    final horizontalPadding = AppSpacing.pageGutter(
      MediaQuery.sizeOf(context).width,
    );

    return CustomScrollView(
      key: const PageStorageKey<String>('progress-scroll'),
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            AppSpacing.x6,
            horizontalPadding,
            AppSpacing.x8,
          ),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ForzaEyebrow(label: 'Progreso'),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'Tu progreso',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'Tu constancia, en perspectiva.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: AppSpacing.x8),
                AppSurfaceCard(
                  padding: const EdgeInsets.all(AppSpacing.x6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Últimos 30 días',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: AppSpacing.x2),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${sessions.length}',
                            style: Theme.of(context).textTheme.displaySmall
                                ?.copyWith(color: context.appColors.accent),
                          ),
                          const SizedBox(width: AppSpacing.x2),
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.x1,
                            ),
                            child: Text(
                              'sesiones',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.x4),
                      Row(
                        children: [
                          _SummaryValue(
                            icon: Icons.schedule_rounded,
                            label:
                                '${totalMinutes ~/ 60} h ${totalMinutes % 60} min',
                          ),
                          const SizedBox(width: AppSpacing.x6),
                          _SummaryValue(
                            icon: Icons.fitness_center_rounded,
                            label:
                                '${sessions.fold<int>(0, (sum, entry) => sum + entry.exerciseCount)} ejercicios',
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.x3),
                      Row(
                        children: [
                          _SummaryValue(
                            icon: Icons.repeat_rounded,
                            label:
                                '${sessions.fold<int>(0, (sum, entry) => sum + entry.loggedSets.length)} series · ${sessions.fold<int>(0, (sum, entry) => sum + entry.totalRepetitions)} reps',
                          ),
                          const SizedBox(width: AppSpacing.x6),
                          _SummaryValue(
                            icon: Icons.scale_outlined,
                            label: _volumeLabel(
                              sessions.fold<double>(
                                0,
                                (sum, entry) => sum + entry.totalVolumeKg,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.x2),
                      Text(
                        'El volumen suma repeticiones × carga de las series con ambos datos.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.x8),
                SectionHeading(
                  title: 'Objetivos personales',
                  actionLabel: 'Añadir',
                  onAction: _openGoalEditor,
                ),
                if (widget.goals.isEmpty)
                  AppSurfaceCard(
                    child: Text(
                      'Define una meta semanal o una marca de carga para seguir tu avance.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  )
                else
                  for (final goal in widget.goals)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.x2),
                      child: _PersonalGoalCard(
                        goal: goal,
                        records: widget.records,
                        onEdit: () => _openGoalEditor(goal),
                        onDelete: () => _deleteGoal(goal),
                      ),
                    ),
                const SizedBox(height: AppSpacing.x8),
                SectionHeading(title: 'Historial de entrenamientos'),
                if (sessions.isEmpty)
                  AppSurfaceCard(
                    child: Row(
                      children: [
                        const Icon(Icons.event_available_outlined, size: 26),
                        const SizedBox(width: AppSpacing.x3),
                        Expanded(
                          child: Text(
                            'Completa una sesión para ver aquí tu actividad reciente.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  for (final session in sessions)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.x2),
                      child: _SessionHistoryCard(
                        session: session,
                        onTap: () => _openSession(context, session),
                      ),
                    ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _openSession(BuildContext context, WorkoutHistoryEntry session) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => SessionDetailPage(session: session),
      ),
    );
  }

  Future<void> _openGoalEditor([PersonalGoal? goal]) async {
    final updated = await Navigator.of(context).push<PersonalGoal>(
      MaterialPageRoute<PersonalGoal>(
        builder: (_) => PersonalGoalEditorPage(goal: goal),
      ),
    );
    if (!mounted || updated == null) return;
    await widget.onSaveGoal(updated);
  }

  Future<void> _deleteGoal(PersonalGoal goal) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Retirar objetivo'),
        content: const Text('¿Quieres quitar este objetivo de tu progreso?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Retirar'),
          ),
        ],
      ),
    );
    if (shouldDelete == true) await widget.onDeleteGoal(goal.id);
  }
}

class _PersonalGoalCard extends StatelessWidget {
  const _PersonalGoalCard({
    required this.goal,
    required this.records,
    required this.onEdit,
    required this.onDelete,
  });

  final PersonalGoal goal;
  final List<WorkoutRecord> records;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final current = goal.currentValue(records);
    final progress = (current / goal.targetValue).clamp(0.0, 1.0);
    final isWeekly = goal.type == PersonalGoalType.sessionsPerWeek;
    final currentLabel = isWeekly
        ? current.toStringAsFixed(0)
        : _formatVolume(current);
    final targetLabel = isWeekly
        ? goal.targetValue.toStringAsFixed(0)
        : _formatVolume(goal.targetValue);
    return AppSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  isWeekly
                      ? 'Sesiones esta semana'
                      : goal.exerciseName ?? 'Meta de carga',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              IconButton(
                tooltip: 'Editar objetivo',
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined),
              ),
              IconButton(
                tooltip: 'Retirar objetivo',
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline_rounded),
              ),
            ],
          ),
          Text(
            '$currentLabel de $targetLabel ${goal.unit}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.x3),
          LinearProgressIndicator(value: progress),
          const SizedBox(height: AppSpacing.x2),
          Text(
            isWeekly
                ? 'Sesiones completadas de lunes a domingo.'
                : 'Mayor carga registrada en tus series para este ejercicio.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _SessionHistoryCard extends StatelessWidget {
  const _SessionHistoryCard({required this.session, required this.onTap});

  final WorkoutHistoryEntry session;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      padding: EdgeInsets.zero,
      child: Semantics(
        button: true,
        label: '${session.title}, ${_formatShortDate(session.date)}',
        child: ExcludeSemantics(
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppRadius.medium),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.x4),
              child: Row(
                children: [
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: Icon(
                      Icons.fitness_center_rounded,
                      color: context.appColors.accent,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x4),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          session.title,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: AppSpacing.x1),
                        Text(
                          '${_formatShortDate(session.date)}  ·  ${session.durationMinutes} min  ·  ${session.exerciseCount} ejercicios${session.totalVolumeKg > 0 ? '  ·  ${_volumeLabel(session.totalVolumeKg)}' : ''}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  const Icon(Icons.chevron_right_rounded),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SummaryValue extends StatelessWidget {
  const _SummaryValue({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 18, color: context.appColors.accent),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}

String _formatShortDate(DateTime date) =>
    '${date.day} ${_monthAbbreviation(date.month)}';

String _volumeLabel(double volume) =>
    volume == 0 ? 'Sin datos de\u00A0carga' : '${_formatVolume(volume)} kg';

String _formatVolume(double volume) => volume == volume.roundToDouble()
    ? volume.toStringAsFixed(0)
    : volume.toStringAsFixed(1);

String _monthAbbreviation(int month) => const [
  'ene',
  'feb',
  'mar',
  'abr',
  'may',
  'jun',
  'jul',
  'ago',
  'sep',
  'oct',
  'nov',
  'dic',
][month - 1];
