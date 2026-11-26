import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../../domain/models/workout_record.dart';
import '../../../data/database/app_database.dart';
import '../../../data/repositories/backup_repository.dart';
import '../../../data/repositories/body_measurement_repository.dart';
import '../../../data/repositories/google_account_auth_repository.dart';
import '../../../data/repositories/personal_goal_repository.dart';
import '../../../data/repositories/profile_settings_repository.dart';
import '../../../data/repositories/training_schedule_repository.dart';
import '../../../data/repositories/training_settings_repository.dart';
import '../../../data/repositories/workout_reminder_repository.dart';
import '../../../data/repositories/workout_log_repository.dart';
import '../../../data/services/firestore_backup_sync_service.dart';
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
  late final StreamSubscription<void> _profileSettingsChanges;
  FirestoreBackupSyncService? _cloudSyncService;
  late final AnimationController _moduleController;
  late final CurvedAnimation _moduleTransition;
  late final Animation<Offset> _moduleOffset;
  int? _pendingDestination;
  bool _isOpeningFirstRun = false;
  bool _firstRunSetupScheduled = false;
  AppPreferences _preferences = const AppPreferences();
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
    _viewModel =
        widget.viewModel ??
        AppShellViewModel(localeController: widget.localeController);
    _profileSettingsRepository =
        widget.profileSettingsRepository ?? ProfileSettingsRepository();
    _profileSettingsChanges = _profileSettingsRepository.changes.listen((_) {
      if (mounted) unawaited(_restoreSettings());
    });
    _accountAuthViewModel =
        widget.accountAuthViewModel ??
        AccountAuthViewModel(repository: GoogleAccountAuthRepository());
    _workoutReminderRepository =
        widget.workoutReminderRepository ?? WorkoutReminderRepository();
    if (Firebase.apps.isNotEmpty) {
      final database = AppDatabase.instance;
      final workoutLogRepository = WorkoutLogRepository(database: database);
      _cloudSyncService = FirestoreBackupSyncService(
        database: database,
        backupRepository: BackupRepository(
          database: database,
          settingsRepository: TrainingSettingsRepository(database: database),
          workoutLogRepository: workoutLogRepository,
          scheduleRepository: TrainingScheduleRepository(database: database),
          goalRepository: PersonalGoalRepository(database: database),
          bodyMeasurementRepository: BodyMeasurementRepository(
            database: database,
          ),
          profileSettingsRepository: _profileSettingsRepository,
          readLanguageCode: () => widget.localeController.locale?.languageCode,
          writeLanguageCode: widget.localeController.setLanguageCode,
        ),
        appearanceMode: () => widget.appearance.mode.name,
        applyAppearance: (mode) => widget.appearance.setMode(
          ThemeMode.values.firstWhere(
            (candidate) => candidate.name == mode,
            orElse: () => ThemeMode.system,
          ),
        ),
        profileSettingsRepository: _profileSettingsRepository,
        appearanceChanges: widget.appearance,
        onDataRestored: _restoreSettings,
      )..start();
    }
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
    unawaited(_profileSettingsChanges.cancel());
    _cloudSyncService?.dispose();
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
      unawaited(_cloudSyncService?.retryNow());
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
    try {
      _preferences = await _profileSettingsRepository.loadAppPreferences();
    } on Object {
      _preferences = const AppPreferences();
    }
    if (mounted) setState(() {});
    await _synchronizeWorkoutRemindersSafely();
    _scheduleFirstRunSetup();
  }

  void _scheduleFirstRunSetup() {
    if (!mounted ||
        !_viewModel.needsFirstRunSetup ||
        _isOpeningFirstRun ||
        _firstRunSetupScheduled) {
      return;
    }

    _firstRunSetupScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _firstRunSetupScheduled = false;
      if (!mounted || !_viewModel.needsFirstRunSetup || _isOpeningFirstRun) {
        return;
      }
      unawaited(_startFirstRunSetup());
    });
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
    if (!widget.appearance.isRestored) await widget.appearance.restore();
    if (!mounted) return;
    final result = await Navigator.of(context).push<Object?>(
      MaterialPageRoute<Object?>(
        builder: (_) => OnboardingView(
          initialSettings: _viewModel.trainingSettings,
          isFirstRun: true,
          initialPreferences: _preferences,
          appearanceController: widget.appearance,
        ),
      ),
    );
    if (!mounted) return;
    try {
      if (result is FirstRunOnboardingResult) {
        final previousSettings = _viewModel.trainingSettings;
        final previousPreferences = _preferences;
        final previousAppearance = widget.appearance.mode;
        try {
          await _viewModel.saveTrainingSettings(result.trainingSettings);
          await _profileSettingsRepository.saveAppPreferences(
            result.preferences,
          );
          await widget.appearance.commitMode(result.appearanceMode);
          await _viewModel.completeFirstRun(null);
          _preferences = result.preferences;
          if (mounted) setState(() {});
        } on Object {
          try {
            await _profileSettingsRepository.saveAppPreferences(
              previousPreferences,
            );
            await widget.appearance.commitMode(previousAppearance);
            await _viewModel.saveTrainingSettings(previousSettings);
          } on Object {
            // Keep first-run setup incomplete so the user can retry on restart.
          }
          rethrow;
        }
      } else {
        await _viewModel.completeFirstRun(
          result is TrainingSettings ? result : null,
        );
      }
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
          weightUnit: _preferences.weightUnit,
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
                      weekStartsOn: _preferences.weekStartsOn,
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
                      preferences: _preferences,
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
                      preferences: _preferences,
                    ),
                    ProfileView(
                      trainingSettings: _viewModel.trainingSettings,
                      preferences: _preferences,
                      accountAuthViewModel: _accountAuthViewModel,
                      cloudSyncService: _cloudSyncService,
                      profileSettingsRepository: _profileSettingsRepository,
                      onPreferencesChanged: (preferences) =>
                          setState(() => _preferences = preferences),
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
                  child: Text(
                    widget.label,
                    maxLines: 2,
                    textAlign: TextAlign.center,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
