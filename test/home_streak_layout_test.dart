import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:forza/app/localization/generated/app_localizations.dart';
import 'package:forza/app/theme/app_theme.dart';
import 'package:forza/ui/features/home/views/home_view.dart';
import 'package:forza/ui/features/profile/models/profile_settings.dart';

void main() {
  for (final width in [320.0, 375.0, 490.0]) {
    testWidgets('Home streak layout fits at ${width.toInt()} px', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = Size(width, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.dark,
          locale: const Locale('en'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: [
            AppLocalizations.delegate,
            ...GlobalMaterialLocalizations.delegates,
          ],
          home: MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: Scaffold(
              body: SafeArea(
                child: HomeView(
                  onShowActivity: () {},
                  onShowProfile: () {},
                  settings: const TrainingSettings(),
                  onStartWorkout: (_) {},
                  onEditPlan: () {},
                  completedDates: const {},
                  streakDays: 30,
                  streakAnimationFrom: 29,
                  streakAnimationRevision: 1,
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Your training plan'), findsOneWidget);
      expect(
        find.byKey(const ValueKey('home-streak-indicator')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);

      if (width == 490) {
        final title = tester.getRect(find.text('Your training plan'));
        final streak = tester.getRect(
          find.byKey(const ValueKey('home-streak-indicator')),
        );
        expect((title.center.dy - streak.center.dy).abs(), lessThan(1));
      }
    });
  }
}
