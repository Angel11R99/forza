import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:forza/app/localization/generated/app_localizations.dart';
import 'package:forza/app/theme/app_theme.dart';
import 'package:forza/data/database/app_database.dart' show AppDatabase;
import 'package:forza/data/repositories/workout_log_repository.dart';
import 'package:forza/domain/models/scheduled_training_session.dart';
import 'package:forza/domain/models/workout_record.dart';
import 'package:forza/ui/features/activity/views/activity_view.dart';
import 'package:forza/ui/features/profile/models/profile_settings.dart';

void main() {
  testWidgets('calendar shows status legend and a Today shortcut on mobile', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final today = DateTime.now();
    final record = WorkoutRecord(
      scheduledDate: today,
      completedAt: today,
      title: 'Workout',
      goal: 'Ganar fuerza',
      durationMinutes: 30,
      exerciseCount: 3,
    );

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
          body: ActivityView(
            settings: const TrainingSettings(),
            records: [record],
            onWorkoutCompleted: (_) async {},
            onSessionClosed: () async {},
            workoutLogRepository: WorkoutLogRepository(database: database),
            scheduledSessions: [
              ScheduledTrainingSession(
                id: today.toIso8601String(),
                scheduledDate: today,
                sessionIndex: 0,
                title: 'Entrenamiento',
                focus: '',
                durationMinutes: 30,
                exerciseCount: 3,
                status: 'completed',
              ),
            ],
            onRescheduleSession: (_, _) async => false,
            onSessionStarted: (_) async => false,
            onSkipSession: (_) async => false,
            onUndoSkipSession: (_) async => false,
          ),
        ),
      ),
    );

    expect(find.byTooltip('Hoy'), findsOneWidget);
    expect(find.text('completada'), findsOneWidget);
    expect(find.text('pendiente'), findsOneWidget);
    expect(find.text('omitida'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.byTooltip('Mes siguiente'));
    await tester.pump(const Duration(milliseconds: 300));
    final nextMonth = DateTime(today.year, today.month + 1);
    expect(find.text(DateFormat.yMMMM('es').format(nextMonth)), findsOneWidget);

    await tester.tap(find.byTooltip('Hoy'));
    await tester.pump();
    expect(find.text(DateFormat.yMMMM('es').format(today)), findsOneWidget);
    expect(find.text('Detalle del día'), findsOneWidget);
  });
}
