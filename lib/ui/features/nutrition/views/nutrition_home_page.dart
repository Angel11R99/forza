import 'package:material_ui/material_ui.dart';

import '../../../../app/localization/localization_extensions.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../data/repositories/nutrition_catalog_repository.dart';
import '../../../../data/repositories/nutrition_meal_log_repository.dart';
import '../../../../data/repositories/hydration_repository.dart';
import '../../../../data/repositories/profile_settings_repository.dart';
import '../../../../domain/models/nutrition/nutrition_catalog.dart';
import '../../../../domain/models/nutrition/nutrition_models.dart';
import '../../../../domain/models/nutrition/hydration_models.dart';
import '../../../../domain/use_cases/nutrition_week_planner.dart';
import '../../../core/widgets/app_surface_card.dart';
import '../../profile/models/profile_settings.dart';
import '../../profile/views/nutrition_profile_page.dart';

class NutritionHomePage extends StatefulWidget {
  const NutritionHomePage({
    super.key,
    required this.profileRepository,
    required this.trainingSettings,
    this.catalogRepository,
    this.mealLogRepository,
    this.hydrationRepository,
    this.initialTab = 0,
  });

  final ProfileSettingsRepository profileRepository;
  final TrainingSettings trainingSettings;
  final NutritionCatalogRepository? catalogRepository;
  final NutritionMealLogRepository? mealLogRepository;
  final HydrationRepository? hydrationRepository;
  final int initialTab;

  @override
  State<NutritionHomePage> createState() => _NutritionHomePageState();
}

