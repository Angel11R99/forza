import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:forza/app/localization/generated/app_localizations.dart';
import 'package:forza/app/theme/app_theme.dart';
import 'package:forza/data/database/app_database.dart';
import 'package:forza/data/repositories/workout_log_repository.dart';
import 'package:forza/ui/features/onboarding/views/training_session_flow.dart';
import 'package:forza/ui/features/profile/models/profile_settings.dart';

void main() {
  testWidgets('exit control confirms leaving and can return to workout', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    final repository = WorkoutLogRepository(database: database);
    await tester.runAsync(() async {
      await database.customSelect('SELECT 1').get();
    });

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('es'),
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: [
          AppLocalizations.delegate,
          ...GlobalMaterialLocalizations.delegates,
        ],
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: TextButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => TrainingSessionFlow(
                      settings: const TrainingSettings(),
                      workoutLogRepository: repository,
                      scheduledDate: DateTime(2026, 11, 24),
                    ),
                  ),
                ),
                child: const Text('Abrir sesión'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Abrir sesión'));
    await tester.pump();
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );
    await tester.pump();
    for (
      var attempt = 0;
      attempt < 30 && find.text('Ver calentamiento').evaluate().isEmpty;
      attempt++
    ) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    await tester.tap(find.text('Ver calentamiento'));
    await tester.pump();
    await tester.tap(find.text('Comenzar entrenamiento'));
    await tester.pump();

    tester
        .widget<IconButton>(
          find.byWidgetPredicate(
            (widget) =>
                widget is IconButton &&
                widget.tooltip == 'Salir del entrenamiento',
          ),
        )
        .onPressed!();
    await tester.pump();
    expect(find.text('¿Quieres abandonar?'), findsOneWidget);

    await tester.tap(find.text('Seguir entrenando'));
    await tester.pump();
    expect(find.text('¿Quieres abandonar?'), findsNothing);
    expect(find.byTooltip('Salir del entrenamiento'), findsOneWidget);

    tester
        .widget<IconButton>(
          find.byWidgetPredicate(
            (widget) =>
                widget is IconButton &&
                widget.tooltip == 'Salir del entrenamiento',
          ),
        )
        .onPressed!();
    await tester.pump();
    await tester.tap(find.text('Sí, abandonar'));
    await tester.pumpAndSettle();
    expect(find.text('Abrir sesión'), findsOneWidget);
    expect(await repository.loadActiveWorkout(), isNull);

    await database.close();
  });
}
