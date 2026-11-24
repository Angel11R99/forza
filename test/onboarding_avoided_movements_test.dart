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
    final createButton = tester.widget<FilledButton>(
      find.ancestor(
        of: find.text('Crear mi plan'),
        matching: find.byType(FilledButton),
      ),
    );
    expect(createButton.onPressed, isNull);
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
