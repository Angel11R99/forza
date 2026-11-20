import '../../domain/models/exercise.dart';
import '../../domain/repositories/exercise_repository.dart';

class DemoExerciseRepository implements ExerciseRepository {
  const DemoExerciseRepository();

  static const _entries = <Exercise>[
    Exercise(
      id: 'press-banca',
      name: 'Press de banca',
      muscleGroup: 'Pecho',
      equipment: 'Barra',
      level: 'Intermedio',
      summary: 'Ejercicio compuesto para desarrollar fuerza en el pecho.',
      instructions: [
        'Acuéstate en el banco y coloca los pies firmes en el suelo.',
        'Sujeta la barra un poco más allá del ancho de los hombros.',
        'Baja la barra con control hasta el centro del pecho.',
        'Empuja hacia arriba sin bloquear los codos de forma brusca.',
      ],
      alternativeIds: ['press-mancuernas', 'flexiones'],
    ),
    Exercise(
      id: 'press-mancuernas',
      name: 'Press con mancuernas',
      muscleGroup: 'Pecho',
      equipment: 'Mancuernas',
      level: 'Principiante',
      summary:
          'Variación de empuje que permite trabajar cada lado por separado.',
      instructions: [
        'Apoya la espalda en el banco y mantén los pies estables.',
        'Sostén las mancuernas a los lados del pecho.',
        'Empuja ambas mancuernas hacia arriba con un recorrido cómodo.',
        'Regresa lentamente a la posición inicial.',
      ],
      alternativeIds: ['press-banca', 'flexiones'],
    ),
    Exercise(
      id: 'flexiones',
      name: 'Flexiones',
      muscleGroup: 'Pecho',
      equipment: 'Peso corporal',
      level: 'Principiante',
      summary: 'Movimiento de empuje con el peso corporal y sin equipo.',
      instructions: [
        'Coloca las manos un poco más abiertas que los hombros.',
        'Mantén el cuerpo alineado desde la cabeza hasta los talones.',
        'Baja el pecho hacia el suelo flexionando los codos.',
        'Empuja el suelo para volver a extender los brazos.',
      ],
      alternativeIds: ['press-mancuernas', 'press-banca'],
    ),
    Exercise(
      id: 'sentadilla-barra',
      name: 'Sentadilla con barra',
      muscleGroup: 'Piernas',
      equipment: 'Barra',
      level: 'Avanzado',
      summary: 'Movimiento multiarticular para entrenar piernas y cadera.',
      instructions: [
        'Apoya la barra de forma estable sobre la parte alta de la espalda.',
        'Coloca los pies aproximadamente al ancho de los hombros.',
        'Lleva la cadera atrás y flexiona las rodillas manteniendo el control.',
        'Empuja el suelo para regresar a la posición erguida.',
      ],
      alternativeIds: ['sentadilla-goblet', 'peso-muerto-rumano'],
    ),
    Exercise(
      id: 'sentadilla-goblet',
      name: 'Sentadilla goblet',
      muscleGroup: 'Piernas',
      equipment: 'Mancuernas',
      level: 'Principiante',
      summary: 'Sentadilla con una carga sostenida frente al pecho.',
      instructions: [
        'Sostén una mancuerna frente al pecho con ambas manos.',
        'Separa los pies a una distancia cómoda y apunta ligeramente hacia fuera.',
        'Desciende flexionando cadera y rodillas.',
        'Empuja con los pies para volver a subir.',
      ],
      alternativeIds: ['sentadilla-barra', 'peso-muerto-rumano'],
    ),
    Exercise(
      id: 'peso-muerto-rumano',
      name: 'Peso muerto rumano',
      muscleGroup: 'Piernas',
      equipment: 'Barra',
      level: 'Intermedio',
      summary: 'Bisagra de cadera enfocada en la cadena posterior.',
      instructions: [
        'Sujeta la barra frente a los muslos con las rodillas ligeramente flexionadas.',
        'Lleva la cadera hacia atrás mientras deslizas la barra cerca de las piernas.',
        'Detén el descenso cuando sientas tensión cómoda en la parte posterior.',
        'Extiende la cadera para volver a quedar de pie.',
      ],
      alternativeIds: ['sentadilla-goblet', 'sentadilla-barra'],
    ),
    Exercise(
      id: 'remo-mancuerna',
      name: 'Remo con mancuerna',
      muscleGroup: 'Espalda',
      equipment: 'Mancuernas',
      level: 'Principiante',
      summary: 'Ejercicio unilateral de tracción para la espalda.',
      instructions: [
        'Apoya una mano y una rodilla en un banco estable.',
        'Sujeta la mancuerna con el brazo extendido debajo del hombro.',
        'Lleva el codo hacia la cadera sin girar el torso.',
        'Baja la mancuerna lentamente y repite por ambos lados.',
      ],
      alternativeIds: ['jalon-pecho', 'press-banca'],
    ),
    Exercise(
      id: 'jalon-pecho',
      name: 'Jalón al pecho',
      muscleGroup: 'Espalda',
      equipment: 'Polea',
      level: 'Principiante',
      summary: 'Tracción vertical con cable y agarre cómodo.',
      instructions: [
        'Siéntate con los muslos sujetos debajo de los apoyos.',
        'Sujeta la barra con las manos algo más separadas que los hombros.',
        'Lleva la barra hacia la parte alta del pecho manteniendo el torso estable.',
        'Regresa arriba con control sin soltar la tensión.',
      ],
      alternativeIds: ['remo-mancuerna', 'press-banca'],
    ),
    Exercise(
      id: 'press-hombros',
      name: 'Press de hombros',
      muscleGroup: 'Hombros',
      equipment: 'Mancuernas',
      level: 'Intermedio',
      summary: 'Empuje vertical con mancuernas y control del tronco.',
      instructions: [
        'Siéntate o ponte de pie con el tronco firme.',
        'Sostén las mancuernas a la altura de los hombros.',
        'Empuja hacia arriba en un recorrido cómodo.',
        'Baja lentamente hasta la posición inicial.',
      ],
      alternativeIds: ['flexiones', 'press-mancuernas'],
    ),
    Exercise(
      id: 'plancha',
      name: 'Plancha frontal',
      muscleGroup: 'Core',
      equipment: 'Peso corporal',
      level: 'Principiante',
      summary: 'Trabajo isométrico de estabilidad para el tronco.',
      instructions: [
        'Apoya los antebrazos y coloca los codos debajo de los hombros.',
        'Extiende las piernas y apoya las puntas de los pies.',
        'Mantén el cuerpo alineado y respira con normalidad.',
        'Termina la posición si pierdes la alineación o el control.',
      ],
      alternativeIds: ['sentadilla-goblet', 'flexiones'],
    ),
  ];

