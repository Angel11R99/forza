class Exercise {
  const Exercise({
    required this.id,
    required this.name,
    required this.muscleGroup,
    required this.equipment,
    required this.level,
    required this.summary,
    required this.instructions,
    required this.alternativeIds,
  });

  final String id;
  final String name;
  final String muscleGroup;
  final String equipment;
  final String level;
  final String summary;
  final List<String> instructions;
  final List<String> alternativeIds;
}
