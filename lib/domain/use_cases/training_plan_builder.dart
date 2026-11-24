class PlannedExercise {
  const PlannedExercise({
    required this.catalogId,
    required this.name,
    required this.focus,
    required this.prescription,
    this.timed = false,
  });

  final String catalogId;
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

  Map<String, Object?> toJson() => {
    'weekday': weekday,
    'title': title,
    'focus': focus,
    'durationMinutes': durationMinutes,
    'exercises': [
      for (final exercise in exercises)
        {
          'catalogId': exercise.catalogId,
          'name': exercise.name,
          'focus': exercise.focus,
          'prescription': exercise.prescription,
          'timed': exercise.timed,
        },
    ],
  };

  factory PlannedTrainingSession.fromJson(Map<String, Object?> json) {
    final rawExercises = json['exercises'];
    if (rawExercises is! List<Object?>) {
      throw const FormatException('La rutina guardada no es válida.');
    }
    final exercises = <PlannedExercise>[];
    for (final raw in rawExercises) {
      if (raw is! Map) {
        throw const FormatException('Un ejercicio guardado no es válido.');
      }
      final exercise = Map<String, Object?>.from(raw);
      final id = exercise['catalogId'];
      final name = exercise['name'];
      final focus = exercise['focus'];
      final prescription = exercise['prescription'];
      final timed = exercise['timed'];
      if ([
            id,
            name,
            focus,
            prescription,
          ].any((value) => value is! String || value.trim().isEmpty) ||
          timed is! bool) {
        throw const FormatException('Un ejercicio guardado no es válido.');
      }
      exercises.add(
        PlannedExercise(
          catalogId: id as String,
          name: name as String,
          focus: focus as String,
          prescription: prescription as String,
          timed: timed,
        ),
      );
    }
    final weekday = json['weekday'];
    final title = json['title'];
    final focus = json['focus'];
    final duration = json['durationMinutes'];
    if (weekday is! int ||
        weekday < 1 ||
        weekday > 7 ||
        title is! String ||
        title.trim().isEmpty ||
        focus is! String ||
        focus.trim().isEmpty ||
        duration is! int ||
        duration < 20 ||
        duration > 90) {
      throw const FormatException('La rutina guardada no es válida.');
    }
    return PlannedTrainingSession(
      weekday: weekday,
      title: title,
      focus: focus,
      durationMinutes: duration,
      exercises: List.unmodifiable(exercises),
    );
  }
}

class TrainingExerciseOption {
  const TrainingExerciseOption({
    required this.catalogId,
    required this.name,
    required this.focus,
    required this.equipment,
  });

  final String catalogId;
  final String name;
  final String focus;
  final String? equipment;
}

class TrainingPlanBuilder {
  const TrainingPlanBuilder();

  List<TrainingExerciseOption> get exerciseOptions => List.unmodifiable([
    for (final exercise in _catalog)
      TrainingExerciseOption(
        catalogId: exercise.catalogId,
        name: exercise.name,
        focus: exercise.focus,
        equipment: exercise.equipment,
      ),
  ]);