  static const _muscleGroups = <String>[
    'Pecho',
    'Espalda',
    'Piernas',
    'Hombros',
    'Core',
  ];

  static const _equipmentTypes = <String>[
    'Barra',
    'Mancuernas',
    'Polea',
    'Peso corporal',
  ];

  @override
  List<String> get muscleGroups => _muscleGroups;

  @override
  List<String> get equipmentTypes => _equipmentTypes;

  @override
  List<Exercise> search({
    String query = '',
    Set<String> muscleGroups = const {},
    Set<String> equipment = const {},
  }) {
    final normalizedQuery = query.trim().toLowerCase();
    return _entries
        .where((exercise) {
          final matchesQuery =
              normalizedQuery.isEmpty ||
              exercise.name.toLowerCase().contains(normalizedQuery) ||
              exercise.muscleGroup.toLowerCase().contains(normalizedQuery) ||
              exercise.equipment.toLowerCase().contains(normalizedQuery);
          final matchesMuscle =
              muscleGroups.isEmpty ||
              muscleGroups.contains(exercise.muscleGroup);
          final matchesEquipment =
              equipment.isEmpty || equipment.contains(exercise.equipment);
          return matchesQuery && matchesMuscle && matchesEquipment;
        })
        .toList(growable: false);
  }

  @override
  Exercise? findById(String id) {
    for (final exercise in _entries) {
      if (exercise.id == id) return exercise;
    }
    return null;
  }

  @override
  List<Exercise> alternativesFor(Exercise exercise) {
    final byId = exercise.alternativeIds
        .map(findById)
        .whereType<Exercise>()
        .toList(growable: false);
    if (byId.isNotEmpty) return byId;

    return _entries
        .where(
          (candidate) =>
              candidate.id != exercise.id &&
              candidate.muscleGroup == exercise.muscleGroup,
        )
        .toList(growable: false);
  }
}
