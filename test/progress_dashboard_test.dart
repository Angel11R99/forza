import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:forza/app/localization/generated/app_localizations.dart';
import 'package:forza/app/theme/app_theme.dart';
import 'package:forza/domain/models/body_measurement.dart';
import 'package:forza/domain/models/workout_record.dart';
import 'package:forza/ui/features/progress/views/progress_view.dart';

Widget _app({
  required List<WorkoutRecord> records,
  List<BodyMeasurement> measurements = const [],
  VoidCallback onShowActivity = _noop,
}) => MaterialApp(
  theme: AppTheme.light,
  locale: const Locale('es'),
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: [
    AppLocalizations.delegate,
    ...GlobalMaterialLocalizations.delegates,
  ],
  home: Scaffold(
    body: ProgressView(
      records: records,
      onShowActivity: onShowActivity,
      measurements: measurements,
      onSaveGoal: (_) async {},
      onDeleteGoal: (_) async {},
      onSaveMeasurement: (_, {previous}) async {},
      onDeleteMeasurement: (_) async {},
    ),
  ),
);

void _noop() {}

void main() {
  testWidgets('empty progress offers a real next action without fake zeros', (
    tester,
  ) async {
    var activityOpened = false;
    await tester.pumpWidget(
      _app(records: const [], onShowActivity: () => activityOpened = true),
    );

    expect(find.text('0'), findsNothing);
    expect(find.textContaining('series registradas'), findsNothing);
    expect(
      find.text(
        'Completa una sesión y registra tus series para empezar a ver tus resultados.',
      ),
      findsOneWidget,
    );
    await tester.tap(find.text('Ir a Actividad'));
    expect(activityOpened, isTrue);
  });

  testWidgets('workouts without set data do not show zero as a trend', (
    tester,
  ) async {
    final today = DateTime.now();
    final record = WorkoutRecord(
      scheduledDate: today,
      completedAt: today,
      title: 'Cuerpo completo',
      goal: 'Fuerza',
      durationMinutes: 35,
      exerciseCount: 4,
    );

    await tester.pumpWidget(_app(records: [record]));

    expect(find.text('1'), findsOneWidget);
    expect(find.text('Sin series registradas'), findsOneWidget);
    expect(find.text('Sin datos de carga'), findsOneWidget);
    expect(find.textContaining('Último entrenamiento'), findsOneWidget);
  });

  testWidgets('history periods reveal older workouts and keep the list lazy', (
    tester,
  ) async {
    final today = DateTime.now();
    final records = List.generate(
      120,
      (index) => WorkoutRecord(
        scheduledDate: today.subtract(Duration(days: 400 + index)),
        completedAt: today.subtract(Duration(days: 400 + index)),
        title: 'Sesión antigua $index',
        goal: 'Fuerza',
        durationMinutes: 30,
        exerciseCount: 2,
      ),
    );

    await tester.pumpWidget(_app(records: records));

    final historyHeading = find.text('Historial de entrenamientos');
    await tester.dragUntilVisible(
      historyHeading,
      find.byType(Scrollable).first,
      const Offset(0, -500),
    );
    await tester.pumpAndSettle();
    expect(find.text('No hay entrenamientos en este período.'), findsOneWidget);
    final allTimeChip = find.widgetWithText(ChoiceChip, 'Todo');
    await tester.ensureVisible(allTimeChip);
    await tester.tap(allTimeChip);
    await tester.pumpAndSettle();

    expect(find.text('Sesión antigua 0'), findsWidgets);
    expect(find.text('Sesión antigua 119'), findsNothing);
  });

  testWidgets(
    'measurements show a real change and overview cards open details',
    (tester) async {
      final today = DateTime.now();
      final measurementOld = BodyMeasurement(
        date: today.subtract(const Duration(days: 12)),
        weightKg: 70,
      );
      final measurementNew = BodyMeasurement(
        date: today.subtract(const Duration(days: 2)),
        weightKg: 71.2,
      );
      final record = WorkoutRecord(
        scheduledDate: today,
        completedAt: today,
        title: 'Tren inferior',
        goal: 'Fuerza',
        durationMinutes: 40,
        exerciseCount: 1,
        exercises: const ['Sentadilla'],
        setResults: const [
          WorkoutSetResult(
            exercisePosition: 0,
            setIndex: 0,
            repetitions: 8,
            loadKg: 50,
          ),
        ],
      );

      await tester.pumpWidget(
        _app(records: [record], measurements: [measurementNew, measurementOld]),
      );

      expect(
        find.textContaining('Cambio desde la medición anterior: +1.2 kg'),
        findsOneWidget,
      );
      expect(
        find.textContaining('Marca reciente · Sentadilla'),
        findsOneWidget,
      );

      final strengthCard = find.text(
        'Compara la mayor carga registrada por sesión para cada ejercicio.',
      );
      await tester.ensureVisible(strengthCard);
      await tester.pump();
      await tester.tap(strengthCard);
      await tester.pumpAndSettle();
      expect(find.text('Evolución de fuerza'), findsWidgets);
      Navigator.of(tester.element(find.byType(Scaffold).last)).pop();
      await tester.pumpAndSettle();

      final recentRecord = find.textContaining('Marca reciente · Sentadilla');
      await tester.ensureVisible(recentRecord);
      await tester.pump();
      await tester.tap(recentRecord);
      await tester.pumpAndSettle();
      expect(find.text('Récords personales'), findsOneWidget);
    },
  );
}
