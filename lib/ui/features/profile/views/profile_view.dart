import 'package:material_ui/material_ui.dart';

import '../../../core/widgets/feature_placeholder_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) => const FeaturePlaceholderView(
    icon: Icons.person_outline_rounded,
    eyebrow: 'TU CUENTA',
    title: 'Perfil',
    description: 'Más adelante podrás personalizar tu perfil y tus preferencias de entrenamiento.',
  );
}
