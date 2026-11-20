import 'package:material_ui/material_ui.dart';

import '../../../core/widgets/feature_placeholder_view.dart';

class ExercisesView extends StatelessWidget {
  const ExercisesView({super.key});

  @override
  Widget build(BuildContext context) => const FeaturePlaceholderView(
    icon: Icons.fitness_center_outlined,
    eyebrow: 'BIBLIOTECA',
    title: 'Ejercicios',
    description: 'Encuentra movimientos para tu rutina y descubre nuevas formas de entrenar.',
  );
}
