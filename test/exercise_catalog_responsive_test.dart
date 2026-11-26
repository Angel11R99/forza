import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:forza/app/localization/generated/app_localizations.dart';
import 'package:forza/app/theme/app_theme.dart';
import 'package:forza/domain/models/exercise.dart';
import 'package:forza/domain/repositories/exercise_repository.dart';
import 'package:forza/ui/features/exercises/views/exercises_view.dart';

class _ExerciseRepository implements ExerciseRepository {
  @override
  bool get isLoaded => true;

  final exercises = List.generate(
    8,
    (index) => Exercise(
      id: 'movement-$index',
      name: 'Ejercicio con un nombre descriptivo largo $index',
      englishName: 'Long descriptive exercise name $index',
      muscleGroup: 'Pecho',
      equipment: 'Mancuernas',
      instructions: const ['Instructions'],
    ),
  );

  @override
  Future<void> load() async {}

  @override
  List<String> get muscleGroups => const ['Pecho'];

  @override
  List<String> get equipmentTypes => const ['Mancuernas'];

  @override
  List<Exercise> search({
    String query = '',
    Set<String> muscleGroups = const {},
    Set<String> equipment = const {},
  }) => exercises.where((exercise) {
    final matchesText =
        query.isEmpty ||
        exercise.name.toLowerCase().contains(query.toLowerCase()) ||
        exercise.englishName!.toLowerCase().contains(query.toLowerCase());
    return matchesText &&
        (muscleGroups.isEmpty || muscleGroups.contains(exercise.muscleGroup)) &&
        (equipment.isEmpty || equipment.contains(exercise.equipment));
  }).toList();

  @override
  Exercise? findById(String id) =>
      exercises.where((exercise) => exercise.id == id).firstOrNull;

  @override
  List<Exercise> alternativesFor(Exercise exercise) => const [];
}

void main() {
  testWidgets('catalog stays readable across phone, tablet and large text', (
    tester,
  ) async {
    final repository = _ExerciseRepository();
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    for (final width in [320.0, 360.0, 390.0, 800.0]) {
      for (final textScale in [1.0, 1.7]) {
        tester.view.physicalSize = Size(width, 900);
        tester.view.devicePixelRatio = 1;
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.light,
            locale: const Locale('es'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: [
              AppLocalizations.delegate,
              ...GlobalMaterialLocalizations.delegates,
            ],
            home: MediaQuery(
              data: MediaQueryData(
                size: Size(width, 900),
                textScaler: TextScaler.linear(textScale),
              ),
              child: Scaffold(body: ExercisesView(repository: repository)),
            ),
          ),
        );

        expect(find.text('Pecho  ·  Mancuernas'), findsWidgets);
        expect(tester.takeException(), isNull);
      }
    }
  });
}
