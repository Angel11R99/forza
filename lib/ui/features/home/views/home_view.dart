import 'package:material_ui/material_ui.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../core/widgets/app_surface_card.dart';
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontalPadding = constraints.maxWidth < 380
            ? AppSpacing.x4
            : AppSpacing.x6;

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
                    _BrandHeader(onShowProfile: onShowProfile),
                    const SizedBox(height: AppSpacing.x8),
                    Text(
                      'ENTRENA A TU RITMO',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.textSecondary,
                        letterSpacing: 1.4,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x2),
                    Text(
                      'Cada sesión\nte hace más fuerte.',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    const SizedBox(height: AppSpacing.x3),
                    const _DemoBadge(),
                    const SizedBox(height: AppSpacing.x8),
                    _TodayWorkoutCard(onPressed: onShowActivity),
                    const SizedBox(height: AppSpacing.x8),
                    SectionHeading(
                      title: 'Tu semana',
                      actionLabel: 'Actividad',
                      onAction: onShowActivity,
                    ),
                    const _WeeklyProgressCard(),
                    const SizedBox(height: AppSpacing.x8),
                    SectionHeading(
                      title: 'Sigue avanzando',
                      actionLabel: 'Explorar',
                      onAction: onExploreExercises,
                    ),
                    _ExploreCard(onPressed: onExploreExercises),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _BrandHeader extends StatelessWidget {
  const _BrandHeader({required this.onShowProfile});

  final VoidCallback onShowProfile;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ExcludeSemantics(
          child: Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.textPrimary,
              shape: BoxShape.circle,
            ),
            child: const Text(
              'F',
              style: TextStyle(
                color: AppColors.inverseText,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Text(
          'FORZA',
          style: Theme.of(context).textTheme.titleMedium
              ?.copyWith(letterSpacing: 1.8, fontWeight: FontWeight.w800),
        ),
        const Spacer(),
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(color: AppColors.divider),
          ),
          child: IconButton(
            tooltip: 'Abrir perfil',
            onPressed: onShowProfile,
            icon: const Icon(Icons.person_outline_rounded, size: 21),
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _DemoBadge extends StatelessWidget {
  const _DemoBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x2,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        'DATOS DE EJEMPLO',
        style: Theme.of(context).textTheme.labelLarge
            ?.copyWith(fontSize: 10, letterSpacing: 1),
      ),
    );
  }
}

class _TodayWorkoutCard extends StatelessWidget {
  const _TodayWorkoutCard({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.x6),
      decoration: BoxDecoration(
        color: AppColors.textPrimary,
        borderRadius: BorderRadius.circular(AppRadius.large),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'ENTRENAMIENTO DE HOY',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.inverseText.withValues(alpha: 0.72),
                    letterSpacing: 1.2,
                    fontSize: 11,
                  ),
                ),
              ),
              const Icon(
                Icons.bolt_rounded,
                color: Color(0xFFD6DED2),
                size: 22,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x6),
          Text(
            'Fuerza total',
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(color: AppColors.inverseText),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            '45 min  ·  6 ejercicios',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.inverseText.withValues(alpha: 0.76),
            ),
          ),
          const SizedBox(height: AppSpacing.x6),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onPressed,
              icon: const Icon(Icons.arrow_forward_rounded, size: 18),
              label: const Text('Ver mi actividad'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.inverseText,
                foregroundColor: AppColors.textPrimary,
                minimumSize: const Size(48, 50),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WeeklyProgressCard extends StatelessWidget {
  const _WeeklyProgressCard();

  static const _days = <({String label, bool completed, bool today})>[
    (label: 'L', completed: true, today: false),
    (label: 'M', completed: true, today: false),
    (label: 'X', completed: false, today: true),
    (label: 'J', completed: false, today: false),
    (label: 'V', completed: false, today: false),
    (label: 'S', completed: false, today: false),
    (label: 'D', completed: false, today: false),
  ];

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
                      '3 de 4 sesiones',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      'Vas construyendo constancia',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              Text('75%', style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: const LinearProgressIndicator(
              value: 0.75,
              minHeight: 7,
              backgroundColor: AppColors.surfaceMuted,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.textPrimary),
            ),
          ),
          const SizedBox(height: AppSpacing.x6),
          LayoutBuilder(
            builder: (context, constraints) {
              final markSize = (constraints.maxWidth / _days.length).clamp(
                24.0,
                34.0,
              );

              return Row(
                children: [
                  for (final day in _days)
                    Expanded(
                      child: Center(
                        child: _WeekdayMark(day: day, markSize: markSize),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _WeekdayMark extends StatelessWidget {
  const _WeekdayMark({required this.day, required this.markSize});

  final ({String label, bool completed, bool today}) day;
  final double markSize;

  @override
  Widget build(BuildContext context) {
    final background = day.completed
        ? AppColors.textPrimary
        : day.today
        ? AppColors.surfaceMuted
        : AppColors.background;
    final foreground = day.completed
        ? AppColors.inverseText
        : AppColors.textPrimary;

    return Column(
      children: [
        Container(
          width: markSize,
          height: markSize,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: background,
            shape: BoxShape.circle,
            border: Border.all(
              color: day.today ? AppColors.textPrimary : Colors.transparent,
              width: day.today ? 1 : 0,
            ),
          ),
          child: day.completed
              ? Icon(Icons.check_rounded, size: 17, color: foreground)
              : Text(
                  day.label,
                  style: Theme.of(context).textTheme.labelLarge
                      ?.copyWith(color: foreground),
                ),
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          day.label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12),
        ),
      ],
    );
  }
}

class _ExploreCard extends StatelessWidget {
  const _ExploreCard({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.surfaceMuted,
                  borderRadius: BorderRadius.circular(AppRadius.small),
                ),
                child: const Icon(
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
                      'Encuentra tu próximo reto',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      'Explora ejercicios por grupo muscular',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              const Icon(Icons.arrow_forward_rounded, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
