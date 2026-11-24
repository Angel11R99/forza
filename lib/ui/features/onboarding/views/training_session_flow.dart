import 'dart:async';
import 'dart:convert';

import 'package:material_ui/material_ui.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../core/widgets/app_surface_card.dart';
import '../../../core/widgets/forza_brand.dart';
import '../../profile/models/profile_settings.dart';
import '../../../../domain/use_cases/training_plan_builder.dart';
import '../../../../domain/models/workout_record.dart';
import '../../../../data/repositories/workout_log_repository.dart';
import '../../../../app/localization/localization_extensions.dart';
import '../../exercises/models/exercise_localized_labels.dart';
import '../../../../data/repositories/demo_exercise_repository.dart';
import '../../../../domain/models/exercise.dart';
import '../../exercises/widgets/exercise_animation.dart';

class TrainingSessionFlow extends StatefulWidget {
  const TrainingSessionFlow({
    super.key,
    required this.settings,
    required this.workoutLogRepository,
    this.sessionIndex = 0,
    required this.scheduledDate,
  });

  final TrainingSettings settings;
  final WorkoutLogRepository workoutLogRepository;
  final int sessionIndex;
  final DateTime scheduledDate;

  @override
  State<TrainingSessionFlow> createState() => _TrainingSessionFlowState();
}

class _TrainingSessionFlowState extends State<TrainingSessionFlow> {
  static const _planBuilder = TrainingPlanBuilder();
  WorkoutLogRepository get _workoutRepository => widget.workoutLogRepository;
  final Map<int, List<WorkoutSetResult>> _setResults = {};
  final Set<String> _completedSets = {};
  List<Exercise> _catalog = const [];
  bool _restoring = true;

  PlannedTrainingSession get _plannedSession => _planBuilder.buildWeek(
    trainingDays: widget.settings.trainingDays,
    sessionMinutes: widget.settings.sessionMinutes,
    goal: widget.settings.goal,
    experience: widget.settings.experience,
    equipment: widget.settings.equipment,
  )[widget.sessionIndex.clamp(0, widget.settings.trainingDays.length - 1)];

  List<_SessionExercise> get _exercises => _planBuilder
      .buildSession(
        sessionIndex: widget.sessionIndex,
        sessionMinutes: widget.settings.sessionMinutes,
        goal: widget.settings.goal,
        experience: widget.settings.experience,
        equipment: widget.settings.equipment,
      )
      .map(
        (exercise) => _SessionExercise(
          name: exercise.name,
          focus: exercise.focus,
          isTimed: exercise.timed,
          setCount: exercise.prescription.startsWith('2 series') ? 2 : 3,
          detail: '${exercise.focus} · ${exercise.prescription}',
          icon: switch (exercise.focus) {
            'Piernas' => Icons.accessibility_new_rounded,
            'Espalda' => Icons.sports_gymnastics_rounded,
            'Core' => Icons.accessibility_new_rounded,
            _ => Icons.fitness_center_rounded,
          },
        ),
      )
      .toList(growable: false);

  _SessionScreen _screen = _SessionScreen.preparation;
  _SessionScreen _resumeScreen = _SessionScreen.exerciseList;
  _SessionScreen _exitReturnScreen = _SessionScreen.preparation;
  int _currentExercise = 0;
  int _remainingRestSeconds = 45;
  int _elapsedSeconds = 0;
  int _timedRemainingSeconds = 30;
  bool _timedSetRunning = false;
  bool _resumeTimedSet = false;
  Timer? _restTimer;
  Timer? _sessionTimer;
  Timer? _timedSetTimer;

  @override
  void initState() {
    super.initState();
    _restoreDraft();
  }

  Future<void> _restoreDraft() async {
    try {
      await DemoExerciseRepository.instance.load();
      _catalog = DemoExerciseRepository.instance.search();
      final raw = await _workoutRepository.loadActiveWorkout();
      if (raw != null) {
        final draft = jsonDecode(raw) as Map<String, Object?>;
        final date = DateTime(
          widget.scheduledDate.year,
          widget.scheduledDate.month,
          widget.scheduledDate.day,
        );
        if (draft['scheduledDate'] == date.toIso8601String()) {
          _currentExercise = (draft['currentExercise'] as int? ?? 0).clamp(
            0,
            _exercises.length - 1,
          );
          _elapsedSeconds = draft['elapsedSeconds'] as int? ?? 0;
          _remainingRestSeconds = draft['remainingRestSeconds'] as int? ?? 45;
          _timedRemainingSeconds = draft['timedRemainingSeconds'] as int? ?? 30;
          _resumeTimedSet = draft['resumeTimedSet'] as bool? ?? false;
          _resumeScreen = _SessionScreen.values.firstWhere(
            (screen) => screen.name == draft['resumeScreen'],
            orElse: () => _SessionScreen.exerciseList,
          );
          _screen = _SessionScreen.paused;
          final savedSets = draft['sets'] as List<Object?>? ?? const [];
          for (final item in savedSets.whereType<Map<String, Object?>>()) {
            final result = WorkoutSetResult.fromJson(item);
            (_setResults[result.exercisePosition] ??= []).add(result);
          }
          _completedSets.addAll(
            (draft['completedSets'] as List<Object?>? ?? const [])
                .whereType<String>(),
          );
        }
      }
    } on Object {
      // Ignore an invalid draft and allow a fresh session.
    }
    if (mounted) setState(() => _restoring = false);
  }

