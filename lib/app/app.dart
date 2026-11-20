import 'package:material_ui/material_ui.dart';

import 'router.dart';
import 'theme/app_theme.dart';

class ForzaApp extends StatelessWidget {
  const ForzaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FORZA',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppRoutes.home,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
