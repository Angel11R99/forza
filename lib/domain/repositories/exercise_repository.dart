import '../models/exercise.dart';

abstract interface class ExerciseRepository {
  bool get isLoaded;

  Future<void> load();

  List<String> get muscleGroups;

  List<String> get equipmentTypes;

  List<Exercise> search({
    String query = '',
    Set<String> muscleGroups = const {},
    Set<String> equipment = const {},
  });

  Exercise? findById(String id);

  List<Exercise> alternativesFor(Exercise exercise);
}
