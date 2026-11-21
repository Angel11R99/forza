import 'package:material_ui/material_ui.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
      locale: const Locale('es', 'DO'),
      supportedLocales: const [Locale('es', 'DO')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      initialRoute: AppRoutes.home,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
