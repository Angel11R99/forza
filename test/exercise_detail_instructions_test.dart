import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:forza/app/localization/generated/app_localizations.dart';
import 'package:forza/app/theme/app_colors.dart';
import 'package:forza/app/theme/app_theme.dart';
import 'package:forza/domain/models/exercise.dart';
import 'package:forza/domain/repositories/exercise_repository.dart';
import 'package:forza/ui/core/widgets/app_surface_card.dart';
import 'package:forza/ui/features/exercises/views/exercise_detail_page.dart';

void main() {
  testWidgets('source citation opens its HTTPS URL', (tester) async {
    Uri? openedUri;
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    const guidedExercise = Exercise(
      id: 'guided-deadlift',
      name: 'Peso muerto',
      englishName: 'Deadlift',
      muscleGroup: 'Espalda',
      equipment: 'Barra',
      instructions: ['Levanta la barra con control.'],
      englishInstructions: ['Lift the bar with control.'],
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        locale: const Locale('es'),
        localizationsDelegates: [
          AppLocalizations.delegate,
          ...GlobalMaterialLocalizations.delegates,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: ExerciseDetailPage(
          exercise: guidedExercise,
          repository: _EmptyExerciseRepository(),
          sourceLinkLauncher: (uri) async {
            openedUri = uri;
            return true;
          },
        ),
      ),
    );

    final sourceLink = find.textContaining('Enlace de la fuente:');
    expect(sourceLink, findsOneWidget);
    await tester.tap(sourceLink);
    await tester.pump();

    expect(openedUri?.scheme, 'https');
    expect(openedUri?.host, 'www.acefitness.org');
  });

  const exercise = Exercise(
    id: 'guide-test',
    name: 'Movimiento de prueba',
    englishName: 'Test movement',
    muscleGroup: 'Pecho',
    equipment: 'Peso corporal',
    instructions: [
      'Coloca las manos en el suelo, un poco más separadas que los hombros.',
      'Baja el cuerpo de forma controlada y vuelve a empujar hasta extender los brazos.',
    ],
    englishInstructions: [
      'Place your hands on the floor slightly wider than your shoulders.',
      'Lower your body with control, then push back up until your arms extend.',
    ],
  );

  for (final (brightness, languageCode) in [
    (Brightness.light, 'es'),
    (Brightness.dark, 'en'),
  ]) {
    testWidgets(
      'instruction steps use separate themed cards at 320 px (${brightness.name})',
      (tester) async {
        tester.view.physicalSize = const Size(320, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: brightness == Brightness.light
                ? ThemeMode.light
                : ThemeMode.dark,
            locale: Locale(languageCode),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: [
              AppLocalizations.delegate,
              ...GlobalMaterialLocalizations.delegates,
            ],
            home: ExerciseDetailPage(
              exercise: exercise,
              repository: _EmptyExerciseRepository(),
            ),
          ),
        );

        expect(find.byType(AppSurfaceCard), findsNWidgets(2));
        final stepLabel = languageCode == 'es' ? 'Paso' : 'Step';
        final instructions = languageCode == 'es'
            ? exercise.instructions
            : exercise.englishInstructions;
        expect(find.text('$stepLabel 1'), findsOneWidget);
        expect(find.text('$stepLabel 2'), findsOneWidget);
        expect(find.text(instructions[0]), findsOneWidget);
        expect(find.text(instructions[1]), findsOneWidget);

        final firstCard = find.ancestor(
          of: find.text('$stepLabel 1'),
          matching: find.byType(AppSurfaceCard),
        );
        final cardMaterial = tester.widget<Material>(
          find.descendant(of: firstCard, matching: find.byType(Material)),
        );
        expect(
          cardMaterial.color,
          brightness == Brightness.light
              ? AppColors.light.surface
              : AppColors.dark.surface,
        );
        expect(tester.takeException(), isNull);
      },
    );
  }
}

class _EmptyExerciseRepository implements ExerciseRepository {
  @override
  bool get isLoaded => true;

  @override
  Future<void> load() async {}

  @override
  List<String> get muscleGroups => const [];

  @override
  List<String> get equipmentTypes => const [];

  @override
  List<Exercise> search({
    String query = '',
    Set<String> muscleGroups = const {},
    Set<String> equipment = const {},
  }) => const [];

  @override
  Exercise? findById(String id) => null;

  @override
  List<Exercise> alternativesFor(Exercise exercise) => const [];
}
