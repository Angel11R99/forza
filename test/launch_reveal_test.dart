import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:forza/app/theme/app_theme.dart';
import 'package:forza/ui/core/widgets/launch_reveal.dart';

void main() {
  testWidgets('reveals the light theme in a circle then shows the app', (
    tester,
  ) async {
    await tester.pumpWidget(_testApp(isDark: false));
    await tester.pump();

    expect(find.byKey(const Key('launch-reveal-overlay')), findsOneWidget);
    expect(
      tester
          .widget<ColoredBox>(find.byKey(const Key('launch-reveal-base')))
          .color,
      Colors.white,
    );
    expect(
      tester
          .widget<ColoredBox>(
            find.byKey(const Key('launch-reveal-circle-color')),
          )
          .color,
      Colors.black,
    );

    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byKey(const Key('launch-reveal-circle')), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byKey(const Key('launch-reveal-overlay')), findsNothing);
    expect(find.byKey(const Key('app-content')), findsOneWidget);
  });

  testWidgets('uses the inverse colors for the dark theme', (tester) async {
    await tester.pumpWidget(_testApp(isDark: true));

    expect(
      tester
          .widget<ColoredBox>(find.byKey(const Key('launch-reveal-base')))
          .color,
      Colors.black,
    );
    expect(
      tester
          .widget<ColoredBox>(
            find.byKey(const Key('launch-reveal-circle-color')),
          )
          .color,
      Colors.white,
    );
  });

  testWidgets('skips the reveal when reduced motion is enabled', (
    tester,
  ) async {
    await tester.pumpWidget(_testApp(reduceMotion: true));

    expect(find.byKey(const Key('launch-reveal-overlay')), findsNothing);
    expect(find.byKey(const Key('app-content')), findsOneWidget);
  });

  testWidgets('waits until saved appearance has been restored', (tester) async {
    await tester.pumpWidget(_testApp(isReady: false));
    await tester.pump(const Duration(seconds: 1));

    expect(find.byKey(const Key('launch-reveal-overlay')), findsOneWidget);

    await tester.pumpWidget(_testApp(isReady: true));
    await tester.pump();
    expect(find.byKey(const Key('launch-reveal-overlay')), findsOneWidget);
  });
}

Widget _testApp({
  bool isDark = false,
  bool reduceMotion = false,
  bool isReady = true,
}) => MaterialApp(
  theme: AppTheme.light,
  darkTheme: AppTheme.dark,
  themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
  builder: (context, child) => MediaQuery(
    data: MediaQuery.of(context).copyWith(disableAnimations: reduceMotion),
    child: LaunchReveal(
      isDark: isDark,
      isReady: isReady,
      child: const ColoredBox(
        key: Key('app-content'),
        color: Colors.transparent,
      ),
    ),
  ),
);
