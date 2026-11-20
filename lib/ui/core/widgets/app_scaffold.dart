import 'package:material_ui/material_ui.dart';
import 'package:native_glass_navbar/native_glass_navbar.dart';

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
      symbol: 'house',
      selectedSymbol: 'house.fill',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_rounded,
    ),
    _AppDestination(
      label: 'Actividad',
      symbol: 'calendar',
      selectedSymbol: 'calendar',
      icon: Icons.calendar_month_outlined,
      selectedIcon: Icons.calendar_month_rounded,
    ),
    _AppDestination(
      label: 'Ejercicios',
      symbol: 'dumbbell',
      selectedSymbol: 'dumbbell.fill',
      icon: Icons.fitness_center_outlined,
      selectedIcon: Icons.fitness_center_rounded,
    ),
    _AppDestination(
      label: 'Progreso',
      symbol: 'chart.bar',
      selectedSymbol: 'chart.bar.fill',
      icon: Icons.insights_outlined,
      selectedIcon: Icons.insights_rounded,
    ),
    _AppDestination(
      label: 'Perfil',
      symbol: 'person.crop.circle',
      selectedSymbol: 'person.crop.circle.fill',
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
      indicatorColor: AppColors.surfaceMuted,
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
                color: AppColors.textPrimary,
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
    return NativeGlassNavBar(
      currentIndex: _selectedIndex,
      onTap: _selectDestination,
      tintColor: AppColors.textPrimary,
      tabs: [
        for (final destination in _destinations)
          NativeGlassNavBarItem(
            label: destination.label,
            symbol: destination.symbol,
            selectedSymbol: destination.selectedSymbol,
          ),
      ],
      fallback: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _selectDestination,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.textPrimary,
        unselectedItemColor: AppColors.textSecondary,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        showUnselectedLabels: true,
        elevation: 0,
        items: [
          for (final destination in _destinations)
            BottomNavigationBarItem(
              icon: Icon(destination.icon),
              activeIcon: Icon(destination.selectedIcon),
              label: destination.label,
              tooltip: destination.label,
            ),
        ],
      ),
    );
  }
}

class _AppDestination {
  const _AppDestination({
    required this.label,
    required this.symbol,
    required this.selectedSymbol,
    required this.icon,
    required this.selectedIcon,
  });

  final String label;
  final String symbol;
  final String selectedSymbol;
  final IconData icon;
  final IconData selectedIcon;
}
