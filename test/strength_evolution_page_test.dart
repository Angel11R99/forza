import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:forza/app/localization/generated/app_localizations.dart';
import 'package:forza/app/theme/app_theme.dart';
import 'package:forza/domain/models/workout_record.dart';
import 'package:forza/ui/features/progress/views/progress_detail_pages.dart';

void main() {
  testWidgets('shows a useful empty state when there are no weighted sets', (
    tester,
  ) async {
    await _pump(tester, const []);

    expect(find.textContaining('No hay series con carga'), findsOneWidget);
    expect(find.text('40.0 kg'), findsNothing);
  });

  testWidgets('charts real loads and selecting a period filters the series', (
    tester,
  ) async {
    final today = DateTime.now();
    final records = [
      _record(
        today.subtract(const Duration(days: 50)),
        'Press de banca',
        'bench',
        48,
      ),
      _record(
        today.subtract(const Duration(days: 4)),
        'Press de banca',
        'bench',
        55,
      ),
    ];
    await _pump(tester, records);

    expect(find.text('48.0 kg'), findsOneWidget);
    expect(find.text('55.0 kg'), findsOneWidget);
    await tester.tap(find.text('30 días'));
    await tester.pumpAndSettle();
    expect(find.textContaining('No hay series con carga'), findsNothing);
    expect(find.text('55.0 kg'), findsNWidgets(2));

    await tester.tap(find.text('Todo'));
    await tester.pumpAndSettle();
    expect(find.text('48.0 kg'), findsOneWidget);
    expect(find.text('55.0 kg'), findsOneWidget);
  });
}

Future<void> _pump(WidgetTester tester, List<WorkoutRecord> records) async {
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
      home: StrengthEvolutionPage(records: records),
    ),
  );
}

WorkoutRecord _record(DateTime date, String name, String id, double load) =>
    WorkoutRecord(
      scheduledDate: date,
      completedAt: date.add(const Duration(hours: 1)),
      title: 'Entrenamiento',
      goal: 'Fuerza',
      durationMinutes: 45,
      exerciseCount: 1,
      exercises: [name],
      exerciseIds: [id],
      setResults: [
        WorkoutSetResult(exercisePosition: 0, setIndex: 0, loadKg: load),
      ],
    );