class _NutritionHomePageState extends State<NutritionHomePage> {
  late final _catalogRepository =
      widget.catalogRepository ?? NutritionCatalogRepository();
  late final _mealLogRepository =
      widget.mealLogRepository ?? NutritionMealLogRepository();
  late final _hydrationRepository =
      widget.hydrationRepository ?? HydrationRepository();
  NutritionProfile? _profile;
  NutritionCatalog? _catalog;
  NutritionWeekPlan? _plan;
  List<MealEntry> _entries = const [];
  bool _loading = true;
  bool _failed = false;
  bool _showingHistory = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (mounted) {
      setState(() {
        _loading = true;
        _failed = false;
      });
    }
    try {
      final profile = await widget.profileRepository.loadNutritionProfile();
      final catalog = await _catalogRepository.load();
      final entries = await _mealLogRepository.loadAll();
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final weekStart = today.subtract(Duration(days: today.weekday - 1));
      final generated = profile == null
          ? null
          : const NutritionWeekPlanner().generate(
              catalog: catalog,
              profile: profile,
              weekStart: weekStart,
              createdAt: now,
              planId: 'nutrition-${profile.id}-${_dateKey(weekStart)}',
              trainingWeekdays: widget.trainingSettings.trainingDays,
            );
      if (!mounted) return;
      setState(() {
        _profile = profile;
        _catalog = catalog;
        _plan = generated?.plan;
        _entries = entries;
        _failed =
            generated?.status == MealPlanGenerationStatus.invalidConfiguration;
        _loading = false;
      });
    } on Object {
      if (!mounted) return;
      setState(() {
        _failed = true;
        _loading = false;
      });
    }
  }

  Future<void> _editProfile() async {
    final profile = await Navigator.of(context).push<NutritionProfile>(
      MaterialPageRoute<NutritionProfile>(
        builder: (_) =>
            NutritionProfilePage(repository: widget.profileRepository),
      ),
    );
    if (profile != null) await _load();
  }

  Future<void> _togglePlannedMeal(PlannedMeal meal, bool consumed) async {
    try {
      final entryId = 'consumed:${meal.id}';
      final entry = consumed
          ? null
          : MealEntry(
              id: entryId,
              dateTime: DateTime.now(),
              recipeId: meal.recipeId,
              type: MealEntryType.consumedPlanned,
              plannedMealId: meal.id,
              quantityGrams: meal.ingredients.fold<double>(
                0,
                (sum, ingredient) => sum + ingredient.grams,
              ),
              nutrientEstimates: meal.nutrients,
              catalogVersion: _catalog?.version,
            );
      if (consumed) {
        await _mealLogRepository.delete(entryId);
      } else {
        await _mealLogRepository.save(entry!);
      }
      if (!mounted) return;
      setState(() {
        _entries = [
          ..._entries.where((entry) => entry.id != entryId),
          ...?(entry == null ? null : [entry]),
        ];
      });
    } on Object {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.nutritionLogSaveError)),
        );
      }
    }
  }

  Future<void> _addFood() async {
    final catalog = _catalog;
    if (catalog == null) return;
    final foodId = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _FoodPickerSheet(foods: catalog.foods),
    );
    if (foodId == null || !mounted) return;
    final grams = await showDialog<double>(
      context: context,
      builder: (_) => const _FoodAmountDialog(),
    );
    if (grams == null || !mounted) return;
    final food = catalog.foods.firstWhere((item) => item.id == foodId);
    final nutrients = <String, double?>{
      for (final code in nutritionNutrientCodes.keys)
        code: food.nutrient(code) == null
            ? null
            : food.nutrient(code)! * grams / 100,
    };
    final now = DateTime.now();
    final entry = MealEntry(
      id: 'manual:${now.microsecondsSinceEpoch}',
      dateTime: now,
      foodId: food.id,
      type: MealEntryType.manual,
      quantityGrams: grams,
      nutrientEstimates: Map.unmodifiable(nutrients),
      catalogVersion: catalog.version,
    );
    try {
      await _mealLogRepository.save(entry);
      if (mounted) setState(() => _entries = [entry, ..._entries]);
    } on Object {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.nutritionLogSaveError)),
        );
      }
    }
  }

  Future<void> _deleteEntry(MealEntry entry) async {
    try {
      await _mealLogRepository.delete(entry.id);
      if (mounted) {
        setState(() {
          _entries = _entries.where((item) => item.id != entry.id).toList();
        });
      }
    } on Object {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.nutritionLogSaveError)),
        );
      }
    }
  }

  Future<void> _adjustEntry(MealEntry entry) async {
    final servings = await showDialog<double>(
      context: context,
      builder: (_) => _ServingAmountDialog(initialValue: entry.servings),
    );
    if (servings == null || !mounted) return;
    final ratio = servings / entry.servings;
    final updated = MealEntry(
      id: entry.id,
      dateTime: entry.dateTime,
      recipeId: entry.recipeId,
      foodId: entry.foodId,
      servings: servings,
      notes: entry.notes,
      type: entry.type,
      plannedMealId: entry.plannedMealId,
      quantityGrams: entry.quantityGrams == null
          ? null
          : entry.quantityGrams! * ratio,
      nutrientEstimates: Map.unmodifiable({
        for (final item in entry.nutrientEstimates.entries)
          item.key: item.value == null ? null : item.value! * ratio,
      }),
      catalogVersion: entry.catalogVersion,
    );
    try {
      await _mealLogRepository.save(updated);
      if (mounted) {
        setState(() {
          _entries = _entries
              .map((item) => item.id == updated.id ? updated : item)
              .toList();
        });
      }
    } on Object {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.nutritionLogSaveError)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.nutritionHubTitle),
        actions: [
          IconButton(
            tooltip: l10n.nutritionEditPreferences,
            onPressed: _editProfile,
            icon: const Icon(Icons.tune_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: _showingHistory
            ? Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () => setState(() => _showingHistory = false),
                      icon: const Icon(Icons.arrow_back_rounded),
                      label: Text(l10n.nutritionBackToPlan),
                    ),
                  ),
                  Expanded(
                    child: _HistoryTab(
                      entries: _entries,
                      catalog: _catalog,
                      onAdjust: _adjustEntry,
                      onDelete: _deleteEntry,
                    ),
                  ),
                ],
              )
            : _loading
            ? const Center(child: CircularProgressIndicator())
            : _failed
            ? _ErrorState(onRetry: _load)
            : _profile == null
            ? _WelcomeState(
                onConfigure: _editProfile,
                onAddFood: _addFood,
                onHistory: () => setState(() => _showingHistory = true),
                hydrationRepository: _hydrationRepository,
              )
            : _buildPlan(context),
      ),
    );
  }

  Widget _buildPlan(BuildContext context) {
    final l10n = context.l10n;
    final plan = _plan;
    if (plan == null) {
      return _NoSafePlan(
        onEdit: _editProfile,
        onAddFood: _addFood,
        onHistory: () => setState(() => _showingHistory = true),
        hydrationRepository: _hydrationRepository,
      );
    }
    final tabIndex = widget.initialTab.clamp(0, 4).toInt();
    final today = DateTime.now();
    final day = plan.days.firstWhere(
      (item) =>
          item.date.year == today.year &&
          item.date.month == today.month &&
          item.date.day == today.day,
      orElse: () => plan.days.first,
    );
    return DefaultTabController(
      length: 5,
      initialIndex: tabIndex,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.x4,
              AppSpacing.x2,
              AppSpacing.x4,
              AppSpacing.x2,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.nutritionWeekSummary,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  l10n.nutritionEstimatesNote,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (_catalog?.scope.regionalAccess.isNotEmpty == true) ...[
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    l10n.nutritionGeneralCatalogNote,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ],
            ),
          ),
          TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: l10n.nutritionTabToday),
              Tab(text: l10n.nutritionTabWeek),
              Tab(text: l10n.nutritionTabRecipes),
              Tab(text: l10n.nutritionTabShopping),
              Tab(text: l10n.nutritionTabHistory),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _TodayTab(
                  day: day,
                  catalog: _catalog!,
                  entries: _entries,
                  onToggleConsumed: _togglePlannedMeal,
                  onAdjustEntry: _adjustEntry,
                  onDeleteEntry: _deleteEntry,
                  onAddFood: _addFood,
                  hydrationRepository: _hydrationRepository,
                ),
                _WeekTab(plan: plan, catalog: _catalog!),
                _RecipesTab(plan: plan, catalog: _catalog!),
                _ShoppingTab(plan: plan, catalog: _catalog!),
                _HistoryTab(
                  entries: _entries,
                  catalog: _catalog!,
                  onAdjust: _adjustEntry,
                  onDelete: _deleteEntry,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WelcomeState extends StatelessWidget {
  const _WelcomeState({
    required this.onConfigure,
    required this.onAddFood,
    required this.onHistory,
    required this.hydrationRepository,
  });

  final VoidCallback onConfigure;
  final VoidCallback onAddFood;
  final VoidCallback onHistory;
  final HydrationRepository hydrationRepository;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.x6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.restaurant_menu_outlined, size: 40),
            const SizedBox(height: AppSpacing.x4),
            Text(
              l10n.nutritionWelcomeTitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.x2),
            Text(
              l10n.nutritionWelcomeDescription,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.x3),
            _HydrationPanel(repository: hydrationRepository),
            const SizedBox(height: AppSpacing.x4),
            FilledButton(
              onPressed: onConfigure,
              child: Text(l10n.nutritionConfigureProfile),
            ),
            const SizedBox(height: AppSpacing.x2),
            OutlinedButton.icon(
              onPressed: onAddFood,
              icon: const Icon(Icons.add_rounded),
              label: Text(l10n.nutritionLogAddFood),
            ),
            TextButton(
              onPressed: onHistory,
              child: Text(l10n.nutritionTabHistory),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(context.l10n.nutritionLoadError, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.x3),
          OutlinedButton(
            onPressed: onRetry,
            child: Text(context.l10n.exerciseRetry),
          ),
        ],
      ),
    ),
  );
}

