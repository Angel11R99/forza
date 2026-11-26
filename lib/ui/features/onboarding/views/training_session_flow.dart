import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../core/widgets/app_surface_card.dart';
import '../../../core/widgets/forza_brand.dart';
import '../../profile/models/profile_settings.dart';
import '../../../../domain/use_cases/training_plan_builder.dart';
import '../../../../domain/models/workout_record.dart';
import '../../../../domain/use_cases/training_progression_advisor.dart';
import '../../../../domain/use_cases/weight_units.dart';
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
    this.plannedSession,
    this.planVersion = 1,
    this.weightUnit = 'kg',
  });

  final TrainingSettings settings;
  final WorkoutLogRepository workoutLogRepository;
  final int sessionIndex;
  final DateTime scheduledDate;
  final PlannedTrainingSession? plannedSession;
  final int planVersion;
  final String weightUnit;

  @override
  State<TrainingSessionFlow> createState() => _TrainingSessionFlowState();
}

class _TrainingSessionFlowState extends State<TrainingSessionFlow> {
  static const _planBuilder = TrainingPlanBuilder();
  static const _progressionAdvisor = TrainingProgressionAdvisor();
  WorkoutLogRepository get _workoutRepository => widget.workoutLogRepository;
  final Map<int, List<WorkoutSetResult>> _setResults = {};
  final Set<String> _completedSets = {};
  List<Exercise> _catalog = const [];
  List<WorkoutRecord> _workoutHistory = const [];
  PlannedTrainingSession? _restoredPlannedSession;
  PlannedTrainingSession? _reviewPlannedSession;
  Map<String, Object?>? _draftToReview;
  DateTime? _restoredScheduledDate;
  DateTime? _reviewScheduledDate;
  int? _restoredPlanVersion;
  Future<void> _pendingDraftWrite = Future<void>.value();
  bool _restoring = true;
  bool _reviewDraftDateMismatch = false;
  bool _reviewDraftCorrupt = false;
  bool _restoredDifferentPlan = false;
  bool _isSavingRecord = false;
  bool _isAbandoning = false;

  PlannedTrainingSession get _plannedSession =>
      _restoredPlannedSession ??
      widget.plannedSession ??
      _planBuilder.buildWeek(
        trainingDays: widget.settings.trainingDays,
        sessionMinutes: widget.settings.sessionMinutes,
        goal: widget.settings.goal,
        experience: widget.settings.experience,
        equipment: widget.settings.equipment,
        avoidedExerciseIds: widget.settings.avoidedExerciseIds,
      )[widget.sessionIndex.clamp(0, widget.settings.trainingDays.length - 1)];

  DateTime get _sessionDate => _restoredScheduledDate ?? widget.scheduledDate;
  int get _sessionPlanVersion => _restoredPlanVersion ?? widget.planVersion;

  List<_SessionExercise> get _exercises => _plannedSession.exercises
      .map(
        (exercise) => _SessionExercise(
          catalogId: exercise.catalogId,
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
  int _restDurationSeconds = 45;
  _RestContext _restContext = _RestContext.betweenExercises;
  int _elapsedSeconds = 0;
  int _timedRemainingSeconds = 30;
  bool _timedSetRunning = false;
  bool _resumeTimedSet = false;
  int _cooldownIndex = 0;
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
      _workoutHistory = await _workoutRepository.load();
      final raw = await _workoutRepository.loadActiveWorkout();
      if (raw != null) {
        final decoded = jsonDecode(raw);
        if (decoded is! Map) {
          _reviewDraftCorrupt = true;
          _screen = _SessionScreen.reviewDraft;
        } else {
          final draft = Map<String, Object?>.from(decoded);
          _reviewDraftDateMismatch = !_matchesScheduledDate(
            draft['scheduledDate'],
            widget.scheduledDate,
          );
          _draftToReview = draft;
          final savedPlanJson = draft['planSnapshot'];
          if (savedPlanJson is Map) {
            try {
              _reviewPlannedSession = PlannedTrainingSession.fromJson(
                Map<String, Object?>.from(savedPlanJson),
              );
            } on Object {
              _reviewDraftCorrupt = true;
            }
          }
          final savedDate = DateTime.tryParse(
            draft['scheduledDate'] as String? ?? '',
          );
          _reviewScheduledDate = savedDate == null
              ? null
              : DateTime(savedDate.year, savedDate.month, savedDate.day);

          if (_reviewDraftDateMismatch ||
              _reviewPlannedSession == null && !_reviewDraftCorrupt) {
            _screen = _SessionScreen.reviewDraft;
          } else if (!_reviewDraftCorrupt) {
            _activateDraft(
              draft,
              savedPlan: _reviewPlannedSession,
              savedDate: _reviewScheduledDate,
            );
          } else {
            _screen = _SessionScreen.reviewDraft;
          }
        }
      }
    } on Object {
      _reviewDraftCorrupt = true;
      _screen = _SessionScreen.reviewDraft;
    }
    if (mounted) setState(() => _restoring = false);
  }

