import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:forza/app/localization/device_time_format.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('es_DO uses regional 12-hour format and offers AM/PM', (
    tester,
  ) async {
    await _pumpTime(tester, const Locale('es', 'DO'));

    expect(find.textContaining('6:00'), findsOneWidget);
    expect(find.textContaining('18:00'), findsNothing);
    expect(find.text('h_colon_mm_space_a'), findsOneWidget);
  });

  testWidgets('es_ES keeps the regional 24-hour format', (tester) async {
    await _pumpTime(tester, const Locale('es', 'ES'));

    expect(find.text('18:00'), findsOneWidget);
    expect(find.text('H_colon_mm'), findsOneWidget);
  });

  testWidgets('es_DO distinguishes midnight and noon in 12-hour mode', (
    tester,
  ) async {
    await _pumpTime(tester, const Locale('es', 'DO'));

    final localizations = MaterialLocalizations.of(
      tester.element(find.byKey(const Key('open-time-picker'))),
    );
    final midnight = tester
        .widget<Text>(find.byKey(const Key('midnight')))
        .data!;
    final noon = tester.widget<Text>(find.byKey(const Key('noon'))).data!;
    expect(midnight, contains('12:00'));
    expect(midnight, contains(localizations.anteMeridiemAbbreviation));
    expect(noon, contains('12:00'));
    expect(noon, contains(localizations.postMeridiemAbbreviation));
  });

  testWidgets(
    'the es_DO time picker exposes its localized day-period control',
    (tester) async {
      await _pumpTime(tester, const Locale('es', 'DO'));
      await tester.tap(find.byKey(const Key('open-time-picker')));
      await tester.pumpAndSettle();

      final context = tester.element(find.byKey(const Key('open-time-picker')));
      final localizations = MaterialLocalizations.of(context);
      expect(find.text(localizations.postMeridiemAbbreviation), findsWidgets);
      expect(find.text(localizations.anteMeridiemAbbreviation), findsWidgets);
    },
  );

  testWidgets('the device 24-hour setting overrides es_DO regional fallback', (
    tester,
  ) async {
    await _pumpTime(
      tester,
      const Locale('es', 'DO'),
      alwaysUse24HourFormat: true,
    );

    expect(find.text('18:00'), findsOneWidget);
    expect(find.text('HH_colon_mm'), findsOneWidget);
  });
}

Future<void> _pumpTime(
  WidgetTester tester,
  Locale locale, {
  bool alwaysUse24HourFormat = false,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      locale: locale,
      supportedLocales: const [
        Locale('es'),
        Locale('es', 'DO'),
        Locale('es', 'ES'),
      ],
      localizationsDelegates: [
        DominicanMaterialLocalizationsDelegate(),
        ...GlobalMaterialLocalizations.delegates,
      ],
      home: Builder(
        builder: (context) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(alwaysUse24HourFormat: alwaysUse24HourFormat),
          child: Builder(
            builder: (context) => Column(
              children: [
                TextButton(
                  key: const Key('open-time-picker'),
                  onPressed: () => showTimePicker(
                    context: context,
                    initialTime: const TimeOfDay(hour: 18, minute: 0),
                  ),
                  child: const Text('Open time picker'),
                ),
                Text(
                  formatDeviceTimeOfDay(
                    context,
                    const TimeOfDay(hour: 18, minute: 0),
                  ),
                ),
                Text(
                  formatDeviceTimeOfDay(
                    context,
                    const TimeOfDay(hour: 0, minute: 0),
                  ),
                  key: const Key('midnight'),
                ),
                Text(
                  formatDeviceTimeOfDay(
                    context,
                    const TimeOfDay(hour: 12, minute: 0),
                  ),
                  key: const Key('noon'),
                ),
                Text(
                  MaterialLocalizations.of(context)
                      .timeOfDayFormat(
                        alwaysUse24HourFormat:
                            MediaQuery.alwaysUse24HourFormatOf(context),
                      )
                      .name,
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}
