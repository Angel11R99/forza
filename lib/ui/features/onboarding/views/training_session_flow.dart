import 'dart:async';

import 'package:material_ui/material_ui.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../core/widgets/app_surface_card.dart';
import '../../../core/widgets/forza_brand.dart';

class TrainingSessionFlow extends StatefulWidget {
  const TrainingSessionFlow({super.key});

  @override
  State<TrainingSessionFlow> createState() => _TrainingSessionFlowState();
}

class _TrainingSessionFlowState extends State<TrainingSessionFlow> {
  static const _exercises = <_SessionExercise>[
    _SessionExercise(
      name: 'Press con mancuernas',
      detail: 'Pecho · 3 series · 8–12 repeticiones',
      icon: Icons.fitness_center_rounded,
    ),
    _SessionExercise(
      name: 'Sentadilla goblet',
      detail: 'Piernas · 3 series · 8–12 repeticiones',
      icon: Icons.accessibility_new_rounded,
    ),
    _SessionExercise(
      name: 'Remo con mancuerna',
      detail: 'Espalda · 3 series · 8–12 repeticiones',
      icon: Icons.sports_gymnastics_rounded,
    ),
    _SessionExercise(
      name: 'Peso muerto rumano',
      detail: 'Piernas · 3 series · 8–10 repeticiones',
      icon: Icons.fitness_center_rounded,
    ),
  ];

  _SessionScreen _screen = _SessionScreen.preparation;
  _SessionScreen _resumeScreen = _SessionScreen.exerciseList;
  int _currentExercise = 0;
  int _remainingRestSeconds = 45;
  int _elapsedSeconds = 0;
  Timer? _restTimer;
  Timer? _sessionTimer;