  bool _matchesScheduledDate(Object? value, DateTime date) {
    if (value is! String) return false;
    final savedDate = DateTime.tryParse(value);
    return savedDate != null &&
        DateTime(savedDate.year, savedDate.month, savedDate.day) ==
            DateTime(date.year, date.month, date.day);
  }

  void _activateDraft(
    Map<String, Object?> draft, {
    PlannedTrainingSession? savedPlan,
    DateTime? savedDate,
  }) {
    final currentPlan = _plannedSession;
    final savedPlanVersion = draft['planVersion'];
    _restoredDifferentPlan =
        savedPlan != null &&
        (jsonEncode(savedPlan.toJson()) != jsonEncode(currentPlan.toJson()) ||
            savedPlanVersion != widget.planVersion);
    _restoredPlannedSession = savedPlan;
    _restoredScheduledDate = savedDate;
    _restoredPlanVersion = savedPlanVersion is int && savedPlanVersion > 0
        ? savedPlanVersion
        : widget.planVersion;
    _currentExercise = (draft['currentExercise'] as int? ?? 0).clamp(
      0,
      _exercises.length - 1,
    );
    _elapsedSeconds = (draft['elapsedSeconds'] as int? ?? 0).clamp(0, 86400);
    _remainingRestSeconds = (draft['remainingRestSeconds'] as int? ?? 45).clamp(
      0,
      90,
    );
    final savedRestDuration = draft['restDurationSeconds'] as int? ?? 45;
    _restDurationSeconds = [30, 45, 60, 90].contains(savedRestDuration)
        ? savedRestDuration
        : 45;
    _restContext = _RestContext.values.firstWhere(
      (context) => context.name == draft['restContext'],
      orElse: () => _RestContext.betweenExercises,
    );
    _timedRemainingSeconds = (draft['timedRemainingSeconds'] as int? ?? 30)
        .clamp(0, 3600);
    _cooldownIndex = (draft['cooldownIndex'] as int? ?? 0).clamp(
      0,
      _cooldownMovements.length - 1,
    );
    _resumeTimedSet = draft['resumeTimedSet'] as bool? ?? false;
    _resumeScreen = _SessionScreen.values.firstWhere(
      (screen) =>
          screen.name == draft['resumeScreen'] &&
          screen != _SessionScreen.paused &&
          screen != _SessionScreen.reviewDraft &&
          screen != _SessionScreen.confirmAbandon &&
          screen != _SessionScreen.preparation,
      orElse: () => _SessionScreen.exerciseList,
    );
    _setResults.clear();
    _completedSets.clear();
    final savedSets = draft['sets'] as List<Object?>? ?? const [];
    for (final item in savedSets.whereType<Map<String, Object?>>()) {
      try {
        final result = WorkoutSetResult.fromJson(item);
        if (result.exercisePosition >= 0 &&
            result.exercisePosition < _exercises.length &&
            result.setIndex >= 0 &&
            result.setIndex < _exercises[result.exercisePosition].setCount &&
            (result.repetitions == null || result.repetitions! >= 0) &&
            (result.durationSeconds == null || result.durationSeconds! >= 0) &&
            (result.loadKg == null ||
                result.loadKg!.isFinite && result.loadKg! >= 0)) {
          final sets = _setResults.putIfAbsent(
            result.exercisePosition,
            () => [],
          );
          final existingIndex = sets.indexWhere(
            (saved) => saved.setIndex == result.setIndex,
          );
          if (existingIndex == -1) {
            sets.add(result);
          } else {
            sets[existingIndex] = result;
          }
        }
      } on Object {
        continue;
      }
    }
    for (final key
        in (draft['completedSets'] as List<Object?>? ?? const [])
            .whereType<String>()) {
      final parts = key.split(':');
      if (parts.length != 2) continue;
      final exercise = int.tryParse(parts[0]);
      final set = int.tryParse(parts[1]);
      if (exercise == null ||
          set == null ||
          exercise < 0 ||
          exercise >= _exercises.length ||
          set < 0 ||
          set >= _exercises[exercise].setCount) {
        continue;
      }
      final result = _resultFor(exercise, set);
      final hasRecordedValue = _exercises[exercise].isTimed
          ? (result?.durationSeconds ?? 0) > 0
          : (result?.repetitions ?? 0) > 0;
      if (hasRecordedValue) _completedSets.add(key);
    }
    _screen = _SessionScreen.paused;
  }

