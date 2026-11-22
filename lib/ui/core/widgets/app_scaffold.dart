import 'package:material_ui/material_ui.dart';

import '../../../data/repositories/training_settings_repository.dart';
import '../../../data/repositories/workout_log_repository.dart';
import '../../../domain/models/workout_record.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_spacing.dart';
import '../../features/activity/views/activity_view.dart';
import '../../features/exercises/views/exercises_view.dart';
import '../../features/home/views/home_view.dart';
import '../../features/onboarding/views/onboarding_view.dart';
import '../../features/profile/models/profile_settings.dart';
import '../../features/profile/views/profile_view.dart';
import '../../features/progress/views/progress_view.dart';
import '../../features/onboarding/views/training_session_flow.dart';
import 'forza_brand.dart';

class AppScaffold extends StatefulWidget {
  const AppScaffold({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  late int _selectedIndex;
  TrainingSettings _trainingSettings = const TrainingSettings();
  final _settingsRepository = TrainingSettingsRepository();
  final _workoutLogRepository = WorkoutLogRepository();
  List<WorkoutRecord> _workoutRecords = const [];
  bool _isReady = false;
  bool _isOpeningFirstRun = false;

  static const _destinations = <_AppDestination>[
    _AppDestination(
      label: 'Inicio',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_rounded,
    ),
    _AppDestination(
      label: 'Actividad',
      icon: Icons.calendar_month_outlined,
      selectedIcon: Icons.calendar_month_rounded,
    ),
    _AppDestination(
      label: 'Ejercicios',
      icon: Icons.fitness_center_outlined,
      selectedIcon: Icons.fitness_center_rounded,
    ),
    _AppDestination(
      label: 'Progreso',
      icon: Icons.insights_outlined,
      selectedIcon: Icons.insights_rounded,
    ),
    _AppDestination(
      label: 'Perfil',
      icon: Icons.person_outline_rounded,
      selectedIcon: Icons.person_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex
        .clamp(0, _destinations.length - 1)
        .toInt();
    _restoreSettings();
  }

  Future<void> _restoreSettings() async {
    var settings = const TrainingSettings();
    var workoutRecords = const <WorkoutRecord>[];
    var setupComplete = false;
    try {
      settings = await _settingsRepository.load();
      setupComplete = await _settingsRepository.setupComplete;
    } on Object {
      // Keep the app available with its defaults if local storage is unavailable.
    }
    try {
      workoutRecords = await _workoutLogRepository.load();
    } on Object {
      // An empty activity history should not block the app from opening.
    }
    if (!mounted) return;
    setState(() {
      _trainingSettings = settings;
      _workoutRecords = workoutRecords;
      _isReady = true;
    });
    if (!setupComplete) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _startFirstRunSetup(),
      );
    }
  }

  Future<void> _startFirstRunSetup() async {
    if (!mounted || _isOpeningFirstRun) return;
    _isOpeningFirstRun = true;
    final settings = await Navigator.of(context).push<TrainingSettings>(
      MaterialPageRoute<TrainingSettings>(
        builder: (_) => OnboardingView(
          initialSettings: _trainingSettings,
          isFirstRun: true,
        ),
      ),
    );
    if (!mounted) return;
    try {
      if (settings != null) {
        setState(() => _trainingSettings = settings);
        await _settingsRepository.save(settings);
      }
      await _settingsRepository.completeSetup();
    } on Object {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No pudimos guardar tu plan.')),
        );
      }
    } finally {
      _isOpeningFirstRun = false;
    }
  }

  void _selectDestination(int index) {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);
  }

  Future<void> _editPlan() async {
    final updated = await Navigator.of(context).push<TrainingSettings>(
      MaterialPageRoute<TrainingSettings>(
        builder: (_) => OnboardingView(initialSettings: _trainingSettings),
      ),
    );
    if (!mounted || updated == null) return;
    setState(() => _trainingSettings = updated);
    await _settingsRepository.save(updated);
  }

  Future<void> _startHomeWorkout() async {
    final days = _trainingSettings.trainingDays.toList()..sort();
    final now = DateTime.now();
    final nextSessionDate = _nextTrainingDate(
      _trainingSettings.trainingDays,
      now,
    );
    final sessionIndex = days.indexOf(nextSessionDate.weekday);
    final record = await Navigator.of(context).push<WorkoutRecord>(
      MaterialPageRoute<WorkoutRecord>(
        builder: (_) => TrainingSessionFlow(
          settings: _trainingSettings,
          sessionIndex: sessionIndex < 0 ? 0 : sessionIndex,
          scheduledDate: now,
        ),
      ),
    );
    if (record != null) await _saveWorkoutRecord(record);
  }

  Future<void> _saveWorkoutRecord(WorkoutRecord record) async {
    try {
      final records = await _workoutLogRepository.save(record);
      if (!mounted) return;
      setState(() => _workoutRecords = records);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sesión guardada en tu actividad.')),
      );
    } on Object {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No pudimos guardar esta sesión.')),
      );
    }
  }

  Set<DateTime> get _completedDates => {
    for (final record in _workoutRecords) record.date,
  };

  DateTime _nextTrainingDate(Set<int> days, DateTime from) {
    final today = DateTime(from.year, from.month, from.day);
    for (var offset = 0; offset < 7; offset++) {
      final candidate = today.add(Duration(days: offset));
      if (days.contains(candidate.weekday)) return candidate;
    }
    return today;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (!_isReady) {
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
                    settings: _trainingSettings,
                    onEditPlan: _editPlan,
                    onStartWorkout: _startHomeWorkout,
                    completedDates: _completedDates,
                  ),
                  ActivityView(
                    settings: _trainingSettings,
                    records: _workoutRecords,
                    onWorkoutCompleted: _saveWorkoutRecord,
                  ),
                  const ExercisesView(),
                  ProgressView(records: _workoutRecords),
                  ProfileView(
                    trainingSettings: _trainingSettings,
                    onTrainingSettingsChanged: (settings) =>
                        _updateTrainingSettings(settings),
                  ),
                ],
              ),
            ),
          ),
        );

        return Scaffold(
          body: useRail
              ? Row(
                  children: [
                    _buildNavigationRail(),
                    const VerticalDivider(width: 1, thickness: 1),
                    Expanded(child: content),
                  ],
                )
              : content,
          bottomNavigationBar: useRail ? null : _buildBottomNavigationBar(),
        );
      },
    );
  }

  void _updateTrainingSettings(TrainingSettings settings) {
    setState(() => _trainingSettings = settings);
    _settingsRepository.save(settings);
  }

  Widget _buildNavigationRail() {
    return NavigationRail(
      selectedIndex: _selectedIndex,
      onDestinationSelected: _selectDestination,
      backgroundColor: AppColors.background,
      indicatorColor: AppColors.accentSoft,
      labelType: NavigationRailLabelType.all,
      minWidth: 84,
      groupAlignment: -0.65,
      leading: Padding(
        padding: const EdgeInsets.only(
          bottom: AppSpacing.x8,
          top: AppSpacing.x4,
        ),
        child: Semantics(
          label: 'FORZA',
          child: ExcludeSemantics(
            child: Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.accent,
                shape: BoxShape.circle,
              ),
              child: const ForzaMark(color: AppColors.inverseText, size: 22),
            ),
          ),
        ),
      ),
      destinations: [
        for (final destination in _destinations)
          NavigationRailDestination(
            icon: Icon(destination.icon),
            selectedIcon: Icon(destination.selectedIcon),
            label: Text(destination.label),
          ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.x4,
          0,
          AppSpacing.x4,
          AppSpacing.x2,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.large),
            border: Border.all(color: AppColors.divider),
          ),
          child: NavigationBarTheme(
            data: NavigationBarThemeData(
              indicatorColor: Colors.transparent,
              labelTextStyle: WidgetStateProperty.resolveWith((states) {
                final selected = states.contains(WidgetState.selected);
                return TextStyle(
                  color: selected ? AppColors.accent : AppColors.textSecondary,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                );
              }),
              iconTheme: WidgetStateProperty.resolveWith((states) {
                final selected = states.contains(WidgetState.selected);
                return IconThemeData(
                  color: selected ? AppColors.accent : AppColors.textSecondary,
                );
              }),
            ),
            child: NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: _selectDestination,
              backgroundColor: Colors.transparent,
              destinations: [
                for (final destination in _destinations)
                  NavigationDestination(
                    icon: Icon(destination.icon),
                    selectedIcon: Icon(destination.selectedIcon),
                    label: destination.label,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AppDestination {
  const _AppDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}