class _NoSafePlan extends StatelessWidget {
  const _NoSafePlan({
    required this.onEdit,
    required this.onAddFood,
    required this.onHistory,
    required this.hydrationRepository,
  });

  final VoidCallback onEdit;
  final VoidCallback onAddFood;
  final VoidCallback onHistory;
  final HydrationRepository hydrationRepository;

  @override
  Widget build(BuildContext context) => Center(
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.info_outline_rounded, size: 32),
          const SizedBox(height: AppSpacing.x3),
          Text(
            context.l10n.nutritionNoSafeRecipes,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            context.l10n.nutritionAllergenUnknownNote,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.x3),
          _HydrationPanel(repository: hydrationRepository),
          const SizedBox(height: AppSpacing.x3),
          OutlinedButton(
            onPressed: onEdit,
            child: Text(context.l10n.nutritionEditPreferences),
          ),
          const SizedBox(height: AppSpacing.x2),
          OutlinedButton.icon(
            onPressed: onAddFood,
            icon: const Icon(Icons.add_rounded),
            label: Text(context.l10n.nutritionLogAddFood),
          ),
          TextButton(
            onPressed: onHistory,
            child: Text(context.l10n.nutritionTabHistory),
          ),
        ],
      ),
    ),
  );
}

class _TodayTab extends StatelessWidget {
  const _TodayTab({
    required this.day,
    required this.catalog,
    required this.entries,
    required this.onToggleConsumed,
    required this.onAdjustEntry,
    required this.onDeleteEntry,
    required this.onAddFood,
    required this.hydrationRepository,
  });

  final MealPlanDay day;
  final NutritionCatalog catalog;
  final List<MealEntry> entries;
  final Future<void> Function(PlannedMeal meal, bool consumed) onToggleConsumed;
  final ValueChanged<MealEntry> onAdjustEntry;
  final ValueChanged<MealEntry> onDeleteEntry;
  final VoidCallback onAddFood;
  final HydrationRepository hydrationRepository;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final manualEntries = entries.where((entry) {
      final local = entry.dateTime.toLocal();
      return entry.type != MealEntryType.consumedPlanned &&
          local.year == today.year &&
          local.month == today.month &&
          local.day == today.day;
    }).toList();
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.x4),
      children: [
        _HydrationPanel(repository: hydrationRepository),
        const SizedBox(height: AppSpacing.x3),
        Align(
          alignment: Alignment.centerLeft,
          child: OutlinedButton.icon(
            onPressed: onAddFood,
            icon: const Icon(Icons.add_rounded),
            label: Text(context.l10n.nutritionLogAddFood),
          ),
        ),
        const SizedBox(height: AppSpacing.x3),
        if (day.meals.isEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.x2),
            child: Text(context.l10n.nutritionNoMealsToday),
          ),
        if (day.meals.isNotEmpty)
          Text(
            day.isTrainingDay
                ? context.l10n.nutritionTrainingDay
                : context.l10n.nutritionRestDay,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        if (day.meals.isNotEmpty) const SizedBox(height: AppSpacing.x2),
        for (var index = 0; index < day.meals.length; index++) ...[
          _MealCard(
            meal: day.meals[index],
            catalog: catalog,
            consumed: entries.any(
              (entry) =>
                  entry.type == MealEntryType.consumedPlanned &&
                  entry.plannedMealId == day.meals[index].id,
            ),
            onConsumedChanged: (value) =>
                onToggleConsumed(day.meals[index], value),
            onAdjust:
                entries
                        .where(
                          (entry) =>
                              entry.type == MealEntryType.consumedPlanned &&
                              entry.plannedMealId == day.meals[index].id,
                        )
                        .firstOrNull ==
                    null
                ? null
                : () => onAdjustEntry(
                    entries.firstWhere(
                      (entry) =>
                          entry.type == MealEntryType.consumedPlanned &&
                          entry.plannedMealId == day.meals[index].id,
                    ),
                  ),
          ),
          if (index != day.meals.length - 1)
            const SizedBox(height: AppSpacing.x2),
        ],
        if (manualEntries.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.x4),
          Text(
            context.l10n.nutritionLoggedItems,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          for (final entry in manualEntries)
            _EntryTile(
              entry: entry,
              catalog: catalog,
              onAdjust: () => onAdjustEntry(entry),
              onDelete: () => onDeleteEntry(entry),
            ),
        ],
      ],
    );
  }
}

class _HydrationPanel extends StatefulWidget {
  const _HydrationPanel({required this.repository});
  final HydrationRepository repository;
  @override
  State<_HydrationPanel> createState() => _HydrationPanelState();
}

