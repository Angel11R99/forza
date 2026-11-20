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

  factory Exercise.fromJson(Map<String, Object?> json) {
    return Exercise(
      id: _requiredString(json, 'id'),
      name: _requiredString(json, 'name'),
      muscleGroup: _requiredString(json, 'muscleGroup'),
      equipment: _requiredString(json, 'equipment'),
      level: _requiredString(json, 'level'),
      summary: _requiredString(json, 'summary'),
      instructions: _stringList(json, 'instructions'),
      alternativeIds: _stringList(json, 'alternativeIds'),
    );
  }
}

String _requiredString(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value is! String || value.isEmpty) {
    throw FormatException('El campo "$key" debe ser un texto no vacío.');
  }
  return value;
}

List<String> _stringList(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value is! List<Object?> || value.any((item) => item is! String)) {
    throw FormatException('El campo "$key" debe ser una lista de textos.');
  }
  return List<String>.unmodifiable(value.cast<String>());
}
