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
  String get exerciseCatalogSpanishNotice =>
      'Los nombres, categorías e instrucciones del catálogo están disponibles en español.';

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
}
