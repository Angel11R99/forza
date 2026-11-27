import 'package:material_ui/material_ui.dart';

import '../../../../app/localization/localization_extensions.dart';
import '../../../../app/localization/generated/app_localizations.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../data/repositories/profile_settings_repository.dart';
import '../../../../domain/models/nutrition/nutrition_models.dart';

class NutritionProfilePage extends StatefulWidget {
  const NutritionProfilePage({super.key, required this.repository});

  final ProfileSettingsRepository repository;

  @override
  State<NutritionProfilePage> createState() => _NutritionProfilePageState();
}

class _NutritionProfilePageState extends State<NutritionProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _age = TextEditingController();
  final _height = TextEditingController();
  final _region = TextEditingController();
  final _allergies = TextEditingController();
  final _intolerances = TextEditingController();
  final _excluded = TextEditingController();
  NutritionProfile? _profile;
  bool _loading = true;
  bool _saving = false;
  RelativeFoodCost _budget = RelativeFoodCost.moderate;
  DietaryPattern _diet = DietaryPattern.unrestricted;
  BodyType _bodyType = BodyType.unknown;
  NutritionGoal? _goal;
  String? _countryCode;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _age.dispose();
    _height.dispose();
    _region.dispose();
    _allergies.dispose();
    _intolerances.dispose();
    _excluded.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final profile = await widget.repository.loadNutritionProfile();
      if (!mounted) return;
      setState(() {
        _profile = profile;
        _age.text = profile?.ageYears?.toString() ?? '';
        _height.text = profile?.heightCm?.toString() ?? '';
        _countryCode = profile?.countryCode;
        _region.text = profile?.region ?? '';
        _budget = profile?.budget ?? RelativeFoodCost.moderate;
        _diet = profile?.dietaryPattern ?? DietaryPattern.unrestricted;
        _bodyType = profile?.bodyType ?? BodyType.unknown;
        _goal = profile?.goal;
        _allergies.text = _restrictionValues(
          profile,
          FoodRestrictionType.allergy,
        );
        _intolerances.text = _restrictionValues(
          profile,
          FoodRestrictionType.intolerance,
        );
        _excluded.text = _restrictionValues(
          profile,
          FoodRestrictionType.excluded,
        );
        _loading = false;
      });
    } on Object {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final previous = _profile;
    final profile = NutritionProfile(
      id: previous?.id ?? 'local-nutrition-profile',
      version: (previous?.version ?? 0) + 1,
      updatedAt: DateTime.now(),
      ageYears: int.tryParse(_age.text),
      heightCm: double.tryParse(_height.text.replaceAll(',', '.')),
      bodyType: _bodyType,
      goal: _goal,
      countryCode: _countryCode,
      region: _region.text.trim().isEmpty ? null : _region.text.trim(),
      budget: _budget,
      dietaryPattern: _diet,
      restrictions: [
        ..._parseRestrictions(_allergies.text, FoodRestrictionType.allergy),
        ..._parseRestrictions(
          _intolerances.text,
          FoodRestrictionType.intolerance,
        ),
        ..._parseRestrictions(_excluded.text, FoodRestrictionType.excluded),
        ...?previous?.restrictions.where(
          (item) => item.type == FoodRestrictionType.preference,
        ),
      ],
      unavailableFoodIds: previous?.unavailableFoodIds ?? const [],
    );
    try {
      await widget.repository.saveNutritionProfile(profile);
      if (!mounted) return;
      Navigator.of(context).pop(profile);
    } on Object {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.nutritionProfileSaveError)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.nutritionProfileTitle)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(AppSpacing.x4),
                  children: [
                    Text(
                      l10n.nutritionProfileIntro,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    Text(
                      l10n.nutritionProfilePersonalSection,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    TextFormField(
                      controller: _age,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: l10n.nutritionProfileAge,
                        helperText: l10n.nutritionProfileOptional,
                      ),
                      validator: (value) {
                        final text = value?.trim() ?? '';
                        if (text.isEmpty) return null;
                        final age = int.tryParse(text);
                        return age == null || age < 13 || age > 120
                            ? l10n.nutritionProfileAgeError
                            : null;
                      },
                    ),
                    TextFormField(
                      controller: _height,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        labelText: l10n.nutritionProfileHeight,
                        helperText: l10n.nutritionProfileHeightHint,
                      ),
                      validator: (value) {
                        final text = value?.trim().replaceAll(',', '.') ?? '';
                        if (text.isEmpty) return null;
                        final height = double.tryParse(text);
                        return height == null || height < 100 || height > 250
                            ? l10n.nutritionProfileHeightError
                            : null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    Text(
                      l10n.nutritionProfilePreferencesSection,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    DropdownButtonFormField<NutritionGoal?>(
                      initialValue: _goal,
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: l10n.nutritionProfileGoal,
                      ),
                      items: [
                        DropdownMenuItem<NutritionGoal?>(
                          value: null,
                          child: Text(l10n.nutritionProfileGoalUnset),
                        ),
                        ...NutritionGoal.values.map(
                          (value) => DropdownMenuItem<NutritionGoal?>(
                            value: value,
                            child: Text(_goalLabel(l10n, value)),
                          ),
                        ),
                      ],
                      onChanged: (value) => setState(() => _goal = value),
                    ),
                    DropdownButtonFormField<DietaryPattern>(
                      initialValue: _diet,
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: l10n.nutritionProfileDiet,
                      ),
                      items: DietaryPattern.values
                          .map(
                            (value) => DropdownMenuItem(
                              value: value,
                              child: Text(_dietLabel(l10n, value)),
                            ),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setState(() => _diet = value ?? _diet),
                    ),
                    DropdownButtonFormField<BodyType>(
                      initialValue: _bodyType,
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: l10n.nutritionProfileBodyType,
                      ),
                      items: BodyType.values
                          .map(
                            (value) => DropdownMenuItem(
                              value: value,
                              child: Text(_bodyTypeLabel(l10n, value)),
                            ),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setState(() => _bodyType = value ?? _bodyType),
                    ),
                    Text(
                      l10n.nutritionProfileSomatotypeNote,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    DropdownButtonFormField<RelativeFoodCost>(
                      initialValue: _budget,
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: l10n.nutritionProfileBudget,
                      ),
                      items:
                          const [
                                RelativeFoodCost.low,
                                RelativeFoodCost.moderate,
                                RelativeFoodCost.unknown,
                              ]
                              .map(
                                (value) => DropdownMenuItem(
                                  value: value,
                                  child: Text(_budgetLabel(l10n, value)),
                                ),
                              )
                              .toList(),
                      onChanged: (value) =>
                          setState(() => _budget = value ?? _budget),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.nutritionProfileCountry),
                      subtitle: Text(_countryName(l10n, _countryCode)),
                      trailing: const Icon(Icons.search),
                      onTap: _chooseCountry,
                    ),
                    TextFormField(
                      key: const ValueKey('nutrition-profile-region'),
                      controller: _region,
                      enabled: _countryCode != null,
                      maxLength: 100,
                      decoration: InputDecoration(
                        labelText: l10n.nutritionProfileRegion,
                        helperText: l10n.nutritionProfileRegionHint,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    Text(
                      l10n.nutritionProfileRestrictionsSection,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    TextFormField(
                      controller: _allergies,
                      decoration: InputDecoration(
                        labelText: l10n.nutritionProfileAllergies,
                        helperText: l10n.nutritionProfileListHint,
                      ),
                    ),
                    TextFormField(
                      controller: _intolerances,
                      decoration: InputDecoration(
                        labelText: l10n.nutritionProfileIntolerances,
                        helperText: l10n.nutritionProfileListHint,
                      ),
                    ),
                    TextFormField(
                      controller: _excluded,
                      decoration: InputDecoration(
                        labelText: l10n.nutritionProfileExcluded,
                        helperText: l10n.nutritionProfileListHint,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    Text(
                      l10n.nutritionProfilePrivacyNote,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    FilledButton(
                      onPressed: _saving ? null : _save,
                      child: Text(
                        _saving ? l10n.commonSaving : l10n.commonSave,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  String _countryName(AppLocalizations l10n, String? code) => switch (code) {
    'AR' => l10n.nutritionCountryArgentina,
    'CO' => l10n.nutritionCountryColombia,
    'DO' => l10n.nutritionCountryDominicanRepublic,
    'ES' => l10n.nutritionCountrySpain,
    'MX' => l10n.nutritionCountryMexico,
    null => l10n.nutritionCountryGeneral,
    _ => code,
  };

  Future<void> _chooseCountry() async {
    final l10n = context.l10n;
    final options = [
      _CountryChoice('AR', l10n.nutritionCountryArgentina),
      _CountryChoice('CO', l10n.nutritionCountryColombia),
      _CountryChoice('DO', l10n.nutritionCountryDominicanRepublic),
      _CountryChoice('ES', l10n.nutritionCountrySpain),
      _CountryChoice('MX', l10n.nutritionCountryMexico),
    ];
    final selected = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _CountrySearchSheet(
        countries: options,
        generalLabel: l10n.nutritionCountryGeneral,
        generalHint: l10n.nutritionCountryGeneralHint,
        searchLabel: l10n.nutritionCountrySearch,
        noResultsLabel: l10n.nutritionCountryNoResults,
      ),
    );
    if (selected == null || !mounted) return;
    setState(() {
      _countryCode = selected.isEmpty ? null : selected;
      if (_countryCode == null) _region.clear();
    });
  }

  String _dietLabel(AppLocalizations l10n, DietaryPattern value) =>
      switch (value) {
        DietaryPattern.unrestricted => l10n.nutritionProfileDietAny,
        DietaryPattern.vegetarian => l10n.nutritionProfileDietVegetarian,
        DietaryPattern.vegan => l10n.nutritionProfileDietVegan,
        DietaryPattern.pescatarian => l10n.nutritionProfileDietPescatarian,
      };

  String _bodyTypeLabel(AppLocalizations l10n, BodyType value) =>
      switch (value) {
        BodyType.ectomorph => l10n.nutritionBodyTypeEctomorph,
        BodyType.mesomorph => l10n.nutritionBodyTypeMesomorph,
        BodyType.endomorph => l10n.nutritionBodyTypeEndomorph,
        BodyType.mixed => l10n.nutritionBodyTypeMixed,
        BodyType.unknown => l10n.nutritionBodyTypeUnknown,
      };

  String _restrictionValues(
    NutritionProfile? profile,
    FoodRestrictionType type,
  ) =>
      profile?.restrictions
          .where((item) => item.type == type)
          .map((item) => item.value)
          .join(', ') ??
      '';

  List<FoodRestriction> _parseRestrictions(
    String value,
    FoodRestrictionType type,
  ) => value
      .split(',')
      .map((item) => item.trim())
      .where((item) => item.isNotEmpty)
      .map((item) => FoodRestriction(type: type, value: item))
      .toList();

  String _goalLabel(AppLocalizations l10n, NutritionGoal value) =>
      switch (value) {
        NutritionGoal.generalWellbeing => l10n.nutritionGoalWellbeing,
        NutritionGoal.supportTraining => l10n.nutritionGoalTraining,
        NutritionGoal.gainWeight => l10n.nutritionGoalGain,
        NutritionGoal.loseWeight => l10n.nutritionGoalLose,
        NutritionGoal.maintainWeight => l10n.nutritionGoalMaintain,
      };

  String _budgetLabel(AppLocalizations l10n, RelativeFoodCost value) =>
      switch (value) {
        RelativeFoodCost.low => l10n.nutritionProfileBudgetLow,
        RelativeFoodCost.moderate => l10n.nutritionProfileBudgetBalanced,
        _ => l10n.nutritionProfileBudgetAny,
      };
}

class _CountryChoice {
  const _CountryChoice(this.code, this.label);

  final String code;
  final String label;
}

class _CountrySearchSheet extends StatefulWidget {
  const _CountrySearchSheet({
    required this.countries,
    required this.generalLabel,
    required this.generalHint,
    required this.searchLabel,
    required this.noResultsLabel,
  });

  final List<_CountryChoice> countries;
  final String generalLabel;
  final String generalHint;
  final String searchLabel;
  final String noResultsLabel;

  @override
  State<_CountrySearchSheet> createState() => _CountrySearchSheetState();
}

class _CountrySearchSheetState extends State<_CountrySearchSheet> {
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _search.text.trim().toLowerCase();
    final filtered = widget.countries
        .where(
          (country) =>
              country.label.toLowerCase().contains(query) ||
              country.code.toLowerCase().contains(query),
        )
        .toList();
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.x4,
          AppSpacing.x4,
          AppSpacing.x4,
          MediaQuery.viewInsetsOf(context).bottom + AppSpacing.x4,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              key: const ValueKey('nutrition-country-search'),
              controller: _search,
              autofocus: true,
              decoration: InputDecoration(
                labelText: widget.searchLabel,
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (_) => setState(() {}),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(context).height * .55,
              ),
              child: ListView(
                shrinkWrap: true,
                children: [
                  ListTile(
                    title: Text(widget.generalLabel),
                    subtitle: Text(widget.generalHint),
                    onTap: () => Navigator.pop(context, ''),
                  ),
                  for (final country in filtered)
                    ListTile(
                      title: Text(country.label),
                      subtitle: Text(country.code),
                      onTap: () => Navigator.pop(context, country.code),
                    ),
                  if (filtered.isEmpty)
                    ListTile(title: Text(widget.noResultsLabel)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
