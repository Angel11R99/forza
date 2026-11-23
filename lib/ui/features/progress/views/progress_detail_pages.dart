import 'package:material_ui/material_ui.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../core/widgets/app_surface_card.dart';
import '../../../core/widgets/section_heading.dart';
import '../data/progress_demo_data.dart';
import '../models/progress_models.dart';
import '../widgets/progress_line_chart.dart';

const _monthNames = <String>[
  'enero',
  'febrero',
  'marzo',
  'abril',
  'mayo',
  'junio',
  'julio',
  'agosto',
  'septiembre',
  'octubre',
  'noviembre',
  'diciembre',
];

const _weekdayNames = <String>[
  'lunes',
  'martes',
  'miércoles',
  'jueves',
  'viernes',
  'sábado',
  'domingo',
];

class SessionDetailPage extends StatelessWidget {
  const SessionDetailPage({super.key, required this.session});

  final WorkoutHistoryEntry session;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de sesión')),
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
                  _formatLongDate(session.date),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: AppSpacing.x6),
                Row(
                  children: [
                    Expanded(
                      child: _ValueCard(
                        label: 'Duración',
                        value: '${session.durationMinutes} min',
                        icon: Icons.schedule_rounded,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x3),
                    Expanded(
                      child: _ValueCard(
                        label: 'Ejercicios',
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
                      'Marcaste esta sesión como realizada fuera de FORZA. No hay detalle de movimientos ni cargas.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.x8),
                if (session.exercises.isNotEmpty) ...[
                  SectionHeading(
                    title: 'Ejercicios · ${session.exercises.length}',
                  ),
                  for (var index = 0; index < session.exercises.length; index++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.x2),
                      child: AppSurfaceCard(
                        child: Row(
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
                              child: Text(
                                session.exercises[index],
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            Icon(
                              Icons.check_circle_rounded,
                              color: context.appColors.accent,
                            ),
                          ],
                        ),
                      ),
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
      appBar: AppBar(title: const Text('Evolución de fuerza')),
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
                  'Más fuerza, paso a paso.',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  'Compara el peso de trabajo entre tus últimas seis sesiones.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: AppSpacing.x6),
                Wrap(
                  spacing: AppSpacing.x2,
                  runSpacing: AppSpacing.x2,
                  children: [
                    for (final exercise in _exercises)
                      ChoiceChip(
                        label: Text(exercise),
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
                        'Peso de trabajo (kg)',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: AppSpacing.x2),
                      ProgressLineChart(
                        values: values,
                        labels: ProgressDemoData.strengthLabels,
                        summary:
                            'El peso de trabajo aumentó ${increase.toStringAsFixed(1)} kilogramos en seis sesiones.',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.x4),
                Row(
                  children: [
                    Expanded(
                      child: _ValueCard(
                        label: 'Inicio',
                        value: '${values.first} kg',
                        icon: Icons.flag_outlined,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x3),
                    Expanded(
                      child: _ValueCard(
                        label: 'Actual',
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
      appBar: AppBar(title: const Text('Evolución corporal')),
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
                  'Cambios que puedes seguir.',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  'Las medidas son referencias orientativas, no objetivos.',
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
                        'Peso corporal',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      Text('kg', style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: AppSpacing.x2),
                      ProgressLineChart(
                        values: values,
                        labels: labels,
                        summary:
                            'El peso corporal pasó de ${first.weightKg.toStringAsFixed(1)} a ${latest.weightKg.toStringAsFixed(1)} kilogramos.',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.x3),
                Row(
                  children: [
                    Expanded(
                      child: _ValueCard(
                        label: 'Último registro',
                        value: '${latest.weightKg.toStringAsFixed(1)} kg',
                        icon: Icons.monitor_weight_outlined,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x3),
                    Expanded(
                      child: _ValueCard(
                        label: 'Cambio del periodo',
                        value:
                            '${change > 0 ? '+' : ''}${change.toStringAsFixed(1)} kg',
                        icon: Icons.trending_up_rounded,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x8),
                SectionHeading(title: 'Medidas recientes'),
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
            label: const Text('Registrar medidas'),
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
      appBar: AppBar(title: const Text('Registrar medidas')),
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
                    'Registra cómo vas.',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(height: AppSpacing.x2),
                  Text(
                    'El peso es obligatorio. Las demás medidas son opcionales.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: AppSpacing.x6),
                  AppSurfaceCard(
                    padding: EdgeInsets.zero,
                    child: ListTile(
                      leading: const Icon(Icons.calendar_today_rounded),
                      title: const Text('Fecha de registro'),
                      subtitle: Text(_formatLongDate(_date)),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: _pickDate,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x6),
                  _MeasurementField(
                    controller: _weightController,
                    label: 'Peso corporal',
                    unit: 'kg',
                    required: true,
                  ),
                  const SizedBox(height: AppSpacing.x3),
                  _MeasurementField(
                    controller: _waistController,
                    label: 'Cintura',
                    unit: 'cm',
                  ),
                  const SizedBox(height: AppSpacing.x3),
                  _MeasurementField(
                    controller: _chestController,
                    label: 'Pecho',
                    unit: 'cm',
                  ),
                  const SizedBox(height: AppSpacing.x3),
                  _MeasurementField(
                    controller: _hipsController,
                    label: 'Cadera',
                    unit: 'cm',
                  ),
                  const SizedBox(height: AppSpacing.x3),
                  _MeasurementField(
                    controller: _armController,
                    label: 'Brazo',
                    unit: 'cm',
                  ),
                  const SizedBox(height: AppSpacing.x6),
                  FilledButton.icon(
                    onPressed: _save,
                    icon: const Icon(Icons.check_rounded),
                    label: const Text('Guardar registro'),
                  ),
                  const SizedBox(height: AppSpacing.x3),
                  Text(
                    'Este registro se conserva mientras la app está abierta.',
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
        labelText: required ? '$label *' : label,
        suffixText: unit,
      ),
      validator: (text) {
        final value = text?.trim().replaceAll(',', '.') ?? '';
        if (value.isEmpty) {
          return required ? 'Ingresa el peso corporal.' : null;
        }
        final parsed = double.tryParse(value);
        if (parsed == null || parsed <= 0) return 'Ingresa un valor válido.';
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
      appBar: AppBar(title: const Text('Récords personales')),
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
                  'Tus mejores marcas.',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  'Tus mejores marcas en distintos ejercicios.',
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
                  record.exercise,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  _formatShortDate(record.date),
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
      if (entry.waistCm != null) 'Cintura ${_formatValue(entry.waistCm!)} cm',
      if (entry.chestCm != null) 'Pecho ${_formatValue(entry.chestCm!)} cm',
      if (entry.hipsCm != null) 'Cadera ${_formatValue(entry.hipsCm!)} cm',
      if (entry.armCm != null) 'Brazo ${_formatValue(entry.armCm!)} cm',
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
                  _formatShortDate(entry.date),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  details.isEmpty ? 'Peso corporal' : details.join('  ·  '),
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

String _formatLongDate(DateTime date) =>
    '${_weekdayNames[date.weekday - 1]}, ${date.day} de ${_monthNames[date.month - 1]}';

String _formatShortDate(DateTime date) =>
    '${date.day} ${_monthNames[date.month - 1].substring(0, 3)}';

String _formatValue(double value) => value == value.roundToDouble()
    ? value.toStringAsFixed(0)
    : value.toStringAsFixed(1);
