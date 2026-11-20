class Exercise {
  const Exercise({
    required this.id,
    required this.name,
    required this.muscleGroup,
    required this.equipment,
    required this.instructions,
    this.level,
    this.summary,
    this.alternativeIds = const [],
  });

  final String id;
  final String name;
  final String muscleGroup;
  final String equipment;
  final String? level;
  final String? summary;
  final List<String> instructions;
  final List<String> alternativeIds;

  factory Exercise.fromJson(Map<String, Object?> json) {
    return Exercise(
      id: _requiredString(json, 'id'),
      name: _requiredString(json, 'name'),
      muscleGroup: _requiredString(json, 'muscleGroup'),
      equipment: _requiredString(json, 'equipment'),
      level: _optionalString(json, 'level'),
      summary: _optionalString(json, 'summary'),
      instructions: _stringList(json, 'instructions'),
      alternativeIds: json.containsKey('alternativeIds')
          ? _stringList(json, 'alternativeIds')
          : const [],
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

String? _optionalString(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value == null) return null;
  if (value is! String) {
    throw FormatException('El campo "$key" debe ser un texto.');
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