class _HydrationPanelState extends State<_HydrationPanel> {
  List<HydrationEntry> _entries = const [];
  HydrationPreferences _preferences = const HydrationPreferences();
  bool _loading = true;
  bool _busy = false;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await widget.repository.load();
      if (!mounted) return;
      setState(() {
        _entries = data.entries;
        _preferences = data.preferences;
        _loading = false;
        _failed = false;
      });
    } on Object {
      if (mounted) {
        setState(() {
          _loading = false;
          _failed = true;
        });
      }
    }
  }

  Future<void> _add(
    int amount, {
    HydrationDrinkType drinkType = HydrationDrinkType.water,
  }) async {
    if (_busy) return;
    setState(() => _busy = true);
    final now = DateTime.now();
    final entry = HydrationEntry(
      id: 'water:${now.microsecondsSinceEpoch}',
      loggedAt: now,
      amountMl: amount,
      drinkType: drinkType,
    );
    try {
      await widget.repository.save(entry);
      if (!mounted) return;
      setState(() {
        _entries = [entry, ..._entries];
        _busy = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.l10n.hydrationAdded(
              _formatWater(
                amount,
                Localizations.localeOf(context).languageCode,
              ),
            ),
          ),
          action: SnackBarAction(
            label: context.l10n.commonUndo,
            onPressed: () async {
              await widget.repository.delete(entry.id);
              if (mounted) {
                setState(
                  () => _entries = _entries
                      .where((item) => item.id != entry.id)
                      .toList(),
                );
              }
            },
          ),
        ),
      );
    } on Object {
      if (mounted) {
        setState(() => _busy = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.hydrationSaveError)),
        );
      }
    }
  }

  Future<void> _manual() async {
    final value =
        await showDialog<({int amountMl, HydrationDrinkType drinkType})>(
          context: context,
          builder: (_) => const _HydrationAmountDialog(),
        );
    if (value != null && mounted) {
      await _add(value.amountMl, drinkType: value.drinkType);
    }
  }

  Future<void> _edit(HydrationEntry entry) async {
    final updated = await showDialog<HydrationEntry>(
      context: context,
      builder: (_) => _HydrationEditDialog(entry: entry),
    );
    if (updated == null || !mounted) return;
    try {
      await widget.repository.save(updated);
      if (mounted) {
        setState(() {
          _entries =
              _entries
                  .map((item) => item.id == entry.id ? updated : item)
                  .toList()
                ..sort((a, b) => b.loggedAt.compareTo(a.loggedAt));
        });
      }
    } on Object {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.hydrationSaveError)),
        );
      }
    }
  }

  Future<void> _delete(HydrationEntry entry) async {
    try {
      await widget.repository.delete(entry.id);
      if (!mounted) return;
      setState(
        () => _entries = _entries.where((item) => item.id != entry.id).toList(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.hydrationDeleted),
          action: SnackBarAction(
            label: context.l10n.commonUndo,
            onPressed: () async {
              await widget.repository.save(entry);
              if (mounted) {
                setState(
                  () =>
                      _entries = [entry, ..._entries]
                        ..sort((a, b) => b.loggedAt.compareTo(a.loggedAt)),
                );
              }
            },
          ),
        ),
      );
    } on Object {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.hydrationSaveError)),
        );
      }
    }
  }

  Future<void> _editPreferences() async {
    final value = await showDialog<HydrationPreferences>(
      context: context,
      builder: (_) => _HydrationPreferencesDialog(initial: _preferences),
    );
    if (value == null || !mounted) return;
    try {
      await widget.repository.savePreferences(value);
      if (mounted) setState(() => _preferences = value);
    } on Object {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.hydrationSaveError)),
        );
      }
    }
  }

  Future<void> _history() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: SizedBox(
            height: MediaQuery.sizeOf(sheetContext).height * .72,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  context.l10n.hydrationHistory,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppSpacing.x2),
                Expanded(
                  child: _entries.isEmpty
                      ? Center(child: Text(context.l10n.hydrationEmpty))
                      : ListView.builder(
                          itemCount: _entries.length,
                          itemBuilder: (context, index) {
                            final entry = _entries[index];
                            final date = MaterialLocalizations.of(context)
                                .formatMediumDate(entry.loggedAt.toLocal());
                            final time = MaterialLocalizations.of(context)
                                .formatTimeOfDay(
                                  TimeOfDay.fromDateTime(
                                    entry.loggedAt.toLocal(),
                                  ),
                                );
                            final drinkName =
                                entry.drinkType == HydrationDrinkType.water
                                ? context.l10n.hydrationWater
                                : context.l10n.hydrationOtherBeverage;
                            return ListTile(
                              title: Text(
                                _formatWater(
                                  entry.amountMl,
                                  Localizations.localeOf(context).languageCode,
                                ),
                              ),
                              subtitle: Text('$drinkName · $date · $time'),
                              trailing: Wrap(
                                spacing: 0,
                                children: [
                                  IconButton(
                                    tooltip: context.l10n.commonEdit,
                                    onPressed: () {
                                      Navigator.pop(sheetContext);
                                      _edit(entry);
                                    },
                                    icon: const Icon(Icons.edit_outlined),
                                  ),
                                  IconButton(
                                    tooltip: context.l10n.commonDelete,
                                    onPressed: () {
                                      Navigator.pop(sheetContext);
                                      _delete(entry);
                                    },
                                    icon: const Icon(Icons.delete_outline),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const LinearProgressIndicator();
    if (_failed) {
      return OutlinedButton.icon(
        onPressed: _load,
        icon: const Icon(Icons.refresh),
        label: Text(context.l10n.hydrationLoadError),
      );
    }
    final today = DateTime.now();
    final todayEntries = _entries.where((entry) {
      final date = entry.loggedAt.toLocal();
      return date.year == today.year &&
          date.month == today.month &&
          date.day == today.day;
    }).toList();
    final total = todayEntries.fold<int>(
      0,
      (sum, entry) => sum + entry.amountMl,
    );
    final goal = _preferences.dailyGoalMl;
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(Icons.water_drop_outlined),
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: Text(
                    context.l10n.hydrationTitle,
                    style: theme.textTheme.titleSmall,
                  ),
                ),
                IconButton(
                  tooltip: context.l10n.hydrationPreferences,
                  onPressed: _editPreferences,
                  icon: const Icon(Icons.tune_rounded),
                ),
                IconButton(
                  tooltip: context.l10n.hydrationHistory,
                  onPressed: _history,
                  icon: const Icon(Icons.history_rounded),
                ),
              ],
            ),
            if (todayEntries.isEmpty)
              Text(
                context.l10n.hydrationEmpty,
                style: theme.textTheme.bodySmall,
              )
            else
              Text(
                context.l10n.hydrationTodayTotal(
                  _formatWater(
                    total,
                    Localizations.localeOf(context).languageCode,
                  ),
                ),
                style: theme.textTheme.bodyMedium,
              ),
            if (goal != null && _preferences.showIndicator) ...[
              const SizedBox(height: AppSpacing.x2),
              Semantics(
                label: context.l10n.hydrationProgress(
                  _formatWater(
                    total,
                    Localizations.localeOf(context).languageCode,
                  ),
                  _formatWater(
                    goal,
                    Localizations.localeOf(context).languageCode,
                  ),
                ),
                child: LinearProgressIndicator(
                  value: (total / goal).clamp(0, 1),
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.x2),
            Wrap(
              spacing: AppSpacing.x2,
              runSpacing: AppSpacing.x1,
              children: [
                OutlinedButton(
                  onPressed: _busy ? null : () => _add(_preferences.glassMl),
                  child: Text(
                    '${context.l10n.hydrationGlass} · ${_formatWater(_preferences.glassMl, Localizations.localeOf(context).languageCode)}',
                  ),
                ),
                OutlinedButton(
                  onPressed: _busy ? null : () => _add(_preferences.bottleMl),
                  child: Text(
                    '${context.l10n.hydrationBottle} · ${_formatWater(_preferences.bottleMl, Localizations.localeOf(context).languageCode)}',
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: _busy ? null : _manual,
                  icon: const Icon(Icons.add_rounded),
                  label: Text(context.l10n.hydrationManual),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HydrationAmountDialog extends StatefulWidget {
  const _HydrationAmountDialog();
  @override
  State<_HydrationAmountDialog> createState() => _HydrationAmountDialogState();
}

class _HydrationAmountDialogState extends State<_HydrationAmountDialog> {
  final _controller = TextEditingController();
  HydrationDrinkType _drinkType = HydrationDrinkType.water;
  bool _invalid = false;
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(context.l10n.hydrationManual),
    content: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<HydrationDrinkType>(
            initialValue: _drinkType,
            decoration: InputDecoration(
              labelText: context.l10n.hydrationDrinkType,
            ),
            items: [
              DropdownMenuItem(
                value: HydrationDrinkType.water,
                child: Text(context.l10n.hydrationWater),
              ),
              DropdownMenuItem(
                value: HydrationDrinkType.otherBeverage,
                child: Text(context.l10n.hydrationOtherBeverage),
              ),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _drinkType = value);
            },
          ),
          TextField(
            controller: _controller,
            autofocus: true,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: context.l10n.hydrationAmount,
              suffixText: 'ml',
              errorText: _invalid ? context.l10n.hydrationInvalidAmount : null,
            ),
            onChanged: (_) {
              if (_invalid) setState(() => _invalid = false);
            },
          ),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(context.l10n.commonCancel),
      ),
      FilledButton(
        onPressed: () {
          final value = int.tryParse(_controller.text.trim());
          if (value == null || value < 1 || value > 10000) {
            setState(() => _invalid = true);
            return;
          }
          Navigator.pop(context, (amountMl: value, drinkType: _drinkType));
        },
        child: Text(context.l10n.commonSave),
      ),
    ],
  );
}

class _HydrationEditDialog extends StatefulWidget {
  const _HydrationEditDialog({required this.entry});
  final HydrationEntry entry;
  @override
  State<_HydrationEditDialog> createState() => _HydrationEditDialogState();
}

class _HydrationEditDialogState extends State<_HydrationEditDialog> {
  late final _controller = TextEditingController(
    text: widget.entry.amountMl.toString(),
  );
  late DateTime _date = widget.entry.loggedAt.toLocal();
  late HydrationDrinkType _drinkType = widget.entry.drinkType;
  bool _invalid = false;
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(context.l10n.hydrationEdit),
    content: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<HydrationDrinkType>(
            initialValue: _drinkType,
            decoration: InputDecoration(
              labelText: context.l10n.hydrationDrinkType,
            ),
            items: [
              DropdownMenuItem(
                value: HydrationDrinkType.water,
                child: Text(context.l10n.hydrationWater),
              ),
              DropdownMenuItem(
                value: HydrationDrinkType.otherBeverage,
                child: Text(context.l10n.hydrationOtherBeverage),
              ),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _drinkType = value);
            },
          ),
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: context.l10n.hydrationAmount,
              suffixText: 'ml',
              errorText: _invalid ? context.l10n.hydrationInvalidAmount : null,
            ),
            onChanged: (_) {
              if (_invalid) setState(() => _invalid = false);
            },
          ),
          TextButton.icon(
            onPressed: () async {
              final chosen = await showDatePicker(
                context: context,
                initialDate: _date,
                firstDate: DateTime(2000),
                lastDate: DateTime.now().add(const Duration(days: 1)),
              );
              if (chosen != null) {
                setState(
                  () => _date = DateTime(
                    chosen.year,
                    chosen.month,
                    chosen.day,
                    _date.hour,
                    _date.minute,
                  ),
                );
              }
            },
            icon: const Icon(Icons.calendar_today_outlined),
            label: Text(
              MaterialLocalizations.of(context).formatMediumDate(_date),
            ),
          ),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(context.l10n.commonCancel),
      ),
      FilledButton(
        onPressed: () {
          final value = int.tryParse(_controller.text.trim());
          if (value == null || value < 1 || value > 10000) {
            setState(() => _invalid = true);
            return;
          }
          Navigator.pop(
            context,
            HydrationEntry(
              id: widget.entry.id,
              loggedAt: _date,
              amountMl: value,
              drinkType: _drinkType,
            ),
          );
        },
        child: Text(context.l10n.commonSave),
      ),
    ],
  );
}

