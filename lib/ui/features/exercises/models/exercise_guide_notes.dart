import '../../../../domain/models/exercise.dart';
import '../../../../app/localization/generated/app_localizations.dart';

class ExerciseGuideNotes {
  const ExerciseGuideNotes._();

  static final _deadlift = ExerciseGuideNote(
    commonMistakes: [
      'Redondear la espalda al bajar hacia el suelo.',
      'Alejar la carga del cuerpo durante la subida.',
      'Terminar inclinándose hacia atrás en vez de quedar de pie con control.',
    ],
    source: 'ACE · Peso muerto y peso muerto rumano',
    sourceUrl: 'https://www.acefitness.org/resources/everyone/exercise-library/6/deadlift/',
  );

  static final _squat = ExerciseGuideNote(
    commonMistakes: [
      'Dejar que las rodillas se inclinen hacia dentro en vez de seguir la dirección de los pies.',
      'Despegar los talones o perder el apoyo del pie al bajar.',
      'Forzar más profundidad cuando ya no puedes mantener el control y una postura cómoda.',
    ],
    source: 'ACE · Sentadilla con peso corporal',
    sourceUrl: 'https://www.acefitness.org/resources/everyone/exercise-library/135/bodyweight-squat/',
  );

  static final _lunge = ExerciseGuideNote(
    commonMistakes: [
      'Inclinar o balancear el tronco hacia los lados durante el paso.',
      'Perder el apoyo del pie delantero o dejar que la rodilla pierda su alineación.',
      'Rebotar al fondo en vez de bajar y volver con control.',
    ],
    source: 'ACE · Zancada hacia delante',
    sourceUrl: 'https://www.acefitness.org/resources/everyone/exercise-library/95/forward-lunge-with-arm-drivers/',
  );

  static final _pushUp = ExerciseGuideNote(
    commonMistakes: [
      'Dejar caer la zona lumbar o elevar la cadera al bajar y empujar.',
      'Adelantar la cabeza en lugar de mantenerla alineada con el tronco.',
      'Acortar el recorrido con repeticiones rápidas que pierden la posición del cuerpo.',
    ],
    source: 'ACE · Flexión de brazos',
    sourceUrl: 'https://www.acefitness.org/resources/everyone/exercise-library/41/push-up/',
  );

  static final _chestPress = ExerciseGuideNote(
    commonMistakes: [
      'Rebotar la carga contra el pecho al cambiar de dirección.',
      'Arquear la zona lumbar o perder los puntos de apoyo para terminar la repetición.',
      'Doblar las muñecas hacia atrás en vez de mantenerlas alineadas con los antebrazos.',
    ],
    source: 'ACE · Press de pecho',
    sourceUrl: 'https://www.acefitness.org/resources/everyone/exercise-library/19/chest-press/',
  );

  static final _row = ExerciseGuideNote(
    commonMistakes: [
      'Balancear el torso para iniciar cada tirón.',
      'Redondear la espalda en vez de mantener la posición estable descrita para el ejercicio.',
      'Dejar caer la carga rápidamente al volver a la posición inicial.',
    ],
    source: 'ACE · Remo inclinado',
    sourceUrl: 'https://www.acefitness.org/resources/everyone/exercise-library/12/bent-over-row/',
  );

  static final _pullUp = ExerciseGuideNote(
    commonMistakes: [
      'Impulsar el cuerpo con balanceos en vez de tirar con control.',
      'Encoger los hombros o perder la alineación del tronco durante la subida.',
      'Soltar la bajada sin control antes de llegar a la posición inicial.',
    ],
    source: 'ACE · Dominadas supinas',
    sourceUrl: 'https://www.acefitness.org/resources/everyone/exercise-library/190/chin-ups/',
  );

  static final _plank = ExerciseGuideNote(
    commonMistakes: [
      'Dejar caer la zona lumbar o elevar demasiado la cadera.',
      'Encoger los hombros o alejarlos de la posición de apoyo.',
      'Contener la respiración mientras sostienes la postura.',
    ],
    source: 'ACE · Plancha frontal',
    sourceUrl: 'https://www.acefitness.org/resources/everyone/exercise-library/32/front-plank/',
  );

