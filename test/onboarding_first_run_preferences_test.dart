import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:forza/app/localization/generated/app_localizations.dart';
import 'package:forza/app/theme/appearance_controller.dart';
import 'package:forza/app/theme/app_theme.dart';
import 'package:forza/ui/features/onboarding/views/onboarding_view.dart';

void main() {
  testWidgets('first run collects preferences and previews appearance', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 720);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final storage = _MemoryAppearancePreferences();
    final appearance = AppearanceController(preferences: storage);
    addTearDown(appearance.dispose);
    final hostKey = GlobalKey<_SetupHostState>();

    await tester.pumpWidget(_app(hostKey, appearance));
    await tester.tap(find.text('Open setup'));
    await tester.pumpAndSettle();
    for (var index = 0; index < 5; index++) {
      await tester.ensureVisible(find.text('Continuar'));
      await tester.tap(find.text('Continuar'));
      await tester.pumpAndSettle();
    }

    expect(find.text('A tu medida'), findsNWidgets(2));
    for (final label in ['Libras (lb)', 'Domingo', 'Oscuro']) {
      final option = find.text(label).last;
      await tester.ensureVisible(option);
      await tester.tap(option);
      await tester.pumpAndSettle();
    }
    await tester.tap(find.byType(Switch));
    expect(appearance.mode, ThemeMode.dark);

    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<ChoiceChip>(
            find.ancestor(
              of: find.text('Libras (lb)'),
              matching: find.byType(ChoiceChip),
            ),
          )
          .selected,
      isTrue,
    );
    expect(tester.widget<Switch>(find.byType(Switch)).value, isFalse);

    await tester.ensureVisible(find.text('Crear mi plan'));
    await tester.tap(find.text('Crear mi plan'));
    await tester.pumpAndSettle();
    final result = hostKey.currentState!.result as FirstRunOnboardingResult;
    expect(result.preferences.weightUnit, 'lb');
    expect(result.preferences.weekStartsOn, 'Domingo');
    expect(result.preferences.hapticsEnabled, isFalse);
    expect(result.appearanceMode, ThemeMode.dark);
  });

  testWidgets('cancel restores the appearance preview without saving', (
    tester,
  ) async {
    final storage = _MemoryAppearancePreferences();
    final appearance = AppearanceController(preferences: storage);
    await appearance.setMode(ThemeMode.light);
    final hostKey = GlobalKey<_SetupHostState>();
    await tester.pumpWidget(_app(hostKey, appearance));
    await tester.tap(find.text('Open setup'));
    await tester.pumpAndSettle();
    for (var index = 0; index < 5; index++) {
      await tester.tap(find.text('Continuar'));
      await tester.pumpAndSettle();
    }
    final darkOption = find.text('Oscuro');
    await tester.ensureVisible(darkOption);
    await tester.tap(darkOption);
    expect(appearance.mode, ThemeMode.dark);
    await tester.tap(find.text('Omitir por ahora'));
    await tester.pumpAndSettle();
    expect(appearance.mode, ThemeMode.light);
    expect(storage.savedValues, ['light']);
    expect(hostKey.currentState!.result, isNull);
    appearance.dispose();
  });
}

Widget _app(
  GlobalKey<_SetupHostState> hostKey,
  AppearanceController appearance,
) => MaterialApp(
  theme: AppTheme.light,
  darkTheme: AppTheme.dark,
  locale: const Locale('es'),
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: [
    AppLocalizations.delegate,
    ...GlobalMaterialLocalizations.delegates,
  ],
  home: _SetupHost(key: hostKey, appearance: appearance),
);

class _SetupHost extends StatefulWidget {
  const _SetupHost({super.key, required this.appearance});

  final AppearanceController appearance;

  @override
  State<_SetupHost> createState() => _SetupHostState();
}

class _SetupHostState extends State<_SetupHost> {
  Object? result;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: FilledButton(
        onPressed: () async {
          result = await Navigator.of(context).push<Object?>(
            MaterialPageRoute<Object?>(
              builder: (_) => OnboardingView(
                isFirstRun: true,
                appearanceController: widget.appearance,
              ),
            ),
          );
          setState(() {});
        },
        child: const Text('Open setup'),
      ),
    ),
  );
}

class _MemoryAppearancePreferences implements AppearancePreferences {
  String? value;
  final savedValues = <String>[];

  @override
  Future<String?> read(String key) async => value;

  @override
  Future<void> write(String key, String nextValue) async {
    value = nextValue;
    savedValues.add(nextValue);
  }
}