class _HydrationPreferencesDialog extends StatefulWidget {
  const _HydrationPreferencesDialog({required this.initial});
  final HydrationPreferences initial;
  @override
  State<_HydrationPreferencesDialog> createState() =>
      _HydrationPreferencesDialogState();
}

class _HydrationPreferencesDialogState
    extends State<_HydrationPreferencesDialog> {
  late final _glass = TextEditingController(
    text: widget.initial.glassMl.toString(),
  );
  late final _bottle = TextEditingController(
    text: widget.initial.bottleMl.toString(),
  );
  late final _goal = TextEditingController(
    text: widget.initial.dailyGoalMl?.toString() ?? '',
  );
  late bool _show = widget.initial.showIndicator;
  bool _invalid = false;
  @override
  void dispose() {
    _glass.dispose();
    _bottle.dispose();
    _goal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(context.l10n.hydrationPreferences),
    content: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final item in [
            (context.l10n.hydrationGlass, _glass),
            (context.l10n.hydrationBottle, _bottle),
            (context.l10n.hydrationGoalOptional, _goal),
          ])
            TextField(
              controller: item.$2,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: item.$1,
                suffixText: 'ml',
                errorText: _invalid
                    ? context.l10n.hydrationInvalidAmount
                    : null,
              ),
            ),
          CheckboxListTile(
            value: _show,
            onChanged: (value) => setState(() => _show = value ?? true),
            title: Text(context.l10n.hydrationShowIndicator),
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(context.l10n.commonCancel),
      ),
      FilledButton(
        onPressed: () {
          final glass = int.tryParse(_glass.text);
          final bottle = int.tryParse(_bottle.text);
          final goalText = _goal.text.trim();
          final goal = goalText.isEmpty ? null : int.tryParse(goalText);
          final prefs = HydrationPreferences(
            glassMl: glass ?? 0,
            bottleMl: bottle ?? 0,
            dailyGoalMl: goal,
            showIndicator: _show,
          );
          if ((goalText.isNotEmpty && goal == null) || !prefs.isValid) {
            setState(() => _invalid = true);
            return;
          }
          Navigator.pop(context, prefs);
        },
        child: Text(context.l10n.commonSave),
      ),
    ],
  );
}

