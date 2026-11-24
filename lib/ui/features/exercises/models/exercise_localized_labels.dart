import 'package:material_ui/material_ui.dart';

import '../../../../app/localization/localization_extensions.dart';
import '../../../../domain/models/exercise.dart';

String localizedExerciseName(BuildContext context, Exercise exercise) {
  final isEnglish = Localizations.localeOf(context).languageCode == 'en';
  return isEnglish ? exercise.englishName ?? exercise.name : exercise.name;
}

List<String> localizedExerciseInstructions(
  BuildContext context,
  Exercise exercise,
) {
  final isEnglish = Localizations.localeOf(context).languageCode == 'en';
  return isEnglish && exercise.englishInstructions.isNotEmpty
      ? exercise.englishInstructions
      : exercise.instructions;
}

String localizedExerciseMuscleGroup(BuildContext context, String value) =>
    switch (value) {
      'Brazos' => context.l10n.exerciseGroupArms,
      'Cardio' => context.l10n.exerciseGroupCardio,
      'Core' => context.l10n.exerciseGroupCore,
      'Cuello' => context.l10n.exerciseGroupNeck,
      'Espalda' => context.l10n.exerciseGroupBack,
      'Hombros' => context.l10n.exerciseGroupShoulders,
      'Pecho' => context.l10n.exerciseGroupChest,
      'Piernas' => context.l10n.exerciseGroupLegs,
      _ => value,
    };

String localizedExerciseTargetMuscle(BuildContext context, String value) {
  if (Localizations.localeOf(context).languageCode == 'en') {
    return _targetMusclesEnglish[value] ?? value;
  }
  return _targetMusclesSpanish[value] ?? value;
}

String localizedExerciseSupportingMuscle(BuildContext context, String value) {
  if (Localizations.localeOf(context).languageCode == 'en') {
    return _supportingMusclesEnglish[value] ?? value;
  }
  return _supportingMusclesSpanish[value] ?? value;
}

const _targetMusclesEnglish = <String, String>{
  'abs': 'abdominals',
  'calves': 'calves',
  'delts': 'deltoids',
  'glutes': 'glutes',
  'hamstrings': 'hamstrings',
  'lats': 'latissimus dorsi',
  'quads': 'quadriceps',
  'spine': 'spinal erectors',
  'traps': 'trapezius',
};

const _targetMusclesSpanish = <String, String>{
  'abductors': 'abductores',
  'abs': 'abdominales',
  'adductors': 'aductores',
  'biceps': 'bíceps',
  'calves': 'pantorrillas',
  'cardiovascular system': 'sistema cardiovascular',
  'delts': 'deltoides',
  'forearms': 'antebrazos',
  'glutes': 'glúteos',
  'hamstrings': 'isquiotibiales',
  'lats': 'dorsales',
  'levator scapulae': 'elevador de la escápula',
  'pectorals': 'pectorales',
  'quads': 'cuádriceps',
  'serratus anterior': 'serrato anterior',
  'spine': 'zona de la columna',
  'traps': 'trapecios',
  'triceps': 'tríceps',
  'upper back': 'espalda alta',
};

const _supportingMusclesEnglish = <String, String>{
  'lats': 'latissimus dorsi',
  'traps': 'trapezius',
};

const _supportingMusclesSpanish = <String, String>{
  'abdominals': 'abdominales',
  'ankle stabilizers': 'estabilizadores del tobillo',
  'ankles': 'tobillos',
  'back': 'espalda',
  'biceps': 'bíceps',
  'brachialis': 'braquial',
  'calves': 'pantorrillas',
  'chest': 'pecho',
  'core': 'core',
  'deltoids': 'deltoides',
  'feet': 'pies',
  'forearms': 'antebrazos',
  'glutes': 'glúteos',
  'grip muscles': 'músculos de agarre',
  'groin': 'ingle',
  'hamstrings': 'isquiotibiales',
  'hands': 'manos',
  'hip flexors': 'flexores de cadera',
  'inner thighs': 'cara interna de los muslos',
  'latissimus dorsi': 'dorsal ancho',
  'lats': 'dorsales',
  'lower abs': 'abdomen inferior',
  'lower back': 'zona lumbar',
  'obliques': 'oblicuos',
  'quadriceps': 'cuádriceps',
  'rear deltoids': 'deltoides posteriores',
  'rhomboids': 'romboides',
  'rotator cuff': 'manguito rotador',
  'shins': 'espinillas',
  'shoulders': 'hombros',
  'soleus': 'sóleo',
  'sternocleidomastoid': 'esternocleidomastoideo',
  'trapezius': 'trapecio',
  'traps': 'trapecios',
  'triceps': 'tríceps',
  'upper back': 'espalda alta',
  'upper chest': 'pecho superior',
  'wrist extensors': 'extensores de la muñeca',
  'wrist flexors': 'flexores de la muñeca',
  'wrists': 'muñecas',
};

