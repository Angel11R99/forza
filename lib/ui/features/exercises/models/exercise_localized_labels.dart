import 'package:material_ui/material_ui.dart';

import '../../../../app/localization/localization_extensions.dart';

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