String _formatWater(int ml, String locale) {
  if (ml < 1000) return '$ml ml';
  final liters = ml / 1000;
  var value = liters == liters.roundToDouble()
      ? liters.toStringAsFixed(0)
      : liters
            .toStringAsFixed(2)
            .replaceFirst(RegExp(r'0+$'), '')
            .replaceFirst(RegExp(r'\.$'), '');
  if (locale == 'es') value = value.replaceFirst('.', ',');
  return '$value L';
}

class _WeekTab extends StatelessWidget {
  const _WeekTab({required this.plan, required this.catalog});

  final NutritionWeekPlan plan;
  final NutritionCatalog catalog;

  @override
  Widget build(BuildContext context) => ListView.builder(
    padding: const EdgeInsets.all(AppSpacing.x4),
    itemCount: plan.days.length,
    itemBuilder: (context, index) {
      final day = plan.days[index];
      final date = MaterialLocalizations.of(context).formatMediumDate(day.date);
      return Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.x3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$date · ${day.isTrainingDay ? context.l10n.nutritionTrainingDay : context.l10n.nutritionRestDay}',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: AppSpacing.x2),
            for (final meal in day.meals)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.x2),
                child: _MealCard(meal: meal, catalog: catalog),
              ),
          ],
        ),
      );
    },
  );
}

class _RecipesTab extends StatelessWidget {
  const _RecipesTab({required this.plan, required this.catalog});

