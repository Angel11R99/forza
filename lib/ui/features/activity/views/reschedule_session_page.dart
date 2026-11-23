import 'package:material_ui/material_ui.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../core/widgets/app_surface_card.dart';
import '../../../core/widgets/forza_brand.dart';
import '../../../../app/localization/localization_extensions.dart';

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
    final localeName = Localizations.localeOf(context).toLanguageTag();
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.rescheduleTitle)),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = AppSpacing.pageGutter(
              constraints.maxWidth,
            );

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
                      ForzaEyebrow(label: context.l10n.rescheduleEyebrow),
                      const SizedBox(height: AppSpacing.x2),
                      Text(
                        context.l10n.rescheduleHeading,
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      const SizedBox(height: AppSpacing.x6),
                      AppSurfaceCard(
                        child: Row(
                          children: [
                            SizedBox(
                              width: 48,
                              height: 48,
                              child: Center(
                                child: Icon(
                                  widget.sessionIcon,
                                  color: context.appColors.textPrimary,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.x4),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    context.l10n.rescheduleCurrentDate(
                                      _formatDate(
                                        widget.sessionDate,
                                        localeName,
                                      ),
                                    ),
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
                        context.l10n.rescheduleAvailableDates,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: AppSpacing.x3),
                      if (widget.availableDates.isEmpty)
                        AppSurfaceCard(
                          child: Text(context.l10n.rescheduleNoDates),
                        )
                      else
                        for (final date in widget.availableDates) ...[
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.x2,
                            ),
                            child: _DateOptionCard(
                              date: date,
                              localeName: localeName,
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
                          label: Text(context.l10n.rescheduleConfirm),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x3),
                      Text(
                        context.l10n.reschedulePersistenceNote,
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
    required this.localeName,
    required this.selected,
    required this.onTap,
  });

  final DateTime date;
  final String localeName;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final dateLabel = _formatDate(date, localeName);
    return Semantics(
      button: true,
      selected: selected,
      label: context.l10n.rescheduleAvailableDateSemantics(dateLabel),
      child: ExcludeSemantics(
        child: Material(
          color: selected
              ? context.appColors.accentSoft
              : context.appColors.surface,
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
                  color: selected
                      ? context.appColors.accent
                      : context.appColors.divider,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    selected
                        ? Icons.radio_button_checked_rounded
                        : Icons.radio_button_off_rounded,
                    color: context.appColors.accent,
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: Text(
                      dateLabel,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  if (_isSameDay(date, DateTime.now()))
                    Text(
                      context.l10n.activityToday,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String _formatDate(DateTime date, String localeName) =>
    DateFormat('EEEE, d MMMM', localeName).format(date);

bool _isSameDay(DateTime first, DateTime? second) =>
    second != null &&
    first.year == second.year &&
    first.month == second.month &&
    first.day == second.day;
