import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';

import 'router.dart';
import 'localization/device_time_format.dart';
import 'theme/appearance_controller.dart';
import 'theme/app_theme.dart';
import 'localization/locale_controller.dart';
import 'localization/generated/app_localizations.dart';
import '../ui/core/widgets/launch_reveal.dart';

class ForzaApp extends StatefulWidget {
  const ForzaApp({super.key});

  @override
  State<ForzaApp> createState() => _ForzaAppState();
}

class _ForzaAppState extends State<ForzaApp> {
  final _appearance = AppearanceController();
  final _localeController = LocaleController();

  @override
  void initState() {
    super.initState();
    _appearance.restore();
    _localeController.restore();
  }

  @override
  void dispose() {
    _appearance.dispose();
    _localeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([_appearance, _localeController]),
      builder: (context, _) => MaterialApp(
        title: 'FORZA',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: _appearance.mode,
        builder: (context, child) {
          final isDark = switch (_appearance.mode) {
            ThemeMode.dark => true,
            ThemeMode.light => false,
            ThemeMode.system =>
              MediaQuery.platformBrightnessOf(context) == Brightness.dark,
          };
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: isDark
                  ? Brightness.light
                  : Brightness.dark,
              statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
              systemNavigationBarColor: Colors.transparent,
              systemNavigationBarDividerColor: Colors.transparent,
              systemNavigationBarIconBrightness: isDark
                  ? Brightness.light
                  : Brightness.dark,
              systemNavigationBarContrastEnforced: false,
            ),
            child: LaunchReveal(
              isDark: isDark,
              isReady: _appearance.isRestored,
              child: child ?? const SizedBox.shrink(),
            ),
          );
        },
        locale: _localeController.locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localeListResolutionCallback: (locales, supportedLocales) {
          for (final locale in locales ?? const <Locale>[]) {
            if (supportedLocales.any(
              (supported) => supported.languageCode == locale.languageCode,
            )) {
              return locale;
            }
          }
          return supportedLocales.first;
        },
        localizationsDelegates: [
          AppLocalizations.delegate,
          const DominicanMaterialLocalizationsDelegate(),
          ...GlobalMaterialLocalizations.delegates,
        ],
        initialRoute: AppRoutes.home,
        onGenerateRoute: (settings) => AppRouter.onGenerateRoute(
          settings,
          appearance: _appearance,
          localeController: _localeController,
        ),
      ),
    );
  }
}