  Future<void> _saveDraft() {
    final date = DateTime(
      _sessionDate.year,
      _sessionDate.month,
      _sessionDate.day,
    );
    final payload = <String, Object?>{
      'scheduledDate': date.toIso8601String(),
      'planVersion': _sessionPlanVersion,
      'planSnapshot': _plannedSession.toJson(),
      'currentExercise': _currentExercise,
      'elapsedSeconds': _elapsedSeconds,
      'remainingRestSeconds': _remainingRestSeconds,
      'restDurationSeconds': _restDurationSeconds,
      'restContext': _restContext.name,
      'timedRemainingSeconds': _timedRemainingSeconds,
      'cooldownIndex': _cooldownIndex,
      'resumeTimedSet': _timedSetRunning || _resumeTimedSet,
      'resumeScreen':
          (_screen == _SessionScreen.paused ? _resumeScreen : _screen).name,
      'sets': [
        for (final sets in _setResults.values)
          ...sets.map((set) => set.toJson()),
      ],
      'completedSets': _completedSets.toList(),
    };
    _pendingDraftWrite = _pendingDraftWrite
        .catchError((Object _) {})
        .then((_) => _workoutRepository.saveActiveWorkout(payload));
    return _pendingDraftWrite;
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
    return PopScope<Object?>(
      canPop:
          _screen == _SessionScreen.preparation ||
          _screen == _SessionScreen.reviewDraft,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && !_restoring) _goBack();
      },
      child: _restoring
          ? const Scaffold(body: Center(child: CircularProgressIndicator()))
          : Scaffold(
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
                  if (_screen != _SessionScreen.confirmAbandon &&
                      _screen != _SessionScreen.reviewDraft)
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
                                  current: _completedSetCount,
                                  total: _totalSetCount,
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
            ),
    );
  }

  String _title(BuildContext context) => switch (_screen) {
    _SessionScreen.preparation => context.l10n.sessionTitlePreparation,
    _SessionScreen.reviewDraft => context.l10n.sessionDraftReviewTitle,
    _SessionScreen.warmup => context.l10n.sessionTitleWarmup,
    _SessionScreen.exerciseList => context.l10n.sessionTitleWorkout,
    _SessionScreen.rest => context.l10n.sessionTitleRest,
    _SessionScreen.paused => context.l10n.sessionTitlePaused,
    _SessionScreen.confirmAbandon => context.l10n.sessionTitleConfirmAbandon,
    _SessionScreen.completed => context.l10n.sessionTitleCompleted,
    _SessionScreen.cooldown => context.l10n.sessionTitleCooldown,
    _SessionScreen.summary => context.l10n.sessionTitleSummary,
  };

  Widget _buildScreen(BuildContext context) => switch (_screen) {
    _SessionScreen.preparation => _buildPreparation(context),
    _SessionScreen.reviewDraft => _buildDraftReview(context),
    _SessionScreen.warmup => _buildWarmup(context),
    _SessionScreen.exerciseList => _buildExerciseList(context),
    _SessionScreen.rest => _buildRest(context),
    _SessionScreen.paused => _buildPaused(context),
    _SessionScreen.confirmAbandon => _buildConfirmAbandon(context),
    _SessionScreen.completed => _buildCompleted(context),
    _SessionScreen.cooldown => _buildCooldown(context),
    _SessionScreen.summary => _buildSummary(context),
  };

  List<_CooldownFocus> get _cooldownMovements {
    final movements = <_CooldownFocus>[];
    for (final exercise in _exercises) {
      final focus = switch (exercise.focus) {
        'Piernas' => _CooldownFocus.legs,
        'Espalda' => _CooldownFocus.back,
        'Pecho' => _CooldownFocus.chest,
        'Hombros' => _CooldownFocus.shoulders,
        'Core' => _CooldownFocus.core,
        'Brazos' => _CooldownFocus.arms,
        _ => null,
      };
      if (focus != null && !movements.contains(focus)) movements.add(focus);
      if (movements.length == 3) break;
    }
    if (movements.isEmpty) movements.add(_CooldownFocus.legs);
    return movements;
  }

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
          (context.l10n.sessionClearSpace, Icons.space_dashboard_outlined),
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
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
        ],
        const _SessionSaveNote(),
      ],
    );
  }

  Widget _buildDraftReview(BuildContext context) {
    final savedDate = _reviewScheduledDate == null
        ? null
        : MaterialLocalizations.of(context)
              .formatMediumDate(_reviewScheduledDate!);
    final message = _reviewDraftCorrupt
        ? context.l10n.sessionDraftReviewCorrupt
        : _reviewDraftDateMismatch
        ? context.l10n.sessionDraftReviewDateMismatch(
            savedDate ?? context.l10n.sessionUnknownDate,
          )
        : context.l10n.sessionDraftReviewLegacy;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SessionEyebrow(label: context.l10n.sessionDraftReviewTitle),
        const SizedBox(height: AppSpacing.x3),
        Text(
          context.l10n.sessionDraftReviewTitle,
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: AppSpacing.x3),
        AppSurfaceCard(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info_outline_rounded),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  message,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDraftReviewActions(BuildContext context) {
    final canContinueSavedSession =
        !_reviewDraftCorrupt &&
        _reviewDraftDateMismatch &&
        _draftToReview != null &&
        _reviewPlannedSession != null &&
        _reviewScheduledDate != null;
    final canContinueLegacySession =
        !_reviewDraftCorrupt &&
        !_reviewDraftDateMismatch &&
        _draftToReview != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (canContinueSavedSession)
          FilledButton.icon(
            onPressed: _continueSavedDraft,
            icon: const Icon(Icons.restore_rounded),
            label: Text(context.l10n.sessionContinueSavedWorkout),
          ),
        if (canContinueLegacySession)
          FilledButton.icon(
            onPressed: _continueLegacyDraft,
            icon: const Icon(Icons.play_arrow_rounded),
            label: Text(context.l10n.sessionContinueWithCurrentPlan),
          ),
        if (canContinueSavedSession || canContinueLegacySession)
          const SizedBox(height: AppSpacing.x2),
        OutlinedButton.icon(
          onPressed: _discardReviewedDraft,
          icon: const Icon(Icons.delete_outline_rounded),
          label: Text(context.l10n.sessionDiscardWorkoutDraft),
        ),
      ],
    );
  }

  void _continueSavedDraft() {
    final draft = _draftToReview;
    final savedPlan = _reviewPlannedSession;
    final savedDate = _reviewScheduledDate;
    if (draft == null || savedPlan == null || savedDate == null) return;
    setState(() {
      _activateDraft(draft, savedPlan: savedPlan, savedDate: savedDate);
      _draftToReview = null;
      _reviewDraftDateMismatch = false;
    });
  }

  void _continueLegacyDraft() {
    final draft = _draftToReview;
    if (draft == null) return;
    setState(() {
      _activateDraft(draft);
      _restoredDifferentPlan = true;
      _draftToReview = null;
      _reviewDraftDateMismatch = false;
    });
  }

  Future<void> _discardReviewedDraft() async {
    await _pendingDraftWrite.catchError((Object _) {});
    await _workoutRepository.clearActiveWorkout();
    if (!mounted) return;
    setState(() {
      _restoredPlannedSession = null;
      _restoredScheduledDate = null;
      _restoredPlanVersion = null;
      _draftToReview = null;
      _reviewPlannedSession = null;
      _reviewScheduledDate = null;
      _reviewDraftDateMismatch = false;
      _reviewDraftCorrupt = false;
      _restoredDifferentPlan = false;
      _screen = _SessionScreen.preparation;
    });
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
        Row(
          children: [
            Expanded(
              child: Text(
                context.l10n.sessionExerciseCountProgress(
                  _currentExercise + 1,
                  _exercises.length,
                ),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            TextButton.icon(
              key: const Key('view-session-routine'),
              onPressed: _openRoutine,
              icon: const Icon(Icons.format_list_bulleted_rounded),
              label: Text(context.l10n.sessionViewRoutine),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x3),
        _buildGuidedExercise(context),
        const SizedBox(height: AppSpacing.x3),
        _buildProgressionGuidance(context),
        const SizedBox(height: AppSpacing.x4),
        if (_currentExercise < _exercises.length) ...[
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
              key: ValueKey('workout-set-$_currentExercise-$setIndex'),
              setIndex: setIndex,
              weightUnit: widget.weightUnit,
              label: context.l10n.sessionSet(setIndex + 1),
              isTimed: _exercises[_currentExercise].isTimed,
              result: _resultFor(_currentExercise, setIndex),
              target: _localizedPrescriptionTarget(
                context,
                _plannedSession.exercises[_currentExercise].prescription,
              ),
              suggestion: setIndex > 0
                  ? _resultFor(_currentExercise, setIndex - 1)
                  : null,
              isNext:
                  !_completedSets.contains('$_currentExercise:$setIndex') &&
                  List.generate(setIndex, (index) => index).every(
                    (index) =>
                        _completedSets.contains('$_currentExercise:$index'),
                  ),
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
                final shouldStartRest =
                    completed &&
                    setIndex == _nextIncompleteSetIndex(_currentExercise);
                setState(() {
                  final key = '$_currentExercise:$setIndex';
                  if (completed) {
                    _completedSets.add(key);
                    if (_exercises[_currentExercise].isTimed &&
                        _timedSetRunning) {
                      _timedSetTimer?.cancel();
                      _timedSetRunning = false;
                      _timedRemainingSeconds = 30;
                    }
                  } else {
                    _completedSets.remove(key);
                  }
                });
                _saveDraft();
                if (shouldStartRest) _startRestAfterSet();
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
                  final hasRequiredValue = _exercises[_currentExercise].isTimed
                      ? (value.durationSeconds ?? 0) > 0
                      : (value.repetitions ?? 0) > 0;
                  if (!hasRequiredValue) {
                    _completedSets.remove('$_currentExercise:$setIndex');
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

  Future<void> _openRoutine() async {
    final selectedExercise = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetContext) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.75,
        minChildSize: 0.45,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.x4,
            AppSpacing.x3,
            AppSpacing.x4,
            AppSpacing.x4,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.l10n.sessionRoutineTitle,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: AppSpacing.x1),
                        Text(
                          context.l10n.sessionRoutineDescription,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: context.l10n.sessionCloseRoutine,
                    onPressed: () => Navigator.of(sheetContext).pop(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x2),
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  itemCount: _exercises.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final exercise = _exercises[index];
                    final isCurrent = index == _currentExercise;
                    final isComplete = _isExerciseComplete(index);
                    final canOpen = index <= _currentExercise;
                    final name = _localizedSessionExerciseName(
                      context,
                      exercise,
                    );
                    final stateLabel = isComplete
                        ? context.l10n.sessionRoutineCompleted
                        : isCurrent
                        ? context.l10n.sessionRoutineCurrent
                        : context.l10n.sessionRoutinePending;
                    final statusIcon = isComplete
                        ? Icons.check_circle_outline_rounded
                        : isCurrent
                        ? Icons.play_circle_outline_rounded
                        : Icons.radio_button_unchecked_rounded;

                    if (!canOpen) {
                      return Padding(
                        key: ValueKey('routine-exercise-$index'),
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.x3,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              statusIcon,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                            const SizedBox(width: AppSpacing.x3),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium,
                                  ),
                                  Text(
                                    '${_localizedExerciseDetail(context, exercise.detail)} · $stateLabel',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListTile(
                      key: ValueKey('routine-exercise-$index'),
                      contentPadding: EdgeInsets.zero,
                      isThreeLine: true,
                      leading: Icon(statusIcon),
                      title: Text(name),
                      subtitle: Text(
                        '${_localizedExerciseDetail(context, exercise.detail)} · $stateLabel',
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => Navigator.of(sheetContext).pop(index),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (selectedExercise == null || !mounted) return;
    _restTimer?.cancel();
    setState(() {
      _currentExercise = selectedExercise;
      _screen = _SessionScreen.exerciseList;
    });
    await _saveDraft();
  }

  Widget _buildProgressionGuidance(BuildContext context) {
    final exercise = _plannedSession.exercises[_currentExercise];
    final advice = _progressionAdvisor.evaluate(
      exercise: exercise,
      goal: widget.settings.goal,
      experience: widget.settings.experience,
      history: _workoutHistory,
    );
    final message = switch (advice.status) {
      TrainingProgressionStatus.noHistory =>
        context.l10n.sessionProgressionNoHistory,
      TrainingProgressionStatus.keepBuilding =>
        context.l10n.sessionProgressionKeepBuilding(
          advice.requiredSessions,
          advice.targetValue,
        ),
      TrainingProgressionStatus.readyToIncrease =>
        context.l10n.sessionProgressionReadyToIncrease(
          advice.targetValue,
          advice.requiredSessions,
        ),
      TrainingProgressionStatus.readyToVary =>
        context.l10n.sessionProgressionBodyweightReady(
          advice.targetValue,
          advice.requiredSessions,
        ),
      TrainingProgressionStatus.habitFocus =>
        context.l10n.sessionProgressionHabitFocus,
      TrainingProgressionStatus.returningAfterBreak =>
        context.l10n.sessionProgressionReturningAfterBreak,
      TrainingProgressionStatus.timedKeepBuilding =>
        context.l10n.sessionProgressionTimedKeepBuilding(
          advice.requiredSessions,
          advice.targetValue,
        ),
      TrainingProgressionStatus.timedReadyToVary =>
        context.l10n.sessionProgressionTimedReadyToVary(
          advice.requiredSessions,
          advice.targetValue,
        ),
    };

    return AppSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.sessionProgressionTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(message, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: AppSpacing.x1),
          Text(
            context.l10n.sessionProgressionTemplateNote,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildGuidedExercise(BuildContext context) {
    final current = _exercises[_currentExercise];
    final matched = _catalogExerciseFor(current);
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
                label: localizedExerciseName(context, matched),
              ),
            ),
            const SizedBox(height: AppSpacing.x3),
          ],
          Text(
            key: const Key('active-exercise-name'),
            matched == null
                ? localizedTrainingExerciseName(context, current.name)
                : localizedExerciseName(context, matched),
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
          _restContext == _RestContext.betweenSets
              ? context.l10n.sessionRestBetweenSets
              : context.l10n.sessionRestBetweenExercises,
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
                      value: _restDurationSeconds == 0
                          ? 0
                          : (_remainingRestSeconds / _restDurationSeconds)
                                .clamp(0.0, 1.0),
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
                _restContext == _RestContext.betweenSets
                    ? context.l10n.sessionNextSetAfterRest(
                        _nextIncompleteSetIndex(_currentExercise) + 1,
                      )
                    : context.l10n.sessionBeforeExercise(
                        _localizedSessionExerciseName(
                          context,
                          _exercises[_currentExercise],
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
          context.l10n.sessionRestDuration,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: AppSpacing.x2),
        Wrap(
          spacing: AppSpacing.x2,
          runSpacing: AppSpacing.x2,
          children: [
            for (final duration in const [30, 45, 60, 90])
              ChoiceChip(
                label: Text('$duration s'),
                selected: _restDurationSeconds == duration,
                onSelected: (_) => _adjustRestDuration(duration),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.x3),
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
        if (_restoredDifferentPlan) ...[
          const SizedBox(height: AppSpacing.x3),
          AppSurfaceCard(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline_rounded),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Text(
                    context.l10n.sessionRestoredOriginalPlan,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ],
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
        Text(
          context.l10n.sessionCooldownOfferDescription,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: AppSpacing.x4),
        const _SessionSaveNote(),
      ],
    );
  }

  Widget _buildCooldown(BuildContext context) {
    final movements = _cooldownMovements;
    final movement = movements[_cooldownIndex.clamp(0, movements.length - 1)];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SessionEyebrow(label: context.l10n.sessionTitleCooldown),
        const SizedBox(height: AppSpacing.x3),
        Text(
          context.l10n.sessionCooldownHeadline,
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          context.l10n.sessionCooldownDescription,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: AppSpacing.x4),
        LinearProgressIndicator(value: (_cooldownIndex + 1) / movements.length),
        const SizedBox(height: AppSpacing.x2),
        Text(
          context.l10n.sessionProgress(_cooldownIndex + 1, movements.length),
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: AppSpacing.x4),
        AppSurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(movement.icon, size: 28, color: context.appColors.accent),
              const SizedBox(height: AppSpacing.x3),
              Text(
                _cooldownTitle(context, movement),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.x2),
              Text(
                _cooldownInstructions(context, movement),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: AppSpacing.x3),
              Text(
                _cooldownDuration(context, movement),
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _cooldownTitle(BuildContext context, _CooldownFocus focus) =>
      switch (focus) {
        _CooldownFocus.legs => context.l10n.sessionCooldownHipsTitle,
        _CooldownFocus.back => context.l10n.sessionCooldownBackTitle,
        _CooldownFocus.chest => context.l10n.sessionCooldownChestTitle,
        _CooldownFocus.shoulders => context.l10n.sessionCooldownShouldersTitle,
        _CooldownFocus.core => context.l10n.sessionCooldownCoreTitle,
        _CooldownFocus.arms => context.l10n.sessionCooldownArmsTitle,
      };

  String _cooldownInstructions(BuildContext context, _CooldownFocus focus) =>
      switch (focus) {
        _CooldownFocus.legs => context.l10n.sessionCooldownHipsInstructions,
        _CooldownFocus.back => context.l10n.sessionCooldownBackInstructions,
        _CooldownFocus.chest => context.l10n.sessionCooldownChestInstructions,
        _CooldownFocus.shoulders =>
          context.l10n.sessionCooldownShouldersInstructions,
        _CooldownFocus.core => context.l10n.sessionCooldownCoreInstructions,
        _CooldownFocus.arms => context.l10n.sessionCooldownArmsInstructions,
      };

  String _cooldownDuration(BuildContext context, _CooldownFocus focus) =>
      switch (focus) {
        _CooldownFocus.core => context.l10n.sessionCooldownSixReps,
        _ => context.l10n.sessionCooldownTwentySecondsEachSide,
      };

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
        _SessionScreen.reviewDraft => _buildDraftReviewActions(context),
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
            child: Text(
              _restContext == _RestContext.betweenSets
                  ? context.l10n.sessionSkipRestButton
                  : context.l10n.sessionStartWhenReady,
            ),
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
              onPressed: _isAbandoning ? null : _abandonSession,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 13),
                child: Text(context.l10n.sessionAbandonConfirm),
              ),
            ),
            const SizedBox(height: AppSpacing.x2),
            TextButton(
              onPressed: _restoreFromExitConfirmation,
              child: Text(context.l10n.sessionKeep),
            ),
          ],
        ),
        _SessionScreen.completed => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilledButton(
              onPressed: _startCooldown,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 13),
                child: Text(context.l10n.sessionCooldownStart),
              ),
            ),
            const SizedBox(height: AppSpacing.x2),
            TextButton(
              onPressed: _skipCooldown,
              child: Text(context.l10n.sessionViewSummary),
            ),
          ],
        ),
        _SessionScreen.cooldown => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilledButton.icon(
              onPressed: _nextCooldownMovement,
              icon: const Icon(Icons.arrow_forward_rounded),
              label: Padding(
                padding: const EdgeInsets.symmetric(vertical: 13),
                child: Text(
                  _cooldownIndex == _cooldownMovements.length - 1
                      ? context.l10n.sessionViewSummary
                      : context.l10n.sessionCooldownNext,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.x2),
            TextButton(
              onPressed: _skipCooldown,
              child: Text(context.l10n.sessionCooldownSkip),
            ),
          ],
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

  void _startCooldown() {
    _cooldownIndex = 0;
    _resumeScreen = _SessionScreen.cooldown;
    setState(() => _screen = _SessionScreen.cooldown);
    _saveDraft();
  }

  void _nextCooldownMovement() {
    if (_cooldownIndex >= _cooldownMovements.length - 1) {
      _skipCooldown();
      return;
    }
    setState(() => _cooldownIndex++);
    _saveDraft();
  }

  void _skipCooldown() {
    setState(() => _screen = _SessionScreen.summary);
    _resumeScreen = _SessionScreen.summary;
    _saveDraft();
  }

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
      _restContext = _RestContext.betweenExercises;
      _remainingRestSeconds = _restDurationSeconds;
      _timedRemainingSeconds = 30;
      _screen = _SessionScreen.rest;
    });
    _saveDraft();
    _startRestTimer();
  }

  void _startRestAfterSet() {
    if (_isExerciseComplete(_currentExercise)) return;
    setState(() {
      _restContext = _RestContext.betweenSets;
      _remainingRestSeconds = _restDurationSeconds;
      _screen = _SessionScreen.rest;
    });
    _saveDraft();
    _startRestTimer();
  }

  void _adjustRestDuration(int duration) {
    if (_restDurationSeconds == duration) return;
    setState(() {
      _restDurationSeconds = duration;
      _remainingRestSeconds = duration;
    });
    _saveDraft();
    _startRestTimer();
  }

  void _startRestTimer() {
    _restTimer?.cancel();
    if (_remainingRestSeconds <= 0) {
      setState(() => _screen = _SessionScreen.exerciseList);
      _saveDraft();
      return;
    }
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
      if (_isExerciseComplete(_currentExercise)) {
        timer.cancel();
        setState(() => _timedSetRunning = false);
        return;
      }
      if (_timedRemainingSeconds <= 1) {
        timer.cancel();
        final setIndex = _nextIncompleteSetIndex(_currentExercise);
        if (setIndex >= _exercises[_currentExercise].setCount) {
          setState(() => _timedSetRunning = false);
          return;
        }
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
        _startRestAfterSet();
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
    if (_isSavingRecord) return;
    _isSavingRecord = true;
    _restTimer?.cancel();
    _sessionTimer?.cancel();
    _timedSetTimer?.cancel();
    final durationMinutes = (_elapsedSeconds / 60).ceil().clamp(1, 99);
    await _pendingDraftWrite.catchError((Object _) {});
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
    final recordPositions = completedPositions.toList()..sort();
    Navigator.of(context).pop(
      WorkoutRecord(
        scheduledDate: _sessionDate,
        completedAt: DateTime.now(),
        title: _plannedSession.title,
        goal: widget.settings.goal,
        durationMinutes: durationMinutes,
        exerciseCount: completedPositions.length,
        exercises: [
          for (final index in recordPositions) _recordExerciseName(index),
        ],
        exerciseIds: [
          for (final index in recordPositions) _exercises[index].catalogId,
        ],
        exercisePositions: recordPositions,
        planVersion: _sessionPlanVersion,
        planSnapshot: jsonEncode(_plannedSession.toJson()),
        setResults: results,
      ),
    );
  }

  Future<void> _abandonSession() async {
    if (_isAbandoning) return;
    _isAbandoning = true;
    await _pendingDraftWrite.catchError((Object _) {});
    await _workoutRepository.clearActiveWorkout();
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  bool _isExerciseComplete(int exercise) => List.generate(
    _exercises[exercise].setCount,
    (index) => index,
  ).every((index) => _completedSets.contains('$exercise:$index'));

  Exercise? _catalogExerciseFor(_SessionExercise planned) {
    for (final exercise in _catalog) {
      if (exercise.id == planned.catalogId) return exercise;
    }
    return null;
  }

  String _localizedSessionExerciseName(
    BuildContext context,
    _SessionExercise planned,
  ) {
    final exercise = _catalogExerciseFor(planned);
    return exercise == null
        ? localizedTrainingExerciseName(context, planned.name)
        : localizedExerciseName(context, exercise);
  }

  String _recordExerciseName(int index) =>
      _catalogExerciseFor(_exercises[index])?.name ?? _exercises[index].name;
  int get _completedExerciseCount =>
      {for (final key in _completedSets) int.tryParse(key.split(':').first)}
          .whereType<int>()
          .length;

  int get _completedSetCount => _completedSets.where((key) {
    final parts = key.split(':');
    if (parts.length != 2) return false;
    final exercise = int.tryParse(parts[0]);
    final set = int.tryParse(parts[1]);
    return exercise != null &&
        set != null &&
        exercise >= 0 &&
        exercise < _exercises.length &&
        set >= 0 &&
        set < _exercises[exercise].setCount;
  }).length;

  int get _totalSetCount =>
      _exercises.fold(0, (total, exercise) => total + exercise.setCount);

  int _nextIncompleteSetIndex(int exercise) =>
      List.generate(_exercises[exercise].setCount, (index) => index).firstWhere(
        (index) => !_completedSets.contains('$exercise:$index'),
        orElse: () => _exercises[exercise].setCount,
      );

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
      case _SessionScreen.reviewDraft:
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
      case _SessionScreen.cooldown:
        setState(() => _screen = _SessionScreen.completed);
      case _SessionScreen.summary:
        _finishWithRecord();
    }
  }
}

enum _SessionScreen {
  reviewDraft,
  preparation,
  warmup,
  exerciseList,
  rest,
  paused,
  confirmAbandon,
  completed,
  cooldown,
  summary,
}

enum _RestContext { betweenSets, betweenExercises }

enum _CooldownFocus { legs, back, chest, shoulders, core, arms }

extension on _CooldownFocus {
  IconData get icon => switch (this) {
    _CooldownFocus.legs => Icons.accessibility_new_rounded,
    _CooldownFocus.back => Icons.sports_gymnastics_rounded,
    _CooldownFocus.chest => Icons.fitness_center_rounded,
    _CooldownFocus.shoulders => Icons.accessibility_new_rounded,
    _CooldownFocus.core => Icons.self_improvement_rounded,
    _CooldownFocus.arms => Icons.fitness_center_rounded,
  };
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
    super.key,
    required this.setIndex,
    required this.weightUnit,
    required this.label,
    required this.isTimed,
    required this.result,
    required this.target,
    required this.suggestion,
    required this.isNext,
    required this.canComplete,
    required this.completed,
    required this.onCompletedChanged,
    required this.onChanged,
  });

  final String label;
  final int setIndex;
  final String weightUnit;
  final bool isTimed;
  final WorkoutSetResult? result;
  final String target;
  final WorkoutSetResult? suggestion;
  final bool isNext;
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
              Icon(
                completed
                    ? Icons.check_circle_rounded
                    : isNext
                    ? Icons.radio_button_checked_rounded
                    : Icons.radio_button_unchecked_rounded,
                size: 20,
                color: completed || isNext
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              if (completed)
                Text(
                  context.l10n.sessionSetComplete,
                  style: Theme.of(context).textTheme.labelMedium,
                )
              else if (isNext)
                Text(
                  context.l10n.sessionNextSet,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(target, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: AppSpacing.x2),
          Row(
            children: [
              Expanded(
                child: _numberField(
                  context: context,
                  key: ValueKey('set-$setIndex-repetitions'),
                  label: isTimed
                      ? context.l10n.sessionSeconds
                      : context.l10n.sessionRepetitions,
                  initialValue: isTimed
                      ? value.durationSeconds
                      : value.repetitions,
                  suggestion: isTimed
                      ? suggestion?.durationSeconds
                      : suggestion?.repetitions,
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
                    context: context,
                    key: ValueKey('set-$setIndex-load'),
                    label: context.l10n.sessionLoad.replaceAll(
                      '(kg)',
                      '($weightUnit)',
                    ),
                    initialValue: value.loadKg == null
                        ? null
                        : weightFromKilograms(value.loadKg!, weightUnit),
                    suggestion: suggestion?.loadKg == null
                        ? null
                        : weightFromKilograms(suggestion!.loadKg!, weightUnit),
                    decimal: true,
                    onChanged: (number) => onChanged(
                      WorkoutSetResult(
                        exercisePosition: value.exercisePosition,
                        setIndex: value.setIndex,
                        repetitions: value.repetitions,
                        loadKg: number == null
                            ? null
                            : weightToKilograms(number.toDouble(), weightUnit),
                        durationSeconds: value.durationSeconds,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          SizedBox(
            width: double.infinity,
            child: completed
                ? OutlinedButton.icon(
                    onPressed: () => onCompletedChanged(false),
                    icon: const Icon(Icons.undo_rounded),
                    label: Text(context.l10n.sessionUndoSet),
                  )
                : isNext
                ? FilledButton.icon(
                    key: ValueKey('complete-set-$setIndex'),
                    onPressed: canComplete
                        ? () => onCompletedChanged(true)
                        : null,
                    icon: const Icon(Icons.check_rounded),
                    label: Text(context.l10n.sessionCompleteSetAction),
                  )
                : TextButton.icon(
                    onPressed: canComplete
                        ? () => onCompletedChanged(true)
                        : null,
                    icon: const Icon(Icons.check_rounded),
                    label: Text(context.l10n.sessionCompleteSetAction),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _numberField({
    required BuildContext context,
    required Key key,
    required String label,
    required num? initialValue,
    required num? suggestion,
    required ValueChanged<num?> onChanged,
    bool decimal = false,
  }) => TextFormField(
    key: key,
    initialValue: _editableNumber(initialValue),
    keyboardType: TextInputType.numberWithOptions(decimal: decimal),
    inputFormatters: [
      TextInputFormatter.withFunction((oldValue, newValue) {
        final pattern = decimal ? r'^\d*\.?\d{0,2}$' : r'^\d*$';
        return newValue.text.isEmpty || RegExp(pattern).hasMatch(newValue.text)
            ? newValue
            : oldValue;
      }),
    ],
    decoration: InputDecoration(
      labelText: label,
      hintText: _editableNumber(suggestion).isEmpty
          ? null
          : _editableNumber(suggestion),
      helperText: suggestion == null
          ? null
          : context.l10n.sessionPreviousSetSuggestion,
    ),
    onChanged: (text) =>
        onChanged(decimal ? double.tryParse(text) : int.tryParse(text)),
  );

  String _editableNumber(num? value) {
    if (value == null) return '';
    return value == value.roundToDouble()
        ? value.toInt().toString()
        : value.toString();
  }
}

class _SessionExercise {
  const _SessionExercise({
    required this.catalogId,
    required this.name,
    required this.focus,
    this.isTimed = false,
    required this.setCount,
    required this.icon,
    this.detail = '',
  });

  final String catalogId;
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
      label: context.l10n.sessionSetsProgress(current, total),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: LinearProgressIndicator(
              value: total == 0 ? 0 : current / total,
              minHeight: 6,
              backgroundColor: context.appColors.surfaceMuted,
              color: context.appColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            context.l10n.sessionSetsProgress(current, total),
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
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

String _localizedPrescriptionTarget(BuildContext context, String prescription) {
  final target = prescription.split('·').last.trim();
  return switch (target) {
    '20–40 segundos' => context.l10n.sessionTimeTarget,
    '6–8 repeticiones' => context.l10n.sessionRepTargetLow,
    '8–12 repeticiones' => context.l10n.sessionRepTargetMid,
    _ => context.l10n.sessionRepTargetComfortable,
  };
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