String localizedExerciseEquipment(BuildContext context, String value) =>
    switch (value) {
      'Asistido' => context.l10n.exerciseEquipmentAssisted,
      'Balón BOSU' => context.l10n.exerciseEquipmentBosu,
      'Balón de estabilidad' => context.l10n.exerciseEquipmentStabilityBall,
      'Balón medicinal' => context.l10n.exerciseEquipmentMedicineBall,
      'Banda elástica' => context.l10n.exerciseEquipmentResistanceBand,
      'Barra' => context.l10n.exerciseEquipmentBarbell,
      'Barra EZ' => context.l10n.exerciseEquipmentEzBar,
      'Barra hexagonal' => context.l10n.exerciseEquipmentTrapBar,
      'Barra olímpica' => context.l10n.exerciseEquipmentOlympicBar,
      'Bicicleta estática' => context.l10n.exerciseEquipmentStationaryBike,
      'Carga adicional' => context.l10n.exerciseEquipmentAddedWeight,
      'Cuerda' => context.l10n.exerciseEquipmentRope,
      'Elíptica' => context.l10n.exerciseEquipmentElliptical,
      'Ergómetro de tren superior' =>
        context.l10n.exerciseEquipmentUpperBodyErgometer,
      'Escaladora' => context.l10n.exerciseEquipmentStairClimber,
      'Mancuernas' => context.l10n.exerciseEquipmentDumbbells,
      'Martillo' => context.l10n.exerciseEquipmentHammer,
      'Máquina SkiErg' => context.l10n.exerciseEquipmentSkiErg,
      'Máquina Smith' => context.l10n.exerciseEquipmentSmithMachine,
      'Máquina de palanca' => context.l10n.exerciseEquipmentLeverageMachine,
      'Neumático' => context.l10n.exerciseEquipmentTire,
      'Pesa rusa' => context.l10n.exerciseEquipmentKettlebell,
      'Peso corporal' => context.l10n.exerciseEquipmentBodyweight,
      'Polea' => context.l10n.exerciseEquipmentCable,
      'Rodillo' => context.l10n.exerciseEquipmentRoller,
      'Rueda abdominal' => context.l10n.exerciseEquipmentAbWheel,
      'Trineo' => context.l10n.exerciseEquipmentSled,
      _ => value,
    };

String localizedTrainingExerciseName(BuildContext context, String value) =>
    switch (value) {
      'Press con mancuernas' => context.l10n.trainingNameDumbbellPress,
      'Sentadilla goblet' => context.l10n.trainingNameGobletSquat,
      'Remo con mancuerna' => context.l10n.trainingNameDumbbellRow,
      'Peso muerto rumano' => context.l10n.trainingNameRomanianDeadlift,
      'Press de hombros' => context.l10n.trainingNameShoulderPress,
      'Sentadilla con barra' => context.l10n.trainingNameBarbellSquat,
      'Press de banca con barra' => context.l10n.trainingNameBarbellBench,
      'Remo con barra' => context.l10n.trainingNameBarbellRow,
      'Peso muerto con barra' => context.l10n.trainingNameBarbellDeadlift,
      'Press de pecho con banda' => context.l10n.trainingNameBandChestPress,
      'Remo con banda' => context.l10n.trainingNameBandRow,
      'Sentadilla con banda' => context.l10n.trainingNameBandSquat,
      'Separación de banda' => context.l10n.trainingNameBandPullApart,
      'Apertura inversa con banda' => context.l10n.trainingNameBandReverseFly,
      'Press de pecho en máquina' => context.l10n.trainingNameMachineChestPress,
      'Prensa de piernas' => context.l10n.trainingNameLegPress,
      'Jalón al pecho' => context.l10n.trainingNameLatPulldown,
      'Remo sentado' => context.l10n.trainingNameSeatedRow,
      'Flexiones' => context.l10n.trainingNamePushUp,
      'Flexiones inclinadas' => context.l10n.trainingNameInclinePushUp,
      'Flexiones de pica a cobra' => context.l10n.trainingNamePikeToCobra,
      'Pike push-up' => context.l10n.trainingNamePikePushUp,
      'Zancadas' => context.l10n.trainingNameLunges,
      'Sentadilla con salto' => context.l10n.trainingNameJumpSquat,
      'Sentadilla con peso corporal' =>
        context.l10n.trainingNameBodyweightSquat,
      'Elevación de pantorrillas' => context.l10n.trainingNameCalfRaise,
      'Puente de glúteos' => context.l10n.trainingNameGluteBridge,
      'Plancha lateral inclinada' => context.l10n.trainingNameSidePlank,
      'Bird-dog' => context.l10n.trainingNameBirdDog,
      'Dead bug' => context.l10n.trainingNameDeadBug,
      'Plancha' => context.l10n.trainingNamePlank,
      _ => value,
    };
