import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:forza/app/localization/generated/app_localizations.dart';
import 'package:forza/domain/models/exercise.dart';
import 'package:forza/domain/models/personal_goal.dart';
import 'package:forza/domain/repositories/exercise_repository.dart';
import 'package:forza/ui/features/progress/views/personal_goal_editor_page.dart';

void main() {
  testWidgets(
    'goal editor searches localized catalog names and saves identity',
    (tester) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      PersonalGoal? savedGoal;
      final catalog = _FakeExerciseRepository();
      final navigatorKey = GlobalKey<NavigatorState>();
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: navigatorKey,
          locale: const Locale('es'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: [
            AppLocalizations.delegate,
            ...GlobalMaterialLocalizations.delegates,
          ],
          home: Scaffold(
            body: Builder(
              builder: (context) => Center(
                child: FilledButton(
                  onPressed: () async {
                    savedGoal = await Navigator.of(context).push<PersonalGoal>(
                      MaterialPageRoute(
                        builder: (_) =>
                            PersonalGoalEditorPage(exerciseRepository: catalog),
                      ),
                    );
                  },
                  child: const Text('Abrir'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Abrir'));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(DropdownButtonFormField<PersonalGoalType>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Marca de carga por ejercicio').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Seleccionar ejercicio'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byType(TextField).last,
        'barbell bench press',
      );
      await tester.pumpAndSettle();
      expect(find.text('Press de banca con barra'), findsOneWidget);
      await tester.tap(find.text('Press de banca con barra'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField), '80');
      await tester.tap(find.text('Guardar objetivo'));
      await tester.pumpAndSettle();

      expect(savedGoal?.exerciseName, 'Press de banca con barra');
      expect(savedGoal?.exerciseCatalogId, '0025');
    },
  );

  testWidgets('goal picker presents English names and searches Spanish names', (
    tester,
  ) async {
    final catalog = _FakeExerciseRepository();
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: [
          AppLocalizations.delegate,
          ...GlobalMaterialLocalizations.delegates,
        ],
        home: Scaffold(
          body: PersonalGoalEditorPage(exerciseRepository: catalog),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byType(DropdownButtonFormField<PersonalGoalType>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Exercise weight record').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Select exercise'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).last, 'Press de banca');
    await tester.pumpAndSettle();
    expect(find.text('barbell bench press'), findsOneWidget);
  });
}

class _FakeExerciseRepository implements ExerciseRepository {
  static const _exercise = Exercise(
    id: '0025',
    name: 'Press de banca con barra',
    englishName: 'barbell bench press',
    muscleGroup: 'Pecho',
    equipment: 'Barra',
    instructions: [],
  );

  @override
  bool get isLoaded => true;

  @override
  Future<void> load() async {}

  @override
  List<String> get muscleGroups => const ['Pecho'];

  @override
  List<String> get equipmentTypes => const ['Barra'];

  @override
  List<Exercise> search({
    String query = '',
    Set<String> muscleGroups = const {},
    Set<String> equipment = const {},
  }) {
    final folded = query.toLowerCase();
    return folded.isEmpty ||
            _exercise.name.toLowerCase().contains(folded) ||
            _exercise.englishName!.contains(folded)
        ? const [_exercise]
        : const [];
  }

  @override
  Exercise? findById(String id) => id == _exercise.id ? _exercise : null;

  @override
  List<Exercise> alternativesFor(Exercise exercise) => const [];
}
