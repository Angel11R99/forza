import 'package:material_ui/material_ui.dart';

import '../../../../data/repositories/demo_exercise_repository.dart';
import '../../../../domain/models/exercise.dart';
import '../../../../domain/repositories/exercise_repository.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../domain/models/personal_goal.dart';
import '../../../../domain/models/workout_record.dart';
import '../../../../app/localization/localization_extensions.dart';
import '../../../../domain/use_cases/weight_units.dart';

class PersonalGoalEditorPage extends StatefulWidget {
  const PersonalGoalEditorPage({
    super.key,
    this.goal,
    this.exerciseRepository,
    this.records = const [],
    this.weightUnit = 'kg',
  });

  final PersonalGoal? goal;
  final ExerciseRepository? exerciseRepository;
  final List<WorkoutRecord> records;
  final String weightUnit;

  @override
  State<PersonalGoalEditorPage> createState() => _PersonalGoalEditorPageState();
}

class _PersonalGoalEditorPageState extends State<PersonalGoalEditorPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _targetController;
  late PersonalGoalType _type;
  late final ExerciseRepository _exerciseRepository;
  String? _selectedExerciseId;
  bool _catalogReady = false;
  bool _catalogFailed = false;

  @override
  void initState() {
    super.initState();
    _exerciseRepository =
        widget.exerciseRepository ?? DemoExerciseRepository.instance;
    _type = widget.goal?.type ?? PersonalGoalType.sessionsPerWeek;
    _targetController = TextEditingController(
      text: widget.goal == null
          ? (_type == PersonalGoalType.sessionsPerWeek ? '3' : '')
          : _targetText(
              _type == PersonalGoalType.exerciseLoad
                  ? weightFromKilograms(
                      widget.goal!.targetValue,
                      widget.weightUnit,
                    )
                  : widget.goal!.targetValue,
            ),
    );
    _selectedExerciseId = widget.goal?.exerciseCatalogId;
    _loadCatalog();
  }

  @override
  void dispose() {
    _targetController.dispose();
    super.dispose();
  }

  Future<void> _loadCatalog() async {
    try {
      await _exerciseRepository.load();
      if (!mounted) return;
      final existing = widget.goal;
      if (_selectedExerciseId != null &&
          _exerciseRepository.findById(_selectedExerciseId!) == null) {
        _selectedExerciseId = null;
      }
      final legacyName = existing?.exerciseName;
      final savedIdentityWasMissingFromCatalog =
          existing?.exerciseCatalogId != null && _selectedExerciseId == null;
      final isAmbiguous =
          existing?.hasAmbiguousExerciseIdentity(widget.records) ?? false;
      if (_selectedExerciseId == null &&
          legacyName != null &&
          !isAmbiguous &&
          !savedIdentityWasMissingFromCatalog) {
        final folded = _fold(legacyName);
        final matches = _exerciseRepository.search().where((exercise) {
          return _fold(exercise.name) == folded ||
              _fold(exercise.englishName ?? '') == folded;
        }).toList();
        if (matches.length == 1) _selectedExerciseId = matches.single.id;
      }
      setState(() {
        _catalogReady = true;
        _catalogFailed = false;
      });
    } on Object {
      if (mounted) setState(() => _catalogFailed = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.goal == null
              ? context.l10n.progressNewGoal
              : context.l10n.progressEditGoal,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.x6),
                children: [
                  Text(
                    context.l10n.progressGoalEditorDescription,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: AppSpacing.x6),
                  DropdownButtonFormField<PersonalGoalType>(
                    initialValue: _type,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: context.l10n.progressGoalType,
                    ),
                    items: [
                      DropdownMenuItem(
                        value: PersonalGoalType.sessionsPerWeek,
                        child: Text(
                          context.l10n.progressWeeklySessions,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      DropdownMenuItem(
                        value: PersonalGoalType.exerciseLoad,
                        child: Text(
                          context.l10n.progressExerciseLoadRecord,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        _type = value;
                        _targetController.text =
                            value == PersonalGoalType.sessionsPerWeek
                            ? '3'
                            : '';
                      });
                    },
                  ),
                  if (_type == PersonalGoalType.exerciseLoad) ...[
                    const SizedBox(height: AppSpacing.x4),
                    _ExerciseGoalPicker(
                      selectedExerciseId: _selectedExerciseId,
                      repository: _exerciseRepository,
                      catalogReady: _catalogReady,
                      catalogFailed: _catalogFailed,
                      legacyName: widget.goal?.exerciseName,
                      onRetry: _loadCatalog,
                      onSelected: (exercise) =>
                          setState(() => _selectedExerciseId = exercise.id),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.x4),
                  TextFormField(
                    controller: _targetController,
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: _type == PersonalGoalType.exerciseLoad,
                    ),
                    decoration: InputDecoration(
                      labelText: _type == PersonalGoalType.sessionsPerWeek
                          ? context.l10n.progressWeeklySessions
                          : context.l10n.progressTargetLoad,
                      suffixText: _type == PersonalGoalType.sessionsPerWeek
                          ? context.l10n.progressSessionsUnit
                          : widget.weightUnit,
                    ),
                    validator: _validateTarget,
                  ),
                  const SizedBox(height: AppSpacing.x6),
                  FilledButton.icon(
                    onPressed: _save,
                    icon: const Icon(Icons.check_rounded),
                    label: Text(context.l10n.progressSaveGoal),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? _validateTarget(String? input) {
    final value = input?.trim().replaceAll(',', '.') ?? '';
    final target = double.tryParse(value);
    if (target == null || target <= 0) {
      return context.l10n.progressPositiveValueRequired;
    }
    if (_type == PersonalGoalType.sessionsPerWeek &&
        (target > 7 || target != target.roundToDouble())) {
      return context.l10n.progressWeeklyTargetRange;
    }
    return null;
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final existing = widget.goal;
    Navigator.of(context).pop(
      PersonalGoal(
        id: existing?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
        type: _type,
        targetValue: _type == PersonalGoalType.exerciseLoad
            ? weightToKilograms(
                double.parse(
                  _targetController.text.trim().replaceAll(',', '.'),
                ),
                widget.weightUnit,
              )
            : double.parse(_targetController.text.trim().replaceAll(',', '.')),
        exerciseName: _type == PersonalGoalType.exerciseLoad
            ? _selectedExerciseName
            : null,
        exerciseCatalogId: _type == PersonalGoalType.exerciseLoad
            ? _selectedExerciseId
            : null,
        createdAt: existing?.createdAt ?? DateTime.now(),
      ),
    );
  }

  String? get _selectedExerciseName {
    final id = _selectedExerciseId;
    if (id == null || !_exerciseRepository.isLoaded) return null;
    return _exerciseRepository.findById(id)?.name;
  }

  static String _fold(String value) =>
      value.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');

  static String _targetText(double value) => value == value.roundToDouble()
      ? value.toStringAsFixed(0)
      : value.toString();
}

class _ExerciseGoalPicker extends StatelessWidget {
  const _ExerciseGoalPicker({
    required this.selectedExerciseId,
    required this.repository,
    required this.catalogReady,
    required this.catalogFailed,
    required this.onRetry,
    required this.onSelected,
    this.legacyName,
  });

  final String? selectedExerciseId;
  final ExerciseRepository repository;
  final bool catalogReady;
  final bool catalogFailed;
  final Future<void> Function() onRetry;
  final ValueChanged<Exercise> onSelected;
  final String? legacyName;

  @override
  Widget build(BuildContext context) {
    final selected = selectedExerciseId == null
        ? null
        : repository.findById(selectedExerciseId!);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.l10n.progressExerciseName),
        const SizedBox(height: AppSpacing.x2),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: catalogReady ? () => _chooseExercise(context) : null,
            icon: const Icon(Icons.search_rounded),
            label: Text(
              selected == null
                  ? context.l10n.progressSelectExercise
                  : _localizedName(context, selected),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        if (catalogFailed)
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: Text(context.l10n.progressExerciseCatalogRetry),
          )
        else if (!catalogReady)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.x2),
            child: Row(
              children: [
                const Icon(Icons.hourglass_top_rounded, size: 18),
                const SizedBox(width: AppSpacing.x2),
                Text(context.l10n.progressExerciseCatalogLoading),
              ],
            ),
          ),
        if (legacyName != null && selected == null && catalogReady) ...[
          const SizedBox(height: AppSpacing.x1),
          Text(
            context.l10n.progressGoalExerciseNeedsResolution(legacyName!),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
        FormField<String>(
          initialValue: selectedExerciseId,
          validator: (_) => selectedExerciseId == null
              ? context.l10n.progressExerciseNameRequired
              : null,
          builder: (field) => field.hasError
              ? Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.x1),
                  child: Text(
                    field.errorText!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Future<void> _chooseExercise(BuildContext context) async {
    final selected = await showDialog<Exercise>(
      context: context,
      builder: (_) => _ExerciseSearchDialog(
        repository: repository,
        selectedExerciseId: selectedExerciseId,
      ),
    );
    if (selected != null) onSelected(selected);
  }

  String _localizedName(BuildContext context, Exercise exercise) =>
      Localizations.localeOf(context).languageCode == 'en'
      ? exercise.englishName ?? exercise.name
      : exercise.name;
}

class _ExerciseSearchDialog extends StatefulWidget {
  const _ExerciseSearchDialog({
    required this.repository,
    required this.selectedExerciseId,
  });

  final ExerciseRepository repository;
  final String? selectedExerciseId;

  @override
  State<_ExerciseSearchDialog> createState() => _ExerciseSearchDialogState();
}

class _ExerciseSearchDialogState extends State<_ExerciseSearchDialog> {
  final _queryController = TextEditingController();

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final exercises = widget.repository.search(query: _queryController.text);
    final windowSize = MediaQuery.sizeOf(context);
    return AlertDialog(
      title: Text(context.l10n.progressSelectExercise),
      content: SizedBox(
        width: (windowSize.width * 0.9).clamp(0.0, 520.0),
        height: (windowSize.height * 0.68).clamp(160.0, 480.0),
        child: Column(
          children: [
            TextField(
              controller: _queryController,
              autofocus: true,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                labelText: context.l10n.progressSearchExercises,
                prefixIcon: const Icon(Icons.search_rounded),
              ),
            ),
            const SizedBox(height: AppSpacing.x2),
            Expanded(
              child: exercises.isEmpty
                  ? Center(child: Text(context.l10n.progressNoExercisesFound))
                  : ListView.builder(
                      itemCount: exercises.length,
                      itemBuilder: (context, index) {
                        final exercise = exercises[index];
                        final isEnglish =
                            Localizations.localeOf(context).languageCode ==
                            'en';
                        final name = isEnglish
                            ? exercise.englishName ?? exercise.name
                            : exercise.name;
                        return ListTile(
                          selected: exercise.id == widget.selectedExerciseId,
                          title: Text(name),
                          subtitle: Text(exercise.muscleGroup),
                          trailing: exercise.id == widget.selectedExerciseId
                              ? const Icon(Icons.check_rounded)
                              : null,
                          onTap: () => Navigator.of(context).pop(exercise),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.l10n.commonCancel),
        ),
      ],
    );
  }
}
