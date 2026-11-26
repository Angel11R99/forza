// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get settingsLanguageTitle => 'Idioma de la aplicación';

  @override
  String get settingsLanguageDescription =>
      'Elige el idioma que se usa en FORZA.';

  @override
  String get settingsLanguageAutomatic => 'Idioma del dispositivo';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageSpanish => 'Español';

  @override
  String get settingsLanguageSystemDescription =>
      'Usa el idioma configurado en tu dispositivo.';

  @override
  String get settingsLanguageSelection => 'Idioma';

  @override
  String get settingsLanguageAutomaticDescription =>
      'Sigue el idioma configurado en tu dispositivo.';

  @override
  String get settingsAppearanceTitle => 'Apariencia';

  @override
  String get settingsThemeTitle => 'Elige tu tema';

  @override
  String get settingsThemeSystem => 'Según el dispositivo';

  @override
  String get settingsThemeSystemDescription => 'Sigue el tema del sistema.';

  @override
  String get settingsThemeLight => 'Claro';

  @override
  String get settingsThemeDark => 'Oscuro';

  @override
  String homeWelcome(Object name) {
    return 'Te damos la bienvenida, $name';
  }

  @override
  String get homeStreakCurrent => 'Racha actual';

  @override
  String get homeStreakDay => 'día';

  @override
  String get homeStreakDays => 'días';

  @override
  String homeStreakCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count días',
      one: '1 día',
      zero: '0 días',
    );
    return '$_temp0';
  }

  @override
  String homeStreakSemantics(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Racha actual: $count días',
      one: 'Racha actual: 1 día',
      zero: 'Racha actual: 0 días',
    );
    return '$_temp0';
  }

  @override
  String workoutCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count entrenamientos',
      one: '1 entrenamiento',
      zero: 'Ningún entrenamiento',
    );
    return '$_temp0';
  }

  @override
  String get exerciseEyebrow => 'Ejercicios';

  @override
  String get exerciseLibraryTitle => 'Biblioteca de ejercicios';

  @override
  String get exerciseLibrarySubtitle =>
      'Encuentra movimientos para tu próxima sesión.';

  @override
  String get exerciseSearchHint => 'Ejercicio, músculo o equipo';

  @override
  String get exerciseClearSearch => 'Borrar búsqueda';

  @override
  String get exerciseOpenFilters => 'Abrir filtros';

  @override
  String exerciseActiveFilters(int count) {
    return 'Filtros activos: $count';
  }

  @override
  String get exerciseSearchResultsTitle => 'Resultados de búsqueda';

  @override
  String get exerciseAllResultsTitle => 'Todos los ejercicios';

  @override
  String exerciseFoundCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ejercicios encontrados',
      one: '1 ejercicio encontrado',
      zero: 'No se encontraron ejercicios',
    );
    return '$_temp0';
  }

  @override
  String get exerciseLoadError => 'No pudimos cargar los ejercicios.';

  @override
  String get exerciseRetry => 'Reintentar';

  @override
  String get exerciseEmptyTitle => 'No encontramos ejercicios';

  @override
  String get exerciseEmptySubtitle =>
      'Prueba otra búsqueda o quita algunos filtros.';

  @override
  String get exerciseClearSearchAndFilters => 'Limpiar búsqueda y filtros';

  @override
  String get exerciseFiltersTitle => 'Filtros';

  @override
  String get exerciseClearFilters => 'Limpiar';

  @override
  String get exerciseRemoveActiveFilters => 'Limpiar filtros';

  @override
  String get exerciseAdjustSearchTitle => 'Ajusta tu búsqueda';

  @override
  String get exerciseFiltersDescription =>
      'Combina grupo muscular y equipo para encontrar movimientos adecuados.';

  @override
  String get exerciseMuscleGroupFilter => 'Grupo muscular';

  @override
  String get exerciseEquipmentFilter => 'Equipo';

  @override
  String exerciseShowResults(int count) {
    return 'Mostrar resultados · $count';
  }

  @override
  String get exerciseAlternativesTitle => 'Alternativas';

  @override
  String exerciseAlternativesTo(String name) {
    return 'Alternativas a $name';
  }

  @override
  String get exerciseAlternativesDescription =>
      'Más ejercicios para trabajar un grupo muscular parecido.';

  @override
  String get exerciseAlternativesEmpty =>
      'No hay alternativas disponibles para este ejercicio.';

  @override
  String get exerciseDetailTitle => 'Detalle del ejercicio';

  @override
  String get exerciseHowTo => 'Cómo hacerlo';

  @override
  String get exerciseInstructionStep => 'Paso';

  @override
  String get exerciseGuideHeading => 'Claves técnicas y errores frecuentes';

  @override
  String get exerciseGuideVariantNote =>
      'Pautas de una variante de referencia. Compara cada punto con los pasos de este ejercicio.';

  @override
  String exerciseSourcePrefix(String source) {
    return 'Fuente: $source';
  }

  @override
  String exerciseSourceLink(String url) {
    return 'Enlace de la fuente: $url';
  }

  @override
  String get exerciseSourceOpenFailure => 'No se pudo abrir la fuente.';

  @override
  String get exerciseViewAlternatives => 'Ver alternativas';

  @override
  String get exerciseAnimationUnavailable =>
      'Sin ilustración animada · consulta los pasos';

  @override
  String get exerciseAnimationIllustrative =>
      'Ilustración orientativa · el ritmo depende de ti';

  @override
  String exerciseAnimationLabel(String name) {
    return 'Animación: $name';
  }

  @override
  String get exerciseFlipHint => 'Toca o desliza';

  @override
  String get exerciseFlipSemanticsFront =>
      'Toca o desliza para ver para qué sirve y qué músculos trabaja';

  @override
  String get exerciseFlipSemanticsBack =>
      'Toca o desliza para volver a la animación';

  @override
  String get exerciseInfoHeading => 'Para qué sirve';

  @override
  String get exerciseInfoPrimaryMuscle => 'Músculo principal';

  @override
  String get exerciseInfoCatalogGroup => 'Grupo del catálogo';

  @override
  String get exerciseInfoBenefitUnavailable =>
      'Sigue los pasos del ejercicio para conocer su enfoque.';

  @override
  String get exerciseInfoSupportingMuscles => 'También trabaja';

  @override
  String exerciseInfoBenefitStrength(Object muscle) {
    return 'Fortalece $muscle y mejora el control de este movimiento.';
  }

  @override
  String exerciseInfoBenefitMobility(Object muscle) {
    return 'Mejora la movilidad de $muscle mediante un estiramiento controlado.';
  }

  @override
  String get exerciseInfoBenefitCardio =>
      'Desarrolla la resistencia cardiovascular y el acondicionamiento general.';

  @override
  String get exerciseInfoNoSupportingMuscles =>
      'El catálogo no indica músculos secundarios.';

  @override
  String exerciseInfoMoreMuscles(int count) {
    return 'y $count más';
  }

  @override
  String get exerciseAnimationPlay => 'Reproducir animación';

  @override
  String get exerciseAnimationPause => 'Pausar animación';

  @override
  String exerciseCardSemantics(String name, String group, String equipment) {
    return '$name, $group, equipo: $equipment';
  }

  @override
  String get exerciseGroupArms => 'Brazos';

  @override
  String get exerciseGroupCardio => 'Cardio';

  @override
  String get exerciseGroupCore => 'Core';

  @override
  String get exerciseGroupNeck => 'Cuello';

  @override
  String get exerciseGroupBack => 'Espalda';

  @override
  String get exerciseGroupShoulders => 'Hombros';

  @override
  String get exerciseGroupChest => 'Pecho';

  @override
  String get exerciseGroupLegs => 'Piernas';

  @override
  String get exerciseEquipmentAssisted => 'Asistido';

  @override
  String get exerciseEquipmentBosu => 'Balón BOSU';

  @override
  String get exerciseEquipmentStabilityBall => 'Balón de estabilidad';

  @override
  String get exerciseEquipmentMedicineBall => 'Balón medicinal';

  @override
  String get exerciseEquipmentResistanceBand => 'Banda elástica';

  @override
  String get exerciseEquipmentBarbell => 'Barra';

  @override
  String get exerciseEquipmentEzBar => 'Barra EZ';

  @override
  String get exerciseEquipmentTrapBar => 'Barra hexagonal';

  @override
  String get exerciseEquipmentOlympicBar => 'Barra olímpica';

  @override
  String get exerciseEquipmentStationaryBike => 'Bicicleta estática';

  @override
  String get exerciseEquipmentAddedWeight => 'Carga adicional';

  @override
  String get exerciseEquipmentRope => 'Cuerda';

  @override
  String get exerciseEquipmentElliptical => 'Elíptica';

  @override
  String get exerciseEquipmentUpperBodyErgometer =>
      'Ergómetro de tren superior';

  @override
  String get exerciseEquipmentStairClimber => 'Escaladora';

  @override
  String get exerciseEquipmentDumbbells => 'Mancuernas';

  @override
  String get exerciseEquipmentHammer => 'Martillo';

  @override
  String get exerciseEquipmentSkiErg => 'Máquina SkiErg';

  @override
  String get exerciseEquipmentSmithMachine => 'Máquina Smith';

  @override
  String get exerciseEquipmentLeverageMachine => 'Máquina de palanca';

  @override
  String get exerciseEquipmentTire => 'Neumático';

  @override
  String get exerciseEquipmentKettlebell => 'Pesa rusa';

  @override
  String get exerciseEquipmentBodyweight => 'Peso corporal';

  @override
  String get exerciseEquipmentCable => 'Polea';

  @override
  String get exerciseEquipmentRoller => 'Rodillo';

  @override
  String get exerciseEquipmentAbWheel => 'Rueda abdominal';

  @override
  String get exerciseEquipmentSled => 'Trineo';

  @override
  String get exerciseGuideDeadliftMistakes =>
      'Redondear la espalda al bajar hacia el suelo.\nAlejar la carga del cuerpo durante la subida.\nTerminar inclinándose hacia atrás en vez de quedar de pie con control.';

  @override
  String get exerciseGuideDeadliftSource => 'ACE · Peso muerto';

  @override
  String get exerciseGuideSquatMistakes =>
      'Dejar que las rodillas se inclinen hacia dentro en vez de seguir la dirección de los pies.\nDespegar los talones o perder el apoyo del pie al bajar.\nForzar más profundidad cuando ya no puedes mantener el control y una postura cómoda.';

  @override
  String get exerciseGuideSquatSource => 'ACE · Sentadilla con peso corporal';

  @override
  String get exerciseGuideLungeMistakes =>
      'Inclinar o balancear el tronco hacia los lados durante el paso.\nPerder el apoyo del pie delantero o dejar que la rodilla pierda su alineación.\nRebotar al fondo en vez de bajar y volver con control.';

  @override
  String get exerciseGuideLungeSource => 'ACE · Zancada hacia delante';

  @override
  String get exerciseGuidePushUpMistakes =>
      'Dejar caer la zona lumbar o elevar la cadera al bajar y empujar.\nAdelantar la cabeza en lugar de mantenerla alineada con el tronco.\nAcortar el recorrido con repeticiones rápidas que pierden la posición del cuerpo.';

  @override
  String get exerciseGuidePushUpSource => 'ACE · Flexión de brazos';

  @override
  String get exerciseGuideChestPressMistakes =>
      'Rebotar la carga contra el pecho al cambiar de dirección.\nArquear la zona lumbar o perder los puntos de apoyo para terminar la repetición.\nDoblar las muñecas hacia atrás en vez de mantenerlas alineadas con los antebrazos.';

  @override
  String get exerciseGuideChestPressSource => 'ACE · Press de pecho';

  @override
  String get exerciseGuideRowMistakes =>
      'Balancear el torso para iniciar cada tirón.\nRedondear la espalda en vez de mantener la posición estable descrita para el ejercicio.\nDejar caer la carga rápidamente al volver a la posición inicial.';

  @override
  String get exerciseGuideRowSource => 'ACE · Remo inclinado';

  @override
  String get exerciseGuidePullUpMistakes =>
      'Impulsar el cuerpo con balanceos en vez de tirar con control.\nEncoger los hombros o perder la alineación del tronco durante la subida.\nSoltar la bajada sin control antes de llegar a la posición inicial.';

  @override
  String get exerciseGuidePullUpSource => 'ACE · Dominada supina';

  @override
  String get exerciseGuidePlankMistakes =>
      'Dejar caer la zona lumbar o elevar demasiado la cadera.\nEncoger los hombros o perder la posición de apoyo.\nContener la respiración mientras sostienes la postura.';

  @override
  String get exerciseGuidePlankSource => 'ACE · Plancha frontal';

  @override
  String get exerciseGuideCrunchMistakes =>
      'Tirar del cuello con las manos, si esa variante las coloca detrás de la cabeza.\nHacer impulso con las piernas o subir rápidamente en vez de enrollar el torso.\nCambiar la posición de la espalda o las caderas que indican los pasos de esta variante.';

  @override
  String get exerciseGuideCrunchSource => 'ACE · Crunch';

  @override
  String get exerciseGuideCurlMistakes =>
      'Balancear el tronco para ayudar a mover la carga.\nDesplazar los codos hacia delante durante la flexión si la variante pide mantenerlos junto al cuerpo.\nSoltar la carga rápidamente durante el regreso.';

  @override
  String get exerciseGuideCurlSource => 'ACE · Curl de bíceps';

  @override
  String get exerciseGuideShoulderPressMistakes =>
      'Arquear la zona lumbar para llevar la carga por encima de la cabeza.\nDejar caer la carga sin controlar el regreso.\nDoblar las muñecas en vez de mantenerlas alineadas con los antebrazos.';

  @override
  String get exerciseGuideShoulderPressSource =>
      'ACE · Press de hombros sentado';

  @override
  String get exerciseGuideLateralRaiseMistakes =>
      'Encoger los hombros en vez de mantenerlos bajos y atrás.\nBalancear el torso o arquear la zona lumbar para levantar más carga.\nDoblar las muñecas o elevar los brazos por encima de los hombros.';

  @override
  String get exerciseGuideLateralRaiseSource => 'ACE · Elevación lateral';

  @override
  String get exerciseGuideLegCurlMistakes =>
      'Arquear la espalda o levantar la cadera para ayudar a doblar la rodilla.\nMover el muslo cuando la variante pide mantenerlo apoyado.\nDejar volver la resistencia sin control.';

  @override
  String get exerciseGuideLegCurlSource => 'ACE · Curl femoral acostado';

  @override
  String get exerciseGuideLegExtensionMistakes =>
      'Aumentar el recorrido hasta que la cadera o el tronco tengan que inclinarse.\nUsar impulso en vez de extender y regresar la pierna con control.\nElegir una resistencia que impida mantener el equilibrio y la postura.';

  @override
  String get exerciseGuideLegExtensionSource =>
      'ACE · Extensión de pierna de pie';

  @override
  String get exerciseGuideCalfRaiseMistakes =>
      'Rebotar en vez de pausar y mover los talones de forma controlada.\nGirar los pies durante una repetición si la variante pide mantenerlos al frente.\nUsar una altura que haga perder el equilibrio o el control del regreso.';

  @override
  String get exerciseGuideCalfRaiseSource =>
      'ACE · Elevación de pantorrillas de pie';

  @override
  String get exerciseGuideStepUpMistakes =>
      'Dejar que el pie o el tobillo pierdan apoyo sobre la plataforma.\nPermitir que la rodilla se incline hacia dentro en vez de mantenerla alineada con el pie.\nBajar de la plataforma sin controlar el peso del cuerpo.';

  @override
  String get exerciseGuideStepUpSource => 'ACE · Step-up';

  @override
  String get exerciseGuideGluteBridgeMistakes =>
      'Elevar las caderas tan alto que se arquee la zona lumbar.\nEmpujar con la espalda en vez de extender la cadera con control.\nDejar caer las caderas rápidamente al volver al suelo.';

  @override
  String get exerciseGuideGluteBridgeSource => 'ACE · Puente de glúteos';

  @override
  String get exerciseGuideRomanianDeadliftMistakes =>
      'Redondear la espalda en vez de llevar la cadera hacia atrás.\nDoblar mucho las rodillas y convertir el movimiento en una sentadilla.\nGirar el cuello para mirarte en un espejo durante la repetición.';

  @override
  String get exerciseGuideRomanianDeadliftSource =>
      'ACE · Técnica del peso muerto rumano';

  @override
  String get homeGreetingMorning => 'Buenos días';

  @override
  String get homeGreetingAfternoon => 'Buenas tardes';

  @override
  String get homeGreetingEvening => 'Buenas noches';

  @override
  String get homeProfileTooltip => 'Abrir perfil';

  @override
  String get homePlanTitle => 'Tu plan de entrenamiento';

  @override
  String get homeTodayWorkout => 'Entrenamiento de hoy';

  @override
  String homeNextSession(Object weekday) {
    return 'Próxima sesión · $weekday';
  }

  @override
  String get homeAdjustPlan => 'Ajustar plan';

  @override
  String get homeWeekTitle => 'Tu semana';

  @override
  String get homeViewActivity => 'Ver actividad';

  @override
  String get homeTodaySession => 'SESIÓN DE HOY';

  @override
  String homeNextSessionLabel(Object weekday) {
    return 'SIGUIENTE SESIÓN · $weekday';
  }

  @override
  String homeDurationExercises(Object count, Object minutes) {
    return 'Presupuesto aprox. $minutes min por sesión · $count ejercicios';
  }

  @override
  String get homeContinueWorkout => 'Continuar entrenamiento';

  @override
  String get homeViewTodaySession => 'Ver sesión de hoy';

  @override
  String homeSessionAvailableOn(String weekday) {
    return 'Disponible el $weekday';
  }

  @override
  String get homeSessionCompleted => 'Sesión completada';

  @override
  String get homeSessionCompletedDescription =>
      'Buen trabajo. Ya completaste el entrenamiento de hoy.';

  @override
  String get homeSessionSkipped => 'Sesión omitida';

  @override
  String get homeSessionSkippedDescription =>
      'La sesión de hoy quedó omitida. Puedes revisar tu plan.';

  @override
  String get homeRecoveryDay => 'Día de recuperación';

  @override
  String get homeRecoveryDescription =>
      'Hoy no tienes una sesión programada. Descansa y recupérate.';

  @override
  String homeWeeklySessionCount(Object done, Object target) {
    return '$done de $target sesiones';
  }

  @override
  String get homeThisWeek => 'Esta semana';

  @override
  String homeWeeklyGoal(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sesiones semanales.',
      one: '1 sesión semanal.',
    );
    return 'Tu meta es $_temp0';
  }

  @override
  String get homeStatusCompleted => 'completada';

  @override
  String get homeStatusSkipped => 'omitida';

  @override
  String get homeStatusPending => 'pendiente';

  @override
  String get homeStatusRest => 'descanso';

  @override
  String get homeStatusRescheduled => 'reprogramada';

  @override
  String get homeRescheduledExplanation =>
      'Las sesiones reprogramadas pueden aparecer en otro día o fuera de esta semana.';

  @override
  String get activityTitle => 'Actividad';

  @override
  String get activitySubtitle => 'Tu calendario de entrenamiento.';

  @override
  String get activityTodayDetail => 'Detalle del día';

  @override
  String get activityToday => 'Hoy';

  @override
  String get activityRescheduleConflict => 'Ese día ya tiene una sesión.';

  @override
  String activityRescheduled(Object date) {
    return 'Sesión movida al $date.';
  }

  @override
  String get activityPreviousMonth => 'Mes anterior';

  @override
  String get activityNextMonth => 'Mes siguiente';

  @override
  String get activityRecoveryDay => 'Día de recuperación';

  @override
  String get activityNoSession => 'No hay sesión programada para este día.';

  @override
  String activityExerciseCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ejercicios',
      one: '1 ejercicio',
    );
    return '$_temp0';
  }

  @override
  String get activitySessionCompleted => 'Sesión completada';

  @override
  String get activityWorkoutInProgress => 'Entrenamiento en curso';

  @override
  String get activityContinueWorkout => 'Continuar entrenamiento';

  @override
  String get activityRepeatWorkout => 'Repetir entrenamiento';

  @override
  String get activityStartSession => 'Empezar sesión';

  @override
  String get activityScheduledSession => 'Sesión programada';

  @override
  String get activityCompletedOutside => 'Ya entrené fuera de la app';

  @override
  String get activitySkipSession => 'Omitir sesión';

  @override
  String get activitySessionSkipped => 'Sesión omitida';

  @override
  String get activityStatusRescheduled => 'Reprogramada';

  @override
  String get activityStatusInProgress => 'En curso';

  @override
  String get activityCalendarLegendAction => 'Ver estados';

  @override
  String get activityCalendarLegendTitle => 'Estados del calendario';

  @override
  String get activityCalendarLegendClose => 'Cerrar';

  @override
  String get activityPlannedRoutine => 'Rutina prevista';

  @override
  String get activityActualRecord => 'Registro real';

  @override
  String get activityOutsideAppDataNote =>
      'Se registró el entrenamiento, pero no hay series ni repeticiones guardadas.';

  @override
  String activitySetCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count series registradas',
      one: '1 serie registrada',
    );
    return '$_temp0';
  }

  @override
  String get activityMoreActions => 'Más acciones';

  @override
  String get activityConfirmExternalTitle => 'Registrar entrenamiento externo';

  @override
  String get activityConfirmExternalMessage =>
      'Se guardará como completado sin datos de series ni repeticiones. ¿Quieres continuar?';

  @override
  String get activityConfirmSkipTitle => 'Omitir sesión';

  @override
  String get activityConfirmSkipMessage =>
      'La sesión quedará marcada como omitida. Puedes deshacerlo después.';

  @override
  String get activityConfirmAction => 'Confirmar';

  @override
  String get activityUndoSkip => 'Deshacer omisión';

  @override
  String get activitySkipUndone => 'La sesión vuelve a estar pendiente';

  @override
  String get activityChangeDay => 'Cambiar día';

  @override
  String get rescheduleTitle => 'Reprogramar sesión';

  @override
  String get rescheduleEyebrow => 'Actividad';

  @override
  String get rescheduleHeading => 'Mueve tu sesión';

  @override
  String rescheduleCurrentDate(Object date) {
    return 'Fecha actual: $date';
  }

  @override
  String get rescheduleAvailableDates => 'Fechas disponibles';

  @override
  String get rescheduleNoDates =>
      'No encontramos otra fecha disponible en las próximas dos semanas.';

  @override
  String get rescheduleConfirm => 'Confirmar nueva fecha';

  @override
  String get reschedulePersistenceNote =>
      'Los cambios se mantienen mientras la app está abierta.';

  @override
  String rescheduleAvailableDateSemantics(Object date) {
    return '$date, fecha disponible';
  }

  @override
  String get profileEyebrow => 'Cuenta';

  @override
  String get profileTitle => 'Perfil';

  @override
  String get profileEdit => 'Editar perfil';

  @override
  String get profileEditSubtitle => 'Nombre y objetivo de entrenamiento';

  @override
  String get profileAccountAccess => 'Cuenta y acceso';

  @override
  String get profileAccountAccessSubtitle =>
      'Opcional · la sincronización se activa por separado';

  @override
  String get profileGoogleConnected => 'Conectado con Google';

  @override
  String get profileNoAccount => 'Sin cuenta';

  @override
  String get profileAccountChecking => 'Comprobando cuenta';

  @override
  String get profileAccountCheckingDescription =>
      'Estamos revisando si hay una cuenta conectada.';

  @override
  String get profileGuestDescription =>
      'Sin cuenta · datos guardados en este dispositivo';

  @override
  String get profilePrivacy => 'Privacidad';

  @override
  String get profilePrivate => 'Perfil privado';

  @override
  String get profileVisible => 'Perfil visible';

  @override
  String get profileTraining => 'Entrenamiento';

  @override
  String get profileMyPlan => 'Mi plan de entrenamiento';

  @override
  String profilePlanSummary(Object days, Object goal, Object minutes) {
    return '$goal · $days días · presupuesto ~$minutes min';
  }

  @override
  String get profilePreferences => 'Preferencias';

  @override
  String get profileAppearance => 'Apariencia';

  @override
  String profileWeightUnit(Object unit) {
    return 'Peso $unit';
  }

  @override
  String profileWeekStart(Object day) {
    return 'semana desde $day';
  }

  @override
  String profileHaptics(Object status) {
    return 'háptica $status';
  }

  @override
  String get profileHapticsOn => 'activa';

  @override
  String get profileHapticsOff => 'desactivada';

  @override
  String get profileBackup => 'Exportar y restaurar datos';

  @override
  String get profileBackupSubtitle => 'Crear un respaldo o recuperar tus datos';

  @override
  String get profileNotifications => 'Notificaciones';

  @override
  String profileReminderAt(Object time) {
    return 'Recordatorio $time';
  }

  @override
  String get profileRemindersOff => 'Recordatorios desactivados';

  @override
  String get profileSessionPreferencesNote =>
      'Las preferencias se mantienen mientras la app está abierta.';

  @override
  String get commonCancel => 'Cancelar';

  @override
  String get commonRetry => 'Inténtalo de nuevo';

  @override
  String get commonBack => 'Volver';

  @override
  String get commonFinish => 'Finalizar';

  @override
  String get commonRemove => 'Retirar';

  @override
  String homeWeekdayStatus(Object day, Object status) {
    return '$day: $status';
  }

  @override
  String get profileEditTitle => 'Editar perfil';

  @override
  String get profileNameField => 'Nombre';

  @override
  String get profileEmailField => 'Correo';

  @override
  String get profileGoalField => 'Objetivo de entrenamiento';

  @override
  String get profileReviewChanges => 'Revisar cambios';

  @override
  String get profilePreferencesTitle => 'Preferencias';

  @override
  String get profileWeightUnitTitle => 'Unidad de peso';

  @override
  String get profileWeekStartTitle => 'Inicio de semana';

  @override
  String get profileHapticTitle => 'Respuesta háptica';

  @override
  String get profileSavePreferences => 'Guardar preferencias';

  @override
  String get profileSettingsLoadFailed =>
      'No se pudieron cargar tus preferencias. Inténtalo otra vez.';

  @override
  String get profileSettingsSaveFailed =>
      'No se pudieron guardar tus preferencias. Inténtalo otra vez.';

  @override
  String get profileNotificationsPageTitle => 'Notificaciones';

  @override
  String get profileWorkoutReminders => 'Recordatorios de entrenamiento';

  @override
  String get profileReminderDescription =>
      'Te avisaremos cerca de esta hora en los días con una sesión pendiente.';

  @override
  String get profileReminderPermissionDenied =>
      'Permite las notificaciones del dispositivo para recibir recordatorios.';

  @override
  String get profileReminderScheduleFailed =>
      'No se pudieron actualizar los recordatorios. Inténtalo otra vez.';

  @override
  String get workoutReminderNotificationTitle => 'FORZA · entrenamiento de hoy';

  @override
  String get workoutReminderNotificationBody =>
      'Tienes una sesión programada para hoy. ¡Tú puedes!';

  @override
  String get profileReminderTime => 'Hora del recordatorio';

  @override
  String get profileWeeklySummary => 'Resumen semanal';

  @override
  String get profileWeeklySummaryDescription => 'Un repaso de tu actividad.';

  @override
  String get profilePersonalRecords => 'Récords personales';

  @override
  String get profileSaveNotifications => 'Guardar preferencias';

  @override
  String get profilePrivacyTitle => 'Privacidad y cuenta';

  @override
  String get profilePrivateTitle => 'Perfil privado';

  @override
  String get profilePrivateDescription => 'Solo tú puedes ver tu perfil.';

  @override
  String get profileShareActivityTitle => 'Compartir actividad';

  @override
  String get profileShareActivityDescription =>
      'Permite mostrar tus avances en la app.';

  @override
  String get profileConfirmAccount => 'Confirmar datos de cuenta';

  @override
  String get profileSavePrivacy => 'Guardar privacidad';

  @override
  String get profileReviewComplete => 'Revisión de datos completada.';

  @override
  String get profileAccountConfirmation => 'Revisar perfil';

  @override
  String get profileReviewTitle => 'Revisar perfil';

  @override
  String get profileName => 'Nombre';

  @override
  String get profileEmail => 'Correo';

  @override
  String get profileGoal => 'Objetivo';

  @override
  String get profileConfirmDetails => 'Guardar datos';

  @override
  String get profileSaveDetails => 'Guardar perfil';

  @override
  String get profileThemeDevice => 'Según el dispositivo';

  @override
  String get profileThemeLight => 'Claro';

  @override
  String get profileThemeDark => 'Oscuro';

  @override
  String get profileThemeAppearance => 'Apariencia';

  @override
  String get profileThemeDescription => 'Elige cómo quieres ver FORZA.';

  @override
  String get profileWeightKg => 'Kilogramos (kg)';

  @override
  String get profileWeightLb => 'Libras (lb)';

  @override
  String get profileWeekMonday => 'Lunes';

  @override
  String get profileWeekSunday => 'Domingo';

  @override
  String get backupTitle => 'Exportar y restaurar';

  @override
  String get backupEyebrow => 'Tus datos';

  @override
  String get backupHeading => 'Un respaldo bajo tu control';

  @override
  String get backupDescription =>
      'El archivo incluye tu plan, historial con series, agenda, objetivos, sesión activa y apariencia. Se guarda como JSON en la ubicación que elijas.';

  @override
  String get backupExport => 'Exportar';

  @override
  String get backupExportDescription =>
      'Crea un archivo que puedes guardar o transferir a otro dispositivo.';

  @override
  String get backupCreate => 'Crear respaldo';

  @override
  String get backupRestore => 'Restaurar';

  @override
  String get backupRestoreDescription =>
      'Revisa el contenido y confirma antes de reemplazar los datos locales.';

  @override
  String get backupChooseFile => 'Elegir archivo de respaldo';

  @override
  String get backupSaveDialog => 'Guardar respaldo de FORZA';

  @override
  String get backupPickDialog => 'Seleccionar respaldo de FORZA';

  @override
  String get backupSaved => 'Respaldo guardado.';

  @override
  String get backupRestored => 'Respaldo restaurado.';

  @override
  String get backupConfirmTitle => 'Restaurar respaldo';

  @override
  String backupConfirmMessage(
    Object date,
    Object goals,
    Object measurements,
    Object records,
    Object schedule,
  ) {
    return 'Se reemplazarán los datos locales por los del respaldo del $date. Incluye $records sesiones de historial, $schedule sesiones de agenda, $goals objetivos y $measurements registros de medidas. Esta acción no se puede deshacer.';
  }

  @override
  String get backupReplace => 'Reemplazar datos';

  @override
  String get backupGenericError =>
      'No pudimos procesar el archivo. Inténtalo de nuevo.';

  @override
  String get profileResetSectionTitle => 'Restablecer datos locales';

  @override
  String get profileResetSectionDescription =>
      'Borra los datos de entrenamiento de este dispositivo. Puedes guardar un respaldo antes; se conservarán idioma, apariencia y preferencias de la app.';

  @override
  String get profileResetAction => 'Restablecer datos';

  @override
  String get profileResetConfirmTitle => '¿Borrar los datos locales?';

  @override
  String get profileResetConfirmMessage =>
      'Se eliminarán el plan, la agenda, el historial y sus series, las metas, las medidas y la sesión en curso. Se conservarán idioma, tema, unidad, hápticos, privacidad y ajustes de recordatorios. El catálogo de ejercicios no se borra.';

  @override
  String get profileResetBackupOption =>
      'Guardar un respaldo JSON antes de borrar';

  @override
  String get profileResetConfirmButton => 'Borrar datos';

  @override
  String get profileResetBackupCancelled =>
      'No se borraron datos porque el respaldo no se guardó.';

  @override
  String get profileResetCompleted =>
      'Datos eliminados. Configura un nuevo plan para continuar.';

  @override
  String get profileResetFailed =>
      'No se pudieron borrar los datos. No se completó el reinicio.';

  @override
  String get accountWelcomeTitle => 'Una cuenta es opcional.';

  @override
  String get accountWelcomeDescription =>
      'Puedes entrenar sin una cuenta. Iniciar sesión con Google no sube tus datos; la sincronización se activa por separado en Perfil.';

  @override
  String get accountSignInWithGoogle => 'Continuar con Google';

  @override
  String get accountSwitchGoogle => 'Cambiar cuenta de Google';

  @override
  String get accountContinueWithoutAccount => 'Seguir sin cuenta';

  @override
  String get accountSignOut => 'Cerrar sesión';

  @override
  String get accountSignOutTitle => '¿Cerrar sesión?';

  @override
  String get accountSignOutMessage =>
      'Se cerrará la cuenta de Google en Forza. Tus entrenamientos y preferencias locales permanecerán en este dispositivo.';

  @override
  String get accountLocalDataNote =>
      'Tus datos se quedan en este dispositivo hasta que aceptes activar la sincronización en Perfil.';

  @override
  String get accountConfigurationRequired =>
      'No se pudo iniciar Google. Revisa la configuración OAuth de Android o iOS y vuelve a intentarlo.';

  @override
  String get accountProviderUnavailable =>
      'Google no está disponible. Comprueba tu conexión o inténtalo otra vez.';

  @override
  String get accountAuthenticationFailed =>
      'No se pudo completar el acceso. Inténtalo de nuevo.';

  @override
  String get onboardingSkip => 'Omitir por ahora';

  @override
  String get onboardingCreatePlan => 'Crear tu plan';

  @override
  String get onboardingPreview => 'Vista previa';

  @override
  String get onboardingBack => 'Volver';

  @override
  String get onboardingPreviousStep => 'Paso anterior';

  @override
  String get onboardingContinue => 'Continuar';

  @override
  String onboardingStepLabel(Object step, Object total) {
    return 'Paso $step de $total';
  }

  @override
  String get onboardingGoalTitle => '¿Qué quieres lograr?';

  @override
  String get onboardingGoalDescription =>
      'Elegiremos un punto de partida que se ajuste a ti. Puedes cambiarlo después.';

  @override
  String get onboardingStrengthGoal => 'Ganar fuerza';

  @override
  String get onboardingMuscleGoal => 'Ganar músculo';

  @override
  String get onboardingHabitGoal => 'Crear el hábito';

  @override
  String get onboardingStrengthGoalDescription =>
      'Progresar en tus levantamientos';

  @override
  String get onboardingMuscleGoalDescription =>
      'Construir masa muscular con constancia';

  @override
  String get onboardingHabitGoalDescription => 'Formar una rutina sostenible';

  @override
  String get onboardingExperienceTitle => '¿Cuál es tu experiencia?';

  @override
  String get onboardingExperienceDescription =>
      'Usaremos tu respuesta para ajustar las series iniciales de cada ejercicio.';

  @override
  String get onboardingExperienceBeginner => 'Estoy empezando';

  @override
  String get onboardingExperienceSome => 'Tengo algo de experiencia';

  @override
  String get onboardingExperienceLong => 'Entreno hace tiempo';

  @override
  String get onboardingExperienceBeginnerDescription =>
      'Quiero aprender y avanzar paso a paso';

  @override
  String get onboardingExperienceSomeDescription =>
      'Ya conozco algunos movimientos';

  @override
  String get onboardingExperienceLongDescription =>
      'Tengo una rutina y busco nuevos retos';

  @override
  String get onboardingExperienceNote =>
      'Tu experiencia ayuda a ajustar el entrenamiento.';

  @override
  String get onboardingScheduleTitle => '¿Qué días puedes entrenar?';

  @override
  String get onboardingScheduleDescription =>
      'Elige los días que suelen funcionarte. Puedes cambiarlos después.';

  @override
  String onboardingSessionsPerWeek(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sesiones por semana',
      one: '1 sesión por semana',
    );
    return '$_temp0';
  }

  @override
  String get onboardingRecoveryTitle => 'Frecuencia y recuperación';

  @override
  String get onboardingRecoveryOnce =>
      'Una sesión es un buen inicio. Para mejorar la fuerza, ACSM recomienda trabajar los grupos principales al menos dos veces por semana en adultos sanos. Puedes aumentar la frecuencia cuando te resulte sostenible.';

  @override
  String get onboardingRecoveryTwoToThree =>
      'El plan distribuye sesiones de cuerpo completo. Si puedes, deja un día entre ellas para repartir el esfuerzo y recuperarte.';

  @override
  String get onboardingRecoveryFour =>
      'El plan alterna tren superior e inferior. Distribuye las sesiones para dar tiempo de recuperación a cada grupo muscular.';

  @override
  String get onboardingRecoveryFiveToSix =>
      'El plan alterna tren superior e inferior. Es una frecuencia alta: organiza pausas según tu recuperación y mueve los días si las necesitas.';

  @override
  String get onboardingRecoverySeven =>
      'Puedes elegir los siete días, pero así no queda un día completo sin entrenamiento de fuerza. Recomendamos reservar al menos uno para descanso o actividad ligera; puedes cambiar los días cuando quieras.';

  @override
  String get onboardingRecoverySource =>
      'Guía ACSM sobre entrenamiento de fuerza';

  @override
  String get onboardingProgressionTemplateNote =>
      'Este plan es una plantilla inicial. Las sugerencias usan tus series registradas y no cambian el plan automáticamente; tú decides si aplicarlas.';

  @override
  String get sessionProgressionTitle => 'Sugerencia de progresión';

  @override
  String get sessionProgressionNoHistory =>
      'Aún no hay suficientes registros de este ejercicio. Completa las series y registra repeticiones y carga si usaste peso.';

  @override
  String sessionProgressionKeepBuilding(int sessions, int repetitions) {
    return 'Mantén el peso y la técnica; todavía no aumentes. Para sugerir más carga, esperamos $sessions entrenamientos seguidos con al menos $repetitions repeticiones en todas las series.';
  }

  @override
  String sessionProgressionReadyToIncrease(int repetitions, int sessions) {
    return 'Alcanzaste $repetitions repeticiones en todas las series durante $sessions entrenamientos seguidos. Si fue cómodo, sin dolor y con técnica estable, prueba el incremento de carga más pequeño disponible y vuelve al extremo bajo del rango.';
  }

  @override
  String sessionProgressionBodyweightReady(int repetitions, int sessions) {
    return 'Completaste $repetitions repeticiones en todas las series durante $sessions entrenamientos seguidos. Si mantuviste una técnica estable, puedes probar una variante de peso corporal un poco más difícil.';
  }

  @override
  String get sessionProgressionHabitFocus =>
      'Para crear el hábito, prioriza la constancia y la técnica. No hace falta aumentar la carga automáticamente.';

  @override
  String get sessionProgressionReturningAfterBreak =>
      'Ha pasado más de un mes desde que registraste este ejercicio. Retoma con una carga cómoda y completa nuevas sesiones antes de considerar un aumento.';

  @override
  String sessionProgressionTimedKeepBuilding(int sessions, int seconds) {
    return 'Registra los segundos y conserva la técnica. Para sugerir una variante más difícil, esperamos $sessions entrenamientos seguidos con $seconds segundos en todas las series.';
  }

  @override
  String sessionProgressionTimedReadyToVary(int sessions, int seconds) {
    return 'Completaste $seconds segundos en todas las series durante $sessions entrenamientos seguidos. Si mantuviste el control, puedes probar una variante un poco más difícil; no añadas peso.';
  }

  @override
  String get sessionProgressionTemplateNote =>
      'Las sugerencias se basan en tus registros. El plan es una plantilla y no cambia automáticamente; tú decides si aplicarlas.';

  @override
  String get onboardingSessionTime => 'Presupuesto de tiempo por sesión';

  @override
  String get onboardingSessionBudgetNote =>
      'El plan ajusta el número de ejercicios a este presupuesto. El tiempo real varía según tu ritmo y el tiempo que dediques al calentamiento y la vuelta a la calma. El temporizador orientativo entre ejercicios es de 45 s.';

  @override
  String onboardingMinutes(Object minutes) {
    return '$minutes min';
  }

  @override
  String get onboardingEquipmentTitle => '¿Con qué equipo cuentas?';

  @override
  String get onboardingEquipmentDescription =>
      'Usaremos esto para elegir ejercicios que puedas hacer.';

  @override
  String get onboardingEquipmentRequired =>
      'Elige al menos una opción para preparar los ejercicios.';

  @override
  String get onboardingAvoidMovementTitle =>
      'Movimientos que prefieres evitar (opcional)';

  @override
  String get onboardingAvoidMovementDescription =>
      'Selecciona ejercicios que prefieres no incluir. Esta preferencia no es un diagnóstico médico; consulta a un profesional si tienes dudas de salud.';

  @override
  String onboardingAvoidedMovementSummary(String movements) {
    return 'Movimientos excluidos: $movements';
  }

  @override
  String get onboardingAvoidedMovementApplied =>
      'La rutina prioriza opciones compatibles cuando están disponibles. Revisa cada ejercicio antes de empezar.';

  @override
  String get onboardingNoCompatibleExercises =>
      'No hay ejercicios compatibles con el equipo y las exclusiones elegidas. Ajusta tus preferencias para generar una rutina.';

  @override
  String get onboardingPreviewTitle => 'Así queda tu semana';

  @override
  String get onboardingPreviewDescription =>
      'Este es un punto de partida. Podrás ajustar tu plan desde Perfil.';

  @override
  String get onboardingEditGoal => 'Objetivo';

  @override
  String get onboardingEditExperience => 'Experiencia';

  @override
  String get onboardingEditSchedule => 'Días y duración';

  @override
  String get onboardingEditEquipment => 'Equipo y exclusiones';

  @override
  String get onboardingReturnToPreview => 'Volver al resumen del plan';

  @override
  String get onboardingEmptySessionConflict =>
      'Al menos una sesión quedó sin ejercicios compatibles. Ajusta los días, el equipo o los movimientos a evitar antes de crear el plan.';

  @override
  String onboardingSessionSummary(int count, int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ejercicios',
      one: '1 ejercicio',
    );
    return '$_temp0 · ~$minutes min estimados';
  }

  @override
  String onboardingTimedPrescription(int sets) {
    return '$sets series · 20–40 segundos';
  }

  @override
  String onboardingRepPrescription(int sets, String target) {
    return '$sets series · $target';
  }

  @override
  String get onboardingStrengthRepRange => '6–8 repeticiones';

  @override
  String get onboardingMuscleRepRange => '8–12 repeticiones';

  @override
  String get onboardingHabitRepRange => '8–12 repeticiones a ritmo cómodo';

  @override
  String onboardingPlanExperience(Object experience) {
    return 'Experiencia: $experience';
  }

  @override
  String onboardingPlanEquipment(Object equipment) {
    return 'Equipo: $equipment';
  }

  @override
  String onboardingPlanExerciseCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ejercicios',
      one: '1 ejercicio',
    );
    return '$_temp0';
  }

  @override
  String get onboardingSafetyNote =>
      'Guía general. Si tienes dolor, una lesión o una condición médica, consulta con un profesional antes de entrenar.';

  @override
  String get onboardingCreateMyPlan => 'Crear mi plan';

  @override
  String get sessionPause => 'Pausar entrenamiento';

  @override
  String get sessionWarmup => 'Calentamiento';

  @override
  String get sessionPreparation => 'Preparación';

  @override
  String get sessionExercises => 'Ejercicios';

  @override
  String sessionSet(Object number) {
    return 'Serie $number';
  }

  @override
  String get sessionRest => 'Descanso';

  @override
  String get sessionPaused => 'Entrenamiento pausado';

  @override
  String get sessionExitTitle => 'Salir del entrenamiento';

  @override
  String get sessionCompletedTitle => 'Entrenamiento completado';

  @override
  String get sessionGoodWork => 'Buen trabajo';

  @override
  String get sessionSummary => 'Resumen de sesión';

  @override
  String get sessionDuration => 'Duración';

  @override
  String get sessionExerciseCount => 'Ejercicios';

  @override
  String get sessionGoal => 'Objetivo';

  @override
  String get sessionViewWarmup => 'Ver calentamiento';

  @override
  String get sessionStart => 'Comenzar entrenamiento';

  @override
  String get sessionSkipWarmup => 'Omitir calentamiento';

  @override
  String get sessionSkipRest => 'Saltar descanso';

  @override
  String get sessionContinue => 'Continuar entrenamiento';

  @override
  String get sessionAbandon => 'Abandonar sesión';

  @override
  String get sessionAbandonConfirm => 'Sí, abandonar';

  @override
  String get sessionKeep => 'Seguir entrenando';

  @override
  String get sessionViewSummary => 'Ver resumen de sesión';

  @override
  String get sessionFinish => 'Finalizar';

  @override
  String get sessionRepetitions => 'Repeticiones';

  @override
  String get sessionSeconds => 'Segundos';

  @override
  String get sessionLoad => 'Carga externa (kg)';

  @override
  String get sessionAddExternalLoad => 'Añadir carga externa';

  @override
  String get sessionRemoveExternalLoad => 'Quitar carga externa';

  @override
  String sessionSetCountSummary(int recommended, int planned) {
    return 'Recomendadas: $recommended · Para esta sesión: $planned';
  }

  @override
  String sessionAdditionalSet(int number) {
    return 'Serie adicional $number';
  }

  @override
  String get sessionAddSet => 'Añadir serie';

  @override
  String get sessionRemovePendingSet => 'Quitar última serie';

  @override
  String get sessionRemoveCompletedSet => 'Eliminar serie completada';

  @override
  String get sessionRemoveCompletedSetTitle => 'Eliminar resultado de la serie';

  @override
  String get sessionRemoveCompletedSetMessage =>
      'Se eliminarán los resultados de la última serie de esta sesión. La prescripción semanal no cambiará.';

  @override
  String sessionProgress(Object current, Object total) {
    return 'Ejercicio $current de $total';
  }

  @override
  String get sessionSavedFeedback =>
      '¡Entrenamiento guardado! Tus resultados ya forman parte de tu progreso.';

  @override
  String get sessionNextExercise => 'Siguiente ejercicio';

  @override
  String get sessionPreviousExercise => 'Ejercicio anterior';

  @override
  String get sessionSetComplete => 'Serie completada';

  @override
  String get progressEyebrow => 'Progreso';

  @override
  String get progressGoals => 'Objetivos personales';

  @override
  String get progressHistory => 'Historial de entrenamientos';

  @override
  String get progressRemoveGoalTitle => 'Retirar objetivo';

  @override
  String get progressRemoveGoalBody =>
      '¿Quieres quitar este objetivo de tu progreso?';

  @override
  String get progressEditGoal => 'Editar objetivo';

  @override
  String get progressGoalRemoved => 'Objetivo retirado.';

  @override
  String get progressDuration => 'Duración';

  @override
  String get progressExercises => 'Ejercicios';

  @override
  String get progressSessionDetails => 'Detalle de sesión';

  @override
  String get progressStrengthTrend => 'Evolución de fuerza';

  @override
  String get progressBodyTrend => 'Evolución corporal';

  @override
  String get progressStart => 'Inicio';

  @override
  String get progressCurrent => 'Actual';

  @override
  String get progressLastEntry => 'Último registro';

  @override
  String get progressPeriodChange => 'Cambio del periodo';

  @override
  String get progressRecentMeasurements => 'Medidas recientes';

  @override
  String get progressRegisterMeasurements => 'Registrar medidas';

  @override
  String get progressMeasurementDate => 'Fecha de registro';

  @override
  String get progressBodyWeight => 'Peso corporal';

  @override
  String get progressWaist => 'Cintura';

  @override
  String get progressChest => 'Pecho';

  @override
  String get progressHips => 'Cadera';

  @override
  String get progressArm => 'Brazo';

  @override
  String get progressSaveEntry => 'Guardar registro';

  @override
  String get progressPersonalRecords => 'Récords personales';

  @override
  String get progressNewGoal => 'Nuevo objetivo';

  @override
  String get progressGoalType => 'Tipo de objetivo';

  @override
  String get progressWeeklySessions => 'Sesiones por semana';

  @override
  String get progressExerciseLoadRecord => 'Marca de carga por ejercicio';

  @override
  String get progressExerciseName => 'Nombre del ejercicio';

  @override
  String get progressSelectExercise => 'Seleccionar ejercicio';

  @override
  String get progressSearchExercises => 'Buscar ejercicios';

  @override
  String get progressNoExercisesFound => 'No se encontraron ejercicios.';

  @override
  String get progressExerciseCatalogRetry => 'Reintentar carga del catálogo';

  @override
  String get progressExerciseCatalogLoading => 'Cargando ejercicios…';

  @override
  String progressGoalExerciseNeedsResolution(String name) {
    return 'El objetivo antiguo «$name» necesita que elijas el ejercicio correcto para evitar mezclar marcas.';
  }

  @override
  String get progressExerciseHint => 'Ej. Sentadilla goblet';

  @override
  String get progressSaveGoal => 'Guardar objetivo';

  @override
  String progressExerciseCount(Object count) {
    return '$count ejercicios';
  }

  @override
  String get progressEmptyTitle => 'Aún no hay datos de progreso';

  @override
  String get progressEmptyDescription =>
      'Completa una sesión y registra tus series para empezar a ver tus resultados.';

  @override
  String get progressNoHistory =>
      'Completa una sesión para ver aquí tu actividad reciente.';

  @override
  String progressGoalSessionsValue(Object done, Object target) {
    return '$done de $target sesiones esta semana';
  }

  @override
  String progressGoalLoadValue(Object unit, Object weight) {
    return 'Marca objetivo: $weight $unit';
  }

  @override
  String progressGoalProgress(Object current, Object target) {
    return '$current de $target';
  }

  @override
  String get progressRecentSessions => 'Sesiones recientes';

  @override
  String get progressViewAll => 'Ver todo';

  @override
  String get progressReps => 'Repeticiones';

  @override
  String get progressSets => 'Series';

  @override
  String get progressVolume => 'Volumen';

  @override
  String get progressNoMeasurements => 'No hay medidas registradas.';

  @override
  String get progressNoRecords => 'Aún no hay récords personales.';

  @override
  String get progressWeightUnitKg => 'kg';

  @override
  String get progressWeightUnitLb => 'lb';

  @override
  String get progressTrendDescription =>
      'Tu progreso se calcula a partir de las sesiones y series guardadas.';

  @override
  String get progressGoalStatusComplete => 'Objetivo cumplido';

  @override
  String get progressGoalStatusInProgress => 'En progreso';

  @override
  String progressSessionCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sesiones',
      one: '1 sesión',
    );
    return '$_temp0';
  }

  @override
  String get onboardingUpperBody => 'Tren superior';

  @override
  String get onboardingLowerBody => 'Tren inferior';

  @override
  String get onboardingFullBody => 'Cuerpo completo';

  @override
  String get accountPasswordRequired => 'Escribe tu contraseña.';

  @override
  String get accountContinueAction => 'Continuar';

  @override
  String get profileYourInformation => 'Tu información';

  @override
  String get profileUpdateInformation =>
      'Actualiza los datos que se muestran en tu perfil.';

  @override
  String get profileNameRequired => 'Ingresa tu nombre.';

  @override
  String get profileEmailInvalid => 'Ingresa un correo válido.';

  @override
  String get profileGoalRequired => 'Escribe un objetivo.';

  @override
  String get settingsThemeDescription =>
      'Puedes seguir el tema del dispositivo o elegir uno para FORZA.';

  @override
  String get profileTailoredTitle => 'A tu medida';

  @override
  String get profileTailoredDescription =>
      'Ajusta las unidades y la forma en que FORZA organiza tu semana.';

  @override
  String get onboardingPreferencesLater =>
      'Podrás cambiar estas preferencias más tarde desde Perfil.';

  @override
  String get profileKilograms => 'Kilogramos (kg)';

  @override
  String get profilePounds => 'Libras (lb)';

  @override
  String get profileHapticDescription =>
      'Vibración suave al usar controles compatibles.';

  @override
  String get profileNotificationsHeading => 'Recibe solo lo útil.';

  @override
  String get profileNotificationsDescription =>
      'Los recordatorios usan la agenda y requieren permiso del dispositivo.';

  @override
  String get profilePrivacyPageTitle => 'Privacidad y cuenta';

  @override
  String get profilePrivacyHeading => 'Tú decides qué compartir.';

  @override
  String get profilePrivacyDescription => 'Tus preferencias de privacidad.';

  @override
  String get profileAccountData => 'Datos de cuenta';

  @override
  String get cloudSyncTitle => 'Sincronización en la nube';

  @override
  String get cloudSyncDescription =>
      'La sincronización es opcional. Tus datos siguen disponibles sin conexión y solo se envían a tu cuenta privada de Firestore después de que la actives.';

  @override
  String get cloudSyncToggleTitle => 'Sincronizar mis datos';

  @override
  String get cloudSyncToggleDescription =>
      'Incluye plan, agenda, entrenamientos, series, objetivos, medidas y ajustes de la app.';

  @override
  String get cloudSyncStatusHeading => 'Estado';

  @override
  String get cloudSyncStatusSignedOut => 'Inicia sesión para sincronizar.';

  @override
  String get cloudSyncStatusDisabled =>
      'Desactivada · los cambios se guardan solo en este dispositivo.';

  @override
  String get cloudSyncStatusSyncing => 'Sincronizando tus datos…';

  @override
  String get cloudSyncStatusSynced => 'Sincronización al día.';

  @override
  String get cloudSyncStatusPending => 'Hay cambios pendientes de sincronizar.';

  @override
  String get cloudSyncStatusFailed =>
      'No se pudo sincronizar. Puedes reintentar.';

  @override
  String get cloudSyncLastSync => 'Última sincronización';

  @override
  String get cloudSyncRetry => 'Reintentar ahora';

  @override
  String get cloudSyncConsentTitle => 'Activar sincronización';

  @override
  String get cloudSyncConsentDescription =>
      'Se subirá a tu cuenta privada de Firestore una copia de tu plan y agenda, entrenamientos y series, objetivos, medidas, sesión activa, apariencia y preferencias, notificaciones y privacidad. Si ya hay datos en la nube, se combinarán y se conservará tu versión local cuando coincidan registros. Puedes desactivarla después.';

  @override
  String get cloudSyncConsentAccept => 'Activar y sincronizar';

  @override
  String get cloudSyncEnableFailed =>
      'No se pudo activar la sincronización. Inténtalo de nuevo.';

  @override
  String get cloudSyncDisableTitle => 'Desactivar sincronización';

  @override
  String get cloudSyncDisableDescription =>
      'Los cambios nuevos quedarán solo en este dispositivo. La copia que ya está en la nube no se borrará.';

  @override
  String get cloudSyncDisableButton => 'Desactivar';

  @override
  String get cloudSyncDeleteSection => 'Copia en la nube';

  @override
  String get cloudSyncDeleteDescription =>
      'Elimina tu perfil y copia de Firestore. Conserva tus datos locales y tu cuenta de Google.';

  @override
  String get cloudSyncDeleteButton => 'Eliminar copia en la nube';

  @override
  String get cloudSyncDeleteTitle => '¿Eliminar la copia en la nube?';

  @override
  String get cloudSyncDeleteConfirm =>
      'Esta acción elimina de Firestore tu perfil y todos los datos sincronizados. Tus datos de este dispositivo y tu cuenta de Google se conservarán.';

  @override
  String get cloudSyncDeleteCompleted =>
      'Se eliminó la copia de Firestore. Los datos locales se conservaron.';

  @override
  String get cloudSyncDeleteFailed =>
      'No se pudo eliminar la copia en la nube. Revisa la conexión e inténtalo de nuevo.';

  @override
  String get profileConfirmHeading => 'Confirma tus datos';

  @override
  String get profileConfirmDescription =>
      'Revisa la información antes de volver a tu perfil.';

  @override
  String get backupInvalid =>
      'El respaldo no es válido o está dañado. Revisa el archivo e inténtalo de nuevo.';

  @override
  String get profileRecordsSubtitle =>
      'Avisos cuando alcances una nueva marca.';

  @override
  String get progressTitle => 'Tu progreso';

  @override
  String get progressSubtitle => 'Tu constancia, en perspectiva.';

  @override
  String get progressLast30Days => 'Últimos 30 días';

  @override
  String get progressNoHistoryInPeriod =>
      'No hay entrenamientos en este período.';

  @override
  String progressLastWorkout(Object date) {
    return 'Último entrenamiento · $date';
  }

  @override
  String get progressGoToActivity => 'Ir a Actividad';

  @override
  String get progressNoSetData => 'Sin series registradas';

  @override
  String progressWeightChange(String change) {
    return 'Cambio desde la medición anterior: $change kg';
  }

  @override
  String progressRecentRecord(
    String exercise,
    String value,
    String unit,
    String date,
  ) {
    return 'Marca reciente · $exercise: $value $unit · $date';
  }

  @override
  String get progressSessions => 'sesiones';

  @override
  String progressTimeTotal(Object hours, Object minutes) {
    return '$hours h $minutes min';
  }

  @override
  String progressSetsAndReps(Object reps, Object sets) {
    return '$sets series · $reps reps';
  }

  @override
  String get progressVolumeExplanation =>
      'El volumen suma repeticiones × carga de las series con ambos datos.';

  @override
  String get progressAddGoal => 'Añadir';

  @override
  String get progressGoalDescription =>
      'Define una meta semanal o una marca de carga para seguir tu avance.';

  @override
  String get progressLoadGoal => 'Meta de carga';

  @override
  String progressGoalCurrentTarget(Object current, Object target, Object unit) {
    return '$current de $target $unit';
  }

  @override
  String get progressWeeklyGoalDescription =>
      'Sesiones completadas de lunes a domingo.';

  @override
  String get progressLoadGoalDescription =>
      'Mayor carga registrada en tus series para este ejercicio.';

  @override
  String progressSessionSemantics(Object date, Object title) {
    return '$title, $date';
  }

  @override
  String progressHistorySummary(
    Object count,
    Object date,
    Object minutes,
    Object volume,
  ) {
    return '$date · $minutes min · $count ejercicios$volume';
  }

  @override
  String get progressNoLoadData => 'Sin datos de carga';

  @override
  String progressVolumeKg(Object value) {
    return '$value kg';
  }

  @override
  String get progressGoalEditorDescription =>
      'Elige una meta que puedas seguir en FORZA.';

  @override
  String get progressTargetLoad => 'Carga objetivo';

  @override
  String get progressSessionsUnit => 'sesiones';

  @override
  String get progressExerciseNameRequired =>
      'Escribe el nombre tal como aparece en tu sesión.';

  @override
  String get progressPositiveValueRequired =>
      'Ingresa un valor mayor que cero.';

  @override
  String get progressWeeklyTargetRange =>
      'Elige entre 1 y 7 sesiones completas.';

  @override
  String get progressSessionDetail => 'Detalle de sesión';

  @override
  String get progressOutsideAppNote =>
      'Marcaste esta sesión como realizada fuera de FORZA. No hay detalle de movimientos ni cargas.';

  @override
  String progressExerciseHeading(Object count) {
    return 'Ejercicios · $count';
  }

  @override
  String get progressStrengthEvolution => 'Evolución de fuerza';

  @override
  String get progressStrengthHeadline => 'Más fuerza, paso a paso.';

  @override
  String get progressStrengthDescription =>
      'Compara la mayor carga registrada por sesión para cada ejercicio.';

  @override
  String get progressWorkingWeight => 'Peso de trabajo (kg)';

  @override
  String progressStrengthChartSummary(
    String start,
    String current,
    int sessions,
  ) {
    return 'La carga pasó de $start a $current kilogramos en $sessions sesiones registradas.';
  }

  @override
  String get progressStrengthMetric =>
      'Mayor carga con peso registrada por sesión (kg). Las series sin carga no se incluyen.';

  @override
  String get progressStrengthSinglePoint =>
      'Solo hay una sesión con carga registrada para este ejercicio.';

  @override
  String get progressStrengthEmpty =>
      'No hay series con carga para este periodo. Registra el peso usado en tus series durante un entrenamiento.';

  @override
  String progressStrengthChange(String sign, String change) {
    return 'Cambio entre la primera y la última sesión: $sign$change kg.';
  }

  @override
  String get progressPeriodLabel => 'Periodo';

  @override
  String get progressPeriod30Days => '30 días';

  @override
  String get progressPeriod90Days => '90 días';

  @override
  String get progressPeriodYear => '1 año';

  @override
  String get progressPeriodAll => 'Todo';

  @override
  String get progressBodyEvolution => 'Evolución corporal';

  @override
  String get progressBodyHeadline => 'Cambios que puedes seguir.';

  @override
  String get progressBodyDescription =>
      'Las medidas son referencias orientativas, no objetivos.';

  @override
  String progressWeightChartSummary(Object current, Object start) {
    return 'El peso corporal pasó de $start a $current kilogramos.';
  }

  @override
  String get progressMeasurementHeadline => 'Registra cómo vas.';

  @override
  String get progressMeasurementDescription =>
      'El peso es obligatorio. Las demás medidas son opcionales.';

  @override
  String get progressMeasurementsSavedNote =>
      'Tus medidas se guardan en este dispositivo.';

  @override
  String get progressMeasurementsEmpty =>
      'Aún no hay medidas. Registra tu peso y medidas para consultar su evolución.';

  @override
  String get progressEditMeasurement => 'Editar medida';

  @override
  String get progressDeleteMeasurement => 'Eliminar medida';

  @override
  String get progressDeleteMeasurementTitle => 'Eliminar registro';

  @override
  String get progressDeleteMeasurementBody =>
      '¿Quieres eliminar las medidas de este día? Esta acción no se puede deshacer.';

  @override
  String get progressSaveFailed =>
      'No se pudo guardar el registro. Inténtalo de nuevo.';

  @override
  String progressValueRange(Object maximum, Object minimum, Object unit) {
    return 'Rango permitido: $minimum–$maximum $unit';
  }

  @override
  String get progressInvalidValue => 'Ingresa un valor válido.';

  @override
  String get progressWeightRequired => 'Ingresa el peso corporal.';

  @override
  String get progressRecordsHeadline => 'Tus mejores marcas.';

  @override
  String get progressRecordsDescription =>
      'Marcas calculadas desde tus series guardadas; muestran fecha y unidad. Si empatan, se conserva la primera fecha.';

  @override
  String get progressRecordsEmpty =>
      'Todavía no hay marcas. Registra repeticiones, carga o duración en una serie para empezar.';

  @override
  String get progressRecordNoMeasurements => 'Peso corporal';

  @override
  String get progressKilograms => 'kg';

  @override
  String get progressRepetitionsUnit => 'reps';

  @override
  String get progressSecondsUnit => 's';

  @override
  String progressSetSummary(Object number, Object values) {
    return 'Serie $number · $values';
  }

  @override
  String get progressMinutesUnit => 'min';

  @override
  String get progressChangeFromStart => 'Cambio desde el inicio';

  @override
  String progressDateFormatShort(Object date) {
    return '$date';
  }

  @override
  String get sessionBack => 'Volver';

  @override
  String get sessionBackStep => 'Volver al paso anterior';

  @override
  String get sessionTitlePreparation => 'Preparación';

  @override
  String get sessionTitleWarmup => 'Calentamiento';

  @override
  String get sessionTitleWorkout => 'Tu entrenamiento';

  @override
  String get sessionTitleRest => 'Descanso';

  @override
  String get sessionTitlePaused => 'Entrenamiento pausado';

  @override
  String get sessionTitleConfirmAbandon => 'Confirmar abandono';

  @override
  String get sessionTitleCompleted => 'Entrenamiento completado';

  @override
  String get sessionTitleCooldown => 'Vuelta a la calma';

  @override
  String get sessionTitleSummary => 'Resumen de sesión';

  @override
  String get sessionWarmupHeadline => 'Prepara tu cuerpo';

  @override
  String sessionWarmupDescription(Object session) {
    return 'Movimientos breves para $session. Hazlos a un ritmo cómodo; puedes omitirlos cuando quieras.';
  }

  @override
  String get warmupShoulderCircles => 'Círculos de hombros';

  @override
  String get warmupShoulderCirclesInstructions =>
      'Haz círculos suaves hacia delante y hacia atrás.';

  @override
  String get warmupThoracicRotation => 'Rotación torácica';

  @override
  String get warmupThoracicInstructions =>
      'Gira el torso sin forzar el cuello.';

  @override
  String get warmupInclinePushups => 'Flexiones inclinadas';

  @override
  String get warmupInclineInstructions =>
      'Apoya las manos en una superficie firme y muévete con control.';

  @override
  String get warmupMarch => 'Marcha en el sitio';

  @override
  String get warmupMarchInstructions => 'Eleva las rodillas a un ritmo cómodo.';

  @override
  String get warmupHipHinge => 'Bisagra de cadera';

  @override
  String get warmupHipHingeInstructions =>
      'Lleva la cadera atrás manteniendo la espalda cómoda.';

  @override
  String get warmupBodyweightSquat => 'Sentadilla sin carga';

  @override
  String get warmupBodyweightSquatInstructions =>
      'Baja solo hasta un rango que puedas controlar.';

  @override
  String get warmupMarchArms => 'Marcha con brazos';

  @override
  String get warmupMarchArmsInstructions =>
      'Marcha en el sitio y acompaña el movimiento con los brazos.';

  @override
  String get warmupTorsoRotations => 'Rotaciones de torso';

  @override
  String get warmupTorsoInstructions =>
      'Gira suavemente de lado a lado, sin rebotes.';

  @override
  String get warmupThirtySeconds => '30 s';

  @override
  String get warmupThirtySecondsEachSide => '30 s por lado';

  @override
  String get warmupFortyFiveSeconds => '45 s';

  @override
  String get warmupEightReps => '8 repeticiones';

  @override
  String get sessionPreparationHeadline => 'Todo listo para empezar';

  @override
  String get sessionPreparationDescription =>
      'Tómate un momento para preparar tu espacio y revisar la sesión de hoy.';

  @override
  String get sessionDraftReviewTitle => 'Revisar entrenamiento guardado';

  @override
  String sessionDraftReviewDateMismatch(String date) {
    return 'Hay un entrenamiento guardado del $date. Puedes retomarlo con la rutina original o descartarlo para iniciar la sesión seleccionada.';
  }

  @override
  String get sessionDraftReviewLegacy =>
      'Este borrador es de una versión anterior y no guardó la rutina exacta. Puedes continuar usando la rutina actual; tus registros parciales se conservarán. También puedes descartarlo.';

  @override
  String get sessionDraftReviewCorrupt =>
      'No se puede leer el borrador guardado. Se conservará hasta que elijas descartarlo para iniciar una sesión nueva.';

  @override
  String get sessionContinueSavedWorkout => 'Continuar entrenamiento guardado';

  @override
  String get sessionContinueWithCurrentPlan => 'Continuar con la rutina actual';

  @override
  String get sessionDiscardWorkoutDraft =>
      'Descartar borrador e iniciar esta sesión';

  @override
  String get sessionRestoredOriginalPlan =>
      'Se restauró la rutina original guardada para mantener cada serie asociada al mismo ejercicio.';

  @override
  String get sessionUnknownDate => 'otra fecha';

  @override
  String get sessionWaterBottle => 'Botella de agua';

  @override
  String get sessionClearSpace => 'Espacio despejado';

  @override
  String get sessionEquipmentReady => 'Equipo a mano';

  @override
  String get sessionExerciseHeadline => 'Sigue tu sesión';

  @override
  String sessionExerciseCountProgress(Object current, Object total) {
    return 'Ejercicio $current de $total';
  }

  @override
  String sessionSetsProgress(int current, int total) {
    return '$current de $total series completadas';
  }

  @override
  String get sessionViewRoutine => 'Ver rutina';

  @override
  String get sessionRoutineTitle => 'Rutina de esta sesión';

  @override
  String get sessionRoutineDescription =>
      'Consulta todos los ejercicios. Puedes abrir el actual o revisar los anteriores; los siguientes se habilitan al avanzar.';

  @override
  String get sessionRoutineCompleted => 'Completado';

  @override
  String get sessionRoutineCurrent => 'Actual';

  @override
  String get sessionRoutinePending => 'Pendiente';

  @override
  String get sessionCloseRoutine => 'Cerrar rutina';

  @override
  String get sessionSetLog => 'Registro de series';

  @override
  String get sessionNextSet => 'Siguiente serie';

  @override
  String get sessionCompleteSetAction => 'Completar serie';

  @override
  String get sessionUndoSet => 'Desmarcar serie';

  @override
  String get sessionPreviousSetSuggestion => 'Sugerencia de la serie anterior';

  @override
  String get sessionRestHeadline => 'Tómate un respiro';

  @override
  String get sessionRestBetweenSets => 'Descanso entre series';

  @override
  String get sessionRestBetweenExercises => 'Cambio de ejercicio';

  @override
  String get sessionRestDuration => 'Duración del descanso';

  @override
  String sessionNextSetAfterRest(int number) {
    return 'Siguiente: serie $number';
  }

  @override
  String get sessionStartWhenReady => 'Empezar cuando estés listo';

  @override
  String sessionBeforeExercise(Object exercise) {
    return 'Antes de $exercise';
  }

  @override
  String get sessionTimerNote =>
      'El temporizador es orientativo y solo corre mientras esta pantalla está activa.';

  @override
  String get sessionPauseHeadline => 'Pausa cuando lo necesites';

  @override
  String get sessionPauseDescription =>
      'La sesión está en pausa. Puedes retomarla o terminar el entrenamiento.';

  @override
  String sessionProgressCount(Object current, Object total) {
    return '$current de $total ejercicios';
  }

  @override
  String get sessionAbandonHeadline => '¿Quieres abandonar?';

  @override
  String get sessionAbandonDescription =>
      'Se cerrará esta sesión. El progreso no se guardará en el historial.';

  @override
  String sessionWorkoutFinishedFor(Object session) {
    return 'Terminaste tu sesión de $session.';
  }

  @override
  String sessionExercisesCompleted(Object count) {
    return '$count ejercicios completados';
  }

  @override
  String get sessionSummaryHeadline => 'Así fue tu sesión';

  @override
  String get sessionSummaryDescription => 'Tu actividad de hoy, resumida.';

  @override
  String get sessionCompleteWorkout => 'Completar entrenamiento';

  @override
  String get sessionCompleteExercise => 'Completar ejercicio';

  @override
  String get sessionWarmupButton => 'Ver calentamiento';

  @override
  String get sessionStartButton => 'Comenzar entrenamiento';

  @override
  String get sessionSkipWarmupButton => 'Omitir calentamiento';

  @override
  String get sessionSkipRestButton => 'Saltar descanso';

  @override
  String get sessionAbandonButton => 'Abandonar sesión';

  @override
  String get sessionConfirmAbandonButton => 'Sí, abandonar';

  @override
  String get sessionContinueButton => 'Seguir entrenando';

  @override
  String get sessionSummaryButton => 'Ver resumen de sesión';

  @override
  String get sessionCooldownOfferDescription =>
      'Puedes cerrar con movimientos suaves de las zonas trabajadas. Es opcional y puedes saltarla en cualquier momento.';

  @override
  String get sessionCooldownStart => 'Ver vuelta a la calma';

  @override
  String get sessionCooldownNext => 'Siguiente movimiento';

  @override
  String get sessionCooldownSkip => 'Omitir vuelta a la calma e ir al resumen';

  @override
  String get sessionCooldownHeadline => 'Baja el ritmo a tu manera';

  @override
  String get sessionCooldownDescription =>
      'Haz cada movimiento despacio y sin dolor. Puedes omitir cualquier paso.';

  @override
  String get sessionCooldownHipsTitle => 'Flexor de cadera';

  @override
  String get sessionCooldownHipsInstructions =>
      'Coloca una rodilla en el suelo y el otro pie delante. Lleva suavemente la cadera hacia delante sin arquear la espalda. Cambia de lado.';

  @override
  String get sessionCooldownBackTitle => 'Gato-vaca';

  @override
  String get sessionCooldownBackInstructions =>
      'Apoya manos y rodillas. Redondea la espalda suavemente y luego vuelve a una posición cómoda, sin forzar el cuello.';

  @override
  String get sessionCooldownChestTitle => 'Apertura de pecho';

  @override
  String get sessionCooldownChestInstructions =>
      'Apoya el antebrazo en un marco firme y gira suavemente el torso hacia el lado contrario. Cambia de lado.';

  @override
  String get sessionCooldownShouldersTitle => 'Cruce de hombro';

  @override
  String get sessionCooldownShouldersInstructions =>
      'Lleva un brazo por delante del pecho y acércalo suavemente con la otra mano. Mantén el hombro relajado y cambia de lado.';

  @override
  String get sessionCooldownCoreTitle => 'Rotación suave de torso';

  @override
  String get sessionCooldownCoreInstructions =>
      'De pie, gira el torso suavemente de un lado al otro sin rebotes y dentro de un rango cómodo.';

  @override
  String get sessionCooldownArmsTitle => 'Estiramiento de tríceps';

  @override
  String get sessionCooldownArmsInstructions =>
      'Eleva un brazo, dobla el codo y acompaña suavemente con la otra mano. No tires del cuello; cambia de lado.';

  @override
  String get sessionCooldownTwentySecondsEachSide => '20 s por lado';

  @override
  String get sessionCooldownSixReps => '6 repeticiones suaves';

  @override
  String get sessionRecordNote =>
      'Al terminar, esta sesión quedará registrada en tu actividad.';

  @override
  String sessionSetsTarget(Object sets, Object target) {
    return '$sets series · $target';
  }

  @override
  String get sessionSetUnit => 'series';

  @override
  String get sessionRepTargetLow => '6–8 repeticiones';

  @override
  String get sessionRepTargetMid => '8–12 repeticiones';

  @override
  String get sessionRepTargetComfortable => '8–12 repeticiones a ritmo cómodo';

  @override
  String get sessionTimeTarget => '20–40 segundos';

  @override
  String get sessionWarmupFallback => 'el entrenamiento';

  @override
  String measurementValue(Object label, Object value) {
    return '$label $value cm';
  }

  @override
  String progressValueWithUnit(Object unit, Object value) {
    return '$value $unit';
  }

  @override
  String requiredField(Object label) {
    return '$label *';
  }

  @override
  String get navigationHome => 'Inicio';

  @override
  String get shellPlanSaveError => 'No pudimos guardar tu plan.';

  @override
  String get shellWorkoutSaved => 'Sesión guardada en tu actividad.';

  @override
  String get shellWorkoutSaveError => 'No pudimos guardar esta sesión.';

  @override
  String get trainingNameDumbbellPress => 'Press con mancuernas';

  @override
  String get trainingNameGobletSquat => 'Sentadilla goblet';

  @override
  String get trainingNameDumbbellRow => 'Remo con mancuerna';

  @override
  String get trainingNameRomanianDeadlift => 'Peso muerto rumano';

  @override
  String get trainingNameShoulderPress => 'Press de hombros';

  @override
  String get trainingNameBarbellSquat => 'Sentadilla con barra';

  @override
  String get trainingNameBarbellBench => 'Press de banca con barra';

  @override
  String get trainingNameBarbellRow => 'Remo con barra';

  @override
  String get trainingNameBarbellDeadlift => 'Peso muerto con barra';

  @override
  String get trainingNameBandChestPress => 'Press de pecho con banda';

  @override
  String get trainingNameBandRow => 'Remo con banda';

  @override
  String get trainingNameBandSquat => 'Sentadilla con banda';

  @override
  String get trainingNameBandPullApart => 'Separación de banda';

  @override
  String get trainingNameMachineChestPress => 'Press de pecho en máquina';

  @override
  String get trainingNameLegPress => 'Prensa de piernas';

  @override
  String get trainingNameLatPulldown => 'Jalón al pecho';

  @override
  String get trainingNameSeatedRow => 'Remo sentado';

  @override
  String get trainingNamePushUp => 'Flexiones';

  @override
  String get trainingNameInclinePushUp => 'Flexiones inclinadas';

  @override
  String get trainingNamePikePushUp => 'Pike push-up';

  @override
  String get trainingNameLunges => 'Zancadas';

  @override
  String get trainingNameBodyweightSquat => 'Sentadilla con peso corporal';

  @override
  String get trainingNameCalfRaise => 'Elevación de pantorrillas';

  @override
  String get trainingNameGluteBridge => 'Puente de glúteos';

  @override
  String get trainingNameBirdDog => 'Bird-dog';

  @override
  String get trainingNameDeadBug => 'Dead bug';

  @override
  String get trainingNamePlank => 'Plancha';

  @override
  String get activityFocusUpper => 'Pecho, espalda y hombros';

  @override
  String get activityFocusLower => 'Piernas y core';

  @override
  String get activityFocusFull => 'Rutina de cuerpo completo';

  @override
  String get profileDefaultName => 'Atleta FORZA';

  @override
  String get progressTotalStrength => 'Fuerza total';

  @override
  String get progressLegsCore => 'Piernas y core';

  @override
  String get progressUpperBody => 'Tren superior';

  @override
  String get sessionStartTimedSet => 'Iniciar serie de 30 segundos';

  @override
  String get sessionTimedSetRunning => 'Pausar serie cronometrada';

  @override
  String get trainingNameBandReverseFly => 'Apertura inversa con banda';

  @override
  String get trainingNamePikeToCobra => 'Flexiones de pica a cobra';

  @override
  String get trainingNameJumpSquat => 'Sentadilla con salto';

  @override
  String get trainingNameSidePlank => 'Plancha lateral inclinada';
}