  final NutritionWeekPlan plan;
  final NutritionCatalog catalog;

  @override
  Widget build(BuildContext context) {
    final recipes = <String, PlannedMeal>{};
    for (final meal in plan.days.expand((day) => day.meals)) {
      recipes.putIfAbsent(meal.recipeId, () => meal);
    }
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.x4),
      children: [
        for (final meal in recipes.values)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.x2),
            child: AppSurfaceCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _localizedRecipe(context, meal),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.x2),
                  for (final ingredient in meal.ingredients)
                    Text(
                      '${_foodName(context, ingredient.foodId, catalog)} · ${_formatGrams(ingredient.grams)} g',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _HistoryTab extends StatelessWidget {
  const _HistoryTab({
    required this.entries,
    required this.catalog,
    required this.onAdjust,
    required this.onDelete,
  });

  final List<MealEntry> entries;
  final NutritionCatalog? catalog;
  final ValueChanged<MealEntry> onAdjust;
  final ValueChanged<MealEntry> onDelete;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Text(
            context.l10n.nutritionHistoryEmpty,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    final grouped = <DateTime, List<MealEntry>>{};
    for (final entry in entries) {
      final date = entry.dateTime.toLocal();
      grouped
          .putIfAbsent(DateTime(date.year, date.month, date.day), () => [])
          .add(entry);
    }
    final dates = grouped.keys.toList()..sort((a, b) => b.compareTo(a));
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.x4),
      children: [
        for (final date in dates) ...[
          Text(
            MaterialLocalizations.of(context).formatMediumDate(date),
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: AppSpacing.x1),
          for (final entry in grouped[date]!)
            _EntryTile(
              entry: entry,
              catalog: catalog,
              onAdjust: () => onAdjust(entry),
              onDelete: () => onDelete(entry),
            ),
          const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _EntryTile extends StatelessWidget {
  const _EntryTile({
    required this.entry,
    required this.catalog,
    required this.onAdjust,
    required this.onDelete,
  });

  final MealEntry entry;
  final NutritionCatalog? catalog;
  final VoidCallback onAdjust;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final time = MaterialLocalizations.of(context)
        .formatTimeOfDay(TimeOfDay.fromDateTime(entry.dateTime.toLocal()));
    final quantity = entry.quantityGrams == null
        ? null
        : '${_formatGrams(entry.quantityGrams!)} g';
    return ListTile(
      minTileHeight: 64,
      contentPadding: EdgeInsets.zero,
      title: Text(_entryName(context, entry, catalog)),
      subtitle: Text(
        [
          time,
          ...?(quantity == null ? null : [quantity]),
          if (entry.type == MealEntryType.consumedPlanned)
            context.l10n.nutritionLoggedFromPlan
          else
            context.l10n.nutritionLoggedManually,
        ].join(' · '),
      ),
      trailing: Wrap(
        children: [
          IconButton(
            tooltip: context.l10n.nutritionLogAdjust,
            onPressed: onAdjust,
            icon: const Icon(Icons.edit_outlined),
          ),
          IconButton(
            tooltip: context.l10n.nutritionLogDelete,
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline_rounded),
          ),
        ],
      ),
    );
  }
}

String _entryName(
  BuildContext context,
  MealEntry entry,
  NutritionCatalog? catalog,
) {
  final language = Localizations.localeOf(context).languageCode;
  if (entry.foodId != null && catalog != null) {
    final food = catalog.foods
        .where((item) => item.id == entry.foodId)
        .firstOrNull;
    if (food != null) return language == 'es' ? food.nameEs : food.name;
  }
  if (entry.recipeId != null && catalog != null) {
    final recipe = catalog.recipes
        .where((item) => item.id == entry.recipeId)
        .firstOrNull;
    if (recipe != null) {
      return language == 'es' ? recipe.titleEs : recipe.titleEn;
    }
  }
  return entry.foodId ?? entry.recipeId ?? entry.id;
}

class _ShoppingTab extends StatelessWidget {
  const _ShoppingTab({required this.plan, required this.catalog});

  final NutritionWeekPlan plan;
  final NutritionCatalog catalog;

  @override
  Widget build(BuildContext context) {
    if (plan.shoppingList.isEmpty) {
      return Center(child: Text(context.l10n.nutritionShoppingEmpty));
    }
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.x4),
      children: [
        for (final item in plan.shoppingList)
          ListTile(
            minTileHeight: 48,
            contentPadding: EdgeInsets.zero,
            title: Text(_foodName(context, item.foodId, catalog)),
            trailing: Text('${_formatGrams(item.grams)} g'),
          ),
      ],
    );
  }
}

class _MealCard extends StatelessWidget {
  const _MealCard({
    required this.meal,
    required this.catalog,
    this.consumed = false,
    this.onConsumedChanged,
    this.onAdjust,
  });

  final PlannedMeal meal;
  final NutritionCatalog catalog;
  final bool consumed;
  final ValueChanged<bool>? onConsumedChanged;
  final VoidCallback? onAdjust;

