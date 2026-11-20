import 'package:material_ui/material_ui.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../core/widgets/app_surface_card.dart';
import '../../profile/models/profile_settings.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  int _step = 0;
  String _goal = 'Ganar fuerza';
  String _experience = 'Estoy empezando';
  int _daysPerWeek = 3;
  int _sessionMinutes = 45;
  int _selectedDay = 0;

  static const _goals = ['Ganar fuerza', 'Ganar músculo', 'Crear el hábito'];
  static const _experienceLevels = [
    'Estoy empezando',
    'Tengo algo de experiencia',
    'Entreno hace tiempo',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_step < 3 ? 'Configura tu plan' : 'Tu plan FORZA'),
        leading: IconButton(
          tooltip: _step == 0 ? 'Volver' : 'Paso anterior',
          onPressed: _step == 0 ? null : () => setState(() => _step--),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final padding = constraints.maxWidth < 380
                ? AppSpacing.x4
                : AppSpacing.x6;
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: padding),
                      child: _StepProgress(step: _step.clamp(0, 2)),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(
                          padding,
                          AppSpacing.x6,
                          padding,
                          AppSpacing.x6,
                        ),
                        child: _buildStep(context),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        padding,
                        AppSpacing.x2,
                        padding,
                        AppSpacing.x4,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: _step == 7 ? _finish : _next,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            child: Text(_actionLabel),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String get _actionLabel => switch (_step) {
    0 || 1 => 'Continuar',
    2 => 'Ver resumen',
    3 => 'Preparar plan',
    4 => 'Ver mi plan',
    5 => 'Ver detalle del día',
    6 => 'Revisar y confirmar',
    _ => 'Confirmar plan',
  };

  Widget _buildStep(BuildContext context) {
    return switch (_step) {
      0 => _buildGoalStep(context),
      1 => _buildExperienceStep(context),
      2 => _buildScheduleStep(context),
      3 => _buildPersonalizationSummary(context),
      4 => _buildPreparingPlan(context),
      5 => _buildPersonalizedPlan(context),
      6 => _buildPlanDayDetail(context),
      _ => _buildConfirmationStep(context),
    };
  }

  Widget _buildPersonalizationSummary(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _StepEyebrow(label: 'B1 · RESUMEN DE PERSONALIZACIÓN'),
        const SizedBox(height: AppSpacing.x3),
        Text(
          'Así empezamos contigo',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          'Revisa tus preferencias antes de preparar una propuesta de entrenamiento.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: AppSpacing.x6),
        AppSurfaceCard(
          padding: const EdgeInsets.all(AppSpacing.x6),
          child: Column(
            children: [
              _PlanSummaryRow(
                icon: Icons.flag_outlined,
                label: 'Tu objetivo',
                value: _goal,
              ),
              const Divider(height: AppSpacing.x8),
              _PlanSummaryRow(
                icon: Icons.trending_up_rounded,
                label: 'Experiencia',
                value: _experience,
              ),
              const Divider(height: AppSpacing.x8),
              _PlanSummaryRow(
                icon: Icons.calendar_month_outlined,
                label: 'Frecuencia',
                value:
                    '$_daysPerWeek ${_daysPerWeek == 1 ? 'día' : 'días'} por semana',
              ),
              const Divider(height: AppSpacing.x8),
              _PlanSummaryRow(
                icon: Icons.schedule_rounded,
                label: 'Tiempo disponible',
                value: '$_sessionMinutes minutos por sesión',
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        OutlinedButton.icon(
          onPressed: () => setState(() => _step = 0),
          icon: const Icon(Icons.edit_outlined),
          label: const Text('Editar preferencias'),
        ),
      ],
    );
  }

  Widget _buildPreparingPlan(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _StepEyebrow(label: 'B2 · PREPARANDO EL PLAN'),
        const SizedBox(height: AppSpacing.x3),
        Text(
          'Dando forma a tu rutina',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          'Usamos tus preferencias para organizar una semana de entrenamiento de ejemplo.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: AppSpacing.x6),
        AppSurfaceCard(
          child: Column(
            children: [
              _PreparationStep(
                title: 'Objetivo definido',
                detail: _goal,
                icon: Icons.check_circle_rounded,
              ),
              const Divider(height: AppSpacing.x6),
              _PreparationStep(
                title: 'Ritmo semanal organizado',
                detail:
                    '$_daysPerWeek ${_daysPerWeek == 1 ? 'sesión' : 'sesiones'} de $_sessionMinutes min',
                icon: Icons.check_circle_rounded,
              ),
              const Divider(height: AppSpacing.x6),
              const _PreparationStep(
                title: 'Rutina de demostración lista',
                detail: 'Puedes revisar cada día antes de confirmarla',
                icon: Icons.auto_awesome_outlined,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        Text(
          'No se consulta ningún servicio externo; este plan se construye con datos locales de muestra.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildPersonalizedPlan(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _StepEyebrow(label: 'B3 · MI PLAN PERSONALIZADO'),
        const SizedBox(height: AppSpacing.x3),
        Text(
          'Tu semana de entrenamiento',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          'Elige un día para ver qué incluye la sesión.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: AppSpacing.x6),
        for (var day = 0; day < _daysPerWeek; day++) ...[
          _PlanDayCard(
            dayNumber: day + 1,
            title: _dayTitle(day),
            duration: _sessionMinutes,
            selected: day == _selectedDay,
            onTap: () => setState(() => _selectedDay = day),
          ),
          const SizedBox(height: AppSpacing.x3),
        ],
        const SizedBox(height: AppSpacing.x2),
        Text('Objetivo: $_goal', style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }

  Widget _buildPlanDayDetail(BuildContext context) {
    final exercises = _dayExercises(_selectedDay);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _StepEyebrow(label: 'B4 · DETALLE DE DÍA DEL PLAN'),
        const SizedBox(height: AppSpacing.x3),
        Text(
          _dayTitle(_selectedDay),
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          'Día ${_selectedDay + 1} · $_sessionMinutes min · ${exercises.length} ejercicios',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: AppSpacing.x6),
        for (var index = 0; index < exercises.length; index++) ...[
          AppSurfaceCard(
            padding: const EdgeInsets.all(AppSpacing.x4),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceMuted,
                    shape: BoxShape.circle,
                  ),
                  child: Text('${index + 1}'),
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exercises[index],
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      Text(
                        '3 series · 8–12 repeticiones',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }

  String _dayTitle(int day) => switch (day % 3) {
    0 => 'Tren superior',
    1 => 'Tren inferior',
    _ => 'Cuerpo completo',
  };

  List<String> _dayExercises(int day) => switch (day % 3) {
    0 => const [
      'Press de pecho con mancuernas',
      'Remo con mancuerna',
      'Press de hombros',
      'Plancha',
    ],
    1 => const [
      'Sentadilla goblet',
      'Peso muerto rumano',
      'Puente de glúteos',
      'Elevación de pantorrillas',
    ],
    _ => const ['Sentadilla', 'Press de pecho', 'Remo', 'Peso muerto rumano'],
  };

  Widget _buildConfirmationStep(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _StepEyebrow(label: 'B5 · CONFIRMACIÓN DEL PLAN'),
        const SizedBox(height: AppSpacing.x3),
        Text(
          'Tu plan está listo',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          'Revisa tu punto de partida. Puedes ajustar estos datos más adelante desde tu perfil.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: AppSpacing.x6),
        AppSurfaceCard(
          padding: const EdgeInsets.all(AppSpacing.x6),
          child: Column(
            children: [
              _PlanSummaryRow(
                icon: Icons.flag_outlined,
                label: 'Objetivo',
                value: _goal,
              ),
              const Divider(height: AppSpacing.x8),
              _PlanSummaryRow(
                icon: Icons.trending_up_rounded,
                label: 'Experiencia',
                value: _experience,
              ),
              const Divider(height: AppSpacing.x8),
              _PlanSummaryRow(
                icon: Icons.calendar_month_outlined,
                label: 'Frecuencia',
                value:
                    '$_daysPerWeek ${_daysPerWeek == 1 ? 'día' : 'días'} por semana',
              ),
              const Divider(height: AppSpacing.x8),
              _PlanSummaryRow(
                icon: Icons.schedule_rounded,
                label: 'Duración',
                value: '$_sessionMinutes minutos por sesión',
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        Text(
          'Esta confirmación solo guarda los valores en la sesión actual de la demo.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildGoalStep(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _StepEyebrow(label: 'PASO 1 DE 3'),
        const SizedBox(height: AppSpacing.x3),
        Text(
          '¿Qué quieres lograr?',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          'Elegiremos un punto de partida que se ajuste a ti. Puedes cambiarlo después.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: AppSpacing.x6),
        for (final goal in _goals) ...[
          _ChoiceCard(
            title: goal,
            subtitle: switch (goal) {
              'Ganar fuerza' => 'Progresar en tus levantamientos',
              'Ganar músculo' => 'Construir masa muscular con constancia',
              _ => 'Formar una rutina sostenible',
            },
            icon: switch (goal) {
              'Ganar fuerza' => Icons.bolt_rounded,
              'Ganar músculo' => Icons.fitness_center_rounded,
              _ => Icons.repeat_rounded,
            },
            selected: _goal == goal,
            onTap: () => setState(() => _goal = goal),
          ),
          const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }

  Widget _buildExperienceStep(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _StepEyebrow(label: 'PASO 2 DE 3'),
        const SizedBox(height: AppSpacing.x3),
        Text(
          '¿Cuál es tu experiencia?',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          'Usaremos tu respuesta para ajustar la carga inicial de la demostración.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: AppSpacing.x6),
        for (final level in _experienceLevels) ...[
          _ChoiceCard(
            title: level,
            subtitle: switch (level) {
              'Estoy empezando' => 'Quiero aprender y avanzar paso a paso',
              'Tengo algo de experiencia' => 'Ya conozco algunos movimientos',
              _ => 'Tengo una rutina y busco nuevos retos',
            },
            icon: Icons.trending_up_rounded,
            selected: _experience == level,
            onTap: () => setState(() => _experience = level),
          ),
          const SizedBox(height: AppSpacing.x3),
        ],
        Text(
          'Tu experiencia solo se usa en esta sesión de demostración.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildScheduleStep(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _StepEyebrow(label: 'PASO 3 DE 3'),
        const SizedBox(height: AppSpacing.x3),
        Text(
          'Haz espacio para entrenar',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          'Define un ritmo inicial realista. Después puedes ajustar estos valores en tu perfil.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: AppSpacing.x6),
        AppSurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Días por semana',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                '$_daysPerWeek ${_daysPerWeek == 1 ? 'día' : 'días'}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Slider(
                value: _daysPerWeek.toDouble(),
                min: 1,
                max: 7,
                divisions: 6,
                label: '$_daysPerWeek',
                onChanged: (value) =>
                    setState(() => _daysPerWeek = value.round()),
              ),
              const Divider(height: AppSpacing.x6),
              Text(
                'Duración por sesión',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                '$_sessionMinutes minutos',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Slider(
                value: _sessionMinutes.toDouble(),
                min: 20,
                max: 90,
                divisions: 7,
                label: '$_sessionMinutes min',
                onChanged: (value) =>
                    setState(() => _sessionMinutes = value.round()),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        AppSurfaceCard(
          color: AppColors.surfaceMuted,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info_outline_rounded),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  'Tu plan: $_goal · $_experience · $_daysPerWeek ${_daysPerWeek == 1 ? 'día' : 'días'} por semana.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _next() => setState(() => _step++);

  void _finish() {
    Navigator.of(context).pop(
      TrainingSettings(
        daysPerWeek: _daysPerWeek,
        sessionMinutes: _sessionMinutes,
        goal: _goal,
      ),
    );
  }
}

class _StepProgress extends StatelessWidget {
  const _StepProgress({required this.step});

  final int step;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Paso ${step + 1} de 3',
      child: Row(
        children: [
          for (var index = 0; index < 3; index++) ...[
            Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                height: 5,
                decoration: BoxDecoration(
                  color: index <= step
                      ? AppColors.textPrimary
                      : AppColors.surfaceMuted,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
              ),
            ),
            if (index < 2) const SizedBox(width: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class _StepEyebrow extends StatelessWidget {
  const _StepEyebrow({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
        color: AppColors.textSecondary,
        letterSpacing: 1.2,
        fontSize: 11,
      ),
    );
  }
}

class _PlanSummaryRow extends StatelessWidget {
  const _PlanSummaryRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 21),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: AppSpacing.x1),
              Text(value, style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        ),
      ],
    );
  }
}

class _PreparationStep extends StatelessWidget {
  const _PreparationStep({
    required this.title,
    required this.detail,
    required this.icon,
  });

  final String title;
  final String detail;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 22),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.x1),
              Text(detail, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}

class _PlanDayCard extends StatelessWidget {
  const _PlanDayCard({
    required this.dayNumber,
    required this.title,
    required this.duration,
    required this.selected,
    required this.onTap,
  });

  final int dayNumber;
  final String title;
  final int duration;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      padding: EdgeInsets.zero,
      borderColor: selected ? AppColors.textPrimary : AppColors.divider,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected
                      ? AppColors.textPrimary
                      : AppColors.surfaceMuted,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$dayNumber',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: selected
                        ? AppColors.inverseText
                        : AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      '$duration min · 4 ejercicios',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              Icon(
                selected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChoiceCard extends StatelessWidget {
  const _ChoiceCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      padding: EdgeInsets.zero,
      borderColor: selected ? AppColors.textPrimary : AppColors.divider,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Row(
            children: [
              Icon(icon, size: 22),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Icon(
                selected ? Icons.check_circle_rounded : Icons.circle_outlined,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
