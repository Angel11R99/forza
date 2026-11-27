import 'package:material_ui/material_ui.dart';

import '../../../../app/localization/localization_extensions.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../data/repositories/nutrition_review_repository.dart';
import '../../../../data/repositories/profile_settings_repository.dart';
import '../../../../domain/models/nutrition/nutrition_catalog.dart';
import '../../../../domain/models/nutrition/nutrition_models.dart';
import '../../../../domain/use_cases/nutrition_week_planner.dart';
import '../../../core/widgets/app_surface_card.dart';
import '../../profile/models/profile_settings.dart';
import '../../profile/views/nutrition_profile_page.dart';

class NutritionReviewPage extends StatefulWidget {
  const NutritionReviewPage({
    super.key,
    required this.repository,
    required this.reviewRepository,
    required this.profile,
    required this.catalog,
    required this.currentPlan,
    required this.trainingSettings,
  });

  final ProfileSettingsRepository repository;
  final NutritionReviewRepository reviewRepository;
  final NutritionProfile profile;
  final NutritionCatalog catalog;
  final NutritionWeekPlan currentPlan;
  final TrainingSettings trainingSettings;

  @override
  State<NutritionReviewPage> createState() => _NutritionReviewPageState();
}

class _NutritionReviewPageState extends State<NutritionReviewPage> {
  static const _questions = <String, List<String>>{
    'energy': ['good', 'mixed', 'low', 'skip'],
    'appetite': ['comfortable', 'varies', 'difficult', 'skip'],
    'recipes': ['easy', 'mostly', 'difficult', 'skip'],
    'access': ['available', 'someMissing', 'hardToFind', 'skip'],
    'recovery': ['good', 'mixed', 'low', 'skip'],
    'performance': ['good', 'mixed', 'low', 'skip'],
  };