  static final _crunch = ExerciseGuideNote(
    commonMistakes: [
      'Tirar del cuello con las manos, si esa variante las coloca detrás de la cabeza.',
      'Hacer impulso con las piernas o subir rápidamente en vez de enrollar el torso.',
      'Cambiar la posición de la espalda o las caderas que indican los pasos de esta variante.',
    ],
    source: 'ACE · Crunch',
    sourceUrl: 'https://www.acefitness.org/resources/everyone/exercise-library/52/crunch/',
  );

  static final _curl = ExerciseGuideNote(
    commonMistakes: [
      'Balancear el tronco para ayudar a mover la carga.',
      'Desplazar los codos hacia delante durante la flexión si la variante pide mantenerlos junto al cuerpo.',
      'Soltar la carga rápidamente durante el regreso.',
    ],
    source: 'ACE · Curl de bíceps',
    sourceUrl: 'https://www.acefitness.org/resources/everyone/exercise-library/70/bicep-curl/',
  );

  static final _shoulderPress = ExerciseGuideNote(
    commonMistakes: [
      'Arquear la zona lumbar para llevar la carga por encima de la cabeza.',
      'Dejar caer la carga sin controlar el regreso.',
      'Doblar las muñecas en vez de mantenerlas alineadas con los antebrazos.',
    ],
    source: 'ACE · Press de hombros sentado',
    sourceUrl: 'https://www.acefitness.org/resources/everyone/exercise-library/186/seated-shoulder-press/',
  );

  static final _lateralRaise = ExerciseGuideNote(
    commonMistakes: [
      'Elevar los hombros o encogerlos durante la repetición.',
      'Balancear el torso o arquear la zona lumbar para levantar más carga.',
      'Doblar las muñecas o continuar elevando los brazos por encima de los hombros.',
    ],
    source: 'ACE · Elevación lateral',
    sourceUrl: 'https://www.acefitness.org/resources/everyone/exercise-library/26/lateral-raise/',
  );

  static final _legCurl = ExerciseGuideNote(
    commonMistakes: [
      'Arquear la espalda o levantar la cadera para ayudar a doblar la rodilla.',
      'Mover el muslo cuando la variante pide mantenerlo apoyado.',
      'Dejar volver la resistencia sin control.',
    ],
    source: 'ACE · Curl femoral acostado',
    sourceUrl: 'https://www.acefitness.org/resources/everyone/exercise-library/153/lying-hamstrings-curl/',
  );

  static final _legExtension = ExerciseGuideNote(
    commonMistakes: [
      'Aumentar el recorrido hasta que la cadera o el tronco tengan que inclinarse.',
      'Usar impulso en vez de extender y regresar la pierna con control.',
      'Elegir una resistencia que impida mantener el equilibrio y la postura.',
    ],
    source: 'ACE · Extensión de pierna de pie',
    sourceUrl: 'https://www.acefitness.org/resources/everyone/exercise-library/133/standing-leg-extension/',
  );

  static final _calfRaise = ExerciseGuideNote(
    commonMistakes: [
      'Rebotar en vez de pausar y mover los talones de forma controlada.',
      'Girar los pies durante una repetición si la variante pide mantenerlos al frente.',
      'Usar una altura que haga perder el equilibrio o el control del regreso.',
    ],
    source: 'ACE · Elevación de pantorrillas de pie',
    sourceUrl: 'https://www.acefitness.org/resources/everyone/exercise-library/73/standing-calf-raises-wall/',
  );

  static final _stepUp = ExerciseGuideNote(
    commonMistakes: [
      'Dejar que el pie o el tobillo pierdan apoyo sobre la plataforma.',
      'Permitir que la rodilla se incline hacia dentro en vez de mantenerla alineada con el pie.',
      'Bajar de la plataforma sin controlar el peso del cuerpo.',
    ],
    source: 'ACE · Step-up',
    sourceUrl: 'https://www.acefitness.org/resources/everyone/exercise-library/28/step-up/',
  );

