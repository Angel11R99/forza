import 'package:material_ui/material_ui.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_spacing.dart';

class SectionHeading extends StatelessWidget {
  const SectionHeading({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final stackAction =
        MediaQuery.sizeOf(context).width < 380 ||
        MediaQuery.textScalerOf(context).scale(1) > 1.3;
    final title = Text(
      this.title,
      style: Theme.of(context).textTheme.titleLarge,
    );
    final action = actionLabel == null || onAction == null
        ? null
        : TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              foregroundColor: context.appColors.accent,
              minimumSize: const Size(48, 48),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.small),
              ),
              overlayColor: context.appColors.accentSoft,
            ),
            child: Text(actionLabel!),
          );
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.x3),
      child: action == null
          ? title
          : stackAction
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                title,
                Align(alignment: Alignment.centerRight, child: action),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: title),
                action,
              ],
            ),
    );
  }
}
