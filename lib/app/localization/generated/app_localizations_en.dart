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
  String get homeStreakCurrent => 'Current streak';

  @override
  String get homeStreakDay => 'day';

  @override
  String get homeStreakDays => 'days';

  @override
  String homeStreakCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
      zero: '0 days',
    );
    return '$_temp0';
  }

  @override
  String homeStreakSemantics(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Current streak: $count days',
      one: 'Current streak: 1 day',
      zero: 'Current streak: 0 days',
    );
    return '$_temp0';
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
  String get exerciseRemoveActiveFilters => 'Clear filters';

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
  String get exerciseInstructionStep => 'Step';

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
  String get exerciseSourceOpenFailure => 'Couldn\'t open the source.';

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
  String get exerciseFlipHint => 'Tap or swipe';

  @override
  String get exerciseFlipSemanticsFront =>
      'Tap or swipe to see what this exercise does and which muscles it works';

  @override
  String get exerciseFlipSemanticsBack =>
      'Tap or swipe to return to the animation';

  @override
  String get exerciseInfoHeading => 'What it does';

  @override
  String get exerciseInfoPrimaryMuscle => 'Main target';

  @override
  String get exerciseInfoCatalogGroup => 'Catalog group';

  @override
  String get exerciseInfoBenefitUnavailable =>
      'Follow the exercise steps to understand its focus.';

  @override
  String get exerciseInfoSupportingMuscles => 'Also works';

  @override
  String exerciseInfoBenefitStrength(Object muscle) {
    return 'Builds strength in $muscle and improves control of this movement.';
  }

  @override
  String exerciseInfoBenefitMobility(Object muscle) {
    return 'Improves $muscle mobility with a controlled stretch.';
  }

  @override
  String get exerciseInfoBenefitCardio =>
      'Builds cardiovascular endurance and overall conditioning.';

  @override
  String get exerciseInfoNoSupportingMuscles =>
      'The catalog does not list supporting muscles.';

  @override
  String exerciseInfoMoreMuscles(int count) {
    return 'and $count more';
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
  String get exerciseGuideLateralRaiseMistakes =>
      'Shrugging instead of keeping your shoulders down and back.\nSwinging your torso or arching your lower back to lift more weight.\nBending your wrists or raising your arms above shoulder level.';

  @override
  String get exerciseGuideLateralRaiseSource => 'ACE · Lateral raise';

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

  @override
  String get homeGreetingMorning => 'Good morning';

  @override
  String get homeGreetingAfternoon => 'Good afternoon';

  @override
  String get homeGreetingEvening => 'Good evening';

  @override
  String get homeProfileTooltip => 'Open profile';

  @override
  String get homePlanTitle => 'Your training plan';

  @override
  String get homeTodayWorkout => 'Today\'s workout';

  @override
  String homeNextSession(Object weekday) {
    return 'Next session · $weekday';
  }

  @override
  String get homeAdjustPlan => 'Adjust plan';

  @override
  String get homeWeekTitle => 'Your week';

  @override
  String get homeViewActivity => 'View activity';

  @override
  String get homeTodaySession => 'TODAY\'S SESSION';

  @override
  String homeNextSessionLabel(Object weekday) {
    return 'NEXT SESSION · $weekday';
  }

  @override
  String homeDurationExercises(Object count, Object minutes) {
    return 'Approx. $minutes-min budget per session · $count exercises';
  }

  @override
  String get homeContinueWorkout => 'Continue workout';

  @override
  String get homeViewTodaySession => 'View today\'s session';

  @override
  String homeSessionAvailableOn(String weekday) {
    return 'Available on $weekday';
  }

  @override
  String get homeSessionCompleted => 'Workout completed';

  @override
  String get homeSessionCompletedDescription =>
      'Great work. You completed today\'s workout.';

  @override
  String get homeSessionSkipped => 'Workout skipped';

  @override
  String get homeSessionSkippedDescription =>
      'Today\'s workout was skipped. You can review your plan.';

  @override
  String get homeRecoveryDay => 'Recovery day';

  @override
  String get homeRecoveryDescription =>
      'You have no workout scheduled today. Rest and recover.';

  @override
  String homeWeeklySessionCount(Object done, Object target) {
    return '$done of $target sessions';
  }

  @override
  String get homeThisWeek => 'This week';

  @override
  String homeWeeklyGoal(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sessions per week.',
      one: '1 session per week.',
    );
    return 'Your goal is $_temp0';
  }

  @override
  String get homeStatusCompleted => 'completed';

  @override
  String get homeStatusSkipped => 'skipped';

  @override
  String get homeStatusPending => 'pending';

  @override
  String get homeStatusRest => 'rest';

  @override
  String get homeStatusRescheduled => 'rescheduled';

  @override
  String get homeRescheduledExplanation =>
      'Rescheduled workouts may appear on another day or outside this week.';

  @override
  String get activityTitle => 'Activity';

  @override
  String get activitySubtitle => 'Your training calendar.';

  @override
  String get activityTodayDetail => 'Day details';

  @override
  String get activityToday => 'Today';

  @override
  String get activityRescheduleConflict =>
      'There is already a workout on that day.';

  @override
  String activityRescheduled(Object date) {
    return 'Workout moved to $date.';
  }

  @override
  String get activityPreviousMonth => 'Previous month';

  @override
  String get activityNextMonth => 'Next month';

  @override
  String get activityRecoveryDay => 'Recovery day';

  @override
  String get activityNoSession => 'No workout is scheduled for this day.';

  @override
  String activityExerciseCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count exercises',
      one: '1 exercise',
    );
    return '$_temp0';
  }

  @override
  String get activitySessionCompleted => 'Workout completed';

  @override
  String get activityWorkoutInProgress => 'Workout in progress';

  @override
  String get activityContinueWorkout => 'Continue workout';

  @override
  String get activityRepeatWorkout => 'Repeat workout';

  @override
  String get activityStartSession => 'Start workout';

  @override
  String get activityScheduledSession => 'Scheduled workout';

  @override
  String get activityCompletedOutside => 'I trained outside the app';

  @override
  String get activitySkipSession => 'Skip workout';

  @override
  String get activitySessionSkipped => 'Workout skipped';

  @override
  String get activityStatusRescheduled => 'Rescheduled';

  @override
  String get activityStatusInProgress => 'In progress';

  @override
  String get activityCalendarLegendAction => 'View statuses';

  @override
  String get activityCalendarLegendTitle => 'Calendar statuses';

  @override
  String get activityCalendarLegendClose => 'Close';

  @override
  String get activityPlannedRoutine => 'Planned routine';

  @override
  String get activityActualRecord => 'Workout record';

  @override
  String get activityOutsideAppDataNote =>
      'The workout is recorded, but no sets or repetitions were saved.';

  @override
  String activitySetCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sets recorded',
      one: '1 set recorded',
    );
    return '$_temp0';
  }

  @override
  String get activityMoreActions => 'More actions';

  @override
  String get activityConfirmExternalTitle => 'Record an outside workout';

  @override
  String get activityConfirmExternalMessage =>
      'It will be saved as completed without set or repetition data. Continue?';

  @override
  String get activityConfirmSkipTitle => 'Skip workout';

  @override
  String get activityConfirmSkipMessage =>
      'This workout will be marked as skipped. You can undo this later.';

  @override
  String get activityConfirmAction => 'Confirm';

  @override
  String get activityUndoSkip => 'Undo skip';

  @override
  String get activitySkipUndone => 'Workout is pending again';

  @override
  String get activityChangeDay => 'Change day';

  @override
  String get rescheduleTitle => 'Reschedule workout';

  @override
  String get rescheduleEyebrow => 'Activity';

  @override
  String get rescheduleHeading => 'Move your workout';

  @override
  String rescheduleCurrentDate(Object date) {
    return 'Current date: $date';
  }

  @override
  String get rescheduleAvailableDates => 'Available dates';

  @override
  String get rescheduleNoDates =>
      'No other date is available in the next two weeks.';

  @override
  String get rescheduleConfirm => 'Confirm new date';

  @override
  String get reschedulePersistenceNote =>
      'Changes are kept while the app is open.';

  @override
  String rescheduleAvailableDateSemantics(Object date) {
    return '$date, available date';
  }

  @override
  String get profileEyebrow => 'Account';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileEdit => 'Edit profile';

  @override
  String get profileEditSubtitle => 'Name and training goal';

  @override
  String get profileAccountAccess => 'Account and access';

  @override
  String get profileAccountAccessSubtitle =>
      'Optional · sync is enabled separately';

  @override
  String get profileGoogleConnected => 'Connected with Google';

  @override
  String get profileNoAccount => 'No account';

  @override
  String get profileAccountChecking => 'Checking account';

  @override
  String get profileAccountCheckingDescription =>
      'Checking whether an account is connected.';

  @override
  String get profileGuestDescription =>
      'No account · data saved on this device';

  @override
  String get profilePrivacy => 'Privacy';

  @override
  String get profilePrivate => 'Private profile';

  @override
  String get profileVisible => 'Visible profile';

  @override
  String get profileTraining => 'Training';

  @override
  String get nutritionProfileSection => 'Nutrition';

  @override
  String get nutritionProfileTitle => 'Nutrition profile';

  @override
  String get nutritionProfileNotConfigured =>
      'Optional · personalize nutrition';

  @override
  String nutritionProfileConfigured(Object summary) {
    return 'Optional profile · $summary';
  }

  @override
  String get nutritionProfileIntro =>
      'Optional preferences are saved on this device. They do not prescribe a diet or change your training plan.';

  @override
  String get nutritionProfilePersonalSection => 'About you';

  @override
  String get nutritionProfileAge => 'Age (years)';

  @override
  String get nutritionProfileOptional =>
      'Optional · only used if you choose to provide it';

  @override
  String get nutritionProfileAgeError =>
      'Enter an age from 13 to 120, or leave it blank.';

  @override
  String get nutritionProfileHeight => 'Height (cm)';

  @override
  String get nutritionProfileHeightHint =>
      'Optional · enter only if you know it';

  @override
  String get nutritionProfileHeightError =>
      'Enter a height from 100 to 250 cm, or leave it blank.';

  @override
  String get nutritionProfilePreferencesSection => 'Food preferences';

  @override
  String get nutritionProfileBodyType => 'Somatotype (optional)';

  @override
  String get nutritionBodyTypeEctomorph => 'Ectomorph';

  @override
  String get nutritionBodyTypeMesomorph => 'Mesomorph';

  @override
  String get nutritionBodyTypeEndomorph => 'Endomorph';

  @override
  String get nutritionBodyTypeMixed => 'Mixed';

  @override
  String get nutritionBodyTypeUnknown => 'I don\'t know';

  @override
  String get nutritionProfileDiet => 'Eating pattern';

  @override
  String get nutritionProfileGoal => 'Nutrition goal';

  @override
  String get nutritionProfileGoalUnset => 'Not set';

  @override
  String get nutritionGoalWellbeing => 'General wellbeing';

  @override
  String get nutritionGoalTraining => 'Support my training';

  @override
  String get nutritionGoalGain => 'Gain weight';

  @override
  String get nutritionGoalLose => 'Lose weight';

  @override
  String get nutritionGoalMaintain => 'Maintain weight';

  @override
  String get nutritionProfileSomatotypeNote =>
      'Somatotypes are descriptive and are not diagnoses or diet formulas. Leave this as unknown if unsure.';

  @override
  String get nutritionProfileDietAny => 'No preference';

  @override
  String get nutritionProfileDietVegetarian => 'Vegetarian';

  @override
  String get nutritionProfileDietVegan => 'Vegan';

  @override
  String get nutritionProfileDietPescatarian => 'Pescatarian';

  @override
  String get nutritionProfileBudget => 'Relative budget';

  @override
  String get nutritionProfileBudgetLow => 'Economical';

  @override
  String get nutritionProfileBudgetBalanced => 'Balanced';

  @override
  String get nutritionProfileBudgetAny => 'No preference';

  @override
  String get nutritionProfileCountry => 'Country of purchase (ISO code)';

  @override
  String get nutritionProfileCountryHint =>
      'Optional · for example, CO or VE; not inferred from language or location';

  @override
  String get nutritionProfileCountryError =>
      'Enter a two-letter country code or leave it blank.';

  @override
  String get nutritionProfileRegion => 'Region or area (optional)';

  @override
  String get nutritionProfileRegionHint =>
      'Used only to improve regional suggestions; no precise location is collected';

  @override
  String get nutritionCountrySearch => 'Search country';

  @override
  String get nutritionCountryGeneral => 'General catalog';

  @override
  String get nutritionCountryGeneralHint =>
      'Use broad suggestions when your country is not listed';

  @override
  String get nutritionCountryNoResults => 'No countries found';

  @override
  String get nutritionCountryArgentina => 'Argentina';

  @override
  String get nutritionCountryColombia => 'Colombia';

  @override
  String get nutritionCountryDominicanRepublic => 'Dominican Republic';

  @override
  String get nutritionCountrySpain => 'Spain';

  @override
  String get nutritionCountryMexico => 'Mexico';

  @override
  String get nutritionProfileRestrictionsSection => 'Safety and exclusions';

  @override
  String get nutritionProfileAllergies => 'Allergies';

  @override
  String get nutritionProfileIntolerances => 'Intolerances';

  @override
  String get nutritionProfileExcluded => 'Ingredients to avoid';

  @override
  String get nutritionProfileListHint =>
      'Optional · separate items with commas; review food labels every time';

  @override
  String get nutritionProfilePrivacyNote =>
      'You can skip these fields. No account is required. Age and height are not used to calculate calorie or macro targets.';

  @override
  String get nutritionProfileSaveError =>
      'Could not save the nutrition profile.';

  @override
  String get commonSave => 'Save';

  @override
  String get commonSaving => 'Saving…';

  @override
  String get profileMyPlan => 'My training plan';

  @override
  String profilePlanSummary(Object days, Object goal, Object minutes) {
    return '$goal · $days days · ~$minutes-min budget';
  }

  @override
  String get profilePreferences => 'Preferences';

  @override
  String get profileAppearance => 'Appearance';

  @override
  String profileWeightUnit(Object unit) {
    return 'Weight $unit';
  }

  @override
  String profileWeekStart(Object day) {
    return 'week starts $day';
  }

  @override
  String profileHaptics(Object status) {
    return 'haptics $status';
  }

  @override
  String get profileHapticsOn => 'on';

  @override
  String get profileHapticsOff => 'off';

  @override
  String get profileBackup => 'Export and restore data';

  @override
  String get profileBackupSubtitle => 'Create a backup or restore your data';

  @override
  String get profileNotifications => 'Notifications';

  @override
  String profileReminderAt(Object time) {
    return 'Reminder at $time';
  }

  @override
  String get profileRemindersOff => 'Reminders off';

  @override
  String get profileSessionPreferencesNote =>
      'Preferences are kept while the app is open.';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonRetry => 'Try again';

  @override
  String get commonBack => 'Back';

  @override
  String get commonFinish => 'Finish';

  @override
  String get commonRemove => 'Remove';

  @override
  String homeWeekdayStatus(Object day, Object status) {
    return '$day: $status';
  }

  @override
  String get profileEditTitle => 'Edit profile';

  @override
  String get profileNameField => 'Name';

  @override
  String get profileEmailField => 'Email';

  @override
  String get profileGoalField => 'Training goal';

  @override
  String get profileReviewChanges => 'Review changes';

  @override
  String get profilePreferencesTitle => 'Preferences';

  @override
  String get profileWeightUnitTitle => 'Weight unit';

  @override
  String get profileWeekStartTitle => 'Week starts on';

  @override
  String get profileHapticTitle => 'Haptic feedback';

  @override
  String get profileSavePreferences => 'Save preferences';

  @override
  String get profileSettingsLoadFailed =>
      'Your preferences could not be loaded. Please try again.';

  @override
  String get profileSettingsSaveFailed =>
      'Your preferences could not be saved. Please try again.';

  @override
  String get profileNotificationsPageTitle => 'Notifications';

  @override
  String get profileWorkoutReminders => 'Workout reminders';

  @override
  String get profileReminderDescription =>
      'We\'ll remind you around this time on days with a pending workout.';

  @override
  String get profileReminderPermissionDenied =>
      'Allow notifications on your device to receive workout reminders.';

  @override
  String get profileReminderScheduleFailed =>
      'Workout reminders could not be updated. Please try again.';

  @override
  String get workoutReminderNotificationTitle => 'FORZA · today\'s workout';

  @override
  String get workoutReminderNotificationBody =>
      'You have a workout scheduled for today. You can do this!';

  @override
  String get profileReminderTime => 'Reminder time';

  @override
  String get profileWeeklySummary => 'Weekly summary';

  @override
  String get profileWeeklySummaryDescription => 'A review of your activity.';

  @override
  String get profilePersonalRecords => 'Personal records';

  @override
  String get profileSaveNotifications => 'Save preferences';

  @override
  String get profilePrivacyTitle => 'Privacy and account';

  @override
  String get profilePrivateTitle => 'Private profile';

  @override
  String get profilePrivateDescription => 'Only you can see your profile.';

  @override
  String get profileShareActivityTitle => 'Share activity';

  @override
  String get profileShareActivityDescription =>
      'Allow your progress to be shown in the app.';

  @override
  String get profileConfirmAccount => 'Confirm account details';

  @override
  String get profileSavePrivacy => 'Save privacy';

  @override
  String get profileReviewComplete => 'Data review complete.';

  @override
  String get profileAccountConfirmation => 'Review profile';

  @override
  String get profileReviewTitle => 'Review profile';

  @override
  String get profileName => 'Name';

  @override
  String get profileEmail => 'Email';

  @override
  String get profileGoal => 'Goal';

  @override
  String get profileConfirmDetails => 'Save details';

  @override
  String get profileSaveDetails => 'Save profile';

  @override
  String get profileThemeDevice => 'Follow device';

  @override
  String get profileThemeLight => 'Light';

  @override
  String get profileThemeDark => 'Dark';

  @override
  String get profileThemeAppearance => 'Appearance';

  @override
  String get profileThemeDescription => 'Choose how you want FORZA to look.';

  @override
  String get profileWeightKg => 'Kilograms (kg)';

  @override
  String get profileWeightLb => 'Pounds (lb)';

  @override
  String get profileWeekMonday => 'Monday';

  @override
  String get profileWeekSunday => 'Sunday';

  @override
  String get backupTitle => 'Export and restore';

  @override
  String get backupEyebrow => 'Your data';

  @override
  String get backupHeading => 'A backup you control';

  @override
  String get backupDescription =>
      'The file includes your plan, workout history and sets, schedule, goals, saved measurements, active workout, appearance, and preferences. It is saved as JSON wherever you choose. As a guest, your data stays on this device; sign in with Google from Profile to enable cloud sync. The file is independent of that sync.';

  @override
  String get backupExport => 'Export';

  @override
  String get backupExportDescription =>
      'Create a file you can save or transfer to another device.';

  @override
  String get backupCreate => 'Create backup';

  @override
  String get backupRestore => 'Restore';

  @override
  String get backupRestoreDescription =>
      'Review the contents and confirm before replacing local data.';

  @override
  String get backupChooseFile => 'Choose backup file';

  @override
  String get backupSaveDialog => 'Save FORZA backup';

  @override
  String get backupPickDialog => 'Select FORZA backup';

  @override
  String get backupSaved => 'Backup saved.';

  @override
  String get backupRestored => 'Backup restored.';

  @override
  String get backupConfirmTitle => 'Restore backup';

  @override
  String backupConfirmMessage(
    Object date,
    Object goals,
    Object measurements,
    Object records,
    Object schedule,
  ) {
    return 'Local data will be replaced with the backup from $date. It includes $records workout history entries, $schedule scheduled workouts, $goals goals, and $measurements measurement entries. This cannot be undone.';
  }

  @override
  String get backupReplace => 'Replace data';

  @override
  String get backupGenericError => 'We couldn\'t process the file. Try again.';

  @override
  String get profileResetSectionTitle => 'Reset local data';

  @override
  String get profileResetSectionDescription =>
      'Delete workout data from this device. You can save a backup first; app preferences and appearance will be kept.';

  @override
  String get profileResetAction => 'Reset data';

  @override
  String get profileResetConfirmTitle => 'Delete local data?';

  @override
  String get profileResetConfirmMessage =>
      'This deletes your plan, schedule, workout history and sets, goals, measurements, and active workout. Language, theme, units, haptics, privacy, and reminder settings will be kept. The exercise catalog is not deleted.';

  @override
  String get profileResetBackupOption => 'Save a JSON backup before deleting';

  @override
  String get profileResetConfirmButton => 'Delete data';

  @override
  String get profileResetBackupCancelled =>
      'No data was deleted because the backup was not saved.';

  @override
  String get profileResetCompleted =>
      'Data deleted. Set up a new plan to continue.';

  @override
  String get profileResetFailed =>
      'Data could not be deleted. The reset was not completed.';

  @override
  String get accountWelcomeTitle => 'An account is optional.';

  @override
  String get accountWelcomeDescription =>
      'You can train without an account. Signing in with Google does not upload your data; you can turn on sync separately in Profile.';

  @override
  String get accountSignInWithGoogle => 'Continue with Google';

  @override
  String get accountSwitchGoogle => 'Switch Google account';

  @override
  String get accountContinueWithoutAccount => 'Continue without an account';

  @override
  String get accountSignOut => 'Sign out';

  @override
  String get accountSignOutTitle => 'Sign out?';

  @override
  String get accountSignOutMessage =>
      'This disconnects your Google account from Forza. Your local workouts and preferences stay on this device.';

  @override
  String get accountLocalDataNote =>
      'Your data stays on this device until you choose to enable sync in Profile.';

  @override
  String get accountConfigurationRequired =>
      'Google sign-in could not start. Check the Android or iOS OAuth setup and try again.';

  @override
  String get accountProviderUnavailable =>
      'Google is unavailable. Check your connection or try again.';

  @override
  String get accountAuthenticationFailed =>
      'We couldn\'t complete sign-in. Try again.';

  @override
  String get onboardingSkip => 'Skip for now';

  @override
  String get onboardingCreatePlan => 'Create your plan';

  @override
  String get onboardingPreview => 'Preview';

  @override
  String get onboardingBack => 'Back';

  @override
  String get onboardingPreviousStep => 'Previous step';

  @override
  String get onboardingContinue => 'Continue';

  @override
  String onboardingStepLabel(Object step, Object total) {
    return 'Step $step of $total';
  }

  @override
  String get onboardingGoalTitle => 'What would you like to achieve?';

  @override
  String get onboardingGoalDescription =>
      'We\'ll choose a starting point that suits you. You can change it later.';

  @override
  String get onboardingStrengthGoal => 'Build strength';

  @override
  String get onboardingMuscleGoal => 'Build muscle';

  @override
  String get onboardingHabitGoal => 'Build a habit';

  @override
  String get onboardingStrengthGoalDescription => 'Make progress in your lifts';

  @override
  String get onboardingMuscleGoalDescription => 'Build muscle consistently';

  @override
  String get onboardingHabitGoalDescription => 'Build a sustainable routine';

  @override
  String get onboardingExperienceTitle => 'What\'s your experience level?';

  @override
  String get onboardingExperienceDescription =>
      'We\'ll use your answer to adjust the starting sets for each exercise.';

  @override
  String get onboardingExperienceBeginner => 'I\'m just getting started';

  @override
  String get onboardingExperienceSome => 'I have some experience';

  @override
  String get onboardingExperienceLong => 'I\'ve been training for a while';

  @override
  String get onboardingExperienceBeginnerDescription =>
      'I want to learn and progress step by step';

  @override
  String get onboardingExperienceSomeDescription =>
      'I know some of the movements';

  @override
  String get onboardingExperienceLongDescription =>
      'I have a routine and want new challenges';

  @override
  String get onboardingExperienceNote =>
      'Your experience helps tailor your training.';

  @override
  String get onboardingScheduleTitle => 'Which days can you train?';

  @override
  String get onboardingScheduleDescription =>
      'Choose the days that usually work for you. You can change them later.';

  @override
  String onboardingSessionsPerWeek(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sessions per week',
      one: '1 session per week',
    );
    return '$_temp0';
  }

  @override
  String get onboardingRecoveryTitle => 'Training frequency and recovery';

  @override
  String get onboardingRecoveryOnce =>
      'One session is a good start. To improve strength, ACSM recommends training the major muscle groups at least twice a week for healthy adults. You can increase frequency when it feels sustainable.';

  @override
  String get onboardingRecoveryTwoToThree =>
      'The plan schedules full-body sessions. When possible, leave a day between them to spread the effort and recover.';

  @override
  String get onboardingRecoveryFour =>
      'The plan alternates upper and lower body. Space sessions to give each muscle group time to recover.';

  @override
  String get onboardingRecoveryFiveToSix =>
      'The plan alternates upper and lower body. This is a high frequency: schedule breaks based on your recovery and move days if needed.';

  @override
  String get onboardingRecoverySeven =>
      'You can select all seven days, but that leaves no full day without strength training. We recommend reserving at least one day for rest or light activity; you can change your schedule anytime.';

  @override
  String get onboardingRecoverySource => 'ACSM resistance training guidance';

  @override
  String get onboardingProgressionTemplateNote =>
      'This plan is an initial template. Suggestions use your logged sets and never change the plan automatically; you decide whether to apply them.';

  @override
  String get sessionProgressionTitle => 'Progression suggestion';

  @override
  String get sessionProgressionNoHistory =>
      'There are not enough records for this exercise yet. Complete your sets and log reps and load if you used weight.';

  @override
  String sessionProgressionKeepBuilding(int sessions, int repetitions) {
    return 'Keep the same load and focus on technique; do not increase yet. Before suggesting more load, we require $sessions consecutive workouts with at least $repetitions reps in every set.';
  }

  @override
  String sessionProgressionReadyToIncrease(int repetitions, int sessions) {
    return 'You reached $repetitions reps in every set for $sessions consecutive workouts. If it felt comfortable, pain-free, and controlled, try the smallest available load increase and return to the lower end of the rep range.';
  }

  @override
  String sessionProgressionBodyweightReady(int repetitions, int sessions) {
    return 'You completed $repetitions reps in every set for $sessions consecutive workouts. If your technique stayed steady, you can try a slightly harder bodyweight variation.';
  }

  @override
  String get sessionProgressionHabitFocus =>
      'For a habit-building goal, prioritize consistency and technique. You do not need to increase load automatically.';

  @override
  String get sessionProgressionReturningAfterBreak =>
      'It has been over a month since you logged this exercise. Resume with a comfortable load and complete new sessions before considering an increase.';

  @override
  String sessionProgressionTimedKeepBuilding(int sessions, int seconds) {
    return 'Log the seconds and keep the movement controlled. Before suggesting a harder variation, we require $sessions consecutive workouts with $seconds seconds in every set.';
  }

  @override
  String sessionProgressionTimedReadyToVary(int sessions, int seconds) {
    return 'You completed $seconds seconds in every set for $sessions consecutive workouts. If you stayed in control, you can try a slightly harder variation; do not add weight.';
  }

  @override
  String get sessionProgressionTemplateNote =>
      'Suggestions are based on your logs. The plan is a template and does not change automatically; you decide whether to apply them.';

  @override
  String get onboardingSessionTime => 'Time budget per session';

  @override
  String get onboardingSessionBudgetNote =>
      'The plan adjusts the number of exercises to this budget. Actual time varies with your pace and how long you spend warming up and cooling down. The timer between exercises is a 45-second guide.';

  @override
  String onboardingMinutes(Object minutes) {
    return '$minutes min';
  }

  @override
  String get onboardingEquipmentTitle => 'What equipment do you have?';

  @override
  String get onboardingEquipmentDescription =>
      'We\'ll use this to choose exercises you can do.';

  @override
  String get onboardingEquipmentRequired =>
      'Choose at least one option to prepare your workouts.';

  @override
  String get onboardingAvoidMovementTitle =>
      'Movements you prefer to avoid (optional)';

  @override
  String get onboardingAvoidMovementDescription =>
      'Select exercises you prefer to leave out. This preference is not a medical diagnosis; consult a professional if you have health concerns.';

  @override
  String onboardingAvoidedMovementSummary(String movements) {
    return 'Excluded movements: $movements';
  }

  @override
  String get onboardingAvoidedMovementApplied =>
      'The plan prioritizes compatible options when available. Review each exercise before starting.';

  @override
  String get onboardingNoCompatibleExercises =>
      'No exercises match the selected equipment and exclusions. Adjust your preferences to generate a plan.';

  @override
  String get onboardingPreviewTitle => 'Here\'s your week';

  @override
  String get onboardingPreviewDescription =>
      'This is a starting point. You can adjust your plan from Profile.';

  @override
  String get onboardingEditGoal => 'Goal';

  @override
  String get onboardingEditExperience => 'Experience';

  @override
  String get onboardingEditSchedule => 'Days and duration';

  @override
  String get onboardingEditEquipment => 'Equipment and exclusions';

  @override
  String get onboardingReturnToPreview => 'Return to plan summary';

  @override
  String get onboardingEmptySessionConflict =>
      'At least one session has no compatible exercises. Adjust training days, equipment, or excluded movements before creating the plan.';

  @override
  String onboardingSessionSummary(int count, int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count exercises',
      one: '1 exercise',
    );
    return '$_temp0 · ~$minutes min estimated';
  }

  @override
  String onboardingTimedPrescription(int sets) {
    return '$sets sets · 20–40 seconds';
  }

  @override
  String onboardingRepPrescription(int sets, String target) {
    return '$sets sets · $target';
  }

  @override
  String get onboardingStrengthRepRange => '6–8 reps';

  @override
  String get onboardingMuscleRepRange => '8–12 reps';

  @override
  String get onboardingHabitRepRange => '8–12 reps at a comfortable pace';

  @override
  String onboardingPlanExperience(Object experience) {
    return 'Experience: $experience';
  }

  @override
  String onboardingPlanEquipment(Object equipment) {
    return 'Equipment: $equipment';
  }

  @override
  String onboardingPlanExerciseCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count exercises',
      one: '1 exercise',
    );
    return '$_temp0';
  }

  @override
  String get onboardingSafetyNote =>
      'General guidance. If you have pain, an injury, or a medical condition, consult a professional before exercising.';

  @override
  String get onboardingCreateMyPlan => 'Create my plan';

  @override
  String get sessionPause => 'Pause workout';

  @override
  String get sessionWarmup => 'Warm-up';

  @override
  String get sessionPreparation => 'Getting ready';

  @override
  String get sessionExercises => 'Exercises';

  @override
  String sessionSet(Object number) {
    return 'Set $number';
  }

  @override
  String get sessionRest => 'Rest';

  @override
  String get sessionPaused => 'Workout paused';

  @override
  String get sessionExitTitle => 'Leave workout';

  @override
  String get sessionCompletedTitle => 'Workout complete';

  @override
  String get sessionGoodWork => 'Well done';

  @override
  String get sessionSummary => 'Workout summary';

  @override
  String get sessionDuration => 'Duration';

  @override
  String get sessionExerciseCount => 'Exercises';

  @override
  String get sessionGoal => 'Goal';

  @override
  String get sessionViewWarmup => 'View warm-up';

  @override
  String get sessionStart => 'Start workout';

  @override
  String get sessionSkipWarmup => 'Skip warm-up';

  @override
  String get sessionSkipRest => 'Skip rest';

  @override
  String get sessionContinue => 'Continue workout';

  @override
  String get sessionAbandon => 'Leave workout';

  @override
  String get sessionAbandonConfirm => 'Yes, leave';

  @override
  String get sessionKeep => 'Keep training';

  @override
  String get sessionViewSummary => 'View workout summary';

  @override
  String get sessionFinish => 'Finish';

  @override
  String get sessionRepetitions => 'Repetitions';

  @override
  String get sessionSeconds => 'Seconds';

  @override
  String get sessionLoad => 'External load (kg)';

  @override
  String get sessionAddExternalLoad => 'Add external load';

  @override
  String get sessionRemoveExternalLoad => 'Remove external load';

  @override
  String sessionSetCountSummary(int recommended, int planned) {
    return 'Recommended: $recommended · This session: $planned';
  }

  @override
  String sessionAdditionalSet(int number) {
    return 'Additional set $number';
  }

  @override
  String get sessionAddSet => 'Add set';

  @override
  String get sessionRemovePendingSet => 'Remove last set';

  @override
  String get sessionRemoveCompletedSet => 'Delete completed set';

  @override
  String get sessionRemoveCompletedSetTitle => 'Delete set results?';

  @override
  String get sessionRemoveCompletedSetMessage =>
      'The results for the last set in this session will be deleted. Your weekly prescription will stay the same.';

  @override
  String sessionProgress(Object current, Object total) {
    return 'Exercise $current of $total';
  }

  @override
  String get sessionSavedFeedback =>
      'Workout saved! Your results are now part of your progress.';

  @override
  String get sessionNextExercise => 'Next exercise';

  @override
  String get sessionPreviousExercise => 'Previous exercise';

  @override
  String get sessionSetComplete => 'Set complete';

  @override
  String get progressEyebrow => 'Progress';

  @override
  String get progressGoals => 'Personal goals';

  @override
  String get progressHistory => 'Workout history';

  @override
  String get progressRemoveGoalTitle => 'Remove goal';

  @override
  String get progressRemoveGoalBody =>
      'Do you want to remove this goal from your progress?';

  @override
  String get progressEditGoal => 'Edit goal';

  @override
  String get progressGoalRemoved => 'Goal removed.';

  @override
  String get progressDuration => 'Duration';

  @override
  String get progressExercises => 'Exercises';

  @override
  String get progressSessionDetails => 'Workout details';

  @override
  String get progressStrengthTrend => 'Strength trend';

  @override
  String get progressBodyTrend => 'Body measurements';

  @override
  String get progressStart => 'Start';

  @override
  String get progressCurrent => 'Current';

  @override
  String get progressLastEntry => 'Latest entry';

  @override
  String get progressPeriodChange => 'Change over the period';

  @override
  String get progressRecentMeasurements => 'Recent measurements';

  @override
  String get progressRegisterMeasurements => 'Log measurements';

  @override
  String get progressMeasurementDate => 'Entry date';

  @override
  String get progressBodyWeight => 'Body weight';

  @override
  String get progressWaist => 'Waist';

  @override
  String get progressChest => 'Chest';

  @override
  String get progressHips => 'Hips';

  @override
  String get progressArm => 'Arm';

  @override
  String get progressSaveEntry => 'Save entry';

  @override
  String get progressPersonalRecords => 'Personal records';

  @override
  String get progressNewGoal => 'New goal';

  @override
  String get progressGoalType => 'Goal type';

  @override
  String get progressWeeklySessions => 'Sessions per week';

  @override
  String get progressExerciseLoadRecord => 'Exercise weight record';

  @override
  String get progressExerciseName => 'Exercise name';

  @override
  String get progressSelectExercise => 'Select exercise';

  @override
  String get progressSearchExercises => 'Search exercises';

  @override
  String get progressNoExercisesFound => 'No exercises found.';

  @override
  String get progressExerciseCatalogRetry => 'Retry loading catalog';

  @override
  String get progressExerciseCatalogLoading => 'Loading exercises…';

  @override
  String progressGoalExerciseNeedsResolution(String name) {
    return 'The older goal “$name” needs you to choose the correct exercise so records are not combined.';
  }

  @override
  String get progressExerciseHint => 'e.g. Goblet squat';

  @override
  String get progressSaveGoal => 'Save goal';

  @override
  String progressExerciseCount(Object count) {
    return '$count exercises';
  }

  @override
  String get progressEmptyTitle => 'No progress data yet';

  @override
  String get progressEmptyDescription =>
      'Complete a workout and log your sets to start seeing your results.';

  @override
  String get progressNoHistory =>
      'Complete a workout to see your recent activity here.';

  @override
  String progressGoalSessionsValue(Object done, Object target) {
    return '$done of $target workouts this week';
  }

  @override
  String progressGoalLoadValue(Object unit, Object weight) {
    return 'Target: $weight $unit';
  }

  @override
  String progressGoalProgress(Object current, Object target) {
    return '$current of $target';
  }

  @override
  String get progressRecentSessions => 'Recent workouts';

  @override
  String get progressViewAll => 'View all';

  @override
  String get progressReps => 'Repetitions';

  @override
  String get progressSets => 'Sets';

  @override
  String get progressVolume => 'Volume';

  @override
  String get progressNoMeasurements => 'No measurements have been logged.';

  @override
  String get progressNoRecords => 'No personal records yet.';

  @override
  String get progressWeightUnitKg => 'kg';

  @override
  String get progressWeightUnitLb => 'lb';

  @override
  String get progressTrendDescription =>
      'Your progress is calculated from saved workouts and sets.';

  @override
  String get progressGoalStatusComplete => 'Goal complete';

  @override
  String get progressGoalStatusInProgress => 'In progress';

  @override
  String progressSessionCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count workouts',
      one: '1 workout',
    );
    return '$_temp0';
  }

  @override
  String get onboardingUpperBody => 'Upper body';

  @override
  String get onboardingLowerBody => 'Lower body';

  @override
  String get onboardingFullBody => 'Full body';

  @override
  String get accountPasswordRequired => 'Enter your password.';

  @override
  String get accountContinueAction => 'Continue';

  @override
  String get profileYourInformation => 'Your information';

  @override
  String get profileUpdateInformation =>
      'Update the information shown on your profile.';

  @override
  String get profileNameRequired => 'Enter your name.';

  @override
  String get profileNameTooLong => 'Name must be 80 characters or fewer.';

  @override
  String get profileUseGoogleName => 'Use Google name';

  @override
  String get profileNameLocalNote =>
      'This display name is saved on this device only.';

  @override
  String get profileShowNavigationLabels => 'Show navigation labels';

  @override
  String get profileShowNavigationLabelsHint =>
      'Show each section name below its icon.';

  @override
  String get profileEmailInvalid => 'Enter a valid email address.';

  @override
  String get profileGoalRequired => 'Enter a goal.';

  @override
  String get settingsThemeDescription =>
      'Use your device theme or choose one for FORZA.';

  @override
  String get profileTailoredTitle => 'Made for you';

  @override
  String get profileTailoredDescription =>
      'Adjust units and how FORZA organizes your week.';

  @override
  String get onboardingPreferencesLater =>
      'You can change these preferences later in Profile.';

  @override
  String get profileKilograms => 'Kilograms (kg)';

  @override
  String get profilePounds => 'Pounds (lb)';

  @override
  String get profileHapticDescription =>
      'Gentle vibration when using supported controls.';

  @override
  String get profileNotificationsHeading => 'Get only what matters.';

  @override
  String get profileNotificationsDescription =>
      'Reminders use your schedule and need device permission.';

  @override
  String get profilePrivacyPageTitle => 'Privacy and account';

  @override
  String get profilePrivacyHeading => 'You decide what to share.';

  @override
  String get profilePrivacyDescription => 'Your privacy preferences.';

  @override
  String get profileAccountData => 'Account details';

  @override
  String get cloudSyncTitle => 'Cloud sync';

  @override
  String get cloudSyncDescription =>
      'Sync is optional. Your data stays available offline and is sent to your private Firestore account only after you turn sync on.';

  @override
  String get cloudSyncToggleTitle => 'Sync my data';

  @override
  String get cloudSyncToggleDescription =>
      'Includes your plan, schedule, workouts, sets, goals, measurements, and app settings.';

  @override
  String get cloudSyncStatusHeading => 'Status';

  @override
  String get cloudSyncStatusSignedOut => 'Sign in to sync.';

  @override
  String get cloudSyncStatusDisabled =>
      'Off · changes are saved on this device only.';

  @override
  String get cloudSyncStatusSyncing => 'Syncing your data…';

  @override
  String get cloudSyncStatusSynced => 'Everything is up to date.';

  @override
  String get cloudSyncStatusPending => 'Changes are waiting to sync.';

  @override
  String get cloudSyncStatusFailed => 'Sync failed. You can try again.';

  @override
  String get cloudSyncAccount => 'Connected account';

  @override
  String get cloudSyncStatusOffline =>
      'Offline. Changes are pending until the connection returns.';

  @override
  String get cloudSyncFrequency => 'Sync frequency';

  @override
  String get cloudSyncFrequencyChanges => 'When changes are detected';

  @override
  String get cloudSyncFrequencyDaily => 'Daily';

  @override
  String get cloudSyncFrequencyWeekly => 'Weekly';

  @override
  String get cloudSyncFrequencyMonthly => 'Monthly';

  @override
  String get cloudSyncFrequencyManual => 'Manual only';

  @override
  String get cloudSyncFrequencyNote =>
      'Automatic intervals are targets while the app can run and a connection is available. The OS may pause it; sync is not guaranteed while the app is closed. Manual only never uploads changes automatically.';

  @override
  String get cloudSyncFrequencySaveFailed =>
      'Could not save the frequency. Try again.';

  @override
  String get cloudSyncNow => 'Sync now';

  @override
  String get cloudSyncIncludedHeading => 'Included data';

  @override
  String get cloudSyncIncludedDescription =>
      'Training plan and days, schedule, workout and set history, goals, saved measurements, active session, appearance, language and preferences, reminders, and privacy settings. Local file export and import remain available separately under Backup.';

  @override
  String get cloudSyncNutritionTitle => 'Sync nutrition data';

  @override
  String get cloudSyncNutritionDescription =>
      'Off by default. If enabled, your nutrition profile preferences and meal history are copied to your private Firestore account. Turning this off stops future sync; your local data stays on this device. Delete an existing cloud copy below when you want it removed.';

  @override
  String get cloudSyncNutritionConsentTitle => 'Sync nutrition data?';

  @override
  String get cloudSyncNutritionConsentDescription =>
      'This sends your food preferences, exclusions, and recorded meals to the private Firestore backup for this account. These data are not sent to analytics. You can revoke this choice later.';

  @override
  String get cloudSyncNutritionConsentAccept => 'Allow nutrition sync';

  @override
  String get cloudSyncNutritionSaveFailed =>
      'Could not update nutrition sync consent.';

  @override
  String get cloudSyncNutritionDeleteButton =>
      'Delete nutrition copy from cloud';

  @override
  String get cloudSyncNutritionDeleteHint =>
      'This only deletes the nutrition copy from Firestore. Other synced data and your local profile and history are kept.';

  @override
  String get cloudSyncNutritionDeleteConfirmTitle =>
      'Delete cloud nutrition data?';

  @override
  String get cloudSyncNutritionDeleteConfirmDescription =>
      'This removes nutrition data from this account\'s Firestore backup. Your on-device profile and meal history remain.';

  @override
  String get cloudSyncNutritionDeleted =>
      'Nutrition data was removed from the cloud backup.';

  @override
  String get cloudSyncNutritionNoRemoteData =>
      'No nutrition data was present in the cloud backup.';

  @override
  String get cloudSyncNutritionDeleteFailed =>
      'Could not remove nutrition data from the cloud. Check your connection and try again.';

  @override
  String get cloudSyncLastSync => 'Last sync';

  @override
  String get cloudSyncRetry => 'Retry now';

  @override
  String get cloudSyncConsentTitle => 'Turn on sync';

  @override
  String get cloudSyncConsentDescription =>
      'A copy of your plan and schedule, workouts and sets, goals, measurements, active workout, appearance and preferences, notifications, and privacy settings will be uploaded to your private Firestore account. Existing cloud and local data will be combined, keeping your local version when records conflict. You can turn sync off later.';

  @override
  String get cloudSyncConsentAccept => 'Turn on and sync';

  @override
  String get cloudSyncEnableFailed => 'Sync could not be enabled. Try again.';

  @override
  String get cloudSyncDisableTitle => 'Turn off sync';

  @override
  String get cloudSyncDisableDescription =>
      'New changes will stay on this device. The existing cloud copy will not be deleted.';

  @override
  String get cloudSyncDisableButton => 'Turn off';

  @override
  String get cloudSyncDeleteSection => 'Cloud copy';

  @override
  String get cloudSyncDeleteDescription =>
      'Deletes your Firestore profile and synced copy. Your local data and Google account stay in place.';

  @override
  String get cloudSyncDeleteButton => 'Delete cloud copy';

  @override
  String get cloudSyncDeleteTitle => 'Delete your cloud copy?';

  @override
  String get cloudSyncDeleteConfirm =>
      'This removes your Firestore profile and all synced data. Data on this device and your Google account will be kept.';

  @override
  String get cloudSyncDeleteCompleted =>
      'The Firestore copy was deleted. Local data was kept.';

  @override
  String get cloudSyncDeleteFailed =>
      'The cloud copy could not be deleted. Check your connection and try again.';

  @override
  String get profileConfirmHeading => 'Confirm your details';

  @override
  String get profileConfirmDescription =>
      'Review this information before returning to your profile.';

  @override
  String get backupInvalid =>
      'The backup is invalid or damaged. Check the file and try again.';

  @override
  String get profileRecordsSubtitle => 'Alerts when you reach a new record.';

  @override
  String get progressTitle => 'Your progress';

  @override
  String get progressSubtitle => 'Your consistency, in perspective.';

  @override
  String get progressLast30Days => 'Last 30 days';

  @override
  String get progressNoHistoryInPeriod => 'No workouts in this period.';

  @override
  String progressLastWorkout(Object date) {
    return 'Last workout · $date';
  }

  @override
  String get progressGoToActivity => 'Go to Activity';

  @override
  String get progressNoSetData => 'No sets logged';

  @override
  String progressWeightChange(String change) {
    return 'Change since previous measurement: $change kg';
  }

  @override
  String progressRecentRecord(
    String exercise,
    String value,
    String unit,
    String date,
  ) {
    return 'Recent record · $exercise: $value $unit · $date';
  }

  @override
  String get progressSessions => 'workouts';

  @override
  String progressTimeTotal(Object hours, Object minutes) {
    return '$hours hr $minutes min';
  }

  @override
  String progressSetsAndReps(Object reps, Object sets) {
    return '$sets sets · $reps reps';
  }

  @override
  String get progressVolumeExplanation =>
      'Volume adds reps × weight for sets that include both values.';

  @override
  String get progressAddGoal => 'Add';

  @override
  String get progressGoalDescription =>
      'Set a weekly goal or a weight target to track your progress.';

  @override
  String get progressLoadGoal => 'Weight goal';

  @override
  String progressGoalCurrentTarget(Object current, Object target, Object unit) {
    return '$current of $target $unit';
  }

  @override
  String get progressWeeklyGoalDescription =>
      'Workouts completed Monday through Sunday.';

  @override
  String get progressLoadGoalDescription =>
      'Heaviest weight recorded in your sets for this exercise.';

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
    return '$date · $minutes min · $count exercises$volume';
  }

  @override
  String get progressNoLoadData => 'No weight data';

  @override
  String progressVolumeKg(Object value) {
    return '$value kg';
  }

  @override
  String get progressGoalEditorDescription =>
      'Choose a goal you can track in FORZA.';

  @override
  String get progressTargetLoad => 'Target weight';

  @override
  String get progressSessionsUnit => 'workouts';

  @override
  String get progressExerciseNameRequired =>
      'Enter the exercise name as it appears in your workout.';

  @override
  String get progressPositiveValueRequired =>
      'Enter a value greater than zero.';

  @override
  String get progressWeeklyTargetRange =>
      'Choose between 1 and 7 whole workouts.';

  @override
  String get progressSessionDetail => 'Workout details';

  @override
  String get progressOutsideAppNote =>
      'You marked this workout as completed outside FORZA. Exercise and weight details aren\'t available.';

  @override
  String progressExerciseHeading(Object count) {
    return 'Exercises · $count';
  }

  @override
  String get progressStrengthEvolution => 'Strength progress';

  @override
  String get progressStrengthHeadline => 'Build strength, one step at a time.';

  @override
  String get progressStrengthDescription =>
      'Compare the heaviest logged load per workout for each exercise.';

  @override
  String get progressWorkingWeight => 'Working weight (kg)';

  @override
  String progressStrengthChartSummary(
    String start,
    String current,
    int sessions,
  ) {
    return 'The load changed from $start to $current kilograms across $sessions logged workouts.';
  }

  @override
  String get progressStrengthMetric =>
      'Heaviest weight logged per workout (kg). Sets without a load are excluded.';

  @override
  String get progressStrengthSinglePoint =>
      'Only one workout has a logged load for this exercise.';

  @override
  String get progressStrengthEmpty =>
      'There are no weighted sets for this period. Log the weight used for your sets during a workout.';

  @override
  String progressStrengthChange(String sign, String change) {
    return 'Change between the first and last workout: $sign$change kg.';
  }

  @override
  String get progressPeriodLabel => 'Period';

  @override
  String get progressPeriod30Days => '30 days';

  @override
  String get progressPeriod90Days => '90 days';

  @override
  String get progressPeriodYear => '1 year';

  @override
  String get progressPeriodAll => 'All time';

  @override
  String get progressBodyEvolution => 'Body measurements';

  @override
  String get progressBodyHeadline => 'Changes you can track.';

  @override
  String get progressBodyDescription =>
      'Measurements are for reference, not targets.';

  @override
  String progressWeightChartSummary(Object current, Object start) {
    return 'Body weight changed from $start to $current kilograms.';
  }

  @override
  String get progressMeasurementHeadline => 'Log your progress.';

  @override
  String get progressMeasurementDescription =>
      'Weight is required. Other measurements are optional.';

  @override
  String get progressMeasurementsSavedNote =>
      'Your measurements are saved on this device.';

  @override
  String get progressMeasurementsEmpty =>
      'No measurements yet. Log your weight and measurements to track changes over time.';

  @override
  String get progressEditMeasurement => 'Edit measurement';

  @override
  String get progressDeleteMeasurement => 'Delete measurement';

  @override
  String get progressDeleteMeasurementTitle => 'Delete entry';

  @override
  String get progressDeleteMeasurementBody =>
      'Do you want to remove the measurements from this day? This cannot be undone.';

  @override
  String get progressSaveFailed => 'The entry could not be saved. Try again.';

  @override
  String progressValueRange(Object maximum, Object minimum, Object unit) {
    return 'Allowed range: $minimum–$maximum $unit';
  }

  @override
  String get progressInvalidValue => 'Enter a valid value.';

  @override
  String get progressWeightRequired => 'Enter your body weight.';

  @override
  String get progressRecordsHeadline => 'Your bests.';

  @override
  String get progressRecordsDescription =>
      'Records calculated from your saved sets, with date and unit. Ties keep the first date.';

  @override
  String get progressRecordsEmpty =>
      'There are no records yet. Log repetitions, load, or duration in a set to get started.';

  @override
  String get progressRecordNoMeasurements => 'Body weight';

  @override
  String get progressKilograms => 'kg';

  @override
  String get progressRepetitionsUnit => 'reps';

  @override
  String get progressSecondsUnit => 's';

  @override
  String progressSetSummary(Object number, Object values) {
    return 'Set $number · $values';
  }

  @override
  String get progressMinutesUnit => 'min';

  @override
  String get progressChangeFromStart => 'Change from start';

  @override
  String progressDateFormatShort(Object date) {
    return '$date';
  }

  @override
  String get sessionBack => 'Back';

  @override
  String get sessionBackStep => 'Back to previous step';

  @override
  String get sessionTitlePreparation => 'Getting ready';

  @override
  String get sessionTitleWarmup => 'Warm-up';

  @override
  String get sessionTitleWorkout => 'Your workout';

  @override
  String get sessionTitleRest => 'Rest';

  @override
  String get sessionTitlePaused => 'Workout paused';

  @override
  String get sessionTitleConfirmAbandon => 'Confirm leaving';

  @override
  String get sessionTitleCompleted => 'Workout complete';

  @override
  String get sessionTitleCooldown => 'Cool-down';

  @override
  String get sessionTitleSummary => 'Workout summary';

  @override
  String get sessionWarmupHeadline => 'Get your body ready';

  @override
  String sessionWarmupDescription(Object session) {
    return 'Brief movements for $session. Keep a comfortable pace; you can skip them whenever you like.';
  }

  @override
  String get warmupShoulderCircles => 'Shoulder circles';

  @override
  String get warmupShoulderCirclesInstructions =>
      'Make gentle circles forward and backward.';

  @override
  String get warmupThoracicRotation => 'Thoracic rotation';

  @override
  String get warmupThoracicInstructions =>
      'Rotate your torso without straining your neck.';

  @override
  String get warmupInclinePushups => 'Incline push-ups';

  @override
  String get warmupInclineInstructions =>
      'Place your hands on a sturdy surface and move with control.';

  @override
  String get warmupMarch => 'March in place';

  @override
  String get warmupMarchInstructions =>
      'Raise your knees at a comfortable pace.';

  @override
  String get warmupHipHinge => 'Hip hinge';

  @override
  String get warmupHipHingeInstructions =>
      'Move your hips back while keeping your back comfortable.';

  @override
  String get warmupBodyweightSquat => 'Bodyweight squat';

  @override
  String get warmupBodyweightSquatInstructions =>
      'Lower only as far as you can control.';

  @override
  String get warmupMarchArms => 'March with arm swings';

  @override
  String get warmupMarchArmsInstructions =>
      'March in place and swing your arms with the movement.';

  @override
  String get warmupTorsoRotations => 'Torso rotations';

  @override
  String get warmupTorsoInstructions =>
      'Rotate gently from side to side without bouncing.';

  @override
  String get warmupThirtySeconds => '30 sec';

  @override
  String get warmupThirtySecondsEachSide => '30 sec per side';

  @override
  String get warmupFortyFiveSeconds => '45 sec';

  @override
  String get warmupEightReps => '8 reps';

  @override
  String get sessionPreparationHeadline => 'Ready to begin';

  @override
  String get sessionPreparationDescription =>
      'Take a moment to prepare your space and review today\'s workout.';

  @override
  String get sessionDraftReviewTitle => 'Review saved workout';

  @override
  String sessionDraftReviewDateMismatch(String date) {
    return 'There is a saved workout from $date. You can resume it with its original routine or discard it to start the selected session.';
  }

  @override
  String get sessionDraftReviewLegacy =>
      'This draft is from an older version and did not save the exact routine. You can continue using the current routine; your partial logs will be kept. You can also discard it.';

  @override
  String get sessionDraftReviewCorrupt =>
      'The saved draft cannot be read. It will be kept until you choose to discard it and start a new session.';

  @override
  String get sessionContinueSavedWorkout => 'Continue saved workout';

  @override
  String get sessionContinueWithCurrentPlan => 'Continue with current routine';

  @override
  String get sessionDiscardWorkoutDraft =>
      'Discard draft and start this session';

  @override
  String get sessionRestoredOriginalPlan =>
      'The original saved routine was restored so each set stays linked to the same exercise.';

  @override
  String get sessionUnknownDate => 'another date';

  @override
  String get sessionWaterBottle => 'Water bottle';

  @override
  String get sessionClearSpace => 'Clear space';

  @override
  String get sessionEquipmentReady => 'Equipment ready';

  @override
  String get sessionExerciseHeadline => 'Keep going';

  @override
  String sessionExerciseCountProgress(Object current, Object total) {
    return 'Exercise $current of $total';
  }

  @override
  String sessionSetsProgress(int current, int total) {
    return '$current of $total sets completed';
  }

  @override
  String get sessionViewRoutine => 'View routine';

  @override
  String get sessionRoutineTitle => 'This session\'s routine';

  @override
  String get sessionRoutineDescription =>
      'Review every exercise. You can open the current or a previous exercise; upcoming ones unlock as you progress.';

  @override
  String get sessionRoutineCompleted => 'Completed';

  @override
  String get sessionRoutineCurrent => 'Current';

  @override
  String get sessionRoutinePending => 'Upcoming';

  @override
  String get sessionCloseRoutine => 'Close routine';

  @override
  String get sessionSetLog => 'Set log';

  @override
  String get sessionNextSet => 'Next set';

  @override
  String get sessionCompleteSetAction => 'Complete set';

  @override
  String get sessionUndoSet => 'Unmark set';

  @override
  String get sessionPreviousSetSuggestion => 'Suggestion from previous set';

  @override
  String get sessionRestHeadline => 'Take a breather';

  @override
  String get sessionRestBetweenSets => 'Rest between sets';

  @override
  String get sessionRestBetweenExercises => 'Exercise changeover';

  @override
  String get sessionRestDuration => 'Rest duration';

  @override
  String sessionNextSetAfterRest(int number) {
    return 'Next: set $number';
  }

  @override
  String get sessionStartWhenReady => 'Start when you’re ready';

  @override
  String sessionBeforeExercise(Object exercise) {
    return 'Before $exercise';
  }

  @override
  String get sessionTimerNote =>
      'The timer is only a guide and runs while this screen is active.';

  @override
  String get sessionPauseHeadline => 'Pause whenever you need';

  @override
  String get sessionPauseDescription =>
      'Your workout is paused. You can resume or end it.';

  @override
  String sessionProgressCount(Object current, Object total) {
    return '$current of $total exercises';
  }

  @override
  String get sessionAbandonHeadline => 'Leave this workout?';

  @override
  String get sessionAbandonDescription =>
      'This workout will close. Your progress won\'t be saved to your history.';

  @override
  String sessionWorkoutFinishedFor(Object session) {
    return 'You finished your $session workout.';
  }

  @override
  String sessionExercisesCompleted(Object count) {
    return '$count exercises completed';
  }

  @override
  String get sessionSummaryHeadline => 'Your workout summary';

  @override
  String get sessionSummaryDescription => 'A summary of today\'s activity.';

  @override
  String get sessionCompleteWorkout => 'Complete workout';

  @override
  String get sessionCompleteExercise => 'Complete exercise';

  @override
  String get sessionWarmupButton => 'View warm-up';

  @override
  String get sessionStartButton => 'Start workout';

  @override
  String get sessionSkipWarmupButton => 'Skip warm-up';

  @override
  String get sessionSkipRestButton => 'Skip rest';

  @override
  String get sessionAbandonButton => 'Leave workout';

  @override
  String get sessionConfirmAbandonButton => 'Yes, leave';

  @override
  String get sessionContinueButton => 'Keep training';

  @override
  String get sessionSummaryButton => 'View workout summary';

  @override
  String get sessionCooldownOfferDescription =>
      'You can finish with gentle movements for the areas you worked. This is optional and you can skip it at any time.';

  @override
  String get sessionCooldownStart => 'View cool-down';

  @override
  String get sessionCooldownNext => 'Next movement';

  @override
  String get sessionCooldownSkip => 'Skip cool-down and view summary';

  @override
  String get sessionCooldownHeadline => 'Ease out at your own pace';

  @override
  String get sessionCooldownDescription =>
      'Move slowly and stay within a pain-free range. You can skip any step.';

  @override
  String get sessionCooldownHipsTitle => 'Hip flexor stretch';

  @override
  String get sessionCooldownHipsInstructions =>
      'Kneel on one knee with your other foot forward. Gently move your hips forward without arching your back. Switch sides.';

  @override
  String get sessionCooldownBackTitle => 'Cat-cow';

  @override
  String get sessionCooldownBackInstructions =>
      'Start on your hands and knees. Gently round your back, then return to a comfortable position without straining your neck.';

  @override
  String get sessionCooldownChestTitle => 'Chest opener';

  @override
  String get sessionCooldownChestInstructions =>
      'Place your forearm on a sturdy doorframe and gently turn your torso away. Switch sides.';

  @override
  String get sessionCooldownShouldersTitle => 'Cross-body shoulder stretch';

  @override
  String get sessionCooldownShouldersInstructions =>
      'Bring one arm across your chest and gently draw it closer with your other hand. Keep your shoulder relaxed and switch sides.';

  @override
  String get sessionCooldownCoreTitle => 'Gentle torso rotation';

  @override
  String get sessionCooldownCoreInstructions =>
      'Standing tall, gently turn your torso from side to side without bouncing and stay within a comfortable range.';

  @override
  String get sessionCooldownArmsTitle => 'Triceps stretch';

  @override
  String get sessionCooldownArmsInstructions =>
      'Raise one arm, bend your elbow, and gently assist with your other hand. Do not pull on your neck; switch sides.';

  @override
  String get sessionCooldownTwentySecondsEachSide => '20 sec per side';

  @override
  String get sessionCooldownSixReps => '6 gentle repetitions';

  @override
  String get sessionRecordNote =>
      'This workout will be saved to your activity when you finish.';

  @override
  String sessionSetsTarget(Object sets, Object target) {
    return '$sets sets · $target';
  }

  @override
  String get sessionSetUnit => 'sets';

  @override
  String get sessionRepTargetLow => '6–8 reps';

  @override
  String get sessionRepTargetMid => '8–12 reps';

  @override
  String get sessionRepTargetComfortable => '8–12 reps at a comfortable pace';

  @override
  String get sessionTimeTarget => '20–40 seconds';

  @override
  String get sessionWarmupFallback => 'your workout';

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
  String get navigationHome => 'Home';

  @override
  String get shellPlanSaveError => 'We couldn\'t save your plan.';

  @override
  String get shellWorkoutSaved => 'Workout saved to your activity.';

  @override
  String get shellWorkoutSaveError => 'We couldn\'t save this workout.';

  @override
  String get trainingNameDumbbellPress => 'Dumbbell press';

  @override
  String get trainingNameGobletSquat => 'Goblet squat';

  @override
  String get trainingNameDumbbellRow => 'Dumbbell row';

  @override
  String get trainingNameRomanianDeadlift => 'Romanian deadlift';

  @override
  String get trainingNameShoulderPress => 'Shoulder press';

  @override
  String get trainingNameBarbellSquat => 'Barbell squat';

  @override
  String get trainingNameBarbellBench => 'Barbell bench press';

  @override
  String get trainingNameBarbellRow => 'Barbell row';

  @override
  String get trainingNameBarbellDeadlift => 'Barbell deadlift';

  @override
  String get trainingNameBandChestPress => 'Band chest press';

  @override
  String get trainingNameBandRow => 'Band row';

  @override
  String get trainingNameBandSquat => 'Banded squat';

  @override
  String get trainingNameBandPullApart => 'Band pull-apart';

  @override
  String get trainingNameMachineChestPress => 'Machine chest press';

  @override
  String get trainingNameLegPress => 'Leg press';

  @override
  String get trainingNameLatPulldown => 'Lat pulldown';

  @override
  String get trainingNameSeatedRow => 'Seated row';

  @override
  String get trainingNamePushUp => 'Push-up';

  @override
  String get trainingNameInclinePushUp => 'Incline push-up';

  @override
  String get trainingNamePikePushUp => 'Pike push-up';

  @override
  String get trainingNameLunges => 'Lunges';

  @override
  String get trainingNameBodyweightSquat => 'Bodyweight squat';

  @override
  String get trainingNameCalfRaise => 'Calf raise';

  @override
  String get trainingNameGluteBridge => 'Glute bridge';

  @override
  String get trainingNameBirdDog => 'Bird-dog';

  @override
  String get trainingNameDeadBug => 'Dead bug';

  @override
  String get trainingNamePlank => 'Plank';

  @override
  String get activityFocusUpper => 'Chest, back, and shoulders';

  @override
  String get activityFocusLower => 'Legs and core';

  @override
  String get activityFocusFull => 'Full-body workout';

  @override
  String get profileDefaultName => 'FORZA athlete';

  @override
  String get progressTotalStrength => 'Total-body strength';

  @override
  String get progressLegsCore => 'Legs and core';

  @override
  String get progressUpperBody => 'Upper body';

  @override
  String get sessionStartTimedSet => 'Start 30 second set';

  @override
  String get sessionTimedSetRunning => 'Pause timed set';

  @override
  String get trainingNameBandReverseFly => 'Band reverse fly';

  @override
  String get trainingNamePikeToCobra => 'Pike-to-cobra push-up';

  @override
  String get trainingNameJumpSquat => 'Jump squat';

  @override
  String get trainingNameSidePlank => 'Incline side plank';

  @override
  String get nutritionHubTitle => 'Nutrition';

  @override
  String get nutritionOpen => 'Open';

  @override
  String get homeNutritionSummary =>
      'Review this week’s menu and shopping list.';

  @override
  String get nutritionMyPlanTitle => 'My nutrition plan';

  @override
  String get nutritionMyPlanSubtitle => 'Weekly menu and shopping list';

  @override
  String get nutritionWeekSummary => 'Suggested weekly plan';

  @override
  String get nutritionEstimatesNote =>
      'Amounts are recipe estimates, not a nutrition prescription.';

  @override
  String get nutritionGeneralCatalogNote =>
      'Showing general options; local availability is not confirmed.';

  @override
  String get nutritionTabToday => 'Today';

  @override
  String get nutritionTabWeek => 'Week';

  @override
  String get nutritionTabRecipes => 'Recipes';

  @override
  String get nutritionTabShopping => 'Shopping';

  @override
  String get nutritionWelcomeTitle => 'Plan meals around your preferences';

  @override
  String get nutritionWelcomeDescription =>
      'Set your preferences to see a simple weekly menu. Nutrition is optional.';

  @override
  String get nutritionConfigureProfile => 'Set preferences';

  @override
  String get nutritionEditPreferences => 'Edit preferences';

  @override
  String get nutritionNoSafeRecipes =>
      'We can’t build a menu that meets your restrictions with the available data.';

  @override
  String get nutritionAllergenUnknownNote =>
      'The catalog does not yet have verified allergen information for every recipe. We will not remove your filters to fill the menu.';

  @override
  String get nutritionNoMealsToday => 'There are no meals to show today.';

  @override
  String get nutritionTrainingDay => 'Training day';

  @override
  String get nutritionRestDay => 'Rest day';

  @override
  String get nutritionShoppingEmpty => 'Your shopping list is empty.';

  @override
  String get nutritionLoadError =>
      'We couldn’t load the meal catalog. Check local storage and try again.';

  @override
  String nutritionRecipeEstimate(int kcal) {
    return 'Estimated $kcal kcal per recipe';
  }

  @override
  String get nutritionMyPlanAction => 'View nutrition plan';

  @override
  String get nutritionBackToPlan => 'Back to plan';

  @override
  String get nutritionLogAddFood => 'Log another food';

  @override
  String get nutritionLoggedItems => 'Foods logged today';

  @override
  String get nutritionLogMarkConsumed => 'Mark as eaten';

  @override
  String get nutritionLogUndo => 'Undo log';

  @override
  String get nutritionLogAdjust => 'Adjust serving';

  @override
  String get nutritionLogDelete => 'Delete log';

  @override
  String get nutritionLoggedFromPlan => 'From plan';

  @override
  String get nutritionLoggedManually => 'Manual entry';

  @override
  String get nutritionFoodSearchLabel => 'Search foods';

  @override
  String get nutritionFoodSearchEmpty => 'No foods match your search.';

  @override
  String get nutritionLogGrams => 'Amount in grams';

  @override
  String get nutritionLogPortions => 'Servings';

  @override
  String get nutritionLogInvalidGrams =>
      'Enter an amount greater than zero grams.';

  @override
  String get nutritionLogInvalidPortions =>
      'Enter a serving amount greater than zero.';

  @override
  String get nutritionLogSaveError => 'We couldn’t save this entry. Try again.';

  @override
  String get nutritionHistoryEmpty =>
      'You haven’t logged meals yet. You can add a meal even if it was not in your plan.';

  @override
  String get nutritionTabHistory => 'History';

  @override
  String get healthConnectionsSection => 'Connections';

  @override
  String get healthConnectionsTitle => 'Health connections';

  @override
  String get healthConnectionsSubtitle =>
      'Import activity and wellbeing from your device';

  @override
  String get healthConnectionsDescription =>
      'Choose which health data to import into FORZA. Connecting is optional and you can keep using the app without it.';

  @override
  String get healthLocalOnlyTitle => 'Your data stays on this device';

  @override
  String get healthLocalOnlyDescription =>
      'Imported data is stored locally. FORZA does not send it to Firestore or other services.';

  @override
  String get healthStatusUnavailable => 'Couldn’t check availability';

  @override
  String get healthTryAgain => 'Check your connection and try again.';

  @override
  String get healthDeviceUnsupported =>
      'Health connections aren’t available on this device';

  @override
  String get healthDeviceUnsupportedDescription =>
      'You can keep using FORZA without connecting a health platform.';

  @override
  String get healthIosPendingTitle => 'Apple Health isn’t enabled yet';

  @override
  String get healthIosPendingDescription =>
      'This connection needs HealthKit setup and validation. FORZA still works without it.';

  @override
  String get healthChooseData => 'Choose what to import';

  @override
  String get healthSteps => 'Steps';

  @override
  String get healthWeight => 'Weight';

  @override
  String get healthSleep => 'Sleep';

  @override
  String get healthWorkouts => 'Workouts';

  @override
  String get healthStepsReason => 'To give context to your daily activity.';

  @override
  String get healthWeightReason =>
      'To view measurements recorded in your health platform.';

  @override
  String get healthSleepReason =>
      'To view sleep sessions; this won’t change your plan.';

  @override
  String get healthWorkoutReason =>
      'To view recorded sessions; workout calories and steps aren’t added to totals.';

  @override
  String get healthPermissionTitle => 'Allow data access';

  @override
  String get healthPermissionExplanation =>
      'FORZA will request read-only access to the selected categories. Your health platform lets you accept or deny each permission.';

  @override
  String get healthContinue => 'Continue';

  @override
  String get healthSelectAtLeastOne => 'Select at least one data type.';

  @override
  String get healthPermissionUnverifiable =>
      'iOS doesn’t disclose whether read access was granted.';

  @override
  String get healthPermissionGranted => 'Permission granted';

  @override
  String get healthPermissionNotGranted => 'Permission not granted';

  @override
  String get healthIosPermissionCaveat =>
      'Apple Health doesn’t reveal when read access is denied. If no data appears, check FORZA’s permissions in the Health app.';

  @override
  String get healthImporting => 'Importing…';

  @override
  String get healthImportNow => 'Import now';

  @override
  String get healthConnect => 'Connect and allow read access';

  @override
  String get healthImportComplete => 'Import complete.';

  @override
  String get healthImportFailed =>
      'Couldn’t import. Check your permissions and try again.';

  @override
  String get healthLastImport => 'Last import:';

  @override
  String get healthImportedRecordCount => 'Imported records:';

  @override
  String get healthRecentData => 'Recent data and source';

  @override
  String get healthDisconnectTitle => 'Disconnect health data';

  @override
  String get healthDisconnectExplanation =>
      'Data imported by FORZA on this device will be deleted. Android revokes Health Connect permissions and applies the change after FORZA restarts. Apple Health permissions are managed in the Health app.';

  @override
  String get healthDisconnect => 'Disconnect and delete data';

  @override
  String get commonUndo => 'Undo';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonDelete => 'Delete';

  @override
  String get hydrationTitle => 'Water and drinks';

  @override
  String get hydrationGlass => 'Glass';

  @override
  String get hydrationBottle => 'Bottle';

  @override
  String get hydrationManual => 'Custom amount';

  @override
  String get hydrationAmount => 'Amount';

  @override
  String get hydrationDrinkType => 'Drink';

  @override
  String get hydrationWater => 'Water';

  @override
  String get hydrationOtherBeverage => 'Other beverage';

  @override
  String hydrationTodayTotal(String amount) {
    return 'Logged today: $amount';
  }

  @override
  String hydrationProgress(String amount, String goal) {
    return 'Recorded $amount of personal goal $goal';
  }

  @override
  String hydrationAdded(String amount) {
    return 'Added $amount';
  }

  @override
  String get hydrationDeleted => 'Water record deleted';

  @override
  String get hydrationHistory => 'Water history';

  @override
  String get hydrationEmpty => 'No drinks recorded for this day.';

  @override
  String get hydrationEdit => 'Edit water record';

  @override
  String get hydrationPreferences => 'Water preferences';

  @override
  String get hydrationGoalOptional => 'Personal daily goal (optional)';

  @override
  String get hydrationShowIndicator => 'Show progress toward my goal';

  @override
  String get hydrationInvalidAmount => 'Enter an amount from 1 to 10,000 ml.';

  @override
  String get hydrationSaveError => 'Couldn’t save the water record. Try again.';

  @override
  String get hydrationLoadError => 'Couldn’t load water records. Retry.';
}
