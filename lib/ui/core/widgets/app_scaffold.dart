import 'dart:async';

import 'package:material_ui/material_ui.dart';

import '../../../domain/models/workout_record.dart';
import '../../../data/repositories/backup_repository.dart';
import '../../../data/repositories/google_account_auth_repository.dart';
import '../../../data/repositories/profile_settings_repository.dart';
import '../../../data/repositories/workout_reminder_repository.dart';
import '../../../app/theme/appearance_controller.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../features/activity/views/activity_view.dart';
import '../../features/exercises/views/exercises_view.dart';
import '../../features/home/views/home_view.dart';
import '../../features/onboarding/views/onboarding_view.dart';
import '../../features/profile/models/profile_settings.dart';
import '../../features/profile/views/profile_view.dart';
import '../../features/profile/views/backup_restore_page.dart';
import '../../features/progress/views/progress_view.dart';
import '../../features/onboarding/views/training_session_flow.dart';
import '../../features/onboarding/view_models/account_auth_view_model.dart';
import '../view_models/app_shell_view_model.dart';
import '../../../app/localization/locale_controller.dart';
import '../../../app/localization/localization_extensions.dart';

class AppScaffold extends StatefulWidget {
  const AppScaffold({
    super.key,
    this.initialIndex = 0,
    this.viewModel,
    this.profileSettingsRepository,
    this.accountAuthViewModel,
    this.workoutReminderRepository,
    required this.appearance,
    required this.localeController,
  });

  final int initialIndex;
  final AppShellViewModel? viewModel;
  final ProfileSettingsRepository? profileSettingsRepository;
  final AccountAuthViewModel? accountAuthViewModel;
  final WorkoutReminderRepository? workoutReminderRepository;
  final AppearanceController appearance;
  final LocaleController localeController;

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late int _selectedIndex;
  late final AppShellViewModel _viewModel;
  late final ProfileSettingsRepository _profileSettingsRepository;
  late final AccountAuthViewModel _accountAuthViewModel;
  late final WorkoutReminderRepository _workoutReminderRepository;
  late final AnimationController _moduleController;
  late final CurvedAnimation _moduleTransition;
  late final Animation<Offset> _moduleOffset;
  int? _pendingDestination;
  bool _isOpeningFirstRun = false;
  Locale? _notificationLocale;
  Timer? _reminderRolloverTimer;

  static const _destinations = <_AppDestination>[
    _AppDestination(
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_rounded,
    ),
    _AppDestination(
      icon: Icons.calendar_month_outlined,
      selectedIcon: Icons.calendar_month_rounded,
    ),
    _AppDestination(
      icon: Icons.fitness_center_outlined,
      selectedIcon: Icons.fitness_center_rounded,
    ),
    _AppDestination(
      icon: Icons.insights_outlined,
      selectedIcon: Icons.insights_rounded,
    ),
    _AppDestination(
      icon: Icons.person_outline_rounded,
      selectedIcon: Icons.person_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _viewModel = widget.viewModel ?? AppShellViewModel();
    _profileSettingsRepository =
        widget.profileSettingsRepository ?? ProfileSettingsRepository();
    _accountAuthViewModel =
        widget.accountAuthViewModel ??
        AccountAuthViewModel(repository: GoogleAccountAuthRepository());
    _workoutReminderRepository =
        widget.workoutReminderRepository ?? WorkoutReminderRepository();
    WidgetsBinding.instance.addObserver(this);
    _selectedIndex = widget.initialIndex
        .clamp(0, _destinations.length - 1)
        .toInt();
    _moduleController = AnimationController(
      vsync: this,
      value: 1,
      duration: const Duration(milliseconds: 210),
      reverseDuration: const Duration(milliseconds: 140),
    )..addStatusListener(_onModuleTransitionStatus);
    _moduleTransition = CurvedAnimation(
      parent: _moduleController,
      curve: Curves.easeInOutCubic,
    );
    _moduleOffset = Tween<Offset>(
      begin: const Offset(0.015, 0),
      end: Offset.zero,
    ).animate(_moduleTransition);
    _restoreSettings();
    _scheduleReminderRollover();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _reminderRolloverTimer?.cancel();
    _moduleController
      ..removeStatusListener(_onModuleTransitionStatus)
      ..dispose();
    _moduleTransition.dispose();
    _viewModel.dispose();
    if (widget.accountAuthViewModel == null) {
      _accountAuthViewModel.dispose();
    }
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = Localizations.localeOf(context);
    if (_notificationLocale == locale) return;
    _notificationLocale = locale;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(_synchronizeWorkoutRemindersSafely());
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _scheduleReminderRollover();
      unawaited(_refreshScheduleAndReminders());
    }
  }

