class ExerciseFilterSelection {
  const ExerciseFilterSelection({
    this.muscleGroups = const {},
    this.equipment = const {},
  });

  final Set<String> muscleGroups;
  final Set<String> equipment;

  bool get isEmpty => muscleGroups.isEmpty && equipment.isEmpty;

  int get count => muscleGroups.length + equipment.length;
}