  Future<void> _saveDraft() {
    final date = DateTime(
      widget.scheduledDate.year,
      widget.scheduledDate.month,
      widget.scheduledDate.day,
    );
    return _workoutRepository.saveActiveWorkout({
      'scheduledDate': date.toIso8601String(),
      'currentExercise': _currentExercise,
      'elapsedSeconds': _elapsedSeconds,
      'remainingRestSeconds': _remainingRestSeconds,
      'timedRemainingSeconds': _timedRemainingSeconds,
      'resumeTimedSet': _timedSetRunning || _resumeTimedSet,
      'resumeScreen':
          (_screen == _SessionScreen.paused ? _resumeScreen : _screen).name,
      'sets': [
        for (final sets in _setResults.values)
          ...sets.map((set) => set.toJson()),
      ],
      'completedSets': _completedSets.toList(),
    });
  }

  @override
  void dispose() {
    _restTimer?.cancel();
    _sessionTimer?.cancel();
    _timedSetTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_restoring) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(_title(context)),
        leading: IconButton(
          tooltip: _screen == _SessionScreen.preparation
              ? context.l10n.sessionBack
              : context.l10n.sessionBackStep,
          onPressed: _goBack,
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        actions: [
          if (_screen != _SessionScreen.confirmAbandon)
            IconButton(
              tooltip: context.l10n.sessionExitTitle,
              onPressed: _requestExit,
              icon: const Icon(Icons.close_rounded),
            ),
          if (_screen == _SessionScreen.exerciseList ||
              _screen == _SessionScreen.rest)
            IconButton(
              tooltip: context.l10n.sessionPause,
              onPressed: _pause,
              icon: const Icon(Icons.pause_rounded),
            ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = AppSpacing.pageGutter(
              constraints.maxWidth,
            );
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

  String _title(BuildContext context) => switch (_screen) {
    _SessionScreen.preparation => context.l10n.sessionTitlePreparation,
    _SessionScreen.warmup => context.l10n.sessionTitleWarmup,
    _SessionScreen.exerciseList => context.l10n.sessionTitleWorkout,
    _SessionScreen.rest => context.l10n.sessionTitleRest,
    _SessionScreen.paused => context.l10n.sessionTitlePaused,
    _SessionScreen.confirmAbandon => context.l10n.sessionTitleConfirmAbandon,
    _SessionScreen.completed => context.l10n.sessionTitleCompleted,
    _SessionScreen.summary => context.l10n.sessionTitleSummary,
  };

  Widget _buildScreen(BuildContext context) => switch (_screen) {
    _SessionScreen.preparation => _buildPreparation(context),
    _SessionScreen.warmup => _buildWarmup(context),
    _SessionScreen.exerciseList => _buildExerciseList(context),
    _SessionScreen.rest => _buildRest(context),
    _SessionScreen.paused => _buildPaused(context),
    _SessionScreen.confirmAbandon => _buildConfirmAbandon(context),
    _SessionScreen.completed => _buildCompleted(context),
    _SessionScreen.summary => _buildSummary(context),
  };

  List<_WarmupMovement> get _warmupMovements =>
      switch (widget.sessionIndex % 3) {
        0 => const [
          _WarmupMovement(
            'Círculos de hombros',
            '30 s',
            'Haz círculos suaves hacia delante y hacia atrás.',
            Icons.accessibility_new_rounded,
          ),
          _WarmupMovement(
            'Rotación torácica',
            '30 s por lado',
            'Gira el torso sin forzar el cuello.',
            Icons.sync_alt_rounded,
          ),
          _WarmupMovement(
            'Flexiones inclinadas',
            '8 repeticiones',
            'Apoya las manos en una superficie firme y mueve con control.',
            Icons.fitness_center_rounded,
          ),
        ],
        1 => const [
          _WarmupMovement(
            'Marcha en el sitio',
            '45 s',
            'Eleva las rodillas a un ritmo cómodo.',
            Icons.directions_walk_rounded,
          ),
          _WarmupMovement(
            'Bisagra de cadera',
            '8 repeticiones',
            'Lleva la cadera atrás manteniendo la espalda cómoda.',
            Icons.accessibility_new_rounded,
          ),
          _WarmupMovement(
            'Sentadilla sin carga',
            '8 repeticiones',
            'Baja solo hasta un rango que puedas controlar.',
            Icons.airline_seat_legroom_normal_rounded,
          ),
        ],
        _ => const [
          _WarmupMovement(
            'Marcha con brazos',
            '45 s',
            'Marcha en el sitio y acompaña el movimiento con los brazos.',
            Icons.directions_walk_rounded,
          ),
          _WarmupMovement(
            'Rotaciones de torso',
            '30 s',
            'Gira suavemente de lado a lado, sin rebotes.',
            Icons.sync_alt_rounded,
          ),
          _WarmupMovement(
            'Bisagra de cadera',
            '8 repeticiones',
            'Lleva la cadera atrás con un movimiento lento y cómodo.',
            Icons.accessibility_new_rounded,
          ),
        ],
      };

  Widget _buildWarmup(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SessionEyebrow(label: context.l10n.sessionWarmup),
        const SizedBox(height: AppSpacing.x3),
        Text(
          context.l10n.sessionWarmupHeadline,
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          context.l10n.sessionWarmupDescription(
            _localizedPlanTitle(context, _plannedSession.title),
          ),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: AppSpacing.x6),
        for (var index = 0; index < _warmupMovements.length; index++) ...[
          AppSurfaceCard(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  _warmupMovements[index].icon,
                  color: context.appColors.accent,
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _localizedWarmupTitle(
                          context,
                          _warmupMovements[index].title,
                        ),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      Text(
                        _localizedWarmupInstructions(
                          context,
                          _warmupMovements[index].title,
                        ),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.x2),
                Text(
                  _localizedWarmupDuration(
                    context,
                    _warmupMovements[index].duration,
                  ),
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ],
            ),
          ),
          if (index < _warmupMovements.length - 1)
            const SizedBox(height: AppSpacing.x2),
        ],
      ],
    );
  }

