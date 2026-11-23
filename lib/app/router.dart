import 'package:material_ui/material_ui.dart';

import 'theme/appearance_controller.dart';
import '../ui/core/widgets/app_scaffold.dart';
import 'localization/locale_controller.dart';

abstract final class AppRoutes {
  static const home = '/';
  static const activity = '/activity';
  static const exercises = '/exercises';
  static const progress = '/progress';
  static const profile = '/profile';
}

abstract final class AppRouter {
  static Route<void> onGenerateRoute(
    RouteSettings settings, {
    required AppearanceController appearance,
    required LocaleController localeController,
  }) {
    final initialIndex = switch (settings.name) {
      AppRoutes.home => 0,
      AppRoutes.activity => 1,
      AppRoutes.exercises => 2,
      AppRoutes.progress => 3,
      AppRoutes.profile => 4,
      _ => 0,
    };

    return MaterialPageRoute<void>(
      settings: settings,
      builder: (_) =>
          AppScaffold(
            initialIndex: initialIndex,
            appearance: appearance,
            localeController: localeController,
          ),
    );
  }
}
