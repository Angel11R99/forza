import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:forza/app/localization/generated/app_localizations.dart';
import 'package:forza/app/theme/app_theme.dart';
import 'package:forza/domain/models/scheduled_training_session.dart';
import 'package:forza/ui/features/home/views/home_view.dart';
import 'package:forza/ui/features/profile/models/profile_settings.dart';

void main() {
  testWidgets('shows tomorrow session but does not allow starting it', (
    tester,
  ) async {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    var startRequested = false;
    tester.view.physicalSize = const Size(400, 900);
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
        home: Scaffold(
          body: HomeView(
            onShowActivity: () {},
            onShowProfile: () {},
            settings: TrainingSettings(
              trainingDays: {tomorrow.weekday},
              equipment: const {'Peso corporal'},
            ),
            onStartWorkout: (_) => startRequested = true,
            onEditPlan: () {},
            completedDates: const {},
            scheduledSessions: [
              ScheduledTrainingSession(
                id: tomorrow.toIso8601String(),
                scheduledDate: tomorrow,
                sessionIndex: 0,
                title: 'Tren superior',
                focus: 'Pecho, espalda y hombros',
                durationMinutes: 45,
                exerciseCount: 4,
              ),
            ],
          ),
        ),
      ),
    );

    final weekday = DateFormat.EEEE('es').format(tomorrow);
    final availableButton = find.widgetWithText(
      FilledButton,
      'Disponible el $weekday',
    );
    expect(availableButton, findsOneWidget);
    expect(tester.widget<FilledButton>(availableButton).onPressed, isNull);
    expect(find.text('Ver sesión de hoy'), findsNothing);
    expect(startRequested, isFalse);
  });
}