  Widget _buildPreparation(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SessionEyebrow(label: context.l10n.sessionPreparation),
        const SizedBox(height: AppSpacing.x3),
        Text(
          context.l10n.sessionPreparationHeadline,
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          context.l10n.sessionPreparationDescription,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: AppSpacing.x6),
        AppSurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _localizedGoal(context, widget.settings.goal),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.x3),
              Text(
                _localizedPlanTitle(context, _plannedSession.title),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: AppSpacing.x2),
              Text(
                context.l10n.homeDurationExercises(
                  widget.settings.sessionMinutes,
                  _exercises.length,
                ),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        for (final item in [
          (context.l10n.sessionWaterBottle, Icons.water_drop_outlined),
          (context.l10n.sessionClearSpace, Icons.check_circle_outline_rounded),
          (context.l10n.sessionEquipmentReady, Icons.fitness_center_outlined),
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
        _SessionEyebrow(label: context.l10n.sessionExercises),
        const SizedBox(height: AppSpacing.x3),
        Text(
          context.l10n.sessionExerciseHeadline,
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          context.l10n.sessionExerciseCountProgress(
            _currentExercise + 1,
            _exercises.length,
          ),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: AppSpacing.x6),
        for (var index = 0; index < _exercises.length; index++) ...[
          _ExerciseSessionCard(
            exercise: _exercises[index],
            index: index,
            current: index == _currentExercise,
            completed: _isExerciseComplete(index),
            onTap: index <= _currentExercise
                ? () {
                    _restTimer?.cancel();
                    setState(() {
                      _currentExercise = index;
                      _screen = _SessionScreen.exerciseList;
                    });
                    _saveDraft();
                  }
                : () {},
          ),
          const SizedBox(height: AppSpacing.x3),
        ],
        if (_currentExercise < _exercises.length) ...[
          _buildGuidedExercise(context),
          const SizedBox(height: AppSpacing.x4),
          Text(
            context.l10n.sessionSetLog,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.x2),
          for (
            var setIndex = 0;
            setIndex < _exercises[_currentExercise].setCount;
            setIndex++
          ) ...[
            _WorkoutSetEditor(
              label: context.l10n.sessionSet(setIndex + 1),
              isTimed: _exercises[_currentExercise].isTimed,
              result: _resultFor(_currentExercise, setIndex),
              canComplete: _exercises[_currentExercise].isTimed
                  ? (_resultFor(_currentExercise, setIndex)?.durationSeconds ??
                            0) >
                        0
                  : (_resultFor(_currentExercise, setIndex)?.repetitions ?? 0) >
                        0,
              completed: _completedSets.contains('$_currentExercise:$setIndex'),
              onCompletedChanged: (completed) {
                final result = _resultFor(_currentExercise, setIndex);
                final hasValue = _exercises[_currentExercise].isTimed
                    ? (result?.durationSeconds ?? 0) > 0
                    : (result?.repetitions ?? 0) > 0;
                if (completed && !hasValue) return;
                setState(() {
                  final key = '$_currentExercise:$setIndex';
                  if (completed) {
                    _completedSets.add(key);
                  } else {
                    _completedSets.remove(key);
                  }
                });
                _saveDraft();
              },
              onChanged: (result) {
                final sets = _setResults.putIfAbsent(
                  _currentExercise,
                  () => [],
                );
                final position = sets.indexWhere(
                  (item) => item.setIndex == setIndex,
                );
                final value = WorkoutSetResult(
                  exercisePosition: _currentExercise,
                  setIndex: setIndex,
                  repetitions: result.repetitions,
                  loadKg: result.loadKg,
                  durationSeconds: result.durationSeconds,
                );
                setState(() {
                  if (position == -1) {
                    sets.add(value);
                  } else {
                    sets[position] = value;
                  }
                });
                _saveDraft();
              },
            ),
            const SizedBox(height: AppSpacing.x2),
          ],
        ],
        const SizedBox(height: AppSpacing.x2),
        const _SessionSaveNote(),
      ],
    );
  }

