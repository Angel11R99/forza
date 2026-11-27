import 'package:material_ui/material_ui.dart';

import '../../../../app/localization/localization_extensions.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../data/repositories/nutrition_catalog_repository.dart';
import '../../../../data/repositories/profile_settings_repository.dart';
import '../../../../domain/models/nutrition/nutrition_catalog.dart';
import '../../../../domain/models/nutrition/nutrition_models.dart';
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
    this.initialTab = 0,
  });

  final ProfileSettingsRepository profileRepository;
  final TrainingSettings trainingSettings;
  final NutritionCatalogRepository? catalogRepository;
  final int initialTab;

  @override
  State<NutritionHomePage> createState() => _NutritionHomePageState();
}

class _NutritionHomePageState extends State<NutritionHomePage> {
  late final _catalogRepository =
      widget.catalogRepository ?? NutritionCatalogRepository();
  NutritionProfile? _profile;
  NutritionCatalog? _catalog;
  NutritionWeekPlan? _plan;
  bool _loading = true;
  bool _failed = false;

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
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _failed
            ? _ErrorState(onRetry: _load)
            : _profile == null
            ? _WelcomeState(onConfigure: _editProfile)
            : _buildPlan(context),
      ),
    );
  }

  Widget _buildPlan(BuildContext context) {
    final l10n = context.l10n;
    final plan = _plan;
    if (plan == null) {
      return _NoSafePlan(onEdit: _editProfile);
    }
    final tabIndex = widget.initialTab.clamp(0, 3).toInt();
    final today = DateTime.now();
    final day = plan.days.firstWhere(
      (item) =>
          item.date.year == today.year &&
          item.date.month == today.month &&
          item.date.day == today.day,
      orElse: () => plan.days.first,
    );
    return DefaultTabController(
      length: 4,
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
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _TodayTab(day: day, catalog: _catalog!),
                _WeekTab(plan: plan, catalog: _catalog!),
                _RecipesTab(plan: plan, catalog: _catalog!),
                _ShoppingTab(plan: plan, catalog: _catalog!),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WelcomeState extends StatelessWidget {
  const _WelcomeState({required this.onConfigure});

  final VoidCallback onConfigure;

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
            const SizedBox(height: AppSpacing.x4),
            FilledButton(
              onPressed: onConfigure,
              child: Text(l10n.nutritionConfigureProfile),
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
  const _NoSafePlan({required this.onEdit});

  final VoidCallback onEdit;

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
          OutlinedButton(
            onPressed: onEdit,
            child: Text(context.l10n.nutritionEditPreferences),
          ),
        ],
      ),
    ),
  );
}

class _TodayTab extends StatelessWidget {
  const _TodayTab({required this.day, required this.catalog});

  final MealPlanDay day;
  final NutritionCatalog catalog;

  @override
  Widget build(BuildContext context) {
    if (day.meals.isEmpty) {
      return Center(child: Text(context.l10n.nutritionNoMealsToday));
    }
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.x4),
      children: [
        Text(
          day.isTrainingDay
              ? context.l10n.nutritionTrainingDay
              : context.l10n.nutritionRestDay,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: AppSpacing.x2),
        for (var index = 0; index < day.meals.length; index++) ...[
          _MealCard(meal: day.meals[index], catalog: catalog),
          if (index != day.meals.length - 1)
            const SizedBox(height: AppSpacing.x2),
        ],
      ],
    );
  }
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
  const _MealCard({required this.meal, required this.catalog});

  final PlannedMeal meal;
  final NutritionCatalog catalog;

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
        ],
      ),
    );
  }
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
