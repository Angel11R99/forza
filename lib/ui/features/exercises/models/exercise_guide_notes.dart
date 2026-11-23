class ExerciseGuideNotes {
  const ExerciseGuideNotes._();

  static const forExercise = <String, ExerciseGuideNote>{
    '0085': ExerciseGuideNote(
      commonMistakes: [
        'Redondear la espalda en vez de llevar la cadera hacia atrás.',
        'Doblar mucho las rodillas y convertir el movimiento en una sentadilla.',
        'Girar el cuello para mirarte en un espejo durante la repetición.',
      ],
      source:
          'American Council on Exercise (ACE), Romanian Deadlift technique.',
    ),
  };
}

class ExerciseGuideNote {
  const ExerciseGuideNote({required this.commonMistakes, required this.source});

  final List<String> commonMistakes;
  final String source;
}
