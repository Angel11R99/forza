import 'package:material_ui/material_ui.dart';

import '../../../core/widgets/feature_placeholder_view.dart';

class ProgressView extends StatelessWidget {
  const ProgressView({super.key});

  @override
  Widget build(BuildContext context) => const FeaturePlaceholderView(
    icon: Icons.insights_outlined,
    eyebrow: 'TU EVOLUCIÓN',
    title: 'Progreso',
    description: 'Revisa tus entrenamientos, marcas personales y cambios a lo largo del tiempo.',
  );
}