  static final _gluteBridge = ExerciseGuideNote(
    commonMistakes: [
      'Elevar las caderas tan alto que se arquee la zona lumbar.',
      'Empujar con la espalda en vez de extender la cadera con control.',
      'Dejar caer las caderas rápidamente al volver al suelo.',
    ],
    source: 'ACE · Puente de glúteos',
    sourceUrl: 'https://www.acefitness.org/resources/everyone/exercise-library/49/glute-bridge/',
  );

  static ExerciseGuideNote? forExercise(Exercise exercise) {
    if (exercise.id == '0085') return _romanianDeadlift;

    final name = _fold(exercise.name);
    if (_containsAny(name, ['peso muerto rumano', 'romanian deadlift'])) {
      return _romanianDeadlift;
    }
    if (_containsAny(name, ['peso muerto', 'deadlift'])) return _deadlift;
    if (exercise.muscleGroup == 'Cardio') return null;
    if (_containsAny(name, ['estiramiento', 'stretch'])) return null;

    if (_containsAny(name, ['sentadilla', 'squat'])) return _squat;
    if (_containsAny(name, ['zancada', 'estocada', 'lunge'])) return _lunge;
    if (_containsAny(name, ['push-up', 'push up', 'flexion'])) {
      if (_containsAny(name, [
        'muneca',
        'wrist',
        'hombro',
        'shoulder',
        'triceps',
        'cable',
        'extension',
      ])) {
        return null;
      }
      return _pushUp;
    }
    if (_containsAny(name, ['press de pecho', 'chest press', 'bench press'])) {
      return _chestPress;
    }
    if (_containsAny(name, [
      'press militar',
      'shoulder press',
      'overhead press',
    ])) {
      return _shoulderPress;
    }
    if (_containsAny(name, ['elevacion lateral', 'lateral raise']) &&
        !_containsAny(name, ['frontal', 'front', 'trasera', 'rear'])) {
      return _lateralRaise;
    }
    if (_containsAny(name, ['remo', 'row']) &&
        !_containsAny(name, ['vertical', 'ergometro'])) {
      return _row;
    }
    if (_containsAny(name, ['dominada', 'pull-up', 'pull up', 'chin-up'])) {
      return _pullUp;
    }
    if (_containsAny(name, [
          'plancha frontal',
          'plancha completa',
          'plancha de rodillas',
          'front plank',
          'plank',
        ]) &&
        !_containsAny(name, ['lateral', 'side'])) {
      return _plank;
    }
    if (_containsAny(name, [
      'crunch',
      '3/4 abdominales',
      'cuarto de abdominales',
    ])) {
      if (_containsAny(name, ['giro ruso', 'russian twist'])) return null;
      return _crunch;
    }
    if (_containsAny(name, [
      'step-up',
      'step up',
      'subida al cajon',
      'subida a la caja',
      'subida al banco',
    ])) {
      return _stepUp;
    }
    if (_containsAny(name, [
      'puente de gluteos',
      'puente de cadera',
      'glute bridge',
    ])) {
      return _gluteBridge;
    }
    if (_containsAny(name, [
      'curl femoral',
      'hamstring curl',
      'curl de piernas',
    ])) {
      return _legCurl;
    }
    if (_containsAny(name, [
      'extension de pierna de pie',
      'extension de piernas de pie',
      'standing leg extension',
    ])) {
      return _legExtension;
    }
    if (_containsAny(name, ['pantorrilla', 'calf raise']) &&
        !_containsAny(name, ['salto', 'jump', 'explosivo'])) {
      return _calfRaise;
    }
    if (_containsAny(name, ['curl', 'curling']) &&
        !_containsAny(name, [
          'muneca',
          'wrist',
          'pierna',
          'femoral',
          'triceps',
        ])) {
      return _curl;
    }
    return null;
  }

  static final _romanianDeadlift = ExerciseGuideNote(
    commonMistakes: [
      'Redondear la espalda en vez de llevar la cadera hacia atrás.',
      'Doblar mucho las rodillas y convertir el movimiento en una sentadilla.',
      'Girar el cuello para mirarte en un espejo durante la repetición.',
    ],
    source: 'ACE · Técnica del peso muerto rumano',
    sourceUrl: 'https://www.acefitness.org/continuing-education/certified/may-2025/8865/the-ace-do-it-better-series-the-romanian-deadlift/',
  );

