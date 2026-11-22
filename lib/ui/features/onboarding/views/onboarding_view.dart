import 'package:material_ui/material_ui.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../core/widgets/app_surface_card.dart';
import '../../../../domain/use_cases/training_plan_builder.dart';
import '../../profile/models/profile_settings.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({
    super.key,
    this.initialSettings = const TrainingSettings(),
    this.isFirstRun = false,
  });

  final TrainingSettings initialSettings;
  final bool isFirstRun;

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  static const _planBuilder = TrainingPlanBuilder();
  int _step = 0;
  late String _goal = widget.initialSettings.goal;
  late String _experience = widget.initialSettings.experience;
  late final Set<int> _trainingDays = {...widget.initialSettings.trainingDays};
  late int _sessionMinutes = widget.initialSettings.sessionMinutes;
  late final Set<String> _equipment = {...widget.initialSettings.equipment};

  static const _goals = ['Ganar fuerza', 'Ganar músculo', 'Crear el hábito'];
  static const _equipmentOptions = [
    'Peso corporal',
    'Mancuernas',
    'Barra',
    'Banda elástica',
    'Polea',
    'Máquina de palanca',
  ];
  static const _weekdays = <int, String>{
    DateTime.monday: 'Lun',
    DateTime.tuesday: 'Mar',
    DateTime.wednesday: 'Mié',
    DateTime.thursday: 'Jue',
    DateTime.friday: 'Vie',
    DateTime.saturday: 'Sáb',
    DateTime.sunday: 'Dom',
  };
  static const _experienceLevels = [
    'Estoy empezando',
    'Tengo algo de experiencia',
    'Entreno hace tiempo',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_step < 4 ? 'Crear tu plan' : 'Vista previa'),
        leading: IconButton(
          tooltip: _step == 0 ? 'Volver' : 'Paso anterior',
          onPressed: _step == 0
              ? () => Navigator.of(context).maybePop()
              : () => setState(() => _step--),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final padding = AppSpacing.pageGutter(constraints.maxWidth);
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: padding),
                      child: _StepProgress(step: _step, totalSteps: 5),
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
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              onPressed: _step == 4
                                  ? _finish
                                  : _step == 3 && _equipment.isEmpty
                                  ? null
                                  : _next,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 13,
                                ),
                                child: Text(_actionLabel),
                              ),
                            ),
                          ),
                          if (widget.isFirstRun)
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Omitir por ahora'),
                            ),
                        ],
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

  String get _actionLabel => _step == 4 ? 'Crear mi plan' : 'Continuar';

  Widget _buildStep(BuildContext context) {
    return switch (_step) {
      0 => _buildGoalStep(context),
      1 => _buildExperienceStep(context),
      2 => _buildScheduleStep(context),
      3 => _buildEquipmentStep(context),
      _ => _buildPersonalizedPlan(context),
    };
  }

  Widget _buildPersonalizedPlan(BuildContext context) {
    final sessions = _planBuilder.buildWeek(
      trainingDays: _trainingDays,
      sessionMinutes: _sessionMinutes,
      goal: _goal,
      experience: _experience,
      equipment: _equipment,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Así queda tu semana',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          'Este es un punto de partida. Podrás ajustar tu plan desde Perfil.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: AppSpacing.x6),
        AppSurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_goal, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.x2),
              Text(
                '${_trainingDays.length} días · $_sessionMinutes min por sesión',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                'Experiencia: $_experience',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                'Equipo: ${_equipment.join(', ')}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        for (final session in sessions) ...[
          AppSurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_weekdays[session.weekday]} · ${session.title}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  '${session.exercises.length} ejercicios · ${session.durationMinutes} min',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  session.exercises
                      .map((exercise) => exercise.name)
                      .join(' · '),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
        ],
        const SizedBox(height: AppSpacing.x2),
        Text(
          'Guía general. Si tienes dolor, una lesión o una condición médica, consulta con un profesional antes de entrenar.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildEquipmentStep(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '¿Con qué equipo cuentas?',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          'Usaremos esto para elegir ejercicios que puedas hacer.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: AppSpacing.x6),
        Wrap(
          spacing: AppSpacing.x2,
          runSpacing: AppSpacing.x2,
          children: [
            for (final equipment in _equipmentOptions)
              FilterChip(
                label: Text(equipment),
                selected: _equipment.contains(equipment),
                onSelected: (selected) => setState(() {
                  if (selected) {
                    _equipment.add(equipment);
                  } else {
                    _equipment.remove(equipment);
                  }
                }),
              ),
          ],
        ),
        if (_equipment.isEmpty) ...[
          const SizedBox(height: AppSpacing.x3),
          Text(
            'Elige al menos una opción para preparar los ejercicios.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ],
    );
  }

  Widget _buildGoalStep(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        Text(
          '¿Cuál es tu experiencia?',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          'Usaremos tu respuesta para ajustar la carga inicial.',
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
          'Tu experiencia ayuda a ajustar el entrenamiento.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildScheduleStep(BuildContext context) {
    final days = _trainingDays.toList()..sort();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '¿Qué días puedes entrenar?',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          'Elige los días que suelen funcionarte. Puedes cambiarlos después.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: AppSpacing.x6),
        AppSurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${days.length} ${days.length == 1 ? 'sesión' : 'sesiones'} por semana',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.x3),
              Wrap(
                spacing: AppSpacing.x2,
                runSpacing: AppSpacing.x2,
                children: [
                  for (final entry in _weekdays.entries)
                    FilterChip(
                      label: Text(entry.value),
                      selected: _trainingDays.contains(entry.key),
                      onSelected: (selected) => setState(() {
                        if (selected) {
                          _trainingDays.add(entry.key);
                        } else if (_trainingDays.length > 1) {
                          _trainingDays.remove(entry.key);
                        }
                      }),
                    ),
                ],
              ),
              const Divider(height: AppSpacing.x8),
              Text(
                'Tiempo por sesión',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                '$_sessionMinutes min',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Slider(
                value: _sessionMinutes.toDouble(),
                min: 20,
                max: 90,
                divisions: 14,
                label: '$_sessionMinutes min',
                onChanged: (value) =>
                    setState(() => _sessionMinutes = value.round()),
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
        trainingDays: Set.unmodifiable(_trainingDays),
        sessionMinutes: _sessionMinutes,
        goal: _goal,
        experience: _experience,
        equipment: Set.unmodifiable(_equipment),
      ),
    );
  }
}

class _StepProgress extends StatelessWidget {
  const _StepProgress({required this.step, required this.totalSteps});

  final int step;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    final progress = (step + 1) / totalSteps;
    return Semantics(
      label: 'Paso ${step + 1} de $totalSteps',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Paso ${step + 1} de $totalSteps',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: AppSpacing.x2),
          LinearProgressIndicator(
            value: progress,
            minHeight: 4,
            backgroundColor: AppColors.surfaceMuted,
            color: AppColors.accent,
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
        ],
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
      borderColor: selected ? AppColors.accent : AppColors.divider,
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