  Widget _buildGuidedExercise(BuildContext context) {
    final current = _exercises[_currentExercise];
    final matched = _catalog.cast<Exercise?>().firstWhere(
      (exercise) =>
          exercise != null &&
          (exercise.name.toLowerCase() == current.name.toLowerCase() ||
              (exercise.englishName?.toLowerCase() ==
                  current.name.toLowerCase())),
      orElse: () => null,
    );
    final instructions = matched == null
        ? const <String>[]
        : localizedExerciseInstructions(context, matched);
    return AppSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.sessionProgress(
              _currentExercise + 1,
              _exercises.length,
            ),
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: AppSpacing.x2),
          if (matched != null) ...[
            SizedBox(
              height: 190,
              width: double.infinity,
              child: ExerciseAnimationView(
                exerciseId: matched.id,
                animation: matched.animation,
                label: localizedTrainingExerciseName(context, current.name),
              ),
            ),
            const SizedBox(height: AppSpacing.x3),
          ],
          Text(
            localizedTrainingExerciseName(context, current.name),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.x2),
          for (var i = 0; i < instructions.length; i++) ...[
            Text(
              '${i + 1}. ${instructions[i]}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (i < instructions.length - 1)
              const SizedBox(height: AppSpacing.x2),
          ],
          if (instructions.isEmpty)
            Text(
              _localizedExerciseDetail(context, current.detail),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          if (current.isTimed) ...[
            const SizedBox(height: AppSpacing.x4),
            Center(
              child: Text(
                '00:${_timedRemainingSeconds.toString().padLeft(2, '0')}',
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ),
            const SizedBox(height: AppSpacing.x2),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _timedSetRunning ? _pauseTimedSet : _startTimedSet,
                icon: Icon(
                  _timedSetRunning ? Icons.pause_rounded : Icons.timer_outlined,
                ),
                label: Text(
                  _timedSetRunning
                      ? context.l10n.sessionTimedSetRunning
                      : context.l10n.sessionStartTimedSet,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRest(BuildContext context) {
    final minutes = (_remainingRestSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingRestSeconds % 60).toString().padLeft(2, '0');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SessionEyebrow(label: context.l10n.sessionRest),
        const SizedBox(height: AppSpacing.x3),
        Text(
          context.l10n.sessionRestHeadline,
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
                      backgroundColor: context.appColors.surfaceMuted,
                      color: context.appColors.accent,
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
                context.l10n.sessionBeforeExercise(
                  localizedTrainingExerciseName(
                    context,
                    _exercises[_currentExercise].name,
                  ),
                ),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        Text(
          context.l10n.sessionTimerNote,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildPaused(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SessionEyebrow(label: context.l10n.sessionPaused),
        const SizedBox(height: AppSpacing.x3),
        Text(
          context.l10n.sessionPauseHeadline,
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          context.l10n.sessionPauseDescription,
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
                  context.l10n.sessionProgressCount(
                    _currentExercise + 1,
                    _exercises.length,
                  ),
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
        _SessionEyebrow(label: context.l10n.sessionExitTitle),
        const SizedBox(height: AppSpacing.x3),
        Text(
          context.l10n.sessionAbandonHeadline,
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          context.l10n.sessionAbandonDescription,
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
        _SessionEyebrow(label: context.l10n.sessionCompletedTitle),
        const SizedBox(height: AppSpacing.x3),
        Text(
          context.l10n.sessionGoodWork,
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          context.l10n.sessionWorkoutFinishedFor(
            _localizedPlanTitle(context, _plannedSession.title),
          ),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: AppSpacing.x6),
        AppSurfaceCard(
          child: Row(
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: context.appColors.accent,
                size: 36,
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Text(
                  context.l10n.sessionExercisesCompleted(
                    _completedExerciseCount,
                  ),
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
        _SessionEyebrow(label: context.l10n.sessionSummary),
        const SizedBox(height: AppSpacing.x3),
        Text(
          context.l10n.sessionSummaryHeadline,
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          context.l10n.sessionSummaryDescription,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: AppSpacing.x6),
        AppSurfaceCard(
          child: Column(
            children: [
              _SummaryMetric(
                icon: Icons.schedule_rounded,
                label: context.l10n.sessionDuration,
                value: '$durationMinutes min',
              ),
              const Divider(height: AppSpacing.x6),
              _SummaryMetric(
                icon: Icons.fitness_center_rounded,
                label: context.l10n.sessionExerciseCount,
                value: '$_completedExerciseCount',
              ),
              const Divider(height: AppSpacing.x6),
              _SummaryMetric(
                icon: Icons.bolt_rounded,
                label: context.l10n.sessionGoal,
                value: _localizedGoal(context, widget.settings.goal),
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
          onPressed: () => setState(() => _screen = _SessionScreen.warmup),
          icon: const Icon(Icons.arrow_forward_rounded),
          label: Padding(
            padding: EdgeInsets.symmetric(vertical: 13),
            child: Text(context.l10n.sessionWarmupButton),
          ),
        ),
        _SessionScreen.warmup => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilledButton.icon(
              onPressed: _start,
              icon: const Icon(Icons.play_arrow_rounded),
              label: Padding(
                padding: EdgeInsets.symmetric(vertical: 13),
                child: Text(context.l10n.sessionStart),
              ),
            ),
            const SizedBox(height: AppSpacing.x2),
            TextButton(
              onPressed: _start,
              child: Text(context.l10n.sessionSkipWarmupButton),
            ),
          ],
        ),
        _SessionScreen.exerciseList => FilledButton(
          onPressed: _isExerciseComplete(_currentExercise)
              ? _completeCurrentExercise
              : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 13),
            child: Text(
              _currentExercise == _exercises.length - 1
                  ? context.l10n.sessionCompleteWorkout
                  : context.l10n.sessionCompleteExercise,
            ),
          ),
        ),
        _SessionScreen.rest => FilledButton(
          onPressed: _skipRest,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 13),
            child: Text(context.l10n.sessionSkipRestButton),
          ),
        ),
        _SessionScreen.paused => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilledButton.icon(
              onPressed: _resume,
              icon: const Icon(Icons.play_arrow_rounded),
              label: Padding(
                padding: EdgeInsets.symmetric(vertical: 13),
                child: Text(context.l10n.sessionContinue),
              ),
            ),
            const SizedBox(height: AppSpacing.x2),
            OutlinedButton(
              onPressed: _finishEarly,
              child: Text(context.l10n.sessionFinish),
            ),
          ],
        ),
        _SessionScreen.confirmAbandon => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilledButton(
              onPressed: () async {
                await _workoutRepository.clearActiveWorkout();
                if (!context.mounted) return;
                Navigator.of(context).pop();
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 13),
                child: Text(context.l10n.sessionAbandonConfirm),
              ),
            ),
            const SizedBox(height: AppSpacing.x2),
            TextButton(
              onPressed: _restoreFromExitConfirmation,
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.small),
                ),
              ),
              child: Text(context.l10n.sessionKeep),
            ),
          ],
        ),
        _SessionScreen.completed => FilledButton(
          onPressed: () => setState(() => _screen = _SessionScreen.summary),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 13),
            child: Text(context.l10n.sessionViewSummary),
          ),
        ),
        _SessionScreen.summary => const SizedBox.shrink(),
      },
    );
  }

  Widget _buildSummaryAction(BuildContext context) => SizedBox(
    width: double.infinity,
    child: FilledButton(
      onPressed: _finishWithRecord,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 13),
        child: Text(context.l10n.sessionFinish),
      ),
    ),
  );

  void _start() {
    _elapsedSeconds = 0;
    _startSessionTimer();
    setState(() => _screen = _SessionScreen.exerciseList);
    _saveDraft();
  }

  void _startSessionTimer() {
    _sessionTimer?.cancel();
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted && _screen != _SessionScreen.paused) {
        setState(() => _elapsedSeconds++);
        if (_elapsedSeconds % 15 == 0) _saveDraft();
      }
    });
  }

  void _completeCurrentExercise() {
    if (!_isExerciseComplete(_currentExercise)) return;
    if (_currentExercise >= _exercises.length - 1) {
      _restTimer?.cancel();
      _sessionTimer?.cancel();
      setState(() => _screen = _SessionScreen.completed);
      _resumeScreen = _SessionScreen.completed;
      _saveDraft();
      return;
    }
    setState(() {
      _currentExercise++;
      _remainingRestSeconds = 45;
      _timedRemainingSeconds = 30;
      _screen = _SessionScreen.rest;
    });
    _saveDraft();
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
        _saveDraft();
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
    _saveDraft();
  }

  void _pause() {
    _resumeScreen = _screen;
    _restTimer?.cancel();
    _resumeTimedSet = _timedSetRunning;
    _timedSetTimer?.cancel();
    _timedSetRunning = false;
    _sessionTimer?.cancel();
    setState(() => _screen = _SessionScreen.paused);
    _saveDraft();
  }

  void _requestExit() {
    _exitReturnScreen = _screen;
    if (_screen == _SessionScreen.exerciseList ||
        _screen == _SessionScreen.rest) {
      _resumeScreen = _screen;
      _restTimer?.cancel();
      _resumeTimedSet = _timedSetRunning;
      _timedSetTimer?.cancel();
      _timedSetRunning = false;
      _sessionTimer?.cancel();
      _saveDraft();
    }
    setState(() => _screen = _SessionScreen.confirmAbandon);
  }

  void _restoreFromExitConfirmation() {
    setState(() => _screen = _exitReturnScreen);
    if (_exitReturnScreen == _SessionScreen.exerciseList ||
        _exitReturnScreen == _SessionScreen.rest) {
      _startSessionTimer();
    }
    if (_exitReturnScreen == _SessionScreen.rest) _startRestTimer();
    if (_exitReturnScreen == _SessionScreen.exerciseList && _resumeTimedSet) {
      _resumeTimedSet = false;
      _startTimedSet();
    }
  }

  void _resume() {
    setState(() => _screen = _resumeScreen);
    if (_resumeScreen == _SessionScreen.exerciseList ||
        _resumeScreen == _SessionScreen.rest) {
      _startSessionTimer();
    }
    if (_resumeScreen == _SessionScreen.rest) _startRestTimer();
    if (_resumeScreen == _SessionScreen.exerciseList && _resumeTimedSet) {
      _resumeTimedSet = false;
      _startTimedSet();
    }
    _saveDraft();
  }

  void _startTimedSet() {
    if (!_exercises[_currentExercise].isTimed ||
        _isExerciseComplete(_currentExercise)) {
      return;
    }
    _timedSetTimer?.cancel();
    if (_timedRemainingSeconds == 0) {
      setState(() => _timedRemainingSeconds = 30);
    }
    setState(() => _timedSetRunning = true);
    _timedSetTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return timer.cancel();
      if (_timedRemainingSeconds <= 1) {
        timer.cancel();
        final setIndex =
            List.generate(
              _exercises[_currentExercise].setCount,
              (index) => index,
            ).firstWhere(
              (index) => !_completedSets.contains('$_currentExercise:$index'),
            );
        final sets = _setResults.putIfAbsent(_currentExercise, () => []);
        final existing = sets.indexWhere((set) => set.setIndex == setIndex);
        final result = WorkoutSetResult(
          exercisePosition: _currentExercise,
          setIndex: setIndex,
          durationSeconds: 30,
        );
        setState(() {
          _timedRemainingSeconds = 0;
          _timedSetRunning = false;
          _completedSets.add('$_currentExercise:$setIndex');
          if (existing < 0) {
            sets.add(result);
          } else {
            sets[existing] = result;
          }
        });
        _saveDraft();
      } else {
        setState(() => _timedRemainingSeconds--);
      }
    });
  }

  void _pauseTimedSet() {
    _timedSetTimer?.cancel();
    setState(() => _timedSetRunning = false);
  }

  Future<void> _finishWithRecord() async {
    await _saveRecord();
  }

  Future<void> _finishEarly() async {
    if (_completedSets.isEmpty) {
      setState(() => _screen = _SessionScreen.confirmAbandon);
      return;
    }
    await _saveRecord();
  }

  Future<void> _saveRecord() async {
    _restTimer?.cancel();
    _sessionTimer?.cancel();
    final durationMinutes = (_elapsedSeconds / 60).ceil().clamp(1, 99);
    await _workoutRepository.clearActiveWorkout();
    if (!mounted) return;
    final results = [for (final sets in _setResults.values) ...sets]
        .where(
          (result) => _completedSets.contains(
            '${result.exercisePosition}:${result.setIndex}',
          ),
        )
        .toList(growable: false);
    final completedPositions = results
        .map((result) => result.exercisePosition)
        .toSet();
    Navigator.of(context).pop(
      WorkoutRecord(
        scheduledDate: widget.scheduledDate,
        completedAt: DateTime.now(),
        title: _plannedSession.title,
        goal: widget.settings.goal,
        durationMinutes: durationMinutes,
        exerciseCount: completedPositions.length,
        exercises: [
          for (final index in completedPositions.toList()..sort())
            _exercises[index].name,
        ],
        setResults: results,
      ),
    );
  }

  bool _isExerciseComplete(int exercise) => List.generate(
    _exercises[exercise].setCount,
    (index) => index,
  ).every((index) => _completedSets.contains('$exercise:$index'));
  int get _completedExerciseCount =>
      {for (final key in _completedSets) int.tryParse(key.split(':').first)}
          .whereType<int>()
          .length;

  WorkoutSetResult? _resultFor(int exercise, int set) {
    for (final result in _setResults[exercise] ?? const <WorkoutSetResult>[]) {
      if (result.setIndex == set) return result;
    }
    return null;
  }

  void _goBack() {
    switch (_screen) {
      case _SessionScreen.preparation:
        Navigator.of(context).pop();
      case _SessionScreen.warmup:
        setState(() => _screen = _SessionScreen.preparation);
      case _SessionScreen.exerciseList:
        _pause();
      case _SessionScreen.rest:
        _pause();
      case _SessionScreen.paused:
        _resume();
      case _SessionScreen.confirmAbandon:
        _restoreFromExitConfirmation();
      case _SessionScreen.completed:
        setState(() => _screen = _SessionScreen.summary);
      case _SessionScreen.summary:
        _finishWithRecord();
    }
  }
}