  late final Map<String, String> _feedback = {
    for (final key in _questions.keys) key: 'skip',
  };
  NutritionProfile? _proposal;
  NutritionWeekPlan? _preview;
  int? _intervalDays = 14;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadInterval();
  }

  Future<void> _loadInterval() async {
    final record = await widget.reviewRepository.load();
    if (mounted) setState(() => _intervalDays = record.intervalDays);
  }

  Future<void> _setInterval(int value) async {
    final days = value == 0 ? null : value;
    try {
      await widget.reviewRepository.setIntervalDays(days);
      if (mounted) setState(() => _intervalDays = days);
    } on Object {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.nutritionReviewSaveError)),
        );
      }
    }
  }

  Future<void> _editPreferences() async {
    final proposal = await Navigator.of(context).push<NutritionProfile>(
      MaterialPageRoute<NutritionProfile>(
        builder: (_) => NutritionProfilePage(
          repository: widget.repository,
          commitOnSave: false,
        ),
      ),
    );
    if (proposal == null || !mounted) return;
    final today = DateTime.now();
    final weekStart = DateTime(
      today.year,
      today.month,
      today.day,
    ).subtract(Duration(days: today.weekday - 1));
    final generated = const NutritionWeekPlanner().generate(
      catalog: widget.catalog,
      profile: proposal,
      weekStart: weekStart,
      createdAt: today,
      planId:
          'nutrition-${proposal.id}-v${proposal.version}-${weekStart.year}-${weekStart.month}-${weekStart.day}',
      trainingWeekdays: widget.trainingSettings.trainingDays,
    );
    if (!mounted) return;
    setState(() {
      _proposal = proposal;
      _preview = generated.plan;
    });
    if (generated.plan == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.nutritionReviewUnsafePreview)),
      );
    }
  }

  Future<void> _finish({required bool applyProposal}) async {
    if (_saving) return;
    if (applyProposal && (_proposal == null || _preview == null)) return;
    setState(() => _saving = true);
    try {
      var profile = widget.profile;
      if (applyProposal) {
        final proposal = _proposal!;
        await widget.repository.saveNutritionProfile(proposal);
        profile = proposal;
      }
      await widget.reviewRepository.complete(
        profile: profile,
        feedback: _feedback,
      );
      if (mounted) Navigator.of(context).pop(true);
    } on Object {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.nutritionReviewSaveError)),
        );
      }
    }
  }

  int _changedMeals() {
    final preview = _preview;
    if (preview == null) return 0;
    var changed = 0;
    for (var day = 0; day < widget.currentPlan.days.length; day++) {
      final before = widget.currentPlan.days[day].meals;
      final after = preview.days[day].meals;
      final length = before.length > after.length
          ? before.length
          : after.length;
      for (var meal = 0; meal < length; meal++) {
        if (meal >= before.length ||
            meal >= after.length ||
            before[meal].recipeId != after[meal].recipeId) {
          changed++;
        }
      }
    }
    return changed;
  }

  List<String> _changedMealSummaries() {
    final preview = _preview;
    if (preview == null) return const [];
    final spanish = Localizations.localeOf(context).languageCode == 'es';
    final changes = <String>[];
    for (var day = 0; day < widget.currentPlan.days.length; day++) {
      final before = widget.currentPlan.days[day].meals;
      final after = preview.days[day].meals;
      final length = before.length > after.length
          ? before.length
          : after.length;
      for (var meal = 0; meal < length; meal++) {
        final oldMeal = meal < before.length ? before[meal] : null;
        final newMeal = meal < after.length ? after[meal] : null;
        if (oldMeal?.recipeId == newMeal?.recipeId) continue;
        final oldTitle = oldMeal == null
            ? '—'
            : spanish
            ? oldMeal.titleEs
            : oldMeal.titleEn;
        final newTitle = newMeal == null
            ? '—'
            : spanish
            ? newMeal.titleEs
            : newMeal.titleEn;
        changes.add('$oldTitle → $newTitle');
      }
    }
    return changes;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final preview = _preview;
    final proposed = _proposal;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.nutritionReviewTitle),
        actions: [
          PopupMenuButton<int>(
            tooltip: l10n.nutritionReviewCadence,
            initialValue: _intervalDays ?? 0,
            onSelected: _setInterval,
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 14,
                child: Text(l10n.nutritionReviewEveryTwoWeeks),
              ),
              PopupMenuItem(
                value: 28,
                child: Text(l10n.nutritionReviewEveryFourWeeks),
              ),
              PopupMenuItem(
                value: 0,
                child: Text(l10n.nutritionReviewCadenceOff),
              ),
            ],
            icon: const Icon(Icons.more_vert_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.x4),
          children: [
            Text(l10n.nutritionReviewIntro),
            const SizedBox(height: AppSpacing.x1),
            Text(
              l10n.nutritionReviewProfessionalNote,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.x3),
            for (final entry in _questions.entries) ...[
              DropdownButtonFormField<String>(
                initialValue: _feedback[entry.key],
                decoration: InputDecoration(
                  labelText: _questionLabel(context, entry.key),
                ),
                items: [
                  for (final option in entry.value)
                    DropdownMenuItem(
                      value: option,
                      child: Text(_optionLabel(context, option)),
                    ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _feedback[entry.key] = value);
                  }
                },
              ),
              const SizedBox(height: AppSpacing.x2),
            ],
            OutlinedButton.icon(
              onPressed: _saving ? null : _editPreferences,
              icon: const Icon(Icons.tune_rounded),
              label: Text(l10n.nutritionReviewAdjust),
            ),
            if (proposed != null) ...[
              const SizedBox(height: AppSpacing.x3),
              AppSurfaceCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.nutritionReviewPreviewTitle,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    if (preview != null) ...[
                      Text(l10n.nutritionReviewPreviewBody(_changedMeals())),
                      const SizedBox(height: AppSpacing.x1),
                      for (final change in _changedMealSummaries().take(5))
                        Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.x1),
                          child: Text(change),
                        ),
                      const SizedBox(height: AppSpacing.x2),
                      Text(l10n.nutritionReviewPreviewSafety),
                    ] else
                      Text(l10n.nutritionReviewUnsafePreview),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.x2),
              if (preview != null)
                FilledButton(
                  onPressed: _saving
                      ? null
                      : () => _finish(applyProposal: true),
                  child: Text(l10n.nutritionReviewApply),
                ),
              TextButton(
                onPressed: _saving
                    ? null
                    : () => setState(() {
                        _proposal = null;
                        _preview = null;
                      }),
                child: Text(l10n.nutritionReviewDiscard),
              ),
            ],
            const SizedBox(height: AppSpacing.x2),
            FilledButton.tonal(
              onPressed: _saving ? null : () => _finish(applyProposal: false),
              child: Text(l10n.nutritionReviewKeep),
            ),
          ],
        ),
      ),
    );
  }

  String _questionLabel(BuildContext context, String key) {
    final l10n = context.l10n;
    return switch (key) {
      'energy' => l10n.nutritionReviewEnergy,
      'appetite' => l10n.nutritionReviewAppetite,
      'recipes' => l10n.nutritionReviewRecipes,
      'access' => l10n.nutritionReviewAccess,
      'recovery' => l10n.nutritionReviewRecovery,
      _ => l10n.nutritionReviewPerformance,
    };
  }

  String _optionLabel(BuildContext context, String option) {
    final l10n = context.l10n;
    return switch (option) {
      'good' => l10n.nutritionReviewGood,
      'mixed' => l10n.nutritionReviewMixed,
      'low' => l10n.nutritionReviewLow,
      'comfortable' => l10n.nutritionReviewComfortable,
      'varies' => l10n.nutritionReviewVaries,
      'difficult' => l10n.nutritionReviewDifficult,
      'easy' => l10n.nutritionReviewEasy,
      'mostly' => l10n.nutritionReviewMostly,
      'available' => l10n.nutritionReviewAvailable,
      'someMissing' => l10n.nutritionReviewSomeMissing,
      'hardToFind' => l10n.nutritionReviewHardToFind,
      _ => l10n.nutritionReviewSkip,
    };
  }
}
