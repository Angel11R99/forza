// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get settingsLanguageTitle => 'App language';

  @override
  String get settingsLanguageDescription =>
      'Choose the language used throughout FORZA.';

  @override
  String get settingsLanguageAutomatic => 'Device language';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageSpanish => 'Español';

  @override
  String get settingsLanguageSystemDescription =>
      'Follow the language set on your device.';

  @override
  String get settingsLanguageSelection => 'Language';

  @override
  String get settingsLanguageAutomaticDescription =>
      'Use the language set on your device.';

  @override
  String get settingsAppearanceTitle => 'Appearance';

  @override
  String get settingsThemeTitle => 'Choose your theme';

  @override
  String get settingsThemeSystem => 'Use device setting';

  @override
  String get settingsThemeSystemDescription => 'Follow your system theme.';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String homeWelcome(Object name) {
    return 'Welcome, $name';
  }

  @override
  String workoutCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count workouts',
      one: '1 workout',
      zero: 'No workouts',
    );
    return '$_temp0';
  }

  @override
  String get exerciseEyebrow => 'Exercises';

  @override
  String get exerciseLibraryTitle => 'Exercise library';

  @override
  String get exerciseLibrarySubtitle => 'Find movements for your next session.';

  @override
  String get exerciseSearchHint => 'Exercise, muscle, or equipment';

  @override
  String get exerciseClearSearch => 'Clear search';

  @override
  String get exerciseOpenFilters => 'Open filters';

  @override
  String exerciseActiveFilters(int count) {
    return 'Active filters: $count';
  }

  @override
  String get exerciseSearchResultsTitle => 'Search results';

  @override
  String get exerciseAllResultsTitle => 'All exercises';

  @override
  String exerciseFoundCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count exercises found',
      one: '1 exercise found',
      zero: 'No exercises found',
    );
    return '$_temp0';
  }

  @override
  String get exerciseCatalogSpanishNotice =>
      'Exercise names, categories, and instructions in this catalog are currently in Spanish.';

  @override
  String get exerciseLoadError => 'We couldn’t load the exercises.';

  @override
  String get exerciseRetry => 'Try again';

  @override
  String get exerciseEmptyTitle => 'No exercises found';

  @override
  String get exerciseEmptySubtitle =>
      'Try another search or remove some filters.';

  @override
  String get exerciseClearSearchAndFilters => 'Clear search and filters';

  @override
  String get exerciseFiltersTitle => 'Filters';

  @override
  String get exerciseClearFilters => 'Clear';

  @override
  String get exerciseAdjustSearchTitle => 'Adjust your search';

  @override
  String get exerciseFiltersDescription =>
      'Combine muscle group and equipment to find movements.';

  @override
  String get exerciseMuscleGroupFilter => 'Muscle group';

  @override
  String get exerciseEquipmentFilter => 'Equipment';

  @override
  String exerciseShowResults(int count) {
    return 'Show results · $count';
  }

  @override
  String get exerciseAlternativesTitle => 'Alternatives';

  @override
  String exerciseAlternativesTo(String name) {
    return 'Alternatives to $name';
  }

  @override
  String get exerciseAlternativesDescription =>
      'More exercises for a similar muscle group.';

  @override
  String get exerciseAlternativesEmpty =>
      'No alternatives are available for this exercise.';

  @override
  String get exerciseDetailTitle => 'Exercise details';

  @override
  String get exerciseHowTo => 'How to do it';

  @override
  String get exerciseGuideHeading => 'Technique cues and common mistakes';

  @override
  String get exerciseGuideVariantNote =>
      'These cues are based on a reference variation. Compare them with the steps for this exercise.';

  @override
  String exerciseSourcePrefix(String source) {
    return 'Source: $source';
  }

  @override
  String exerciseSourceLink(String url) {
    return 'Source link: $url';
  }

  @override
  String get exerciseViewAlternatives => 'View alternatives';

  @override
  String get exerciseAnimationUnavailable =>
      'No animation available · follow the steps';

  @override
  String get exerciseAnimationIllustrative =>
      'Illustration for reference · pace is up to you';

  @override
  String exerciseAnimationLabel(String name) {
    return 'Exercise animation: $name';
  }

  @override
  String get exerciseAnimationPlay => 'Play animation';

  @override
  String get exerciseAnimationPause => 'Pause animation';

  @override
  String exerciseCardSemantics(String name, String group, String equipment) {
    return '$name, $group, equipment: $equipment';
  }

  @override
  String get exerciseGroupArms => 'Arms';

  @override
  String get exerciseGroupCardio => 'Cardio';

  @override
  String get exerciseGroupCore => 'Core';

  @override
  String get exerciseGroupNeck => 'Neck';

  @override
  String get exerciseGroupBack => 'Back';

  @override
  String get exerciseGroupShoulders => 'Shoulders';

  @override
  String get exerciseGroupChest => 'Chest';

  @override
  String get exerciseGroupLegs => 'Legs';

  @override
  String get exerciseEquipmentAssisted => 'Assisted';

  @override
  String get exerciseEquipmentBosu => 'BOSU ball';

  @override
  String get exerciseEquipmentStabilityBall => 'Stability ball';

  @override
  String get exerciseEquipmentMedicineBall => 'Medicine ball';

  @override
  String get exerciseEquipmentResistanceBand => 'Resistance band';

  @override
  String get exerciseEquipmentBarbell => 'Barbell';

  @override
  String get exerciseEquipmentEzBar => 'EZ bar';

  @override
  String get exerciseEquipmentTrapBar => 'Trap bar';

  @override
  String get exerciseEquipmentOlympicBar => 'Olympic barbell';

  @override
  String get exerciseEquipmentStationaryBike => 'Stationary bike';

  @override
  String get exerciseEquipmentAddedWeight => 'Added weight';

  @override
  String get exerciseEquipmentRope => 'Rope';

  @override
  String get exerciseEquipmentElliptical => 'Elliptical trainer';

  @override
  String get exerciseEquipmentUpperBodyErgometer => 'Upper-body ergometer';

  @override
  String get exerciseEquipmentStairClimber => 'Stair climber';

  @override
  String get exerciseEquipmentDumbbells => 'Dumbbells';

  @override
  String get exerciseEquipmentHammer => 'Hammer';

  @override
  String get exerciseEquipmentSkiErg => 'SkiErg machine';

  @override
  String get exerciseEquipmentSmithMachine => 'Smith machine';

  @override
  String get exerciseEquipmentLeverageMachine => 'Leverage machine';

  @override
  String get exerciseEquipmentTire => 'Tire';

  @override
  String get exerciseEquipmentKettlebell => 'Kettlebell';

  @override
  String get exerciseEquipmentBodyweight => 'Bodyweight';

  @override
  String get exerciseEquipmentCable => 'Cable machine';

  @override
  String get exerciseEquipmentRoller => 'Foam roller';

  @override
  String get exerciseEquipmentAbWheel => 'Ab wheel';

  @override
  String get exerciseEquipmentSled => 'Sled';

  @override
  String get exerciseGuideDeadliftMistakes =>
      'Rounding your back as you lower toward the floor.\nLetting the load drift away from your body on the way up.\nLeaning backward at the finish instead of standing tall with control.';

  @override
  String get exerciseGuideDeadliftSource => 'ACE · Deadlift';

  @override
  String get exerciseGuideSquatMistakes =>
      'Letting the knees collapse inward instead of following the direction of the feet.\nLifting the heels or losing foot support as you lower.\nForcing extra depth after you lose control or a comfortable position.';

  @override
  String get exerciseGuideSquatSource => 'ACE · Bodyweight squat';

  @override
  String get exerciseGuideLungeMistakes =>
      'Leaning or swaying your torso sideways during the step.\nLosing support through the front foot or letting the knee drift out of line.\nBouncing at the bottom instead of lowering and rising with control.';

  @override
  String get exerciseGuideLungeSource => 'ACE · Forward lunge';

  @override
  String get exerciseGuidePushUpMistakes =>
      'Letting your lower back sag or hips rise as you lower and press.\nLeading with your head instead of keeping it aligned with your torso.\nRushing repetitions until you lose your body position.';

  @override
  String get exerciseGuidePushUpSource => 'ACE · Push-up';

  @override
  String get exerciseGuideChestPressMistakes =>
      'Bouncing the load against your chest at the change of direction.\nArching your lower back or losing your points of contact to finish a repetition.\nBending your wrists back instead of keeping them aligned with your forearms.';

  @override
  String get exerciseGuideChestPressSource => 'ACE · Chest press';

  @override
  String get exerciseGuideRowMistakes =>
      'Swinging your torso to start each pull.\nRounding your back instead of keeping the position described for your variation.\nDropping the load quickly on the return.';

  @override
  String get exerciseGuideRowSource => 'ACE · Bent-over row';

  @override
  String get exerciseGuidePullUpMistakes =>
      'Using a kip or swing instead of pulling with control.\nShrugging your shoulders or losing torso alignment on the way up.\nDropping quickly instead of controlling the return to the start.';

  @override
  String get exerciseGuidePullUpSource => 'ACE · Chin-up';

  @override
  String get exerciseGuidePlankMistakes =>
      'Letting your lower back sag or raising your hips too high.\nShrugging your shoulders or losing your support position.\nHolding your breath while maintaining the position.';

  @override
  String get exerciseGuidePlankSource => 'ACE · Front plank';

  @override
  String get exerciseGuideCrunchMistakes =>
      'Pulling on your neck with your hands, if your variation places them behind your head.\nUsing momentum to rise instead of curling your torso with control.\nChanging your back or hip position from what the instructions for this variation describe.';

  @override
  String get exerciseGuideCrunchSource => 'ACE · Crunch';

  @override
  String get exerciseGuideCurlMistakes =>
      'Swinging your torso to help move the load.\nMoving your elbows forward if the variation asks you to keep them by your sides.\nLetting the load drop quickly on the way down.';

  @override
  String get exerciseGuideCurlSource => 'ACE · Biceps curl';

  @override
  String get exerciseGuideShoulderPressMistakes =>
      'Arching your lower back to move the load overhead.\nDropping the load instead of controlling the return.\nBending your wrists instead of keeping them in line with your forearms.';

  @override
  String get exerciseGuideShoulderPressSource => 'ACE · Seated shoulder press';

  @override
  String get exerciseGuideLegCurlMistakes =>
      'Arching your back or lifting your hips to help bend the knee.\nMoving your thigh when the variation asks you to keep it supported.\nLetting the resistance return without control.';

  @override
  String get exerciseGuideLegCurlSource => 'ACE · Lying hamstring curl';

  @override
  String get exerciseGuideLegExtensionMistakes =>
      'Increasing the range until your hip or torso has to lean.\nUsing momentum instead of extending and returning the leg with control.\nChoosing resistance that makes it hard to stay balanced and upright.';

  @override
  String get exerciseGuideLegExtensionSource => 'ACE · Standing leg extension';

  @override
  String get exerciseGuideCalfRaiseMistakes =>
      'Bouncing instead of lifting and lowering your heels with control.\nTurning your feet during a repetition when your variation asks you to keep them facing forward.\nUsing a range that makes you lose balance or control on the return.';

  @override
  String get exerciseGuideCalfRaiseSource => 'ACE · Standing calf raise';

  @override
  String get exerciseGuideStepUpMistakes =>
      'Letting your foot or ankle lose support on the platform.\nLetting your knee drift inward instead of following your foot.\nStepping down without controlling your body weight.';

  @override
  String get exerciseGuideStepUpSource => 'ACE · Step-up';

  @override
  String get exerciseGuideGluteBridgeMistakes =>
      'Raising your hips so high that your lower back arches.\nPushing through your back instead of extending your hips with control.\nDropping your hips quickly on the way down.';

  @override
  String get exerciseGuideGluteBridgeSource => 'ACE · Glute bridge';

  @override
  String get exerciseGuideRomanianDeadliftMistakes =>
      'Rounding your back instead of moving your hips backward.\nBending your knees so much that the movement becomes a squat.\nTurning your neck to look in a mirror during a repetition.';

  @override
  String get exerciseGuideRomanianDeadliftSource =>
      'ACE · Romanian deadlift technique';
}
