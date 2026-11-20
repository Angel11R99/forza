import 'package:material_ui/material_ui.dart';

import '../../../core/widgets/feature_placeholder_view.dart';

class ActivityView extends StatelessWidget {
  const ActivityView({super.key});

  @override
  Widget build(BuildContext context) => const FeaturePlaceholderView(
    icon: Icons.calendar_month_outlined,
    eyebrow: 'TU RITMO, A TU MANERA',
    title: 'Actividad',
    description: 'Aquí podrás organizar tus sesiones y consultar tu calendario de entrenamiento.',
  );
}
