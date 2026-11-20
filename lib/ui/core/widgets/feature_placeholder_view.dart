import 'package:material_ui/material_ui.dart';

import '../../../app/theme/app_spacing.dart';
import 'app_surface_card.dart';

class FeaturePlaceholderView extends StatelessWidget {
  const FeaturePlaceholderView({
    super.key,
    required this.icon,
    required this.eyebrow,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String eyebrow;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(AppSpacing.x6),
          sliver: SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.x6),
                Icon(icon, size: 28),
                const SizedBox(height: AppSpacing.x8),
                Text(eyebrow, style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: AppSpacing.x2),
                Text(title, style: Theme.of(context).textTheme.displaySmall),
                const SizedBox(height: AppSpacing.x6),
                AppSurfaceCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tu espacio de entrenamiento',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: AppSpacing.x2),
                      Text(
                        description,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  'La vista completa forma parte de la siguiente etapa.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.x6),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
