import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:table_calendar/table_calendar.dart';
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
      exercises: const ['Push-ups'],
      completedOutsideApp: true,
      planSnapshot: jsonEncode({
        'weekday': today.weekday,
        'title': 'Workout',
        'focus': 'Chest',
        'durationMinutes': 30,
        'exercises': [
          {
            'catalogId': 'push_up',
            'name': 'Push-ups',
            'focus': 'Chest',
            'prescription': '3 × 8',
            'timed': false,
          },
        ],
      }),
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
    final calendar = tester.widget<TableCalendar<dynamic>>(
      find.byKey(const ValueKey('activity-calendar')),
    );
    expect(
      (calendar.calendarStyle.todayDecoration as BoxDecoration).border,
      isNull,
    );
    expect(find.text('completada'), findsOneWidget);
    expect(find.text('pendiente'), findsOneWidget);
    expect(find.text('omitida'), findsOneWidget);
    expect(find.text('Registro real'), findsOneWidget);
    expect(find.text('Rutina prevista'), findsOneWidget);
    expect(find.text('Push-ups · 3 × 8'), findsOneWidget);
    expect(find.text('Push-ups'), findsOneWidget);
    expect(find.text('Repetir entrenamiento'), findsNothing);
    expect(find.textContaining('no hay series'), findsOneWidget);
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

  testWidgets('external workout registration asks before saving', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final today = DateTime.now();
    var saveCount = 0;
    tester.view.physicalSize = const Size(400, 1600);
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
          body: ActivityView(
            settings: const TrainingSettings(),
            records: const [],
            onWorkoutCompleted: (_) async {
              saveCount++;
            },
            onSessionClosed: () async {},
            workoutLogRepository: WorkoutLogRepository(database: database),
            scheduledSessions: [
              ScheduledTrainingSession(
                id: today.toIso8601String(),
                scheduledDate: today,
                sessionIndex: 0,
                title: 'Cuerpo completo',
                focus: 'Fuerza',
                durationMinutes: 30,
                exerciseCount: 3,
                status: 'pending',
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

    final moreActions = find.byWidgetPredicate(
      (widget) => widget is PopupMenuButton,
    );
    await tester.tap(moreActions);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ya entrené fuera de la app'));
    await tester.pumpAndSettle();
    expect(find.text('Registrar entrenamiento externo'), findsOneWidget);
    expect(saveCount, 0);
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
    expect(saveCount, 0);

    await tester.tap(moreActions);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ya entrené fuera de la app'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Confirmar'));
    await tester.pumpAndSettle();
    expect(saveCount, 1);
  });
}
