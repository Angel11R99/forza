import 'package:material_ui/material_ui.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../domain/models/personal_goal.dart';
import '../../../../app/localization/localization_extensions.dart';

class PersonalGoalEditorPage extends StatefulWidget {
  const PersonalGoalEditorPage({super.key, this.goal});

  final PersonalGoal? goal;

  @override
  State<PersonalGoalEditorPage> createState() => _PersonalGoalEditorPageState();
}

class _PersonalGoalEditorPageState extends State<PersonalGoalEditorPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _targetController;
  late final TextEditingController _exerciseController;
  late PersonalGoalType _type;

  @override
  void initState() {
    super.initState();
    _type = widget.goal?.type ?? PersonalGoalType.sessionsPerWeek;
    _targetController = TextEditingController(
      text: widget.goal == null
          ? (_type == PersonalGoalType.sessionsPerWeek ? '3' : '')
          : _targetText(widget.goal!.targetValue),
    );
    _exerciseController = TextEditingController(
      text: widget.goal?.exerciseName ?? '',
    );
  }

  @override
  void dispose() {
    _targetController.dispose();
    _exerciseController.dispose();
    super.dispose();
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
                    decoration: InputDecoration(
                      labelText: context.l10n.progressGoalType,
                    ),
                    items: [
                      DropdownMenuItem(
                        value: PersonalGoalType.sessionsPerWeek,
                        child: Text(context.l10n.progressWeeklySessions),
                      ),
                      DropdownMenuItem(
                        value: PersonalGoalType.exerciseLoad,
                        child: Text(context.l10n.progressExerciseLoadRecord),
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
                    TextFormField(
                      controller: _exerciseController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        labelText: context.l10n.progressExerciseName,
                        hintText: context.l10n.progressExerciseHint,
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? context.l10n.progressExerciseNameRequired
                          : null,
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
                          : 'kg',
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
        targetValue: double.parse(
          _targetController.text.trim().replaceAll(',', '.'),
        ),
        exerciseName: _type == PersonalGoalType.exerciseLoad
            ? _exerciseController.text.trim()
            : null,
        createdAt: existing?.createdAt ?? DateTime.now(),
      ),
    );
  }

  static String _targetText(double value) => value == value.roundToDouble()
      ? value.toStringAsFixed(0)
      : value.toString();
}
