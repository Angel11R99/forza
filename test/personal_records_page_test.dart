import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:forza/app/localization/generated/app_localizations.dart';
import 'package:forza/app/theme/app_theme.dart';
import 'package:forza/domain/models/workout_record.dart';
import 'package:forza/ui/features/progress/views/progress_detail_pages.dart';

void main() {
  testWidgets('shows an empty state without invented records', (tester) async {
    await _pump(tester, const []);

    expect(find.textContaining('Todavía no hay marcas'), findsOneWidget);
    expect(find.text('67.5 kg'), findsNothing);
  });

  testWidgets('shows the best real value, unit and date', (tester) async {
    final date = DateTime(2026, 6, 2);
    await _pump(tester, [
      WorkoutRecord(
        scheduledDate: date,
        completedAt: date.add(const Duration(hours: 1)),
        title: 'Sesión',
        goal: 'Fuerza',
        durationMinutes: 40,
        exerciseCount: 1,
        exercises: const ['Press de banca con barra'],
        exerciseIds: const ['bench'],
        setResults: const [
          WorkoutSetResult(
            exercisePosition: 0,
            setIndex: 0,
            repetitions: 8,
            loadKg: 50,
          ),
        ],
      ),
    ]);

    expect(find.text('Press de banca con barra'), findsNWidgets(2));
    expect(find.text('50 kg'), findsOneWidget);
    expect(find.text('8 rep'), findsOneWidget);
    expect(find.textContaining('jun'), findsNWidgets(2));
  });
}

Future<void> _pump(WidgetTester tester, List<WorkoutRecord> records) async {
  tester.view.physicalSize = const Size(800, 1200);
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
      home: PersonalRecordsPage(records: records),
    ),
  );
}
