import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:forza/app/localization/generated/app_localizations.dart';
import 'package:forza/app/theme/app_theme.dart';
import 'package:forza/ui/features/onboarding/views/onboarding_view.dart';

void main() {
  testWidgets(
    'allows seven days and warns that no full rest day is scheduled',
    (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          locale: const Locale('es'),
          localizationsDelegates: [
            AppLocalizations.delegate,
            ...GlobalMaterialLocalizations.delegates,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: const OnboardingView(),
        ),
      );

      await tester.tap(find.text('Continuar'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Continuar'));
      await tester.pumpAndSettle();

      for (final day in [2, 4, 7]) {
        final chip = find.byKey(ValueKey('training-day-$day'));
        await tester.ensureVisible(chip);
        await tester.tap(chip);
        await tester.pumpAndSettle();
      }
      expect(find.text('7 sesiones por semana'), findsOneWidget);
      expect(
        find.textContaining('Puedes elegir los siete días'),
        findsOneWidget,
      );

      final saturday = find.byKey(const ValueKey('training-day-6'));
      await tester.ensureVisible(saturday);
      await tester.tap(saturday);
      await tester.pumpAndSettle();
      expect(find.text('6 sesiones por semana'), findsOneWidget);
      expect(find.textContaining('frecuencia alta'), findsOneWidget);
    },
  );
}
