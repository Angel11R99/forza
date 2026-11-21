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
    this.animation,
  });

  final String id;
  final String name;
  final String muscleGroup;
  final String equipment;
  final String? level;
  final String? summary;
  final List<String> instructions;
  final List<String> alternativeIds;
  final ExerciseAnimation? animation;

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
      animation: json['animation'] == null
          ? null
          : ExerciseAnimation.fromJson(_object(json['animation'], 'animation')),
    );
  }
}

class ExerciseAnimation {
  const ExerciseAnimation({
    required this.frames,
    required this.sequence,
    required this.frameDuration,
  });

  final List<String> frames;
  final List<int> sequence;
  final Duration frameDuration;

  factory ExerciseAnimation.fromJson(Map<String, Object?> json) {
    final frames = _stringList(json, 'frames');
    final sequenceValue = json['sequence'];
    if (sequenceValue is! List<Object?> ||
        sequenceValue.any((value) => value is! int)) {
      throw const FormatException('La secuencia de animación no es válida.');
    }
    final duration = json['frameDurationMs'];
    if (duration is! int || duration <= 0) {
      throw const FormatException('La duración de animación no es válida.');
    }
    return ExerciseAnimation(
      frames: frames,
      sequence: List<int>.unmodifiable(sequenceValue.cast<int>()),
      frameDuration: Duration(milliseconds: duration),
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

Map<String, Object?> _object(Object? value, String key) {
  if (value is! Map) {
    throw FormatException('El campo "$key" debe ser un objeto.');
  }
  return Map<String, Object?>.from(value);
}
