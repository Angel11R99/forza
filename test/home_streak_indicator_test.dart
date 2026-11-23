import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:forza/app/localization/generated/app_localizations.dart';
import 'package:forza/app/theme/app_theme.dart';
import 'package:forza/ui/features/home/widgets/home_streak_indicator.dart';
import 'package:streak_flame/streak_flame.dart';

void main() {
  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('shows a readable streak in $mode without overflow', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: mode,
          locale: const Locale('es'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: [
            AppLocalizations.delegate,
            ...GlobalMaterialLocalizations.delegates,
          ],
          home: MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: const Scaffold(
              body: Center(
                child: HomeStreakIndicator(
                  days: 7,
                  animationFrom: 6,
                  animationRevision: 1,
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Racha actual'), findsOneWidget);
      expect(find.text('7 días'), findsOneWidget);
      final flame = tester.getRect(
        find.byKey(const ValueKey('home-streak-flame')),
      );
      final labels = tester.getRect(
        find.byKey(const ValueKey('home-streak-labels')),
      );
      expect((flame.center.dy - labels.center.dy).abs(), lessThan(1));
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('animates a real increase without overflowing the compact tile', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        locale: const Locale('es'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: [
          AppLocalizations.delegate,
          ...GlobalMaterialLocalizations.delegates,
        ],
        home: const Scaffold(
          body: Center(
            child: HomeStreakIndicator(
              days: 100,
              animationFrom: 99,
              animationRevision: 1,
            ),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 1100));

    expect(find.text('100 días'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('uses a cool color tier that advances with streak length', (
    WidgetTester tester,
  ) async {
    Future<void> showCount(int count) => tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        locale: const Locale('es'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: [
          AppLocalizations.delegate,
          ...GlobalMaterialLocalizations.delegates,
        ],
        home: MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: Scaffold(
            body: Center(
              child: HomeStreakIndicator(
                days: count,
                animationFrom: count,
                animationRevision: 0,
              ),
            ),
          ),
        ),
      ),
    );

    for (final sample in {
      6: const Color(0xFF64748B),
      7: const Color(0xFF0EA5E9),
      30: const Color(0xFF14B8A6),
      60: const Color(0xFF3B82F6),
      100: const Color(0xFF8B5CF6),
    }.entries) {
      await showCount(sample.key);
      final flame = tester.widget<StreakWidget>(find.byType(StreakWidget));
      expect(flame.palette.flameBase, sample.value);
    }
  });
}