  @override
  void dispose() {
    _restTimer?.cancel();
    _sessionTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        leading: IconButton(
          tooltip: _screen == _SessionScreen.preparation
              ? 'Volver'
              : 'Volver al paso anterior',
          onPressed: _goBack,
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        actions: [
          if (_screen == _SessionScreen.exerciseList ||
              _screen == _SessionScreen.rest)
            IconButton(
              tooltip: 'Pausar entrenamiento',
              onPressed: _pause,
              icon: const Icon(Icons.pause_rounded),
            ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = constraints.maxWidth < 380
                ? AppSpacing.x4
                : AppSpacing.x6;
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: Column(
                  children: [
                    if (_screen == _SessionScreen.exerciseList ||
                        _screen == _SessionScreen.rest)
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                        ),
                        child: _SessionProgress(
                          current: _currentExercise,
                          total: _exercises.length,
                        ),
                      ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(horizontalPadding),
                        child: _buildScreen(context),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        AppSpacing.x2,
                        horizontalPadding,
                        AppSpacing.x4,
                      ),
                      child: _screen == _SessionScreen.summary
                          ? _buildSummaryAction(context)
                          : _buildPrimaryAction(context),
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

  String get _title => switch (_screen) {
    _SessionScreen.preparation => 'Preparación',
    _SessionScreen.exerciseList => 'Tu entrenamiento',
    _SessionScreen.rest => 'Descanso',
    _SessionScreen.paused => 'Entrenamiento pausado',
    _SessionScreen.confirmAbandon => 'Confirmar abandono',
    _SessionScreen.completed => 'Entrenamiento completado',
    _SessionScreen.summary => 'Resumen de sesión',
  };

  Widget _buildScreen(BuildContext context) => switch (_screen) {
    _SessionScreen.preparation => _buildPreparation(context),
    _SessionScreen.exerciseList => _buildExerciseList(context),
    _SessionScreen.rest => _buildRest(context),
    _SessionScreen.paused => _buildPaused(context),
    _SessionScreen.confirmAbandon => _buildConfirmAbandon(context),
    _SessionScreen.completed => _buildCompleted(context),
    _SessionScreen.summary => _buildSummary(context),
  };

  Widget _buildPreparation(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SessionEyebrow(label: 'C1 · PREPARACIÓN DEL ENTRENAMIENTO'),
        const SizedBox(height: AppSpacing.x3),
        Text(
          'Todo listo para empezar',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          'Tómate un momento para preparar tu espacio y revisar la sesión de hoy.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: AppSpacing.x6),
        AppSurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Fuerza total',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.x3),
              Text(
                'Sesión de cuerpo completo',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: AppSpacing.x2),
              Text(
                '45 min · ${_exercises.length} ejercicios',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        for (final item in const [
          ('Botella de agua', Icons.water_drop_outlined),
          ('Espacio despejado', Icons.check_circle_outline_rounded),
          ('Equipo a mano', Icons.fitness_center_outlined),
        ]) ...[
          AppSurfaceCard(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.x4,
              vertical: AppSpacing.x3,
            ),
            child: Row(
              children: [
                Icon(item.$2, size: 20),
                const SizedBox(width: AppSpacing.x3),
                Expanded(child: Text(item.$1)),
                const Icon(Icons.check_rounded, size: 18),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
        ],
        const _SessionSaveNote(),
      ],
    );
  }

  Widget _buildExerciseList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SessionEyebrow(label: 'C4 · LISTA DE EJERCICIOS'),
        const SizedBox(height: AppSpacing.x3),
        Text(
          'Sigue tu sesión',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          'Ejercicio ${_currentExercise + 1} de ${_exercises.length}',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: AppSpacing.x6),
        for (var index = 0; index < _exercises.length; index++) ...[
          _ExerciseSessionCard(
            exercise: _exercises[index],
            index: index,
            current: index == _currentExercise,
            completed: index < _currentExercise,
          ),
          const SizedBox(height: AppSpacing.x3),
        ],
        const SizedBox(height: AppSpacing.x2),
        const _SessionSaveNote(),
      ],
    );
  }

  Widget _buildRest(BuildContext context) {
    final minutes = (_remainingRestSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingRestSeconds % 60).toString().padLeft(2, '0');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SessionEyebrow(label: 'C3 · DESCANSO'),
        const SizedBox(height: AppSpacing.x3),
        Text(
          'Tómate un respiro',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: AppSpacing.x6),
        AppSurfaceCard(
          padding: const EdgeInsets.all(AppSpacing.x8),
          child: Column(
            children: [
              SizedBox(
                width: 176,
                height: 176,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CircularProgressIndicator(
                      value: _remainingRestSeconds / 45,
                      strokeWidth: 8,
                      backgroundColor: AppColors.surfaceMuted,
                      color: AppColors.accent,
                    ),
                    Center(
                      child: Text(
                        '$minutes:$seconds',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.x4),
              Text(
                'Antes de ${_exercises[_currentExercise].name}',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        Text(
          'El temporizador es orientativo y solo corre mientras esta pantalla está activa.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildPaused(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SessionEyebrow(label: 'C5 · ENTRENAMIENTO PAUSADO'),
        const SizedBox(height: AppSpacing.x3),
        Text(
          'Pausa cuando lo necesites',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          'La sesión está en pausa. Puedes retomarla o terminar el entrenamiento.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: AppSpacing.x6),
        AppSurfaceCard(
          child: Row(
            children: [
              const Icon(Icons.pause_circle_outline_rounded, size: 32),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Text(
                  '${_currentExercise + 1} de ${_exercises.length} ejercicios',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmAbandon(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SessionEyebrow(label: 'C6 · CONFIRMAR ABANDONO'),
        const SizedBox(height: AppSpacing.x3),
        Text(
          '¿Quieres abandonar?',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          'Se cerrará esta sesión. El progreso no se guardará en el historial.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: AppSpacing.x6),
        const _SessionSaveNote(),
      ],
    );
  }

  Widget _buildCompleted(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SessionEyebrow(label: 'C7 · ENTRENAMIENTO COMPLETADO'),
        const SizedBox(height: AppSpacing.x3),
        Text('Buen trabajo', style: Theme.of(context).textTheme.displaySmall),
        const SizedBox(height: AppSpacing.x2),
        Text(
          'Terminaste la sesión de fuerza total.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: AppSpacing.x6),
        AppSurfaceCard(
          child: Row(
            children: [
              const Icon(
                Icons.check_circle_rounded,
                color: AppColors.accent,
                size: 36,
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Text(
                  '${_exercises.length} ejercicios completados',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        const _SessionSaveNote(),
      ],
    );
  }

  Widget _buildSummary(BuildContext context) {
    final durationMinutes = (_elapsedSeconds / 60).ceil().clamp(1, 99);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SessionEyebrow(label: 'C8 · RESUMEN DE SESIÓN'),
        const SizedBox(height: AppSpacing.x3),
        Text(
          'Así fue tu sesión',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          'Tu actividad de hoy, resumida.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: AppSpacing.x6),
        AppSurfaceCard(
          child: Column(
            children: [
              _SummaryMetric(
                icon: Icons.schedule_rounded,
                label: 'Duración',
                value: '$durationMinutes min',
              ),
              const Divider(height: AppSpacing.x6),
              _SummaryMetric(
                icon: Icons.fitness_center_rounded,
                label: 'Ejercicios',
                value: '${_exercises.length}',
              ),
              const Divider(height: AppSpacing.x6),
              const _SummaryMetric(
                icon: Icons.bolt_rounded,
                label: 'Tipo de sesión',
                value: 'Fuerza total',
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        const _SessionSaveNote(),
      ],
    );
  }

  Widget _buildPrimaryAction(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: switch (_screen) {
        _SessionScreen.preparation => FilledButton.icon(
          onPressed: _start,
          icon: const Icon(Icons.play_arrow_rounded),
          label: const Padding(
            padding: EdgeInsets.symmetric(vertical: 13),
            child: Text('Comenzar entrenamiento'),
          ),
        ),
        _SessionScreen.exerciseList => FilledButton(
          onPressed: _completeCurrentExercise,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 13),
            child: Text(
              _currentExercise == _exercises.length - 1
                  ? 'Completar entrenamiento'
                  : 'Completar ejercicio',
            ),
          ),
        ),
        _SessionScreen.rest => FilledButton(
          onPressed: _skipRest,
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 13),
            child: Text('Saltar descanso'),
          ),
        ),
        _SessionScreen.paused => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilledButton.icon(
              onPressed: _resume,
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Padding(
                padding: EdgeInsets.symmetric(vertical: 13),
                child: Text('Continuar entrenamiento'),
              ),
            ),
            const SizedBox(height: AppSpacing.x2),
            OutlinedButton(
              onPressed: () =>
                  setState(() => _screen = _SessionScreen.confirmAbandon),
              child: const Text('Abandonar sesión'),
            ),
          ],
        ),
        _SessionScreen.confirmAbandon => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 13),
                child: Text('Sí, abandonar'),
              ),
            ),
            const SizedBox(height: AppSpacing.x2),
            TextButton(
              onPressed: () => setState(() => _screen = _SessionScreen.paused),
              child: const Text('Seguir entrenando'),
            ),
          ],
        ),
        _SessionScreen.completed => FilledButton(
          onPressed: () => setState(() => _screen = _SessionScreen.summary),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 13),
            child: Text('Ver resumen de sesión'),
          ),
        ),
        _SessionScreen.summary => const SizedBox.shrink(),
      },
    );
  }

  Widget _buildSummaryAction(BuildContext context) => SizedBox(
    width: double.infinity,
    child: FilledButton(
      onPressed: () => Navigator.of(context).pop(true),
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 13),
        child: Text('Finalizar'),
      ),
    ),
  );

  void _start() {
    _elapsedSeconds = 0;
    _startSessionTimer();
    setState(() => _screen = _SessionScreen.exerciseList);
  }

  void _startSessionTimer() {
    _sessionTimer?.cancel();
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted && _screen != _SessionScreen.paused) {
        setState(() => _elapsedSeconds++);
      }
    });
  }

  void _completeCurrentExercise() {
    if (_currentExercise >= _exercises.length - 1) {
      _restTimer?.cancel();
      _sessionTimer?.cancel();
      setState(() => _screen = _SessionScreen.completed);
      return;
    }
    setState(() {
      _currentExercise++;
      _remainingRestSeconds = 45;
      _screen = _SessionScreen.rest;
    });
    _startRestTimer();
  }

  void _startRestTimer() {
    _restTimer?.cancel();
    _restTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return timer.cancel();
      if (_screen != _SessionScreen.rest) return;
      if (_remainingRestSeconds <= 1) {
        timer.cancel();
        setState(() {
          _remainingRestSeconds = 0;
          _screen = _SessionScreen.exerciseList;
        });
      } else {
        setState(() => _remainingRestSeconds--);
      }
    });
  }

  void _skipRest() {
    _restTimer?.cancel();
    setState(() {
      _remainingRestSeconds = 0;
      _screen = _SessionScreen.exerciseList;
    });
  }

  void _pause() {
    _resumeScreen = _screen;
    _restTimer?.cancel();
    _sessionTimer?.cancel();
    setState(() => _screen = _SessionScreen.paused);
  }

  void _resume() {
    setState(() => _screen = _resumeScreen);
    _startSessionTimer();
    if (_resumeScreen == _SessionScreen.rest) _startRestTimer();
  }

  void _goBack() {
    switch (_screen) {
      case _SessionScreen.preparation:
        Navigator.of(context).pop();
      case _SessionScreen.exerciseList:
        _pause();
      case _SessionScreen.rest:
        _pause();
      case _SessionScreen.paused:
        _resume();
      case _SessionScreen.confirmAbandon:
        setState(() => _screen = _SessionScreen.paused);
      case _SessionScreen.completed:
        setState(() => _screen = _SessionScreen.summary);
      case _SessionScreen.summary:
        Navigator.of(context).pop(true);
    }
  }
}

enum _SessionScreen {
  preparation,
  exerciseList,
  rest,
  paused,
  confirmAbandon,
  completed,
  summary,
}

class _SessionExercise {
  const _SessionExercise({
    required this.name,
    required this.detail,
    required this.icon,
  });

