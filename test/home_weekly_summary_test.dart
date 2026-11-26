import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:forza/app/localization/generated/app_localizations.dart';
import 'package:forza/app/theme/app_theme.dart';
import 'package:forza/ui/features/home/views/home_view.dart';
import 'package:forza/ui/features/profile/models/profile_settings.dart';

void main() {
  testWidgets(
    'weekly summary uses configured target and shows all seven days',
    (tester) async {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final nextTrainingDay = today.add(const Duration(days: 2));

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          locale: const Locale('es'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: [
            AppLocalizations.delegate,
            ...GlobalMaterialLocalizations.delegates,
          ],
          home: Scaffold(
            body: HomeView(
              onShowActivity: () {},
              onShowProfile: () {},
              settings: TrainingSettings(
                trainingDays: {today.weekday, nextTrainingDay.weekday},
                equipment: const {'Peso corporal'},
              ),
              onStartWorkout: (_) {},
              onEditPlan: () {},
              completedDates: {today},
            ),
          ),
        ),
      );

      expect(find.text('1 de 2 sesiones'), findsOneWidget);
      await tester.ensureVisible(find.text('1 de 2 sesiones'));
      await tester.pump();
      final progress = tester.widgetList<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );
      expect(progress.last.value, 0.5);
    },
  );

  testWidgets('weekly progress stays in range when weekly target is empty', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        locale: const Locale('es'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: [
          AppLocalizations.delegate,
          ...GlobalMaterialLocalizations.delegates,
        ],
        home: Scaffold(
          body: HomeView(
            onShowActivity: () {},
            onShowProfile: () {},
            settings: const TrainingSettings(
              trainingDays: {},
              equipment: {'Peso corporal'},
            ),
            onStartWorkout: (_) {},
            onEditPlan: () {},
            completedDates: const {},
          ),
        ),
      ),
    );

    expect(find.text('0 de 0 sesiones'), findsOneWidget);
    final progress = tester.widgetList<LinearProgressIndicator>(
      find.byType(LinearProgressIndicator),
    );
    expect(progress.last.value, 0);
  });
}
