import 'package:material_ui/material_ui.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../core/widgets/app_surface_card.dart';
import '../../../core/widgets/section_heading.dart';
import '../data/progress_demo_data.dart';
import '../models/progress_models.dart';
import 'progress_detail_pages.dart';

class ProgressView extends StatefulWidget {
  const ProgressView({super.key});

  @override
  State<ProgressView> createState() => _ProgressViewState();
}

class _ProgressViewState extends State<ProgressView> {
  late final List<MeasurementEntry> _measurements =
      ProgressDemoData.measurements(DateTime.now());

  @override
  Widget build(BuildContext context) {
    final sessions = ProgressDemoData.sessions(DateTime.now());
    final totalMinutes = sessions.fold<int>(
      0,
      (total, session) => total + session.durationMinutes,
    );
    final horizontalPadding = MediaQuery.sizeOf(context).width < 380
        ? AppSpacing.x4
        : AppSpacing.x6;

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
                Text(
                  'Tu constancia cuenta',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  'Tu progreso',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'Cada entrenamiento suma.',
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
                      Text(
                        '${sessions.length} sesiones',
                        style: Theme.of(context).textTheme.headlineSmall,
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
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.x8),
                SectionHeading(title: 'Historial de entrenamientos'),
                for (final session in sessions) ...[
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.x2),
                    child: _SessionHistoryCard(
                      session: session,
                      onTap: () => _openSession(context, session),
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.x6),
                SectionHeading(title: 'Evolución y marcas'),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final wide = constraints.maxWidth >= 520;
                    final cardWidth = wide
                        ? (constraints.maxWidth - AppSpacing.x3) / 2
                        : constraints.maxWidth;
                    return Wrap(
                      spacing: AppSpacing.x3,
                      runSpacing: AppSpacing.x3,
                      children: [
                        SizedBox(
                          width: cardWidth,
                          child: _ProgressShortcut(
                            icon: Icons.show_chart_rounded,
                            title: 'Evolución de fuerza',
                            subtitle: 'Mira tus cargas',
                            onTap: () => _openStrength(context),
                          ),
                        ),
                        SizedBox(
                          width: cardWidth,
                          child: _ProgressShortcut(
                            icon: Icons.monitor_weight_outlined,
                            title: 'Evolución corporal',
                            subtitle: 'Peso y medidas',
                            onTap: () => _openBody(context),
                          ),
                        ),
                        SizedBox(
                          width: cardWidth,
                          child: _ProgressShortcut(
                            icon: Icons.emoji_events_outlined,
                            title: 'Récords personales',
                            subtitle: 'Tus mejores marcas',
                            onTap: () => _openRecords(context),
                          ),
                        ),
                      ],
                    );
                  },
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

  void _openStrength(BuildContext context) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(builder: (_) => const StrengthEvolutionPage()),
    );
  }

  void _openBody(BuildContext context) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => BodyEvolutionPage(
          measurements: List.unmodifiable(_measurements),
          onSaveMeasurement: (entry) {
            setState(() => _measurements.add(entry));
          },
        ),
      ),
    );
  }

  void _openRecords(BuildContext context) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(builder: (_) => const PersonalRecordsPage()),
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
                  const SizedBox(
                    width: 48,
                    height: 48,
                    child: Icon(
                      Icons.fitness_center_rounded,
                      color: AppColors.textPrimary,
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
                          '${_formatShortDate(session.date)}  ·  ${session.durationMinutes} min  ·  ${session.exerciseCount} ejercicios',
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

class _ProgressShortcut extends StatelessWidget {
  const _ProgressShortcut({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      padding: EdgeInsets.zero,
      child: Semantics(
        button: true,
        label: '$title, $subtitle',
        child: ExcludeSemantics(
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppRadius.medium),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.x4),
              child: Row(
                children: [
                  Icon(icon, size: 24),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: AppSpacing.x1),
                        Text(
                          subtitle,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_rounded, size: 18),
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
          Icon(icon, size: 18, color: AppColors.textSecondary),
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