  final String name;
  final String detail;
  final IconData icon;
}

class _SessionProgress extends StatelessWidget {
  const _SessionProgress({required this.current, required this.total});

  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Ejercicio ${current + 1} de $total',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: LinearProgressIndicator(
          value: (current + 1) / total,
          minHeight: 6,
          backgroundColor: AppColors.surfaceMuted,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}

class _SessionEyebrow extends StatelessWidget {
  const _SessionEyebrow({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return ForzaEyebrow(label: label);
  }
}

class _ExerciseSessionCard extends StatelessWidget {
  const _ExerciseSessionCard({
    required this.exercise,
    required this.index,
    required this.current,
    required this.completed,
  });

  final _SessionExercise exercise;
  final int index;
  final bool current;
  final bool completed;

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      borderColor: current ? AppColors.accent : AppColors.divider,
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: current ? AppColors.accent : AppColors.surfaceMuted,
              shape: BoxShape.circle,
            ),
            child: completed
                ? const Icon(Icons.check_rounded, color: AppColors.inverseText)
                : Icon(
                    exercise.icon,
                    color: current
                        ? AppColors.inverseText
                        : AppColors.textPrimary,
                    size: 19,
                  ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercise.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  exercise.detail,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          if (current)
            const Icon(Icons.play_circle_outline_rounded, size: 22)
          else if (!completed)
            Text('${index + 1}', style: Theme.of(context).textTheme.labelLarge),
        ],
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({
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
        Icon(icon, size: 20),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Text(label, style: Theme.of(context).textTheme.bodyLarge),
        ),
        Text(value, style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }
}

class _SessionSaveNote extends StatelessWidget {
  const _SessionSaveNote();

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      color: AppColors.surfaceMuted,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded, size: 20),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              'Los ejercicios y resultados no se guardan en el historial.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