  void _scheduleReminderRollover() {
    _reminderRolloverTimer?.cancel();
    final now = DateTime.now();
    final nextDay = DateTime(now.year, now.month, now.day + 1, 0, 0, 1);
    _reminderRolloverTimer = Timer(nextDay.difference(now), () {
      unawaited(_refreshScheduleAndReminders());
      _scheduleReminderRollover();
    });
  }

  Future<void> _restoreSettings() async {
    await _viewModel.restore();
    if (!mounted) return;
    await _synchronizeWorkoutRemindersSafely();
    if (_viewModel.needsFirstRunSetup) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _startFirstRunSetup(),
      );
    }
  }

  Future<void> _refreshScheduleAndReminders() async {
    if (!_viewModel.isReady) return;
    try {
      await _viewModel.refreshScheduledSessions();
      await _synchronizeWorkoutReminders();
    } on Object {
      if (mounted) _showReminderScheduleError();
    }
  }

  Future<void> _synchronizeWorkoutReminders({
    NotificationSettings? settings,
  }) async {
    if (!_viewModel.isReady) return;
    final title = context.l10n.workoutReminderNotificationTitle;
    final body = context.l10n.workoutReminderNotificationBody;
    final currentSettings =
        settings ?? await _profileSettingsRepository.loadNotifications();
    await _workoutReminderRepository.synchronize(
      settings: currentSettings,
      sessions: _viewModel.scheduledSessions,
      title: title,
      body: body,
    );
  }

  Future<void> _synchronizeWorkoutRemindersSafely() async {
    try {
      await _synchronizeWorkoutReminders();
    } on Object {
      if (mounted && _viewModel.isReady) _showReminderScheduleError();
    }
  }

  Future<bool> _saveNotificationSettings(
    NotificationSettings previous,
    NotificationSettings updated,
  ) async {
    if (updated.workoutReminders &&
        !await _workoutReminderRepository.requestPermission()) {
      return false;
    }
    await _profileSettingsRepository.saveNotifications(updated);
    try {
      await _synchronizeWorkoutReminders(settings: updated);
    } on Object {
      await _profileSettingsRepository.saveNotifications(previous);
      try {
        await _synchronizeWorkoutReminders(settings: previous);
      } on Object {
        // Keep the original failure visible to the user.
      }
      throw const WorkoutReminderSyncException();
    }
    return true;
  }

  void _showReminderScheduleError() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.profileReminderScheduleFailed)),
    );
  }

  Future<void> _startFirstRunSetup() async {
    if (!mounted || _isOpeningFirstRun) return;
    _isOpeningFirstRun = true;
    final settings = await Navigator.of(context).push<TrainingSettings>(
      MaterialPageRoute<TrainingSettings>(
        builder: (_) => OnboardingView(
          initialSettings: _viewModel.trainingSettings,
          isFirstRun: true,
        ),
      ),
    );
    if (!mounted) return;
    try {
      await _viewModel.completeFirstRun(settings);
      await _synchronizeWorkoutRemindersSafely();
    } on Object {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.shellPlanSaveError)),
        );
      }
    } finally {
      _isOpeningFirstRun = false;
    }
  }

  void _selectDestination(int index) {
    if (MediaQuery.disableAnimationsOf(context)) {
      _pendingDestination = null;
      if (index != _selectedIndex) setState(() => _selectedIndex = index);
      return;
    }
    if (index == _selectedIndex) {
      _pendingDestination = null;
      _moduleController.forward();
      return;
    }
    _pendingDestination = index;
    if (_moduleController.status != AnimationStatus.reverse) {
      _moduleController.reverse();
    }
  }

  void _onModuleTransitionStatus(AnimationStatus status) {
    if (status != AnimationStatus.dismissed || _pendingDestination == null) {
      return;
    }
    final nextIndex = _pendingDestination!;
    _pendingDestination = null;
    if (nextIndex != _selectedIndex) {
      setState(() => _selectedIndex = nextIndex);
    }
    _moduleController.forward();
  }

  Future<void> _editPlan() async {
    final updated = await Navigator.of(context).push<TrainingSettings>(
      MaterialPageRoute<TrainingSettings>(
        builder: (_) =>
            OnboardingView(initialSettings: _viewModel.trainingSettings),
      ),
    );
    if (!mounted || updated == null) return;
    await _saveTrainingSettings(updated);
  }

  Future<void> _openBackupRestore() async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => BackupRestorePage(
          exportBackup: (mode) => _viewModel.exportBackup(appearanceMode: mode),
          validateBackup: _viewModel.validateBackup,
          restoreBackup: _restoreBackupAndReminders,
          resetUserData: _resetUserDataAndReminders,
          appearanceMode: _appearanceName(widget.appearance.mode),
          onAppearanceModeChanged: (mode) =>
              widget.appearance.setMode(_themeMode(mode)),
        ),
      ),
    );
    if (mounted && _viewModel.needsFirstRunSetup) {
      await _startFirstRunSetup();
    }
  }

  Future<void> _resetUserDataAndReminders() async {
    await _viewModel.resetUserData();
    await _synchronizeWorkoutRemindersSafely();
  }

  Future<void> _startHomeWorkout(DateTime selectedSessionDate) async {
    final trainingSettings = _viewModel.trainingSettings;
    final days = trainingSettings.trainingDays.toList()..sort();
    final now = DateTime.now();
    final activeDate = _viewModel.activeWorkoutDate;
    final nextSessionDate = _nextTrainingDate(
      trainingSettings.trainingDays,
      now,
    );
    final planned = _viewModel.nextScheduledSession;
    final sessionDate =
        activeDate ?? planned?.scheduledDate ?? selectedSessionDate;
    final today = DateTime(now.year, now.month, now.day);
    final sessionDay = DateTime(
      sessionDate.year,
      sessionDate.month,
      sessionDate.day,
    );
    if (sessionDay.isAfter(today)) return;
    final sessionIndex =
        planned?.sessionIndex ??
        days.indexOf((activeDate ?? nextSessionDate).weekday);
    final started = await _viewModel.markSessionStarted(sessionDate);
    if (!started) return;
    await _synchronizeWorkoutRemindersSafely();
    if (!mounted) return;
    final record = await Navigator.of(context).push<WorkoutRecord>(
      MaterialPageRoute<WorkoutRecord>(
        builder: (_) => TrainingSessionFlow(
          settings: trainingSettings,
          workoutLogRepository: _viewModel.workoutLogRepository,
          sessionIndex: sessionIndex < 0 ? 0 : sessionIndex,
          scheduledDate: sessionDate,
          plannedSession: planned?.plannedSession,
          planVersion: planned?.planVersion ?? 1,
        ),
      ),
    );
    if (!mounted) return;
    await _viewModel.refreshActiveWorkout();
    if (record != null) await _saveWorkoutRecord(record);
  }

  Future<void> _saveWorkoutRecord(WorkoutRecord record) async {
    try {
      await _viewModel.recordWorkout(record);
      if (!mounted) return;
      await _synchronizeWorkoutRemindersSafely();
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.shellWorkoutSaved)));
    } on Object {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.shellWorkoutSaveError)),
      );
    }
  }

  DateTime _nextTrainingDate(Set<int> days, DateTime from) {
    final today = DateTime(from.year, from.month, from.day);
    for (var offset = 0; offset < 7; offset++) {
      final candidate = today.add(Duration(days: offset));
      if (days.contains(candidate.weekday)) return candidate;
    }
    return today;
  }

  Future<void> _restoreBackupAndReminders(ValidatedForzaBackup backup) async {
    await _viewModel.restoreBackup(backup);
    await _synchronizeWorkoutRemindersSafely();
  }

  Future<void> _refreshActiveWorkoutAndReminders() async {
    await _viewModel.refreshActiveWorkout();
    await _synchronizeWorkoutRemindersSafely();
  }

  Future<bool> _markSessionStartedAndSync(DateTime date) async {
    final started = await _viewModel.markSessionStarted(date);
    if (!started) return false;
    await _synchronizeWorkoutRemindersSafely();
    return true;
  }

  Future<bool> _rescheduleSessionAndSync(DateTime from, DateTime to) async {
    final moved = await _viewModel.rescheduleSession(from, to);
    if (moved) await _synchronizeWorkoutRemindersSafely();
    return moved;
  }

  Future<bool> _skipSessionAndSync(DateTime date) async {
    final skipped = await _viewModel.skipSession(date);
    if (skipped) await _synchronizeWorkoutRemindersSafely();
    return skipped;
  }

  Future<bool> _undoSkipSessionAndSync(DateTime date) async {
    final restored = await _viewModel.undoSkipSession(date);
    if (restored) await _synchronizeWorkoutRemindersSafely();
    return restored;
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) => LayoutBuilder(
        builder: (context, constraints) {
          if (!_viewModel.isReady) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          final useRail = constraints.maxWidth >= 840;
          final content = Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 960),
              child: SafeArea(
                top: true,
                bottom: true,
                child: IndexedStack(
                  index: _selectedIndex,
                  children: [
                    HomeView(
                      onShowActivity: () => _selectDestination(1),
                      onShowProfile: () => _selectDestination(4),
                      settings: _viewModel.trainingSettings,
                      onEditPlan: _editPlan,
                      onStartWorkout: _startHomeWorkout,
                      completedDates: _viewModel.completedDates,
                      streakDays: _viewModel.currentStreak,
                      streakAnimationFrom: _viewModel.streakAnimationFrom,
                      streakAnimationRevision:
                          _viewModel.streakAnimationRevision,
                      hasActiveWorkout: _viewModel.hasActiveWorkout,
                      activeWorkoutDate: _viewModel.activeWorkoutDate,
                      scheduledSessions: _viewModel.scheduledSessions,
                    ),
                    ActivityView(
                      settings: _viewModel.trainingSettings,
                      records: _viewModel.workoutRecords,
                      onWorkoutCompleted: _saveWorkoutRecord,
                      onSessionClosed: _refreshActiveWorkoutAndReminders,
                      workoutLogRepository: _viewModel.workoutLogRepository,
                      scheduledSessions: _viewModel.scheduledSessions,
                      onRescheduleSession: _rescheduleSessionAndSync,
                      onSessionStarted: _markSessionStartedAndSync,
                      onSkipSession: _skipSessionAndSync,
                      onUndoSkipSession: _undoSkipSessionAndSync,
                    ),
                    const ExercisesView(),
                    ProgressView(
                      records: _viewModel.workoutRecords,
                      onShowActivity: () => _selectDestination(1),
                      goals: _viewModel.personalGoals,
                      measurements: _viewModel.bodyMeasurements,
                      onSaveGoal: _viewModel.savePersonalGoal,
                      onDeleteGoal: _viewModel.deletePersonalGoal,
                      onSaveMeasurement: _viewModel.saveBodyMeasurement,
                      onDeleteMeasurement: _viewModel.deleteBodyMeasurement,
                    ),
                    ProfileView(
                      trainingSettings: _viewModel.trainingSettings,
                      accountAuthViewModel: _accountAuthViewModel,
                      profileSettingsRepository: _profileSettingsRepository,
                      onNotificationsChanged: _saveNotificationSettings,
                      themeMode: widget.appearance.mode,
                      onThemeModeChanged: widget.appearance.setMode,
                      localeController: widget.localeController,
                      onManageBackups: _openBackupRestore,
                      onTrainingSettingsChanged: (settings) =>
                          _updateTrainingSettings(settings),
                    ),
                  ],
                ),
              ),
            ),
          );
          final animatedContent = FadeTransition(
            opacity: _moduleTransition,
            child: SlideTransition(position: _moduleOffset, child: content),
          );

          return Scaffold(
            body: useRail
                ? Row(
                    children: [
                      _buildNavigationRail(),
                      const VerticalDivider(width: 1, thickness: 1),
                      Expanded(child: animatedContent),
                    ],
                  )
                : animatedContent,
            bottomNavigationBar: useRail ? null : _buildBottomNavigationBar(),
          );
        },
      ),
    );
  }

  Future<void> _saveTrainingSettings(TrainingSettings settings) async {
    try {
      await _viewModel.saveTrainingSettings(settings);
    } on Object {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.shellPlanSaveError)));
      return;
    }
    await _synchronizeWorkoutRemindersSafely();
  }

  void _updateTrainingSettings(TrainingSettings settings) {
    _saveTrainingSettings(settings);
  }

  Widget _buildNavigationRail() {
    return NavigationRail(
      selectedIndex: _selectedIndex,
      onDestinationSelected: _selectDestination,
      backgroundColor: context.appColors.background,
      indicatorColor: context.appColors.accentSoft,
      indicatorShape: const CircleBorder(),
      labelType: NavigationRailLabelType.all,
      minWidth: 84,
      groupAlignment: 0,
      destinations: [
        for (var index = 0; index < _destinations.length; index++)
          NavigationRailDestination(
            icon: Icon(_destinations[index].icon),
            selectedIcon: Icon(_destinations[index].selectedIcon),
            label: Text(_destinationLabel(context, index)),
          ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: context.appColors.surface,
        border: Border(top: BorderSide(color: context.appColors.divider)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            for (var index = 0; index < _destinations.length; index++)
              Expanded(
                child: _BottomNavigationDestination(
                  destination: _destinations[index],
                  label: _destinationLabel(context, index),
                  selected: index == _selectedIndex,
                  onTap: () => _selectDestination(index),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

String _appearanceName(ThemeMode mode) => switch (mode) {
  ThemeMode.system => 'system',
  ThemeMode.light => 'light',
  ThemeMode.dark => 'dark',
};

String _destinationLabel(BuildContext context, int index) => switch (index) {
  0 => context.l10n.navigationHome,
  1 => context.l10n.activityTitle,
  2 => context.l10n.exerciseEyebrow,
  3 => context.l10n.progressEyebrow,
  _ => context.l10n.profileTitle,
};

ThemeMode _themeMode(String mode) => switch (mode) {
  'light' => ThemeMode.light,
  'dark' => ThemeMode.dark,
  _ => ThemeMode.system,
};

class _AppDestination {
  const _AppDestination({required this.icon, required this.selectedIcon});

  final IconData icon;
  final IconData selectedIcon;
}

class _BottomNavigationDestination extends StatefulWidget {
  const _BottomNavigationDestination({
    required this.destination,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final _AppDestination destination;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_BottomNavigationDestination> createState() =>
      _BottomNavigationDestinationState();
}

class _BottomNavigationDestinationState
    extends State<_BottomNavigationDestination> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final labelStyle = Theme.of(context).textTheme.labelSmall;
    return Semantics(
      button: true,
      selected: widget.selected,
      label: widget.label,
      onTap: widget.onTap,
      child: ExcludeSemantics(
        child: InkWell(
          onTap: widget.onTap,
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.x1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                MouseRegion(
                  onEnter: (_) => setState(() => _hovered = true),
                  onExit: (_) => setState(() => _hovered = false),
                  child: AnimatedContainer(
                    duration: MediaQuery.disableAnimationsOf(context)
                        ? Duration.zero
                        : const Duration(milliseconds: 120),
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _hovered ? colors.accentSoft : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      widget.selected
                          ? widget.destination.selectedIcon
                          : widget.destination.icon,
                      color: widget.selected
                          ? colors.accent
                          : colors.textSecondary,
                      size: 22,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.x1,
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      widget.label,
                      maxLines: 1,
                      softWrap: false,
                      style: labelStyle?.copyWith(
                        color: widget.selected
                            ? colors.accent
                            : colors.textSecondary,
                        fontWeight: widget.selected
                            ? FontWeight.w600
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