enum _SessionScreen {
  preparation,
  warmup,
  exerciseList,
  rest,
  paused,
  confirmAbandon,
  completed,
  summary,
}

class _WarmupMovement {
  const _WarmupMovement(
    this.title,
    this.duration,
    this.instructions,
    this.icon,
  );

  final String title;
  final String duration;
  final String instructions;
  final IconData icon;
}

class _WorkoutSetEditor extends StatelessWidget {
  const _WorkoutSetEditor({
    required this.label,
    required this.isTimed,
    required this.result,
    required this.canComplete,
    required this.completed,
    required this.onCompletedChanged,
    required this.onChanged,
  });

  final String label;
  final bool isTimed;
  final WorkoutSetResult? result;
  final bool canComplete;
  final bool completed;
  final ValueChanged<bool> onCompletedChanged;
  final ValueChanged<WorkoutSetResult> onChanged;

  @override
  Widget build(BuildContext context) {
    final value =
        result ?? const WorkoutSetResult(exercisePosition: 0, setIndex: 0);
    return AppSurfaceCard(
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              Checkbox(
                value: completed,
                onChanged: completed || canComplete
                    ? (value) => onCompletedChanged(value ?? false)
                    : null,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          Row(
            children: [
              Expanded(
                child: _numberField(
                  label: isTimed
                      ? context.l10n.sessionSeconds
                      : context.l10n.sessionRepetitions,
                  initialValue: isTimed
                      ? value.durationSeconds
                      : value.repetitions,
                  onChanged: (number) => onChanged(
                    WorkoutSetResult(
                      exercisePosition: value.exercisePosition,
                      setIndex: value.setIndex,
                      repetitions: isTimed
                          ? value.repetitions
                          : number?.toInt(),
                      loadKg: value.loadKg,
                      durationSeconds: isTimed
                          ? number?.toInt()
                          : value.durationSeconds,
                    ),
                  ),
                ),
              ),
              if (!isTimed) ...[
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: _numberField(
                    label: context.l10n.sessionLoad,
                    initialValue: value.loadKg,
                    decimal: true,
                    onChanged: (number) => onChanged(
                      WorkoutSetResult(
                        exercisePosition: value.exercisePosition,
                        setIndex: value.setIndex,
                        repetitions: value.repetitions,
                        loadKg: number?.toDouble(),
                        durationSeconds: value.durationSeconds,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _numberField({
    required String label,
    required num? initialValue,
    required ValueChanged<num?> onChanged,
    bool decimal = false,
  }) => TextFormField(
    initialValue: initialValue?.toString() ?? '',
    keyboardType: TextInputType.numberWithOptions(decimal: decimal),
    decoration: InputDecoration(labelText: label),
    onChanged: (text) =>
        onChanged(decimal ? double.tryParse(text) : int.tryParse(text)),
  );
}

class _SessionExercise {
  const _SessionExercise({
    required this.name,
    required this.focus,
    this.isTimed = false,
    required this.setCount,
    required this.icon,
    this.detail = '',
  });

  final String name;
  final String focus;
  final bool isTimed;
  final int setCount;
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
      label: context.l10n.sessionExerciseCountProgress(current + 1, total),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: LinearProgressIndicator(
          value: (current + 1) / total,
          minHeight: 6,
          backgroundColor: context.appColors.surfaceMuted,
          color: context.appColors.textPrimary,
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
    required this.onTap,
  });

  final _SessionExercise exercise;
  final int index;
  final bool current;
  final bool completed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      padding: EdgeInsets.zero,
      borderColor: current
          ? context.appColors.accent
          : context.appColors.divider,
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
                  color: current
                      ? context.appColors.accent
                      : context.appColors.surfaceMuted,
                  shape: BoxShape.circle,
                ),
                child: completed
                    ? Icon(
                        Icons.check_rounded,
                        color: context.appColors.inverseText,
                      )
                    : Icon(
                        exercise.icon,
                        color: current
                            ? context.appColors.inverseText
                            : context.appColors.textPrimary,
                        size: 19,
                      ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizedTrainingExerciseName(context, exercise.name),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      _localizedExerciseDetail(context, exercise.detail),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              if (current)
                const Icon(Icons.play_circle_outline_rounded, size: 22)
              else if (!completed)
                Text(
                  '${index + 1}',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
            ],
          ),
        ),
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
      color: context.appColors.surfaceMuted,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded, size: 20),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              context.l10n.sessionRecordNote,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

String _localizedPlanTitle(BuildContext context, String title) =>
    switch (title) {
      'Tren superior' => context.l10n.onboardingUpperBody,
      'Tren inferior' => context.l10n.onboardingLowerBody,
      _ => context.l10n.onboardingFullBody,
    };

String _localizedGoal(BuildContext context, String goal) =>
    context.localizeTrainingGoal(goal);

String _localizedExerciseDetail(BuildContext context, String detail) {
  final parts = detail.split(' · ');
  if (parts.length < 3) return detail;
  final setCount = int.tryParse(parts[1].split(' ').first) ?? 0;
  final target = switch (parts[2]) {
    '20–40 segundos' => context.l10n.sessionTimeTarget,
    '6–8 repeticiones' => context.l10n.sessionRepTargetLow,
    '8–12 repeticiones' => context.l10n.sessionRepTargetMid,
    _ => context.l10n.sessionRepTargetComfortable,
  };
  return '${localizedExerciseMuscleGroup(context, parts.first)} · ${context.l10n.sessionSetsTarget(setCount, target)}';
}

String _localizedWarmupTitle(BuildContext context, String title) =>
    switch (title) {
      'Círculos de hombros' => context.l10n.warmupShoulderCircles,
      'Rotación torácica' => context.l10n.warmupThoracicRotation,
      'Flexiones inclinadas' => context.l10n.warmupInclinePushups,
      'Marcha en el sitio' => context.l10n.warmupMarch,
      'Bisagra de cadera' => context.l10n.warmupHipHinge,
      'Sentadilla sin carga' => context.l10n.warmupBodyweightSquat,
      'Marcha con brazos' => context.l10n.warmupMarchArms,
      _ => context.l10n.warmupTorsoRotations,
    };

String _localizedWarmupInstructions(BuildContext context, String title) =>
    switch (title) {
      'Círculos de hombros' => context.l10n.warmupShoulderCirclesInstructions,
      'Rotación torácica' => context.l10n.warmupThoracicInstructions,
      'Flexiones inclinadas' => context.l10n.warmupInclineInstructions,
      'Marcha en el sitio' => context.l10n.warmupMarchInstructions,
      'Bisagra de cadera' => context.l10n.warmupHipHingeInstructions,
      'Sentadilla sin carga' => context.l10n.warmupBodyweightSquatInstructions,
      'Marcha con brazos' => context.l10n.warmupMarchArmsInstructions,
      _ => context.l10n.warmupTorsoInstructions,
    };

String _localizedWarmupDuration(BuildContext context, String duration) =>
    switch (duration) {
      '30 s' => context.l10n.warmupThirtySeconds,
      '30 s por lado' => context.l10n.warmupThirtySecondsEachSide,
      '45 s' => context.l10n.warmupFortyFiveSeconds,
      _ => context.l10n.warmupEightReps,
    };