  static String _fold(String value) => value
      .toLowerCase()
      .replaceAll('á', 'a')
      .replaceAll('é', 'e')
      .replaceAll('í', 'i')
      .replaceAll('ó', 'o')
      .replaceAll('ú', 'u')
      .replaceAll('ü', 'u')
      .replaceAll('ñ', 'n');

  static bool _containsAny(String value, List<String> terms) =>
      terms.any(value.contains);
}

class ExerciseGuideNote {
  const ExerciseGuideNote({
    required this.commonMistakes,
    required this.source,
    required this.sourceUrl,
  });

  final List<String> commonMistakes;
  final String source;
  final String sourceUrl;

  List<String> commonMistakesFor(AppLocalizations l10n) {
    final text = switch (source) {
      'ACE · Peso muerto y peso muerto rumano' =>
        l10n.exerciseGuideDeadliftMistakes,
      'ACE · Sentadilla con peso corporal' => l10n.exerciseGuideSquatMistakes,
      'ACE · Zancada hacia delante' => l10n.exerciseGuideLungeMistakes,
      'ACE · Flexión de brazos' => l10n.exerciseGuidePushUpMistakes,
      'ACE · Press de pecho' => l10n.exerciseGuideChestPressMistakes,
      'ACE · Remo inclinado' => l10n.exerciseGuideRowMistakes,
      'ACE · Dominadas supinas' => l10n.exerciseGuidePullUpMistakes,
      'ACE · Plancha frontal' => l10n.exerciseGuidePlankMistakes,
      'ACE · Crunch' => l10n.exerciseGuideCrunchMistakes,
      'ACE · Curl de bíceps' => l10n.exerciseGuideCurlMistakes,
      'ACE · Press de hombros sentado' =>
        l10n.exerciseGuideShoulderPressMistakes,
      'ACE · Elevación lateral' => l10n.exerciseGuideLateralRaiseMistakes,
      'ACE · Curl femoral acostado' => l10n.exerciseGuideLegCurlMistakes,
      'ACE · Extensión de pierna de pie' =>
        l10n.exerciseGuideLegExtensionMistakes,
      'ACE · Elevación de pantorrillas de pie' =>
        l10n.exerciseGuideCalfRaiseMistakes,
      'ACE · Step-up' => l10n.exerciseGuideStepUpMistakes,
      'ACE · Puente de glúteos' => l10n.exerciseGuideGluteBridgeMistakes,
      _ => l10n.exerciseGuideRomanianDeadliftMistakes,
    };
    return text.split('\n');
  }

  String sourceFor(AppLocalizations l10n) => switch (source) {
    'ACE · Peso muerto y peso muerto rumano' =>
      l10n.exerciseGuideDeadliftSource,
    'ACE · Sentadilla con peso corporal' => l10n.exerciseGuideSquatSource,
    'ACE · Zancada hacia delante' => l10n.exerciseGuideLungeSource,
    'ACE · Flexión de brazos' => l10n.exerciseGuidePushUpSource,
    'ACE · Press de pecho' => l10n.exerciseGuideChestPressSource,
    'ACE · Remo inclinado' => l10n.exerciseGuideRowSource,
    'ACE · Dominadas supinas' => l10n.exerciseGuidePullUpSource,
    'ACE · Plancha frontal' => l10n.exerciseGuidePlankSource,
    'ACE · Crunch' => l10n.exerciseGuideCrunchSource,
    'ACE · Curl de bíceps' => l10n.exerciseGuideCurlSource,
    'ACE · Press de hombros sentado' => l10n.exerciseGuideShoulderPressSource,
    'ACE · Elevación lateral' => l10n.exerciseGuideLateralRaiseSource,
    'ACE · Curl femoral acostado' => l10n.exerciseGuideLegCurlSource,
    'ACE · Extensión de pierna de pie' => l10n.exerciseGuideLegExtensionSource,
    'ACE · Elevación de pantorrillas de pie' =>
      l10n.exerciseGuideCalfRaiseSource,
    'ACE · Step-up' => l10n.exerciseGuideStepUpSource,
    'ACE · Puente de glúteos' => l10n.exerciseGuideGluteBridgeSource,
    _ => l10n.exerciseGuideRomanianDeadliftSource,
  };
}
