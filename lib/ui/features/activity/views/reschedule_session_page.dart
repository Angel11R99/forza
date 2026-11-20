import 'package:material_ui/material_ui.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../core/widgets/app_surface_card.dart';

const _rescheduleMonths = <String>[
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

const _rescheduleWeekdays = <String>[
  'lunes',
  'martes',
  'miércoles',
  'jueves',
  'viernes',
  'sábado',
  'domingo',
];

class RescheduleSessionPage extends StatefulWidget {
  const RescheduleSessionPage({
    super.key,
    required this.sessionDate,
    required this.sessionTitle,
    required this.sessionIcon,
    required this.availableDates,
  });

  final DateTime sessionDate;
  final String sessionTitle;
  final IconData sessionIcon;
  final List<DateTime> availableDates;

  @override
  State<RescheduleSessionPage> createState() => _RescheduleSessionPageState();
}

class _RescheduleSessionPageState extends State<RescheduleSessionPage> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.availableDates.isEmpty
        ? null
        : widget.availableDates.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reprogramar sesión')),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = constraints.maxWidth < 380
                ? AppSpacing.x4
                : AppSpacing.x6;

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    AppSpacing.x4,
                    horizontalPadding,
                    AppSpacing.x8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ELIGE UNA NUEVA FECHA',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                          letterSpacing: 1.3,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x2),
                      Text(
                        'Mueve tu sesión',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      const SizedBox(height: AppSpacing.x6),
                      AppSurfaceCard(
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppColors.surfaceMuted,
                                borderRadius: BorderRadius.circular(
                                  AppRadius.small,
                                ),
                              ),
                              child: Icon(
                                widget.sessionIcon,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.x4),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Fecha actual: ${_formatDate(widget.sessionDate)}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium,
                                  ),
                                  const SizedBox(height: AppSpacing.x1),
                                  Text(
                                    widget.sessionTitle,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x8),
                      Text(
                        'Fechas disponibles',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: AppSpacing.x3),
                      if (widget.availableDates.isEmpty)
                        const AppSurfaceCard(
                          child: Text(
                            'No encontramos otra fecha disponible en las próximas dos semanas.',
                          ),
                        )
                      else
                        for (final date in widget.availableDates) ...[
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.x2,
                            ),
                            child: _DateOptionCard(
                              date: date,
                              selected: _isSameDay(date, _selectedDate),
                              onTap: () => setState(() => _selectedDate = date),
                            ),
                          ),
                        ],
                      const SizedBox(height: AppSpacing.x4),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: _selectedDate == null
                              ? null
                              : () => Navigator.of(context).pop(_selectedDate),
                          icon: const Icon(Icons.check_rounded),
                          label: const Text('Confirmar nueva fecha'),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x3),
                      Text(
                        'Los cambios de esta demostración no se guardan al cerrar la app.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _DateOptionCard extends StatelessWidget {
  const _DateOptionCard({
    required this.date,
    required this.selected,
    required this.onTap,
  });

  final DateTime date;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: '${_formatDate(date)}, fecha disponible',
      child: ExcludeSemantics(
        child: Material(
          color: selected ? AppColors.surfaceMuted : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.medium),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppRadius.medium),
            child: Container(
              constraints: const BoxConstraints(minHeight: 68),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.x4,
                vertical: AppSpacing.x3,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.medium),
                border: Border.all(
                  color: selected ? AppColors.textPrimary : AppColors.divider,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    selected
                        ? Icons.radio_button_checked_rounded
                        : Icons.radio_button_off_rounded,
                    color: AppColors.textPrimary,
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: Text(
                      _formatDate(date),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  if (_isSameDay(date, DateTime.now()))
                    Text('HOY', style: Theme.of(context).textTheme.labelLarge),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String _formatDate(DateTime date) =>
    '${_rescheduleWeekdays[date.weekday - 1]}, ${date.day} de ${_rescheduleMonths[date.month - 1]}';

bool _isSameDay(DateTime first, DateTime? second) =>
    second != null &&
    first.year == second.year &&
    first.month == second.month &&
    first.day == second.day;
