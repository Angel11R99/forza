import 'package:material_ui/material_ui.dart';

import '../../../../data/repositories/demo_exercise_repository.dart';
import '../../../../domain/models/exercise.dart';
import '../../../../domain/repositories/exercise_repository.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/localization/localization_extensions.dart';
import '../../../core/widgets/app_surface_card.dart';
import '../../../core/widgets/forza_brand.dart';
import '../models/exercise_filter_selection.dart';
import '../models/exercise_localized_labels.dart';
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

  void _clearFilters() =>
      setState(() => _filters = const ExerciseFilterSelection());

  void _removeMuscleGroup(String value) => setState(() {
    _filters = ExerciseFilterSelection(
      muscleGroups: Set.unmodifiable({..._filters.muscleGroups}..remove(value)),
      equipment: _filters.equipment,
    );
  });

  void _removeEquipment(String value) => setState(() {
    _filters = ExerciseFilterSelection(
      muscleGroups: _filters.muscleGroups,
      equipment: Set.unmodifiable({..._filters.equipment}..remove(value)),
    );
  });

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
                context.l10n.exerciseLoadError,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.x3),
              OutlinedButton.icon(
                onPressed: _loadCatalog,
                icon: const Icon(Icons.refresh_rounded),
                label: Text(context.l10n.exerciseRetry),
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
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final useGrid = contentWidth >= 560 && textScale < 1.3;
    final columns = (contentWidth / 280).floor().clamp(2, 4).toInt();

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
                ForzaEyebrow(label: context.l10n.exerciseEyebrow),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  context.l10n.exerciseLibraryTitle,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  context.l10n.exerciseLibrarySubtitle,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: AppSpacing.x6),
              ],
            ),
          ),
        ),
        SliverPersistentHeader(
          pinned: true,
          delegate: _PinnedCatalogControls(
            child: ColoredBox(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: _CatalogSearchControls(
                  controller: _searchController,
                  query: _searchQuery,
                  filterCount: _filters.count,
                  hasFilters: !_filters.isEmpty,
                  onQueryChanged: (value) =>
                      setState(() => _searchQuery = value),
                  onClearQuery: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                  onOpenFilters: _openFilters,
                ),
              ),
            ),
          ),
        ),
        if (!_filters.isEmpty)
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              AppSpacing.x2,
              horizontalPadding,
              0,
            ),
            sliver: SliverToBoxAdapter(
              child: Wrap(
                spacing: AppSpacing.x2,
                runSpacing: AppSpacing.x2,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  for (final group in _filters.muscleGroups)
                    InputChip(
                      label: Text(localizedExerciseMuscleGroup(context, group)),
                      onDeleted: () => _removeMuscleGroup(group),
                    ),
                  for (final equipment in _filters.equipment)
                    InputChip(
                      label: Text(
                        localizedExerciseEquipment(context, equipment),
                      ),
                      onDeleted: () => _removeEquipment(equipment),
                    ),
                  TextButton(
                    onPressed: _clearFilters,
                    child: Text(context.l10n.exerciseRemoveActiveFilters),
                  ),
                ],
              ),
            ),
          ),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            AppSpacing.x4,
            horizontalPadding,
            AppSpacing.x2,
          ),
          sliver: SliverToBoxAdapter(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _searchQuery.trim().isNotEmpty || !_filters.isEmpty
                        ? context.l10n.exerciseSearchResultsTitle
                        : context.l10n.exerciseAllResultsTitle,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Semantics(
                  liveRegion: true,
                  label: context.l10n.exerciseFoundCount(results.length),
                  child: ExcludeSemantics(
                    child: Text(
                      '${results.length}',
                      style: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(color: context.appColors.textSecondary),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (results.isEmpty)
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            sliver: SliverToBoxAdapter(
              child: _EmptyResults(
                hasQuery: _searchQuery.trim().isNotEmpty,
                hasFilters: !_filters.isEmpty,
                onClearQuery: () {
                  _searchController.clear();
                  setState(() => _searchQuery = '');
                },
                onClearFilters: _clearFilters,
              ),
            ),
          )
        else if (useGrid)
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
                mainAxisExtent: 136 * textScale.clamp(1, 1.25),
                crossAxisSpacing: AppSpacing.x2,
                mainAxisSpacing: AppSpacing.x2,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => ExerciseListCard(
                  exercise: results[index],
                  onTap: () => _openExercise(results[index]),
                  compact: false,
                ),
                childCount: results.length,
              ),
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
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.x2),
                  child: ExerciseListCard(
                    exercise: results[index],
                    onTap: () => _openExercise(results[index]),
                  ),
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
  const _EmptyResults({
    required this.hasQuery,
    required this.hasFilters,
    required this.onClearQuery,
    required this.onClearFilters,
  });

  final bool hasQuery;
  final bool hasFilters;
  final VoidCallback onClearQuery;
  final VoidCallback onClearFilters;

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      padding: const EdgeInsets.all(AppSpacing.x8),
      child: Column(
        children: [
          const Icon(Icons.search_off_rounded, size: 32),
          const SizedBox(height: AppSpacing.x3),
          Text(
            context.l10n.exerciseEmptyTitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            context.l10n.exerciseEmptySubtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (hasQuery || hasFilters) ...[
            const SizedBox(height: AppSpacing.x4),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: AppSpacing.x2,
              runSpacing: AppSpacing.x2,
              children: [
                if (hasQuery)
                  OutlinedButton.icon(
                    onPressed: onClearQuery,
                    icon: const Icon(Icons.search_off_rounded),
                    label: Text(context.l10n.exerciseClearSearch),
                  ),
                if (hasFilters)
                  OutlinedButton.icon(
                    onPressed: onClearFilters,
                    icon: const Icon(Icons.filter_alt_off_rounded),
                    label: Text(context.l10n.exerciseRemoveActiveFilters),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _CatalogSearchControls extends StatelessWidget {
  const _CatalogSearchControls({
    required this.controller,
    required this.query,
    required this.filterCount,
    required this.hasFilters,
    required this.onQueryChanged,
    required this.onClearQuery,
    required this.onOpenFilters,
  });

  final TextEditingController controller;
  final String query;
  final int filterCount;
  final bool hasFilters;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback onClearQuery;
  final VoidCallback onOpenFilters;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 72,
    child: Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            onChanged: onQueryChanged,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: context.l10n.exerciseSearchHint,
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: query.isEmpty
                  ? null
                  : IconButton(
                      tooltip: context.l10n.exerciseClearSearch,
                      onPressed: onClearQuery,
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
            color: hasFilters
                ? context.appColors.surfaceMuted
                : context.appColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.medium),
            border: Border.all(
              color: hasFilters
                  ? context.appColors.accent
                  : context.appColors.divider,
            ),
          ),
          child: IconButton(
            tooltip: filterCount == 0
                ? context.l10n.exerciseOpenFilters
                : context.l10n.exerciseActiveFilters(filterCount),
            onPressed: onOpenFilters,
            icon: Badge(
              isLabelVisible: filterCount > 0,
              label: Text('$filterCount'),
              child: const Icon(Icons.tune_rounded),
            ),
          ),
        ),
      ],
    ),
  );
}

class _PinnedCatalogControls extends SliverPersistentHeaderDelegate {
  const _PinnedCatalogControls({required this.child});

  final Widget child;

  @override
  double get minExtent => 72;

  @override
  double get maxExtent => 72;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) => child;

  @override
  bool shouldRebuild(_PinnedCatalogControls oldDelegate) =>
      oldDelegate.child != child;
}
