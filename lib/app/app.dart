import 'package:material_ui/material_ui.dart';

import 'router.dart';
import 'theme/appearance_controller.dart';
import 'theme/app_theme.dart';

class ForzaApp extends StatefulWidget {
  const ForzaApp({super.key});

  @override
  State<ForzaApp> createState() => _ForzaAppState();
}

class _ForzaAppState extends State<ForzaApp> {
  final _appearance = AppearanceController();

  @override
  void initState() {
    super.initState();
    _appearance.restore();
  }

  @override
  void dispose() {
    _appearance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _appearance,
      builder: (context, _) => MaterialApp(
        title: 'FORZA',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: _appearance.mode,
        locale: const Locale('es', 'DO'),
        supportedLocales: const [Locale('es', 'DO')],
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        initialRoute: AppRoutes.home,
        onGenerateRoute: (settings) =>
            AppRouter.onGenerateRoute(settings, appearance: _appearance),
      ),
    );
  }
}
