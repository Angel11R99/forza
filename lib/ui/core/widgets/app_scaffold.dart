import 'package:material_ui/material_ui.dart';

import '../../../domain/models/workout_record.dart';
import '../../../app/theme/appearance_controller.dart';
import '../../../app/theme/app_colors.dart';
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
import '../view_models/app_shell_view_model.dart';

class AppScaffold extends StatefulWidget {
  const AppScaffold({
    super.key,
    this.initialIndex = 0,
    required this.appearance,
  });

  final int initialIndex;
  final AppearanceController appearance;

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  late int _selectedIndex;
  final _viewModel = AppShellViewModel();
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

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _restoreSettings() async {
    await _viewModel.restore();
    if (!mounted) return;
    if (_viewModel.needsFirstRunSetup) {
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
          initialSettings: _viewModel.trainingSettings,
          isFirstRun: true,
        ),
      ),
    );
    if (!mounted) return;
    try {
      await _viewModel.completeFirstRun(settings);
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
        builder: (_) =>
            OnboardingView(initialSettings: _viewModel.trainingSettings),
      ),
    );
    if (!mounted || updated == null) return;
    await _saveTrainingSettings(updated);
  }

  Future<void> _startHomeWorkout() async {
    final trainingSettings = _viewModel.trainingSettings;
    final days = trainingSettings.trainingDays.toList()..sort();
    final now = DateTime.now();
    final nextSessionDate = _nextTrainingDate(
      trainingSettings.trainingDays,
      now,
    );
    final sessionIndex = days.indexOf(nextSessionDate.weekday);
    final record = await Navigator.of(context).push<WorkoutRecord>(
      MaterialPageRoute<WorkoutRecord>(
        builder: (_) => TrainingSessionFlow(
          settings: trainingSettings,
          sessionIndex: sessionIndex < 0 ? 0 : sessionIndex,
          scheduledDate: now,
        ),
      ),
    );
    if (!mounted) return;
    if (record != null) await _saveWorkoutRecord(record);
  }

  Future<void> _saveWorkoutRecord(WorkoutRecord record) async {
    try {
      await _viewModel.recordWorkout(record);
      if (!mounted) return;
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
                    ),
                    ActivityView(
                      settings: _viewModel.trainingSettings,
                      records: _viewModel.workoutRecords,
                      onWorkoutCompleted: _saveWorkoutRecord,
                    ),
                    const ExercisesView(),
                    ProgressView(records: _viewModel.workoutRecords),
                    ProfileView(
                      trainingSettings: _viewModel.trainingSettings,
                      themeMode: widget.appearance.mode,
                      onThemeModeChanged: widget.appearance.setMode,
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
      ),
    );
  }

  Future<void> _saveTrainingSettings(TrainingSettings settings) async {
    try {
      await _viewModel.saveTrainingSettings(settings);
    } on Object {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No pudimos guardar tu plan.')),
      );
    }
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
              decoration: BoxDecoration(
                color: context.appColors.accent,
                shape: BoxShape.circle,
              ),
              child: ForzaMark(color: context.appColors.inverseText, size: 22),
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

class _BottomNavigationDestination extends StatefulWidget {
  const _BottomNavigationDestination({
    required this.destination,
    required this.selected,
    required this.onTap,
  });

  final _AppDestination destination;
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
    return Semantics(
      button: true,
      selected: widget.selected,
      label: widget.destination.label,
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
                  duration: const Duration(milliseconds: 120),
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
              Text(
                widget.destination.label,
                style: TextStyle(
                  color: widget.selected ? colors.accent : colors.textSecondary,
                  fontSize: 12,
                  fontWeight: widget.selected
                      ? FontWeight.w700
                      : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
