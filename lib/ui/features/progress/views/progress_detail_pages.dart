import 'package:material_ui/material_ui.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../core/widgets/app_surface_card.dart';
import '../../../core/widgets/section_heading.dart';
import '../../../../domain/models/workout_record.dart';
import '../data/progress_demo_data.dart';
import '../models/progress_models.dart';
import '../widgets/progress_line_chart.dart';
import '../../../../app/localization/localization_extensions.dart';
import '../../exercises/models/exercise_localized_labels.dart';

class SessionDetailPage extends StatelessWidget {
  const SessionDetailPage({super.key, required this.session});

  final WorkoutHistoryEntry session;

  @override
  Widget build(BuildContext context) {
    final localeName = Localizations.localeOf(context).toLanguageTag();
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.progressSessionDetail)),
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.x6,
                AppSpacing.x2,
                AppSpacing.x6,
                AppSpacing.x8,
              ),
              children: [
                const SizedBox(height: AppSpacing.x4),
                Text(
                  session.title,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  _formatLongDate(session.date, localeName),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: AppSpacing.x6),
                Row(
                  children: [
                    Expanded(
                      child: _ValueCard(
                        label: context.l10n.progressDuration,
                        value: '${session.durationMinutes} min',
                        icon: Icons.schedule_rounded,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x3),
                    Expanded(
                      child: _ValueCard(
                        label: context.l10n.progressExercises,
                        value: '${session.exerciseCount}',
                        icon: Icons.fitness_center_rounded,
                      ),
                    ),
                  ],
                ),
                if (session.completedOutsideApp) ...[
                  const SizedBox(height: AppSpacing.x4),
                  AppSurfaceCard(
                    color: context.appColors.surfaceMuted,
                    child: Text(
                      context.l10n.progressOutsideAppNote,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.x8),
                if (session.exercises.isNotEmpty) ...[
                  SectionHeading(
                    title: context.l10n.progressExerciseHeading(
                      session.exercises.length,
                    ),
                  ),
                  for (var index = 0; index < session.exercises.length; index++)
                    Builder(
                      builder: (context) {
                        final sets = session.loggedSets
                            .where((set) => set.exercisePosition == index)
                            .toList(growable: false);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.x2),
                          child: AppSurfaceCard(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  (index + 1).toString().padLeft(2, '0'),
                                  style: Theme.of(context).textTheme.labelLarge
                                      ?.copyWith(
                                        color: context.appColors.textSecondary,
                                      ),
                                ),
                                const SizedBox(width: AppSpacing.x4),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        localizedTrainingExerciseName(
                                          context,
                                          session.exercises[index],
                                        ),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      if (sets.isNotEmpty) ...[
                                        const SizedBox(height: AppSpacing.x2),
                                        for (final set in sets)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: AppSpacing.x1,
                                            ),
                                            child: Text(
                                              _setSummary(context, set),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                            ),
                                          ),
                                      ],
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.check_circle_rounded,
                                  color: context.appColors.accent,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StrengthEvolutionPage extends StatefulWidget {
  const StrengthEvolutionPage({super.key});

  @override
  State<StrengthEvolutionPage> createState() => _StrengthEvolutionPageState();
}

class _StrengthEvolutionPageState extends State<StrengthEvolutionPage> {
  static const _exercises = <String>[
    'Press de banca',
    'Sentadilla con barra',
    'Peso muerto rumano',
  ];

  String _selectedExercise = _exercises.first;

  List<double> get _values => switch (_selectedExercise) {
    'Sentadilla con barra' => [60, 62.5, 67.5, 72.5, 80, 85],
    'Peso muerto rumano' => [70, 75, 80, 85, 90, 95],
    _ => ProgressDemoData.strengthValuesKg,
  };

  @override
  Widget build(BuildContext context) {
    final values = _values;
    final increase = values.last - values.first;

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.progressStrengthEvolution)),
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.x6,
                AppSpacing.x2,
                AppSpacing.x6,
                AppSpacing.x8,
              ),
              children: [
                const SizedBox(height: AppSpacing.x4),
                Text(
                  context.l10n.progressStrengthHeadline,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  context.l10n.progressStrengthDescription,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: AppSpacing.x6),
                Wrap(
                  spacing: AppSpacing.x2,
                  runSpacing: AppSpacing.x2,
                  children: [
                    for (final exercise in _exercises)
                      ChoiceChip(
                        label: Text(
                          localizedTrainingExerciseName(context, exercise),
                        ),
                        selected: exercise == _selectedExercise,
                        onSelected: (_) =>
                            setState(() => _selectedExercise = exercise),
                        selectedColor: context.appColors.surfaceMuted,
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x6),
                AppSurfaceCard(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.x4,
                    AppSpacing.x4,
                    AppSpacing.x4,
                    AppSpacing.x2,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedExercise,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      Text(
                        context.l10n.progressWorkingWeight,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: AppSpacing.x2),
                      ProgressLineChart(
                        values: values,
                        labels: ProgressDemoData.strengthLabels,
                        summary: context.l10n.progressStrengthChartSummary(
                          increase.toStringAsFixed(1),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.x4),
                Row(
                  children: [
                    Expanded(
                      child: _ValueCard(
                        label: context.l10n.progressStart,
                        value: '${values.first} kg',
                        icon: Icons.flag_outlined,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x3),
                    Expanded(
                      child: _ValueCard(
                        label: context.l10n.progressCurrent,
                        value: '${values.last} kg',
                        icon: Icons.trending_up_rounded,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BodyEvolutionPage extends StatefulWidget {
  const BodyEvolutionPage({
    super.key,
    required this.measurements,
    required this.onSaveMeasurement,
  });

  final List<MeasurementEntry> measurements;
  final ValueChanged<MeasurementEntry> onSaveMeasurement;

  @override
  State<BodyEvolutionPage> createState() => _BodyEvolutionPageState();
}

class _BodyEvolutionPageState extends State<BodyEvolutionPage> {
  late final List<MeasurementEntry> _measurements = [...widget.measurements];

  List<MeasurementEntry> get _orderedMeasurements {
    final entries = [..._measurements];
    entries.sort((a, b) => a.date.compareTo(b.date));
    return entries;
  }

  @override
  Widget build(BuildContext context) {
    final ordered = _orderedMeasurements;
    final first = ordered.first;
    final latest = ordered.last;
    final change = latest.weightKg - first.weightKg;
    final values = ordered.map((entry) => entry.weightKg).toList();
    final labels = ordered
        .map((entry) => '${entry.date.day}/${entry.date.month}')
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.progressBodyEvolution)),
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.x6,
                AppSpacing.x2,
                AppSpacing.x6,
                AppSpacing.x8,
              ),
              children: [
                const SizedBox(height: AppSpacing.x4),
                Text(
                  context.l10n.progressBodyHeadline,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  context.l10n.progressBodyDescription,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: AppSpacing.x6),
                AppSurfaceCard(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.x4,
                    AppSpacing.x4,
                    AppSpacing.x4,
                    AppSpacing.x2,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.progressBodyWeight,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      Text('kg', style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: AppSpacing.x2),
                      ProgressLineChart(
                        values: values,
                        labels: labels,
                        summary: context.l10n.progressWeightChartSummary(
                          first.weightKg.toStringAsFixed(1),
                          latest.weightKg.toStringAsFixed(1),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.x3),
                Row(
                  children: [
                    Expanded(
                      child: _ValueCard(
                        label: context.l10n.progressLastEntry,
                        value: '${latest.weightKg.toStringAsFixed(1)} kg',
                        icon: Icons.monitor_weight_outlined,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x3),
                    Expanded(
                      child: _ValueCard(
                        label: context.l10n.progressPeriodChange,
                        value:
                            '${change > 0 ? '+' : ''}${change.toStringAsFixed(1)} kg',
                        icon: Icons.trending_up_rounded,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x8),
                SectionHeading(title: context.l10n.progressRecentMeasurements),
                for (final entry in ordered.reversed.take(3))
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.x2),
                    child: _MeasurementSummaryCard(entry: entry),
                  ),
              ],
            ),
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
          child: FilledButton.icon(
            onPressed: _openMeasurementForm,
            icon: const Icon(Icons.add_rounded),
            label: Text(context.l10n.progressRegisterMeasurements),
          ),
        ),
      ),
    );
  }

  Future<void> _openMeasurementForm() async {
    final entry = await Navigator.of(context).push<MeasurementEntry>(
      MaterialPageRoute<MeasurementEntry>(
        builder: (_) => const MeasurementFormPage(),
      ),
    );
    if (!mounted || entry == null) return;
    setState(() => _measurements.add(entry));
    widget.onSaveMeasurement(entry);
  }
}

class MeasurementFormPage extends StatefulWidget {
  const MeasurementFormPage({super.key});

  @override
  State<MeasurementFormPage> createState() => _MeasurementFormPageState();
}

class _MeasurementFormPageState extends State<MeasurementFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _chestController = TextEditingController();
  final _waistController = TextEditingController();
  final _hipsController = TextEditingController();
  final _armController = TextEditingController();
  DateTime _date = DateTime.now();

  @override
  void dispose() {
    _weightController.dispose();
    _chestController.dispose();
    _waistController.dispose();
    _hipsController.dispose();
    _armController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.progressRegisterMeasurements)),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.x6,
                  AppSpacing.x2,
                  AppSpacing.x6,
                  AppSpacing.x8,
                ),
                children: [
                  const SizedBox(height: AppSpacing.x4),
                  Text(
                    context.l10n.progressMeasurementHeadline,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(height: AppSpacing.x2),
                  Text(
                    context.l10n.progressMeasurementDescription,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: AppSpacing.x6),
                  AppSurfaceCard(
                    padding: EdgeInsets.zero,
                    child: ListTile(
                      leading: const Icon(Icons.calendar_today_rounded),
                      title: Text(context.l10n.progressMeasurementDate),
                      subtitle: Text(
                        _formatLongDate(
                          _date,
                          Localizations.localeOf(context).toLanguageTag(),
                        ),
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: _pickDate,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x6),
                  _MeasurementField(
                    controller: _weightController,
                    label: context.l10n.progressBodyWeight,
                    unit: 'kg',
                    required: true,
                  ),
                  const SizedBox(height: AppSpacing.x3),
                  _MeasurementField(
                    controller: _waistController,
                    label: context.l10n.progressWaist,
                    unit: 'cm',
                  ),
                  const SizedBox(height: AppSpacing.x3),
                  _MeasurementField(
                    controller: _chestController,
                    label: context.l10n.progressChest,
                    unit: 'cm',
                  ),
                  const SizedBox(height: AppSpacing.x3),
                  _MeasurementField(
                    controller: _hipsController,
                    label: context.l10n.progressHips,
                    unit: 'cm',
                  ),
                  const SizedBox(height: AppSpacing.x3),
                  _MeasurementField(
                    controller: _armController,
                    label: context.l10n.progressArm,
                    unit: 'cm',
                  ),
                  const SizedBox(height: AppSpacing.x6),
                  FilledButton.icon(
                    onPressed: _save,
                    icon: const Icon(Icons.check_rounded),
                    label: Text(context.l10n.progressSaveEntry),
                  ),
                  const SizedBox(height: AppSpacing.x3),
                  Text(
                    context.l10n.progressMeasurementsSavedNote,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(now.year - 5),
      lastDate: now,
    );
    if (picked != null) setState(() => _date = picked);
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(
      MeasurementEntry(
        date: _date,
        weightKg: double.parse(_weightController.text.replaceAll(',', '.')),
        chestCm: _optionalValue(_chestController),
        waistCm: _optionalValue(_waistController),
        hipsCm: _optionalValue(_hipsController),
        armCm: _optionalValue(_armController),
      ),
    );
  }

  double? _optionalValue(TextEditingController controller) {
    final value = controller.text.trim().replaceAll(',', '.');
    return value.isEmpty ? null : double.tryParse(value);
  }
}

class _MeasurementField extends StatelessWidget {
  const _MeasurementField({
    required this.controller,
    required this.label,
    required this.unit,
    this.required = false,
  });

  final TextEditingController controller;
  final String label;
  final String unit;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: required ? context.l10n.requiredField(label) : label,
        suffixText: unit,
      ),
      validator: (text) {
        final value = text?.trim().replaceAll(',', '.') ?? '';
        if (value.isEmpty) {
          return required ? context.l10n.progressWeightRequired : null;
        }
        final parsed = double.tryParse(value);
        if (parsed == null || parsed <= 0) {
          return context.l10n.progressInvalidValue;
        }
        return null;
      },
    );
  }
}

class PersonalRecordsPage extends StatelessWidget {
  const PersonalRecordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final records = ProgressDemoData.records(DateTime.now());

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.progressPersonalRecords)),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.x6,
                AppSpacing.x2,
                AppSpacing.x6,
                AppSpacing.x8,
              ),
              children: [
                const SizedBox(height: AppSpacing.x4),
                Text(
                  context.l10n.progressRecordsHeadline,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  context.l10n.progressRecordsDescription,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: AppSpacing.x6),
                for (final record in records)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.x2),
                    child: _RecordCard(record: record),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RecordCard extends StatelessWidget {
  const _RecordCard({required this.record});

  final PersonalRecord record;

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      child: Row(
        children: [
          SizedBox(
            width: 42,
            height: 42,
            child: Icon(
              Icons.emoji_events_outlined,
              color: context.appColors.textPrimary,
            ),
          ),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizedTrainingExerciseName(context, record.exercise),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  _formatShortDate(
                    record.date,
                    Localizations.localeOf(context).toLanguageTag(),
                  ),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          Text(
            '${record.value} ${record.unit}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}

class _MeasurementSummaryCard extends StatelessWidget {
  const _MeasurementSummaryCard({required this.entry});

  final MeasurementEntry entry;

  @override
  Widget build(BuildContext context) {
    final details = <String>[
      if (entry.waistCm != null)
        context.l10n.measurementValue(
          context.l10n.progressWaist,
          _formatValue(entry.waistCm!),
        ),
      if (entry.chestCm != null)
        context.l10n.measurementValue(
          context.l10n.progressChest,
          _formatValue(entry.chestCm!),
        ),
      if (entry.hipsCm != null)
        context.l10n.measurementValue(
          context.l10n.progressHips,
          _formatValue(entry.hipsCm!),
        ),
      if (entry.armCm != null)
        context.l10n.measurementValue(
          context.l10n.progressArm,
          _formatValue(entry.armCm!),
        ),
    ];

    return AppSurfaceCard(
      child: Row(
        children: [
          const Icon(Icons.straighten_rounded),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatShortDate(
                    entry.date,
                    Localizations.localeOf(context).toLanguageTag(),
                  ),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  details.isEmpty
                      ? context.l10n.progressBodyWeight
                      : details.join('  ·  '),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          Text(
            '${entry.weightKg.toStringAsFixed(1)} kg',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}

class _ValueCard extends StatelessWidget {
  const _ValueCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: context.appColors.textSecondary),
          const SizedBox(height: AppSpacing.x3),
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: AppSpacing.x1),
          Text(value, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}

String _formatLongDate(DateTime date, String localeName) =>
    DateFormat.yMMMMEEEEd(localeName).format(date);

String _formatShortDate(DateTime date, String localeName) =>
    DateFormat.MMMd(localeName).format(date);

String _formatValue(double value) => value == value.roundToDouble()
    ? value.toStringAsFixed(0)
    : value.toStringAsFixed(1);

String _setSummary(BuildContext context, WorkoutSetResult set) {
  final values = <String>[
    if (set.repetitions != null)
      context.l10n.progressValueWithUnit(
        '${set.repetitions}',
        context.l10n.progressRepetitionsUnit,
      ),
    if (set.loadKg != null)
      context.l10n.progressValueWithUnit(
        _formatValue(set.loadKg!),
        context.l10n.progressKilograms,
      ),
    if (set.durationSeconds != null)
      context.l10n.progressValueWithUnit(
        '${set.durationSeconds}',
        context.l10n.progressSecondsUnit,
      ),
  ];
  return context.l10n.progressSetSummary(set.setIndex + 1, values.join(' · '));
}
