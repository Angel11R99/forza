import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:forza/app/localization/generated/app_localizations.dart';
import 'package:forza/app/theme/app_theme.dart';
import 'package:forza/domain/use_cases/training_plan_builder.dart';
import 'package:forza/ui/features/onboarding/views/onboarding_view.dart';
import 'package:forza/ui/features/profile/models/profile_settings.dart';

void main() {
  testWidgets('selected movement exclusion is returned with plan settings', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    TrainingSettings? result;
    await _pump(
      tester,
      onOpen: (context) async {
        result = await Navigator.of(context).push<TrainingSettings>(
          MaterialPageRoute<TrainingSettings>(
            builder: (_) => const OnboardingView(),
          ),
        );
      },
    );

    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    for (var step = 0; step < 3; step++) {
      await tester.tap(find.text('Continuar'));
      await tester.pumpAndSettle();
    }

    final movement = find.text('Press con mancuernas');
    await tester.ensureVisible(movement);
    final chipFinder = find.ancestor(
      of: movement,
      matching: find.byType(FilterChip),
    );
    expect(tester.widget<FilterChip>(chipFinder).selected, isFalse);
    await tester.tap(movement);
    await tester.pumpAndSettle();
    expect(tester.widget<FilterChip>(chipFinder).selected, isTrue);

    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Movimientos excluidos:'), findsOneWidget);
    expect(
      find.textContaining('La rutina prioriza opciones compatibles'),
      findsOneWidget,
    );
    await tester.tap(find.text('Crear mi plan'));
    await tester.pumpAndSettle();

    expect(result?.avoidedExerciseIds, contains('1700'));
  });

  testWidgets('disables creation and explains when there are no alternatives', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final allAvoided = TrainingPlanBuilder().exerciseOptions
        .map((exercise) => exercise.catalogId)
        .toSet();
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        locale: const Locale('es'),
        localizationsDelegates: [
          AppLocalizations.delegate,
          ...GlobalMaterialLocalizations.delegates,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: OnboardingView(
          initialSettings: TrainingSettings(avoidedExerciseIds: allAvoided),
        ),
      ),
    );

    for (var step = 0; step < 4; step++) {
      await tester.tap(find.text('Continuar'));
      await tester.pumpAndSettle();
    }

    expect(find.textContaining('No hay ejercicios compatibles'), findsWidgets);
    expect(
      find.textContaining(
        'Al menos una sesión quedó sin ejercicios compatibles',
      ),
      findsOneWidget,
    );
    final createButton = tester.widget<FilledButton>(
      find.ancestor(
        of: find.text('Crear mi plan'),
        matching: find.byType(FilledButton),
      ),
    );
    expect(createButton.onPressed, isNull);
  });

  testWidgets('review edits return to summary and expand real prescriptions', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 720);
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
        home: const OnboardingView(isFirstRun: true),
      ),
    );

    for (var step = 0; step < 4; step++) {
      await tester.tap(find.text('Continuar'));
      await tester.pumpAndSettle();
    }
    expect(find.text('Objetivo'), findsOneWidget);
    expect(find.textContaining('presupuesto ~45 min'), findsOneWidget);

    await tester.ensureVisible(find.text('Objetivo'));
    await tester.tap(find.text('Objetivo'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Crear el hábito'));
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();
    expect(find.text('Crear el hábito'), findsOneWidget);

    final firstSession = find.byType(ExpansionTile).first;
    await tester.ensureVisible(firstSession);
    await tester.tap(firstSession);
    await tester.pumpAndSettle();
    expect(find.textContaining('repeticiones a ritmo cómodo'), findsWidgets);

    await tester.ensureVisible(find.text('Días y duración'));
    await tester.tap(find.text('Días y duración'));
    await tester.pumpAndSettle();
    final tuesday = find.byKey(const ValueKey('training-day-2'));
    await tester.ensureVisible(tuesday);
    await tester.tap(tuesday);
    await tester.pumpAndSettle();
    expect(tester.widget<FilterChip>(tuesday).selected, isTrue);
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();

    expect(find.textContaining('5 días'), findsOneWidget);
    expect(find.byType(ExpansionTile), findsNWidgets(5));
  });

  testWidgets('English review localizes the exercise prescriptions', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 720);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        locale: const Locale('en'),
        localizationsDelegates: [
          AppLocalizations.delegate,
          ...GlobalMaterialLocalizations.delegates,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: const OnboardingView(),
      ),
    );

    for (var step = 0; step < 4; step++) {
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
    }
    expect(find.text('Goal'), findsOneWidget);
    final firstSession = find.byType(ExpansionTile).first;
    await tester.ensureVisible(firstSession);
    await tester.tap(firstSession);
    await tester.pumpAndSettle();
    expect(find.textContaining('6–8 reps'), findsWidgets);
  });
}

Future<void> _pump(
  WidgetTester tester, {
  required Future<void> Function(BuildContext context) onOpen,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      locale: const Locale('es'),
      localizationsDelegates: [
        AppLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (context) => Scaffold(
          body: TextButton(
            onPressed: () => onOpen(context),
            child: const Text('Abrir'),
          ),
        ),
      ),
    ),
  );
}
