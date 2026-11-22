class PlannedExercise {
  const PlannedExercise({
    required this.name,
    required this.focus,
    required this.prescription,
    this.timed = false,
  });

  final String name;
  final String focus;
  final String prescription;
  final bool timed;
}

class PlannedTrainingSession {
  const PlannedTrainingSession({
    required this.weekday,
    required this.title,
    required this.focus,
    required this.durationMinutes,
    required this.exercises,
  });

  final int weekday;
  final String title;
  final String focus;
  final int durationMinutes;
  final List<PlannedExercise> exercises;
}

class TrainingPlanBuilder {
  const TrainingPlanBuilder();

  static const _catalog = <_ExerciseTemplate>[
    _ExerciseTemplate('Press con mancuernas', 'Pecho', equipment: 'Mancuernas'),
    _ExerciseTemplate('Sentadilla goblet', 'Piernas', equipment: 'Mancuernas'),
    _ExerciseTemplate('Remo con mancuerna', 'Espalda', equipment: 'Mancuernas'),
    _ExerciseTemplate('Peso muerto rumano', 'Piernas', equipment: 'Mancuernas'),
    _ExerciseTemplate('Press de hombros', 'Hombros', equipment: 'Mancuernas'),
    _ExerciseTemplate('Sentadilla con barra', 'Piernas', equipment: 'Barra'),
    _ExerciseTemplate('Press de banca con barra', 'Pecho', equipment: 'Barra'),
    _ExerciseTemplate('Remo con barra', 'Espalda', equipment: 'Barra'),
    _ExerciseTemplate('Peso muerto con barra', 'Piernas', equipment: 'Barra'),
    _ExerciseTemplate(
      'Press de pecho con banda',
      'Pecho',
      equipment: 'Banda elástica',
    ),
    _ExerciseTemplate('Remo con banda', 'Espalda', equipment: 'Banda elástica'),
    _ExerciseTemplate(
      'Sentadilla con banda',
      'Piernas',
      equipment: 'Banda elástica',
    ),
    _ExerciseTemplate(
      'Separación de banda',
      'Hombros',
      equipment: 'Banda elástica',
    ),
    _ExerciseTemplate(
      'Press de pecho en máquina',
      'Pecho',
      equipment: 'Máquina de palanca',
    ),
    _ExerciseTemplate(
      'Prensa de piernas',
      'Piernas',
      equipment: 'Máquina de palanca',
    ),
    _ExerciseTemplate('Jalón al pecho', 'Espalda', equipment: 'Polea'),
    _ExerciseTemplate('Remo sentado', 'Espalda', equipment: 'Polea'),
    _ExerciseTemplate('Flexiones', 'Pecho'),
    _ExerciseTemplate('Flexiones inclinadas', 'Pecho'),
    _ExerciseTemplate('Pike push-up', 'Hombros'),
    _ExerciseTemplate('Zancadas', 'Piernas'),
    _ExerciseTemplate('Sentadilla con peso corporal', 'Piernas'),
    _ExerciseTemplate('Elevación de pantorrillas', 'Piernas'),
    _ExerciseTemplate('Puente de glúteos', 'Glúteos'),
    _ExerciseTemplate('Bird-dog', 'Core', timed: true),
    _ExerciseTemplate('Dead bug', 'Core', timed: true),
    _ExerciseTemplate('Plancha', 'Core', timed: true),
  ];

  List<PlannedTrainingSession> buildWeek({
    required Set<int> trainingDays,
    required int sessionMinutes,
    required String goal,
    required String experience,
    required Set<String> equipment,
  }) {
    final days = trainingDays.toList()..sort();
    return [
      for (var index = 0; index < days.length; index++)
        PlannedTrainingSession(
          weekday: days[index],
          title: _sessionTitle(index),
          focus: _sessionFocus(index),
          durationMinutes: sessionMinutes,
          exercises: buildSession(
            sessionIndex: index,
            sessionMinutes: sessionMinutes,
            goal: goal,
            experience: experience,
            equipment: equipment,
          ),
        ),
    ];
  }

  List<PlannedExercise> buildSession({
    required int sessionIndex,
    required int sessionMinutes,
    required String goal,
    required String experience,
    required Set<String> equipment,
  }) {
    final allAvailable = _catalog
        .where(
          (exercise) =>
              exercise.equipment == null ||
              equipment.contains(exercise.equipment),
        )
        .toList(growable: false);
    if (allAvailable.isEmpty) return const [];

    final focusGroup = sessionIndex % 3;
    final focused = allAvailable
        .where((exercise) => _belongsToSession(exercise.focus, focusGroup))
        .toList(growable: false);
    final available = focused.length >= 4 ? focused : allAvailable;

    final offset = sessionIndex % available.length;
    final rotated = [...available.skip(offset), ...available.take(offset)];
    final count = exerciseCount(
      sessionMinutes,
      availableCount: available.length,
    );
    final sets = experience == 'Estoy empezando' ? 2 : 3;
    return [
      for (final exercise in rotated.take(count))
        PlannedExercise(
          name: exercise.name,
          focus: exercise.focus,
          timed: exercise.timed,
          prescription: exercise.timed
              ? '$sets series · 20–40 segundos'
              : '$sets series · ${_repetitions(goal)}',
        ),
    ];
  }

  int exerciseCount(int sessionMinutes, {required int availableCount}) =>
      (sessionMinutes / 8).round().clamp(4, 8).clamp(1, availableCount);

  static String _sessionTitle(int index) => switch (index % 3) {
    0 => 'Tren superior',
    1 => 'Tren inferior',
    _ => 'Cuerpo completo',
  };

  static String _sessionFocus(int index) => switch (index % 3) {
    0 => 'Pecho, espalda y hombros',
    1 => 'Piernas y core',
    _ => 'Rutina de cuerpo completo',
  };

  static bool _belongsToSession(String focus, int sessionIndex) {
    if (sessionIndex == 2) return true;
    final upper = const {'Pecho', 'Espalda', 'Hombros'};
    final lower = const {'Piernas', 'Glúteos', 'Core'};
    return (sessionIndex == 0 ? upper : lower).contains(focus);
  }

  static String _repetitions(String goal) => switch (goal) {
    'Ganar fuerza' => '6–8 repeticiones',
    'Ganar músculo' => '8–12 repeticiones',
    _ => '8–12 repeticiones a ritmo cómodo',
  };
}

class _ExerciseTemplate {
  const _ExerciseTemplate(
    this.name,
    this.focus, {
    this.equipment,
    this.timed = false,
  });

  final String name;
  final String focus;
  final String? equipment;
  final bool timed;
}