  @override
  Widget build(BuildContext context) {
    final energy = meal.nutrients['energyKcal'];
    return AppSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _localizedRecipe(context, meal),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          if (energy != null) ...[
            const SizedBox(height: AppSpacing.x1),
            Text(
              context.l10n.nutritionRecipeEstimate(energy.round()),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
          const SizedBox(height: AppSpacing.x2),
          for (final ingredient in meal.ingredients)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.x1),
              child: Text(
                '${_foodName(context, ingredient.foodId, catalog)} · ${_formatGrams(ingredient.grams)} g',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          if (onConsumedChanged != null) ...[
            const SizedBox(height: AppSpacing.x2),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              minTileHeight: 48,
              value: consumed,
              onChanged: (value) => onConsumedChanged!(value ?? false),
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(
                consumed
                    ? context.l10n.nutritionLogUndo
                    : context.l10n.nutritionLogMarkConsumed,
              ),
            ),
            if (consumed && onAdjust != null)
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: onAdjust,
                  icon: const Icon(Icons.edit_outlined),
                  label: Text(context.l10n.nutritionLogAdjust),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _FoodPickerSheet extends StatefulWidget {
  const _FoodPickerSheet({required this.foods});

  final List<NutritionCatalogFood> foods;

  @override
  State<_FoodPickerSheet> createState() => _FoodPickerSheetState();
}

class _FoodPickerSheetState extends State<_FoodPickerSheet> {
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _search.text.trim().toLowerCase();
    final foods = widget.foods
        .where((food) {
          if (query.isEmpty) return true;
          return [
            food.name,
            food.nameEs,
            ...food.aliases,
          ].any((name) => name.toLowerCase().contains(query));
        })
        .toList(growable: false);
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.x4,
          AppSpacing.x3,
          AppSpacing.x4,
          MediaQuery.viewInsetsOf(context).bottom + AppSpacing.x4,
        ),
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.72,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.nutritionLogAddFood,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.x2),
              TextField(
                controller: _search,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  labelText: context.l10n.nutritionFoodSearchLabel,
                  prefixIcon: const Icon(Icons.search_rounded),
                ),
              ),
              const SizedBox(height: AppSpacing.x2),
              Expanded(
                child: foods.isEmpty
                    ? Center(child: Text(context.l10n.nutritionFoodSearchEmpty))
                    : ListView.builder(
                        itemCount: foods.length,
                        itemBuilder: (context, index) {
                          final food = foods[index];
                          final spanish =
                              Localizations.localeOf(context).languageCode ==
                              'es';
                          return ListTile(
                            minTileHeight: 52,
                            title: Text(spanish ? food.nameEs : food.name),
                            onTap: () => Navigator.of(context).pop(food.id),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FoodAmountDialog extends StatefulWidget {
  const _FoodAmountDialog();

  @override
  State<_FoodAmountDialog> createState() => _FoodAmountDialogState();
}

class _FoodAmountDialogState extends State<_FoodAmountDialog> {
  final _amount = TextEditingController();
  bool _invalid = false;

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(context.l10n.nutritionLogAddFood),
    content: TextField(
      controller: _amount,
      autofocus: true,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: context.l10n.nutritionLogGrams,
        suffixText: 'g',
        errorText: _invalid ? context.l10n.nutritionLogInvalidGrams : null,
      ),
      onChanged: (_) {
        if (_invalid) setState(() => _invalid = false);
      },
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: Text(context.l10n.commonCancel),
      ),
      FilledButton(
        onPressed: () {
          final amount = double.tryParse(
            _amount.text.trim().replaceAll(',', '.'),
          );
          if (amount == null ||
              !amount.isFinite ||
              amount <= 0 ||
              amount > 10000) {
            setState(() => _invalid = true);
            return;
          }
          Navigator.of(context).pop(amount);
        },
        child: Text(context.l10n.commonSave),
      ),
    ],
  );
}

class _ServingAmountDialog extends StatefulWidget {
  const _ServingAmountDialog({required this.initialValue});

  final double initialValue;

  @override
  State<_ServingAmountDialog> createState() => _ServingAmountDialogState();
}

class _ServingAmountDialogState extends State<_ServingAmountDialog> {
  late final _amount = TextEditingController(
    text: _formatGrams(widget.initialValue),
  );
  bool _invalid = false;

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(context.l10n.nutritionLogAdjust),
    content: TextField(
      controller: _amount,
      autofocus: true,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: context.l10n.nutritionLogPortions,
        errorText: _invalid ? context.l10n.nutritionLogInvalidPortions : null,
      ),
      onChanged: (_) {
        if (_invalid) setState(() => _invalid = false);
      },
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: Text(context.l10n.commonCancel),
      ),
      FilledButton(
        onPressed: () {
          final amount = double.tryParse(
            _amount.text.trim().replaceAll(',', '.'),
          );
          if (amount == null ||
              !amount.isFinite ||
              amount <= 0 ||
              amount > 10) {
            setState(() => _invalid = true);
            return;
          }
          Navigator.of(context).pop(amount);
        },
        child: Text(context.l10n.commonSave),
      ),
    ],
  );
}

String _localizedRecipe(BuildContext context, PlannedMeal meal) =>
    Localizations.localeOf(context).languageCode == 'es'
    ? meal.titleEs
    : meal.titleEn;

String _foodName(BuildContext context, String id, NutritionCatalog? catalog) {
  if (catalog == null) return id;
  for (final food in catalog.foods) {
    if (food.id == id) {
      return Localizations.localeOf(context).languageCode == 'es'
          ? food.nameEs
          : food.name;
    }
  }
  return id;
}

String _formatGrams(double value) => value == value.roundToDouble()
    ? value.toStringAsFixed(0)
    : value.toStringAsFixed(1);

String _dateKey(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