  static const _catalog = <_ExerciseTemplate>[
    _ExerciseTemplate(
      '1700',
      'Press con mancuernas',
      'Pecho',
      equipment: 'Mancuernas',
    ),
    _ExerciseTemplate(
      '1760',
      'Sentadilla goblet',
      'Piernas',
      equipment: 'Mancuernas',
    ),
    _ExerciseTemplate(
      '0293',
      'Remo con mancuerna',
      'Espalda',
      equipment: 'Mancuernas',
    ),
    _ExerciseTemplate(
      '1459',
      'Peso muerto rumano',
      'Piernas',
      equipment: 'Mancuernas',
    ),
    _ExerciseTemplate(
      '0405',
      'Press de hombros',
      'Hombros',
      equipment: 'Mancuernas',
    ),
    _ExerciseTemplate(
      '0043',
      'Sentadilla con barra',
      'Piernas',
      equipment: 'Barra',
    ),
    _ExerciseTemplate(
      '0025',
      'Press de banca con barra',
      'Pecho',
      equipment: 'Barra',
    ),
    _ExerciseTemplate('0027', 'Remo con barra', 'Espalda', equipment: 'Barra'),
    _ExerciseTemplate(
      '0032',
      'Peso muerto con barra',
      'Piernas',
      equipment: 'Barra',
    ),
    _ExerciseTemplate(
      '1254',
      'Press de pecho con banda',
      'Pecho',
      equipment: 'Banda elástica',
    ),
    _ExerciseTemplate(
      '0990',
      'Remo con banda',
      'Espalda',
      equipment: 'Banda elástica',
    ),
    _ExerciseTemplate(
      '1004',
      'Sentadilla con banda',
      'Piernas',
      equipment: 'Banda elástica',
    ),
    _ExerciseTemplate(
      '0993',
      'Apertura inversa con banda',
      'Hombros',
      equipment: 'Banda elástica',
    ),
    _ExerciseTemplate(
      '0577',
      'Press de pecho en máquina',
      'Pecho',
      equipment: 'Máquina de palanca',
    ),
    _ExerciseTemplate(
      '2287',
      'Prensa de piernas',
      'Piernas',
      equipment: 'Máquina de palanca',
    ),
    _ExerciseTemplate('0818', 'Jalón al pecho', 'Espalda', equipment: 'Polea'),
    _ExerciseTemplate('0861', 'Remo sentado', 'Espalda', equipment: 'Polea'),
    _ExerciseTemplate('0662', 'Flexiones', 'Pecho'),
    _ExerciseTemplate('0493', 'Flexiones inclinadas', 'Pecho'),
    _ExerciseTemplate('3662', 'Flexiones de pica a cobra', 'Hombros'),
    _ExerciseTemplate('3470', 'Zancadas', 'Piernas'),
    _ExerciseTemplate('0514', 'Sentadilla con salto', 'Piernas'),
    _ExerciseTemplate('1373', 'Elevación de pantorrillas', 'Piernas'),
    _ExerciseTemplate('3013', 'Puente de glúteos', 'Glúteos'),
    _ExerciseTemplate('3544', 'Plancha lateral inclinada', 'Core', timed: true),
    _ExerciseTemplate('0276', 'Dead bug', 'Core', timed: true),
    _ExerciseTemplate('0464', 'Plancha', 'Core', timed: true),
  ];

  List<PlannedTrainingSession> buildWeek({
    required Set<int> trainingDays,
    required int sessionMinutes,
    required String goal,
    required String experience,
    required Set<String> equipment,
    Set<String> avoidedExerciseIds = const {},
  }) {
    validateSettings(
      trainingDays: trainingDays,
      sessionMinutes: sessionMinutes,
      goal: goal,
      experience: experience,
      equipment: equipment,
      avoidedExerciseIds: avoidedExerciseIds,
    );
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
            avoidedExerciseIds: avoidedExerciseIds,
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
    Set<String> avoidedExerciseIds = const {},
  }) {
    if (sessionIndex < 0) {
      throw const FormatException('El índice de sesión no es válido.');
    }
    validateSettings(
      trainingDays: const {DateTime.monday},
      sessionMinutes: sessionMinutes,
      goal: goal,
      experience: experience,
      equipment: equipment,
      avoidedExerciseIds: avoidedExerciseIds,
    );
    final allAvailable = _catalog
        .where(
          (exercise) =>
              exercise.equipment == null ||
              equipment.contains(exercise.equipment),
        )
        .where((exercise) => !avoidedExerciseIds.contains(exercise.catalogId))
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
          catalogId: exercise.catalogId,
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

  static void validateSettings({
    required Set<int> trainingDays,
    required int sessionMinutes,
    required String goal,
    required String experience,
    required Set<String> equipment,
    Set<String> avoidedExerciseIds = const {},
  }) {
    if (trainingDays.isEmpty ||
        trainingDays.any((day) => day < 1 || day > 7) ||
        sessionMinutes < 20 ||
        sessionMinutes > 90 ||
        !const {
          'Ganar fuerza',
          'Ganar músculo',
          'Crear el hábito',
        }.contains(goal) ||
        !const {
          'Estoy empezando',
          'Tengo algo de experiencia',
          'Entreno hace tiempo',
        }.contains(experience) ||
        equipment.isEmpty ||
        !const {
          'Peso corporal',
          'Mancuernas',
          'Barra',
          'Banda elástica',
          'Polea',
          'Máquina de palanca',
        }.containsAll(equipment)) {
      throw const FormatException('Las preferencias del plan no son válidas.');
    }
    final validIds = _catalog.map((exercise) => exercise.catalogId).toSet();
    if (!validIds.containsAll(avoidedExerciseIds)) {
      throw const FormatException(
        'La lista de movimientos a evitar no es válida.',
      );
    }
  }
}

class _ExerciseTemplate {
  const _ExerciseTemplate(
    this.catalogId,
    this.name,
    this.focus, {
    this.equipment,
    this.timed = false,
  });

  final String name;
  final String catalogId;
  final String focus;
  final String? equipment;
  final bool timed;
}
