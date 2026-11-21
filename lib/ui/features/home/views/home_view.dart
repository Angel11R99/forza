import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../core/widgets/app_surface_card.dart';
import '../../../core/widgets/forza_brand.dart';
import '../../../core/widgets/section_heading.dart';

class HomeView extends StatelessWidget {
  const HomeView({
    super.key,
    required this.onShowActivity,
    required this.onExploreExercises,
    required this.onShowProfile,
  });

  final VoidCallback onShowActivity;
  final VoidCallback onExploreExercises;
  final VoidCallback onShowProfile;

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = MediaQuery.sizeOf(context).width < 380
        ? AppSpacing.x4
        : AppSpacing.x6;
    final now = DateTime.now();
    final greeting = switch (now.hour) {
      < 12 => 'Buenos días',
      < 19 => 'Buenas tardes',
      _ => 'Buenas noches',
    };

    return CustomScrollView(
      key: const PageStorageKey<String>('home-scroll'),
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            AppSpacing.x4,
            horizontalPadding,
            AppSpacing.x8,
          ),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: const ForzaWordmark(),
                    ),
                    IconButton.filledTonal(
                      onPressed: onShowProfile,
                      tooltip: 'Abrir perfil',
                      icon: const Icon(Icons.person_outline_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  DateFormat('EEEE, d MMMM', 'es_DO').format(now),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: AppSpacing.x6),
                Text(greeting, style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'Hazte más fuerte.',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: AppSpacing.x6),
                _TodayWorkoutCard(onPressed: onShowActivity),
                const SizedBox(height: AppSpacing.x8),
                SectionHeading(
                  title: 'Esta semana',
                  actionLabel: 'Ver actividad',
                  onAction: onShowActivity,
                ),
                const _WeeklySummary(),
                const SizedBox(height: AppSpacing.x8),
                SectionHeading(
                  title: 'Biblioteca',
                  actionLabel: 'Explorar',
                  onAction: onExploreExercises,
                ),
                _LibraryLink(onPressed: onExploreExercises),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TodayWorkoutCard extends StatelessWidget {
  const _TodayWorkoutCard({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.x6),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(AppRadius.large),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.fitness_center_rounded,
                color: AppColors.inverseText,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'ENTRENAMIENTO DE HOY',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.inverseText.withValues(alpha: 0.8),
                  fontSize: 11,
                  letterSpacing: 0.7,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Text(
            'Fuerza total',
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(color: AppColors.inverseText),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            '45 min   ·   6 ejercicios',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.inverseText.withValues(alpha: 0.82),
            ),
          ),
          const SizedBox(height: AppSpacing.x6),
          SizedBox(
            width: double.infinity,
            child: FilledButton.tonalIcon(
              onPressed: onPressed,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.inverseText,
                foregroundColor: AppColors.accent,
              ),
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Ver entrenamiento'),
            ),
          ),
        ],
      ),
    );
  }
}

class _WeeklySummary extends StatelessWidget {
  const _WeeklySummary();

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      padding: const EdgeInsets.all(AppSpacing.x6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '2 de 4 sesiones',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      'La mitad de tu meta semanal',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 52,
                height: 52,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    const CircularProgressIndicator(
                      value: 0.5,
                      strokeWidth: 4,
                      backgroundColor: AppColors.surfaceMuted,
                      valueColor: AlwaysStoppedAnimation(AppColors.accent),
                    ),
                    Center(
                      child: Text(
                        '50%',
                        style: Theme.of(context).textTheme.labelLarge
                            ?.copyWith(color: AppColors.accent, fontSize: 11),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x6),
          const Row(
            children: [
              _DayMark(label: 'L', completed: true),
              _DayMark(label: 'M', completed: true),
              _DayMark(label: 'X', current: true),
              _DayMark(label: 'J'),
              _DayMark(label: 'V'),
              _DayMark(label: 'S'),
              _DayMark(label: 'D'),
            ],
          ),
        ],
      ),
    );
  }
}

class _DayMark extends StatelessWidget {
  const _DayMark({
    required this.label,
    this.completed = false,
    this.current = false,
  });

  final String label;
  final bool completed;
  final bool current;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: completed ? AppColors.accentSoft : AppColors.surfaceMuted,
              border: current
                  ? Border.all(color: AppColors.accent, width: 1.5)
                  : null,
            ),
            alignment: Alignment.center,
            child: completed
                ? const Icon(
                    Icons.check_rounded,
                    size: 17,
                    color: AppColors.accent,
                  )
                : null,
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _LibraryLink extends StatelessWidget {
  const _LibraryLink({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      padding: EdgeInsets.zero,
      child: ListTile(
        onTap: onPressed,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x4,
          vertical: AppSpacing.x2,
        ),
        leading: const Icon(Icons.sports_gymnastics_outlined, size: 26),
        title: Text(
          'Explora ejercicios',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          'Guías visuales para cada movimiento',
          style: Theme.of(context).textTheme.bodyMedium
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        trailing: const Icon(Icons.chevron_right_rounded),
      ),
    );
  }
}
