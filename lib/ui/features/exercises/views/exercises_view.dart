import 'package:material_ui/material_ui.dart';

import '../../../../data/repositories/demo_exercise_repository.dart';
import '../../../../domain/models/exercise.dart';
import '../../../../domain/repositories/exercise_repository.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../core/widgets/app_surface_card.dart';
import '../../../core/widgets/forza_brand.dart';
import '../models/exercise_filter_selection.dart';
import '../widgets/exercise_list_card.dart';
import 'exercise_detail_page.dart';
import 'exercise_filters_page.dart';

class ExercisesView extends StatefulWidget {
  const ExercisesView({super.key, this.repository});

  final ExerciseRepository? repository;

  @override
  State<ExercisesView> createState() => _ExercisesViewState();
}

class _ExercisesViewState extends State<ExercisesView> {
  final _searchController = TextEditingController();
  ExerciseFilterSelection _filters = const ExerciseFilterSelection();
  String _searchQuery = '';
  bool _isLoading = true;
  bool _loadFailed = false;

  ExerciseRepository get _repository =>
      widget.repository ?? DemoExerciseRepository.instance;

  @override
  void initState() {
    super.initState();
    if (_repository.isLoaded) {
      _isLoading = false;
    } else {
      _loadCatalog();
    }
  }

  Future<void> _loadCatalog() async {
    setState(() {
      _isLoading = true;
      _loadFailed = false;
    });
    try {
      await _repository.load();
      if (mounted) setState(() => _isLoading = false);
    } on Object {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _loadFailed = true;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Exercise> get _results {
    return _repository.search(
      query: _searchQuery,
      muscleGroups: _filters.muscleGroups,
      equipment: _filters.equipment,
    );
  }

  Future<void> _openFilters() async {
    final selection = await Navigator.of(context).push<ExerciseFilterSelection>(
      MaterialPageRoute<ExerciseFilterSelection>(
        builder: (_) => ExerciseFiltersPage(
          initialSelection: _filters,
          searchQuery: _searchQuery,
          repository: _repository,
        ),
      ),
    );
    if (!mounted || selection == null) return;
    setState(() => _filters = selection);
  }

  void _openExercise(Exercise exercise) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) =>
            ExerciseDetailPage(exercise: exercise, repository: _repository),
      ),
    );
  }

  void _clearSearchAndFilters() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
      _filters = const ExerciseFilterSelection();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_loadFailed) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.x8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline_rounded, size: 36),
              const SizedBox(height: AppSpacing.x3),
              Text(
                'No pudimos cargar los ejercicios.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.x3),
              OutlinedButton.icon(
                onPressed: _loadCatalog,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    final results = _results;
    final horizontalPadding = AppSpacing.pageGutter(
      MediaQuery.sizeOf(context).width,
    );
    final contentWidth =
        MediaQuery.sizeOf(context).width - (horizontalPadding * 2);
    final columns = (contentWidth / 112).floor().clamp(3, 5).toInt();
    final textScale = MediaQuery.textScalerOf(context).scale(1).clamp(1, 1.3);
    final cardHeight =
        (contentWidth / columns * 1.58).clamp(176.0, 210.0) * textScale;

    return CustomScrollView(
      key: const PageStorageKey<String>('exercises-scroll'),
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            AppSpacing.x6,
            horizontalPadding,
            AppSpacing.x8,
          ),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ForzaEyebrow(label: 'Ejercicios'),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'Ejercicios',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'Encuentra movimientos para tu próxima sesión.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: AppSpacing.x6),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) =>
                            setState(() => _searchQuery = value),
                        textInputAction: TextInputAction.search,
                        decoration: InputDecoration(
                          hintText: 'Ejercicio, músculo o equipo',
                          prefixIcon: const Icon(Icons.search_rounded),
                          suffixIcon: _searchQuery.isEmpty
                              ? null
                              : IconButton(
                                  tooltip: 'Borrar búsqueda',
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() => _searchQuery = '');
                                  },
                                  icon: const Icon(Icons.close_rounded),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: _filters.isEmpty
                            ? AppColors.surface
                            : AppColors.surfaceMuted,
                        borderRadius: BorderRadius.circular(AppRadius.medium),
                        border: Border.all(
                          color: _filters.isEmpty
                              ? AppColors.divider
                              : AppColors.accent,
                        ),
                      ),
                      child: IconButton(
                        tooltip: _filters.count == 0
                            ? 'Abrir filtros'
                            : 'Filtros activos: ${_filters.count}',
                        onPressed: _openFilters,
                        icon: Badge(
                          isLabelVisible: _filters.count > 0,
                          label: Text('${_filters.count}'),
                          child: const Icon(Icons.tune_rounded),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x6),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _searchQuery.trim().isNotEmpty
                            ? 'Resultados de búsqueda'
                            : 'Todos los ejercicios',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    Semantics(
                      liveRegion: true,
                      label: '${results.length} ejercicios encontrados',
                      child: ExcludeSemantics(
                        child: Text(
                          '${results.length}',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (results.isEmpty)
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            sliver: SliverToBoxAdapter(
              child: _EmptyResults(onClear: _clearSearchAndFilters),
            ),
          )
        else
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              0,
              horizontalPadding,
              AppSpacing.x8,
            ),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                mainAxisExtent: cardHeight,
                crossAxisSpacing: AppSpacing.x2,
                mainAxisSpacing: AppSpacing.x2,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => ExerciseListCard(
                  exercise: results[index],
                  onTap: () => _openExercise(results[index]),
                  compact: true,
                ),
                childCount: results.length,
              ),
            ),
          ),
      ],
    );
  }
}

class _EmptyResults extends StatelessWidget {
  const _EmptyResults({required this.onClear});

  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      padding: const EdgeInsets.all(AppSpacing.x8),
      child: Column(
        children: [
          const Icon(Icons.search_off_rounded, size: 32),
          const SizedBox(height: AppSpacing.x3),
          Text(
            'No encontramos ejercicios',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            'Prueba otra búsqueda o quita algunos filtros.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.x4),
          OutlinedButton.icon(
            onPressed: onClear,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Limpiar búsqueda y filtros'),
          ),
        ],
      ),
    );
  }
}
