import 'package:material_ui/material_ui.dart';

import '../../../../domain/repositories/exercise_repository.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/localization/localization_extensions.dart';
import '../../../core/widgets/forza_brand.dart';
import '../models/exercise_filter_selection.dart';
import '../models/exercise_localized_labels.dart';

class ExerciseFiltersPage extends StatefulWidget {
  const ExerciseFiltersPage({
    super.key,
    required this.initialSelection,
    required this.searchQuery,
    required this.repository,
  });

  final ExerciseFilterSelection initialSelection;
  final String searchQuery;
  final ExerciseRepository repository;

  @override
  State<ExerciseFiltersPage> createState() => _ExerciseFiltersPageState();
}

class _ExerciseFiltersPageState extends State<ExerciseFiltersPage> {
  late final Set<String> _muscleGroups = {
    ...widget.initialSelection.muscleGroups,
  };
  late final Set<String> _equipment = {...widget.initialSelection.equipment};

  int get _matchingCount {
    return widget.repository
        .search(
          query: widget.searchQuery,
          muscleGroups: _muscleGroups,
          equipment: _equipment,
        )
        .length;
  }

  void _apply() {
    Navigator.of(context).pop(
      ExerciseFilterSelection(
        muscleGroups: Set.unmodifiable(_muscleGroups),
        equipment: Set.unmodifiable(_equipment),
      ),
    );
  }

  void _clear() {
    setState(() {
      _muscleGroups.clear();
      _equipment.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.exerciseFiltersTitle),
        actions: [
          TextButton(
            onPressed: _clear,
            child: Text(context.l10n.exerciseClearFilters),
          ),
          const SizedBox(width: AppSpacing.x2),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.pageGutter(MediaQuery.sizeOf(context).width),
            AppSpacing.x4,
            AppSpacing.pageGutter(MediaQuery.sizeOf(context).width),
            AppSpacing.x6,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ForzaEyebrow(label: context.l10n.exerciseEyebrow),
              const SizedBox(height: AppSpacing.x3),
              Text(
                context.l10n.exerciseAdjustSearchTitle,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: AppSpacing.x2),
              Text(
                context.l10n.exerciseFiltersDescription,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: AppSpacing.x8),
              _FilterSection(
                title: context.l10n.exerciseMuscleGroupFilter,
                options: widget.repository.muscleGroups,
                localizeOption: (option) =>
                    localizedExerciseMuscleGroup(context, option),
                selected: _muscleGroups,
                onSelected: (value) => _toggle(_muscleGroups, value),
              ),
              const SizedBox(height: AppSpacing.x8),
              _FilterSection(
                title: context.l10n.exerciseEquipmentFilter,
                localizeOption: (option) =>
                    localizedExerciseEquipment(context, option),
                options: widget.repository.equipmentTypes,
                selected: _equipment,
                onSelected: (value) => _toggle(_equipment, value),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.pageGutter(MediaQuery.sizeOf(context).width),
            AppSpacing.x3,
            AppSpacing.pageGutter(MediaQuery.sizeOf(context).width),
            AppSpacing.x4,
          ),
          child: FilledButton(
            onPressed: _apply,
            child: Text(context.l10n.exerciseShowResults(_matchingCount)),
          ),
        ),
      ),
    );
  }

  void _toggle(Set<String> selection, String value) {
    setState(() {
      if (!selection.add(value)) selection.remove(value);
    });
  }
}

class _FilterSection extends StatelessWidget {
  const _FilterSection({
    required this.title,
    required this.options,
    required this.selected,
    required this.onSelected,
    this.localizeOption,
  });

  final String title;
  final List<String> options;
  final Set<String> selected;
  final ValueChanged<String> onSelected;
  final String Function(String value)? localizeOption;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: AppSpacing.x3),
        Wrap(
          spacing: AppSpacing.x2,
          runSpacing: AppSpacing.x2,
          children: [
            for (final option in options)
              FilterChip(
                label: Text(localizeOption?.call(option) ?? option),
                selected: selected.contains(option),
                onSelected: (_) => onSelected(option),
                checkmarkColor: context.appColors.accent,
                selectedColor: context.appColors.accentSoft,
                side: BorderSide(
                  color: selected.contains(option)
                      ? context.appColors.accent
                      : context.appColors.divider,
                ),
                showCheckmark: true,
              ),
          ],
        ),
      ],
    );
  }
}
