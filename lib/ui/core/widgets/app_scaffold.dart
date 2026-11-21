import 'dart:ui';

import 'package:material_ui/material_ui.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../features/activity/views/activity_view.dart';
import '../../features/exercises/views/exercises_view.dart';
import '../../features/home/views/home_view.dart';
import '../../features/profile/views/profile_view.dart';
import '../../features/progress/views/progress_view.dart';

class AppScaffold extends StatefulWidget {
  const AppScaffold({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  late int _selectedIndex;

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
  }

  void _selectDestination(int index) {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
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
                    onExploreExercises: () => _selectDestination(2),
                    onShowProfile: () => _selectDestination(4),
                  ),
                  const ActivityView(),
                  const ExercisesView(),
                  const ProgressView(),
                  const ProfileView(),
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
              child: const Text(
                'F',
                style: TextStyle(
                  color: AppColors.inverseText,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
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
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(26),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha: 0.82),
                borderRadius: BorderRadius.circular(26),
                border: Border.all(
                  color: AppColors.surface.withValues(alpha: 0.8),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x12000000),
                    blurRadius: 20,
                    offset: Offset(0, 6),
                  ),
                ],
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
