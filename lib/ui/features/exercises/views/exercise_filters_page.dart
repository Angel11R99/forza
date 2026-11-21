import 'package:material_ui/material_ui.dart';

import '../../../../domain/repositories/exercise_repository.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../models/exercise_filter_selection.dart';

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
        title: const Text('Filtros'),
        actions: [
          TextButton(onPressed: _clear, child: const Text('Limpiar')),
          const SizedBox(width: AppSpacing.x2),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.x6,
            AppSpacing.x4,
            AppSpacing.x6,
            AppSpacing.x6,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ajusta tu búsqueda',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: AppSpacing.x2),
              Text(
                'Combina grupo muscular y equipo para encontrar movimientos adecuados.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: AppSpacing.x8),
              _FilterSection(
                title: 'Grupo muscular',
                options: widget.repository.muscleGroups,
                selected: _muscleGroups,
                onSelected: (value) => _toggle(_muscleGroups, value),
              ),
              const SizedBox(height: AppSpacing.x8),
              _FilterSection(
                title: 'Equipo',
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
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.x6,
            AppSpacing.x3,
            AppSpacing.x6,
            AppSpacing.x4,
          ),
          child: FilledButton(
            onPressed: _apply,
            child: Text('Mostrar resultados · $_matchingCount'),
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
  });

  final String title;
  final List<String> options;
  final Set<String> selected;
  final ValueChanged<String> onSelected;

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
                label: Text(option),
                selected: selected.contains(option),
                onSelected: (_) => onSelected(option),
                checkmarkColor: AppColors.accent,
                selectedColor: AppColors.accentSoft,
                side: BorderSide(
                  color: selected.contains(option)
                      ? AppColors.accent
                      : AppColors.divider,
                ),
                showCheckmark: true,
              ),
          ],
        ),
      ],
    );
  }
}
