import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @settingsLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get settingsLanguageTitle;

  /// No description provided for @settingsLanguageDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose the language used throughout FORZA.'**
  String get settingsLanguageDescription;

  /// No description provided for @settingsLanguageAutomatic.
  ///
  /// In en, this message translates to:
  /// **'Device language'**
  String get settingsLanguageAutomatic;

  /// No description provided for @settingsLanguageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLanguageEnglish;

  /// No description provided for @settingsLanguageSpanish.
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get settingsLanguageSpanish;

  /// No description provided for @settingsLanguageSystemDescription.
  ///
  /// In en, this message translates to:
  /// **'Follow the language set on your device.'**
  String get settingsLanguageSystemDescription;

  /// No description provided for @settingsLanguageSelection.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguageSelection;

  /// No description provided for @settingsLanguageAutomaticDescription.
  ///
  /// In en, this message translates to:
  /// **'Use the language set on your device.'**
  String get settingsLanguageAutomaticDescription;

  /// No description provided for @settingsAppearanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearanceTitle;

  /// No description provided for @settingsThemeTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your theme'**
  String get settingsThemeTitle;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'Use device setting'**
  String get settingsThemeSystem;

  /// No description provided for @settingsThemeSystemDescription.
  ///
  /// In en, this message translates to:
  /// **'Follow your system theme.'**
  String get settingsThemeSystemDescription;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @homeWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {name}'**
  String homeWelcome(Object name);

  /// No description provided for @homeStreakCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current streak'**
  String get homeStreakCurrent;

  /// No description provided for @homeStreakDay.
  ///
  /// In en, this message translates to:
  /// **'day'**
  String get homeStreakDay;

  /// No description provided for @homeStreakDays.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get homeStreakDays;

  /// No description provided for @homeStreakCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{0 days} =1{1 day} other{{count} days}}'**
  String homeStreakCount(num count);

  /// No description provided for @homeStreakSemantics.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Current streak: 0 days} =1{Current streak: 1 day} other{Current streak: {count} days}}'**
  String homeStreakSemantics(num count);

  /// Number of completed workouts
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No workouts} =1{1 workout} other{{count} workouts}}'**
  String workoutCount(int count);

  /// No description provided for @exerciseEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Exercises'**
  String get exerciseEyebrow;

  /// No description provided for @exerciseLibraryTitle.
  ///
  /// In en, this message translates to:
  /// **'Exercise library'**
  String get exerciseLibraryTitle;

  /// No description provided for @exerciseLibrarySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Find movements for your next session.'**
  String get exerciseLibrarySubtitle;

  /// No description provided for @exerciseSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Exercise, muscle, or equipment'**
  String get exerciseSearchHint;

  /// No description provided for @exerciseClearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get exerciseClearSearch;

  /// No description provided for @exerciseOpenFilters.
  ///
  /// In en, this message translates to:
  /// **'Open filters'**
  String get exerciseOpenFilters;

  /// Active filter count
  ///
  /// In en, this message translates to:
  /// **'Active filters: {count}'**
  String exerciseActiveFilters(int count);

  /// No description provided for @exerciseSearchResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'Search results'**
  String get exerciseSearchResultsTitle;

  /// No description provided for @exerciseAllResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'All exercises'**
  String get exerciseAllResultsTitle;

  /// Number of exercises found
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No exercises found} =1{1 exercise found} other{{count} exercises found}}'**
  String exerciseFoundCount(int count);

  /// No description provided for @exerciseLoadError.
  ///
  /// In en, this message translates to:
  /// **'We couldn’t load the exercises.'**
  String get exerciseLoadError;

  /// No description provided for @exerciseRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get exerciseRetry;

  /// No description provided for @exerciseEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No exercises found'**
  String get exerciseEmptyTitle;

  /// No description provided for @exerciseEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Try another search or remove some filters.'**
  String get exerciseEmptySubtitle;

  /// No description provided for @exerciseClearSearchAndFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear search and filters'**
  String get exerciseClearSearchAndFilters;

  /// No description provided for @exerciseFiltersTitle.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get exerciseFiltersTitle;

  /// No description provided for @exerciseClearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get exerciseClearFilters;

  /// No description provided for @exerciseRemoveActiveFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get exerciseRemoveActiveFilters;

  /// No description provided for @exerciseAdjustSearchTitle.
  ///
  /// In en, this message translates to:
  /// **'Adjust your search'**
  String get exerciseAdjustSearchTitle;

  /// No description provided for @exerciseFiltersDescription.
  ///
  /// In en, this message translates to:
  /// **'Combine muscle group and equipment to find movements.'**
  String get exerciseFiltersDescription;

  /// No description provided for @exerciseMuscleGroupFilter.
  ///
  /// In en, this message translates to:
  /// **'Muscle group'**
  String get exerciseMuscleGroupFilter;

  /// No description provided for @exerciseEquipmentFilter.
  ///
  /// In en, this message translates to:
  /// **'Equipment'**
  String get exerciseEquipmentFilter;

  /// Number of matching exercises
  ///
  /// In en, this message translates to:
  /// **'Show results · {count}'**
  String exerciseShowResults(int count);

  /// No description provided for @exerciseAlternativesTitle.
  ///
  /// In en, this message translates to:
  /// **'Alternatives'**
  String get exerciseAlternativesTitle;

  /// Name of the selected exercise
  ///
  /// In en, this message translates to:
  /// **'Alternatives to {name}'**
  String exerciseAlternativesTo(String name);

  /// No description provided for @exerciseAlternativesDescription.
  ///
  /// In en, this message translates to:
  /// **'More exercises for a similar muscle group.'**
  String get exerciseAlternativesDescription;

  /// No description provided for @exerciseAlternativesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No alternatives are available for this exercise.'**
  String get exerciseAlternativesEmpty;

  /// No description provided for @exerciseDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Exercise details'**
  String get exerciseDetailTitle;

  /// No description provided for @exerciseHowTo.
  ///
  /// In en, this message translates to:
  /// **'How to do it'**
  String get exerciseHowTo;

  /// No description provided for @exerciseInstructionStep.
  ///
  /// In en, this message translates to:
  /// **'Step'**
  String get exerciseInstructionStep;

  /// No description provided for @exerciseGuideHeading.
  ///
  /// In en, this message translates to:
  /// **'Technique cues and common mistakes'**
  String get exerciseGuideHeading;

  /// No description provided for @exerciseGuideVariantNote.
  ///
  /// In en, this message translates to:
  /// **'These cues are based on a reference variation. Compare them with the steps for this exercise.'**
  String get exerciseGuideVariantNote;

  /// Name of the cited source
  ///
  /// In en, this message translates to:
  /// **'Source: {source}'**
  String exerciseSourcePrefix(String source);

  /// URL for the cited source
  ///
  /// In en, this message translates to:
  /// **'Source link: {url}'**
  String exerciseSourceLink(String url);

  /// No description provided for @exerciseSourceOpenFailure.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open the source.'**
  String get exerciseSourceOpenFailure;

  /// No description provided for @exerciseViewAlternatives.
  ///
  /// In en, this message translates to:
  /// **'View alternatives'**
  String get exerciseViewAlternatives;

  /// No description provided for @exerciseAnimationUnavailable.
  ///
  /// In en, this message translates to:
  /// **'No animation available · follow the steps'**
  String get exerciseAnimationUnavailable;

  /// No description provided for @exerciseAnimationIllustrative.
  ///
  /// In en, this message translates to:
  /// **'Illustration for reference · pace is up to you'**
  String get exerciseAnimationIllustrative;

  /// Accessible label for the exercise animation
  ///
  /// In en, this message translates to:
  /// **'Exercise animation: {name}'**
  String exerciseAnimationLabel(String name);

  /// No description provided for @exerciseFlipHint.
  ///
  /// In en, this message translates to:
  /// **'Tap or swipe'**
  String get exerciseFlipHint;

  /// No description provided for @exerciseFlipSemanticsFront.
  ///
  /// In en, this message translates to:
  /// **'Tap or swipe to see what this exercise does and which muscles it works'**
  String get exerciseFlipSemanticsFront;

  /// No description provided for @exerciseFlipSemanticsBack.
  ///
  /// In en, this message translates to:
  /// **'Tap or swipe to return to the animation'**
  String get exerciseFlipSemanticsBack;

  /// No description provided for @exerciseInfoHeading.
  ///
  /// In en, this message translates to:
  /// **'What it does'**
  String get exerciseInfoHeading;

  /// No description provided for @exerciseInfoPrimaryMuscle.
  ///
  /// In en, this message translates to:
  /// **'Main target'**
  String get exerciseInfoPrimaryMuscle;

  /// No description provided for @exerciseInfoCatalogGroup.
  ///
  /// In en, this message translates to:
  /// **'Catalog group'**
  String get exerciseInfoCatalogGroup;

  /// No description provided for @exerciseInfoBenefitUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Follow the exercise steps to understand its focus.'**
  String get exerciseInfoBenefitUnavailable;

  /// No description provided for @exerciseInfoSupportingMuscles.
  ///
  /// In en, this message translates to:
  /// **'Also works'**
  String get exerciseInfoSupportingMuscles;

  /// No description provided for @exerciseInfoBenefitStrength.
  ///
  /// In en, this message translates to:
  /// **'Builds strength in {muscle} and improves control of this movement.'**
  String exerciseInfoBenefitStrength(Object muscle);

  /// No description provided for @exerciseInfoBenefitMobility.
  ///
  /// In en, this message translates to:
  /// **'Improves {muscle} mobility with a controlled stretch.'**
  String exerciseInfoBenefitMobility(Object muscle);

  /// No description provided for @exerciseInfoBenefitCardio.
  ///
  /// In en, this message translates to:
  /// **'Builds cardiovascular endurance and overall conditioning.'**
  String get exerciseInfoBenefitCardio;

  /// No description provided for @exerciseInfoNoSupportingMuscles.
  ///
  /// In en, this message translates to:
  /// **'The catalog does not list supporting muscles.'**
  String get exerciseInfoNoSupportingMuscles;

  /// No description provided for @exerciseInfoMoreMuscles.
  ///
  /// In en, this message translates to:
  /// **'and {count} more'**
  String exerciseInfoMoreMuscles(int count);

  /// No description provided for @exerciseAnimationPlay.
  ///
  /// In en, this message translates to:
  /// **'Play animation'**
  String get exerciseAnimationPlay;

  /// No description provided for @exerciseAnimationPause.
  ///
  /// In en, this message translates to:
  /// **'Pause animation'**
  String get exerciseAnimationPause;

  /// Accessible exercise card description
  ///
  /// In en, this message translates to:
  /// **'{name}, {group}, equipment: {equipment}'**
  String exerciseCardSemantics(String name, String group, String equipment);

  /// No description provided for @exerciseGroupArms.
  ///
  /// In en, this message translates to:
  /// **'Arms'**
  String get exerciseGroupArms;

  /// No description provided for @exerciseGroupCardio.
  ///
  /// In en, this message translates to:
  /// **'Cardio'**
  String get exerciseGroupCardio;

  /// No description provided for @exerciseGroupCore.
  ///
  /// In en, this message translates to:
  /// **'Core'**
  String get exerciseGroupCore;

  /// No description provided for @exerciseGroupNeck.
  ///
  /// In en, this message translates to:
  /// **'Neck'**
  String get exerciseGroupNeck;

  /// No description provided for @exerciseGroupBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get exerciseGroupBack;

  /// No description provided for @exerciseGroupShoulders.
  ///
  /// In en, this message translates to:
  /// **'Shoulders'**
  String get exerciseGroupShoulders;

  /// No description provided for @exerciseGroupChest.
  ///
  /// In en, this message translates to:
  /// **'Chest'**
  String get exerciseGroupChest;

  /// No description provided for @exerciseGroupLegs.
  ///
  /// In en, this message translates to:
  /// **'Legs'**
  String get exerciseGroupLegs;

  /// No description provided for @exerciseEquipmentAssisted.
  ///
  /// In en, this message translates to:
  /// **'Assisted'**
  String get exerciseEquipmentAssisted;

  /// No description provided for @exerciseEquipmentBosu.
  ///
  /// In en, this message translates to:
  /// **'BOSU ball'**
  String get exerciseEquipmentBosu;

  /// No description provided for @exerciseEquipmentStabilityBall.
  ///
  /// In en, this message translates to:
  /// **'Stability ball'**
  String get exerciseEquipmentStabilityBall;

  /// No description provided for @exerciseEquipmentMedicineBall.
  ///
  /// In en, this message translates to:
  /// **'Medicine ball'**
  String get exerciseEquipmentMedicineBall;

  /// No description provided for @exerciseEquipmentResistanceBand.
  ///
  /// In en, this message translates to:
  /// **'Resistance band'**
  String get exerciseEquipmentResistanceBand;

  /// No description provided for @exerciseEquipmentBarbell.
  ///
  /// In en, this message translates to:
  /// **'Barbell'**
  String get exerciseEquipmentBarbell;

  /// No description provided for @exerciseEquipmentEzBar.
  ///
  /// In en, this message translates to:
  /// **'EZ bar'**
  String get exerciseEquipmentEzBar;

  /// No description provided for @exerciseEquipmentTrapBar.
  ///
  /// In en, this message translates to:
  /// **'Trap bar'**
  String get exerciseEquipmentTrapBar;

  /// No description provided for @exerciseEquipmentOlympicBar.
  ///
  /// In en, this message translates to:
  /// **'Olympic barbell'**
  String get exerciseEquipmentOlympicBar;

  /// No description provided for @exerciseEquipmentStationaryBike.
  ///
  /// In en, this message translates to:
  /// **'Stationary bike'**
  String get exerciseEquipmentStationaryBike;

  /// No description provided for @exerciseEquipmentAddedWeight.
  ///
  /// In en, this message translates to:
  /// **'Added weight'**
  String get exerciseEquipmentAddedWeight;

  /// No description provided for @exerciseEquipmentRope.
  ///
  /// In en, this message translates to:
  /// **'Rope'**
  String get exerciseEquipmentRope;

  /// No description provided for @exerciseEquipmentElliptical.
  ///
  /// In en, this message translates to:
  /// **'Elliptical trainer'**
  String get exerciseEquipmentElliptical;

  /// No description provided for @exerciseEquipmentUpperBodyErgometer.
  ///
  /// In en, this message translates to:
  /// **'Upper-body ergometer'**
  String get exerciseEquipmentUpperBodyErgometer;

  /// No description provided for @exerciseEquipmentStairClimber.
  ///
  /// In en, this message translates to:
  /// **'Stair climber'**
  String get exerciseEquipmentStairClimber;

  /// No description provided for @exerciseEquipmentDumbbells.
  ///
  /// In en, this message translates to:
  /// **'Dumbbells'**
  String get exerciseEquipmentDumbbells;

  /// No description provided for @exerciseEquipmentHammer.
  ///
  /// In en, this message translates to:
  /// **'Hammer'**
  String get exerciseEquipmentHammer;

  /// No description provided for @exerciseEquipmentSkiErg.
  ///
  /// In en, this message translates to:
  /// **'SkiErg machine'**
  String get exerciseEquipmentSkiErg;

  /// No description provided for @exerciseEquipmentSmithMachine.
  ///
  /// In en, this message translates to:
  /// **'Smith machine'**
  String get exerciseEquipmentSmithMachine;

  /// No description provided for @exerciseEquipmentLeverageMachine.
  ///
  /// In en, this message translates to:
  /// **'Leverage machine'**
  String get exerciseEquipmentLeverageMachine;

  /// No description provided for @exerciseEquipmentTire.
  ///
  /// In en, this message translates to:
  /// **'Tire'**
  String get exerciseEquipmentTire;

  /// No description provided for @exerciseEquipmentKettlebell.
  ///
  /// In en, this message translates to:
  /// **'Kettlebell'**
  String get exerciseEquipmentKettlebell;

  /// No description provided for @exerciseEquipmentBodyweight.
  ///
  /// In en, this message translates to:
  /// **'Bodyweight'**
  String get exerciseEquipmentBodyweight;

  /// No description provided for @exerciseEquipmentCable.
  ///
  /// In en, this message translates to:
  /// **'Cable machine'**
  String get exerciseEquipmentCable;

  /// No description provided for @exerciseEquipmentRoller.
  ///
  /// In en, this message translates to:
  /// **'Foam roller'**
  String get exerciseEquipmentRoller;

  /// No description provided for @exerciseEquipmentAbWheel.
  ///
  /// In en, this message translates to:
  /// **'Ab wheel'**
  String get exerciseEquipmentAbWheel;

  /// No description provided for @exerciseEquipmentSled.
  ///
  /// In en, this message translates to:
  /// **'Sled'**
  String get exerciseEquipmentSled;

  /// No description provided for @exerciseGuideDeadliftMistakes.
  ///
  /// In en, this message translates to:
  /// **'Rounding your back as you lower toward the floor.\nLetting the load drift away from your body on the way up.\nLeaning backward at the finish instead of standing tall with control.'**
  String get exerciseGuideDeadliftMistakes;

  /// No description provided for @exerciseGuideDeadliftSource.
  ///
  /// In en, this message translates to:
  /// **'ACE · Deadlift'**
  String get exerciseGuideDeadliftSource;

  /// No description provided for @exerciseGuideSquatMistakes.
  ///
  /// In en, this message translates to:
  /// **'Letting the knees collapse inward instead of following the direction of the feet.\nLifting the heels or losing foot support as you lower.\nForcing extra depth after you lose control or a comfortable position.'**
  String get exerciseGuideSquatMistakes;

  /// No description provided for @exerciseGuideSquatSource.
  ///
  /// In en, this message translates to:
  /// **'ACE · Bodyweight squat'**
  String get exerciseGuideSquatSource;

  /// No description provided for @exerciseGuideLungeMistakes.
  ///
  /// In en, this message translates to:
  /// **'Leaning or swaying your torso sideways during the step.\nLosing support through the front foot or letting the knee drift out of line.\nBouncing at the bottom instead of lowering and rising with control.'**
  String get exerciseGuideLungeMistakes;

  /// No description provided for @exerciseGuideLungeSource.
  ///
  /// In en, this message translates to:
  /// **'ACE · Forward lunge'**
  String get exerciseGuideLungeSource;

  /// No description provided for @exerciseGuidePushUpMistakes.
  ///
  /// In en, this message translates to:
  /// **'Letting your lower back sag or hips rise as you lower and press.\nLeading with your head instead of keeping it aligned with your torso.\nRushing repetitions until you lose your body position.'**
  String get exerciseGuidePushUpMistakes;

  /// No description provided for @exerciseGuidePushUpSource.
  ///
  /// In en, this message translates to:
  /// **'ACE · Push-up'**
  String get exerciseGuidePushUpSource;

  /// No description provided for @exerciseGuideChestPressMistakes.
  ///
  /// In en, this message translates to:
  /// **'Bouncing the load against your chest at the change of direction.\nArching your lower back or losing your points of contact to finish a repetition.\nBending your wrists back instead of keeping them aligned with your forearms.'**
  String get exerciseGuideChestPressMistakes;

  /// No description provided for @exerciseGuideChestPressSource.
  ///
  /// In en, this message translates to:
  /// **'ACE · Chest press'**
  String get exerciseGuideChestPressSource;

  /// No description provided for @exerciseGuideRowMistakes.
  ///
  /// In en, this message translates to:
  /// **'Swinging your torso to start each pull.\nRounding your back instead of keeping the position described for your variation.\nDropping the load quickly on the return.'**
  String get exerciseGuideRowMistakes;

  /// No description provided for @exerciseGuideRowSource.
  ///
  /// In en, this message translates to:
  /// **'ACE · Bent-over row'**
  String get exerciseGuideRowSource;

  /// No description provided for @exerciseGuidePullUpMistakes.
  ///
  /// In en, this message translates to:
  /// **'Using a kip or swing instead of pulling with control.\nShrugging your shoulders or losing torso alignment on the way up.\nDropping quickly instead of controlling the return to the start.'**
  String get exerciseGuidePullUpMistakes;

  /// No description provided for @exerciseGuidePullUpSource.
  ///
  /// In en, this message translates to:
  /// **'ACE · Chin-up'**
  String get exerciseGuidePullUpSource;

  /// No description provided for @exerciseGuidePlankMistakes.
  ///
  /// In en, this message translates to:
  /// **'Letting your lower back sag or raising your hips too high.\nShrugging your shoulders or losing your support position.\nHolding your breath while maintaining the position.'**
  String get exerciseGuidePlankMistakes;

  /// No description provided for @exerciseGuidePlankSource.
  ///
  /// In en, this message translates to:
  /// **'ACE · Front plank'**
  String get exerciseGuidePlankSource;

  /// No description provided for @exerciseGuideCrunchMistakes.
  ///
  /// In en, this message translates to:
  /// **'Pulling on your neck with your hands, if your variation places them behind your head.\nUsing momentum to rise instead of curling your torso with control.\nChanging your back or hip position from what the instructions for this variation describe.'**
  String get exerciseGuideCrunchMistakes;

  /// No description provided for @exerciseGuideCrunchSource.
  ///
  /// In en, this message translates to:
  /// **'ACE · Crunch'**
  String get exerciseGuideCrunchSource;

  /// No description provided for @exerciseGuideCurlMistakes.
  ///
  /// In en, this message translates to:
  /// **'Swinging your torso to help move the load.\nMoving your elbows forward if the variation asks you to keep them by your sides.\nLetting the load drop quickly on the way down.'**
  String get exerciseGuideCurlMistakes;

  /// No description provided for @exerciseGuideCurlSource.
  ///
  /// In en, this message translates to:
  /// **'ACE · Biceps curl'**
  String get exerciseGuideCurlSource;

  /// No description provided for @exerciseGuideShoulderPressMistakes.
  ///
  /// In en, this message translates to:
  /// **'Arching your lower back to move the load overhead.\nDropping the load instead of controlling the return.\nBending your wrists instead of keeping them in line with your forearms.'**
  String get exerciseGuideShoulderPressMistakes;

  /// No description provided for @exerciseGuideShoulderPressSource.
  ///
  /// In en, this message translates to:
  /// **'ACE · Seated shoulder press'**
  String get exerciseGuideShoulderPressSource;

  /// No description provided for @exerciseGuideLateralRaiseMistakes.
  ///
  /// In en, this message translates to:
  /// **'Shrugging instead of keeping your shoulders down and back.\nSwinging your torso or arching your lower back to lift more weight.\nBending your wrists or raising your arms above shoulder level.'**
  String get exerciseGuideLateralRaiseMistakes;

  /// No description provided for @exerciseGuideLateralRaiseSource.
  ///
  /// In en, this message translates to:
  /// **'ACE · Lateral raise'**
  String get exerciseGuideLateralRaiseSource;

  /// No description provided for @exerciseGuideLegCurlMistakes.
  ///
  /// In en, this message translates to:
  /// **'Arching your back or lifting your hips to help bend the knee.\nMoving your thigh when the variation asks you to keep it supported.\nLetting the resistance return without control.'**
  String get exerciseGuideLegCurlMistakes;

  /// No description provided for @exerciseGuideLegCurlSource.
  ///
  /// In en, this message translates to:
  /// **'ACE · Lying hamstring curl'**
  String get exerciseGuideLegCurlSource;

  /// No description provided for @exerciseGuideLegExtensionMistakes.
  ///
  /// In en, this message translates to:
  /// **'Increasing the range until your hip or torso has to lean.\nUsing momentum instead of extending and returning the leg with control.\nChoosing resistance that makes it hard to stay balanced and upright.'**
  String get exerciseGuideLegExtensionMistakes;

  /// No description provided for @exerciseGuideLegExtensionSource.
  ///
  /// In en, this message translates to:
  /// **'ACE · Standing leg extension'**
  String get exerciseGuideLegExtensionSource;

  /// No description provided for @exerciseGuideCalfRaiseMistakes.
  ///
  /// In en, this message translates to:
  /// **'Bouncing instead of lifting and lowering your heels with control.\nTurning your feet during a repetition when your variation asks you to keep them facing forward.\nUsing a range that makes you lose balance or control on the return.'**
  String get exerciseGuideCalfRaiseMistakes;

  /// No description provided for @exerciseGuideCalfRaiseSource.
  ///
  /// In en, this message translates to:
  /// **'ACE · Standing calf raise'**
  String get exerciseGuideCalfRaiseSource;

  /// No description provided for @exerciseGuideStepUpMistakes.
  ///
  /// In en, this message translates to:
  /// **'Letting your foot or ankle lose support on the platform.\nLetting your knee drift inward instead of following your foot.\nStepping down without controlling your body weight.'**
  String get exerciseGuideStepUpMistakes;

  /// No description provided for @exerciseGuideStepUpSource.
  ///
  /// In en, this message translates to:
  /// **'ACE · Step-up'**
  String get exerciseGuideStepUpSource;

  /// No description provided for @exerciseGuideGluteBridgeMistakes.
  ///
  /// In en, this message translates to:
  /// **'Raising your hips so high that your lower back arches.\nPushing through your back instead of extending your hips with control.\nDropping your hips quickly on the way down.'**
  String get exerciseGuideGluteBridgeMistakes;

  /// No description provided for @exerciseGuideGluteBridgeSource.
  ///
  /// In en, this message translates to:
  /// **'ACE · Glute bridge'**
  String get exerciseGuideGluteBridgeSource;

  /// No description provided for @exerciseGuideRomanianDeadliftMistakes.
  ///
  /// In en, this message translates to:
  /// **'Rounding your back instead of moving your hips backward.\nBending your knees so much that the movement becomes a squat.\nTurning your neck to look in a mirror during a repetition.'**
  String get exerciseGuideRomanianDeadliftMistakes;

  /// No description provided for @exerciseGuideRomanianDeadliftSource.
  ///
  /// In en, this message translates to:
  /// **'ACE · Romanian deadlift technique'**
  String get exerciseGuideRomanianDeadliftSource;

  /// No description provided for @homeGreetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get homeGreetingMorning;

  /// No description provided for @homeGreetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get homeGreetingAfternoon;

  /// No description provided for @homeGreetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get homeGreetingEvening;

  /// No description provided for @homeProfileTooltip.
  ///
  /// In en, this message translates to:
  /// **'Open profile'**
  String get homeProfileTooltip;

  /// No description provided for @homePlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Your training plan'**
  String get homePlanTitle;

  /// No description provided for @homeTodayWorkout.
  ///
  /// In en, this message translates to:
  /// **'Today\'s workout'**
  String get homeTodayWorkout;

  /// No description provided for @homeNextSession.
  ///
  /// In en, this message translates to:
  /// **'Next session · {weekday}'**
  String homeNextSession(Object weekday);

  /// No description provided for @homeAdjustPlan.
  ///
  /// In en, this message translates to:
  /// **'Adjust plan'**
  String get homeAdjustPlan;

  /// No description provided for @homeWeekTitle.
  ///
  /// In en, this message translates to:
  /// **'Your week'**
  String get homeWeekTitle;

  /// No description provided for @homeViewActivity.
  ///
  /// In en, this message translates to:
  /// **'View activity'**
  String get homeViewActivity;

  /// No description provided for @homeTodaySession.
  ///
  /// In en, this message translates to:
  /// **'TODAY\'S SESSION'**
  String get homeTodaySession;

  /// No description provided for @homeNextSessionLabel.
  ///
  /// In en, this message translates to:
  /// **'NEXT SESSION · {weekday}'**
  String homeNextSessionLabel(Object weekday);

  /// No description provided for @homeDurationExercises.
  ///
  /// In en, this message translates to:
  /// **'Approx. {minutes}-min budget per session · {count} exercises'**
  String homeDurationExercises(Object count, Object minutes);

  /// No description provided for @homeContinueWorkout.
  ///
  /// In en, this message translates to:
  /// **'Continue workout'**
  String get homeContinueWorkout;

  /// No description provided for @homeViewTodaySession.
  ///
  /// In en, this message translates to:
  /// **'View today\'s session'**
  String get homeViewTodaySession;

  /// No description provided for @homeSessionAvailableOn.
  ///
  /// In en, this message translates to:
  /// **'Available on {weekday}'**
  String homeSessionAvailableOn(String weekday);

  /// No description provided for @homeSessionCompleted.
  ///
  /// In en, this message translates to:
  /// **'Workout completed'**
  String get homeSessionCompleted;

  /// No description provided for @homeSessionCompletedDescription.
  ///
  /// In en, this message translates to:
  /// **'Great work. You completed today\'s workout.'**
  String get homeSessionCompletedDescription;

  /// No description provided for @homeSessionSkipped.
  ///
  /// In en, this message translates to:
  /// **'Workout skipped'**
  String get homeSessionSkipped;

  /// No description provided for @homeSessionSkippedDescription.
  ///
  /// In en, this message translates to:
  /// **'Today\'s workout was skipped. You can review your plan.'**
  String get homeSessionSkippedDescription;

  /// No description provided for @homeRecoveryDay.
  ///
  /// In en, this message translates to:
  /// **'Recovery day'**
  String get homeRecoveryDay;

  /// No description provided for @homeRecoveryDescription.
  ///
  /// In en, this message translates to:
  /// **'You have no workout scheduled today. Rest and recover.'**
  String get homeRecoveryDescription;

  /// No description provided for @homeWeeklySessionCount.
  ///
  /// In en, this message translates to:
  /// **'{done} of {target} sessions'**
  String homeWeeklySessionCount(Object done, Object target);

  /// No description provided for @homeThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get homeThisWeek;

  /// No description provided for @homeWeeklyGoal.
  ///
  /// In en, this message translates to:
  /// **'Your goal is {count, plural, =1{1 session per week.} other{{count} sessions per week.}}'**
  String homeWeeklyGoal(num count);

  /// No description provided for @homeStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'completed'**
  String get homeStatusCompleted;

  /// No description provided for @homeStatusSkipped.
  ///
  /// In en, this message translates to:
  /// **'skipped'**
  String get homeStatusSkipped;

  /// No description provided for @homeStatusPending.
  ///
  /// In en, this message translates to:
  /// **'pending'**
  String get homeStatusPending;

  /// No description provided for @homeStatusRest.
  ///
  /// In en, this message translates to:
  /// **'rest'**
  String get homeStatusRest;

  /// No description provided for @homeStatusRescheduled.
  ///
  /// In en, this message translates to:
  /// **'rescheduled'**
  String get homeStatusRescheduled;

  /// No description provided for @homeRescheduledExplanation.
  ///
  /// In en, this message translates to:
  /// **'Rescheduled workouts may appear on another day or outside this week.'**
  String get homeRescheduledExplanation;

  /// No description provided for @activityTitle.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get activityTitle;

  /// No description provided for @activitySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your training calendar.'**
  String get activitySubtitle;

  /// No description provided for @activityTodayDetail.
  ///
  /// In en, this message translates to:
  /// **'Day details'**
  String get activityTodayDetail;

  /// No description provided for @activityToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get activityToday;

  /// No description provided for @activityRescheduleConflict.
  ///
  /// In en, this message translates to:
  /// **'There is already a workout on that day.'**
  String get activityRescheduleConflict;

  /// No description provided for @activityRescheduled.
  ///
  /// In en, this message translates to:
  /// **'Workout moved to {date}.'**
  String activityRescheduled(Object date);

  /// No description provided for @activityPreviousMonth.
  ///
  /// In en, this message translates to:
  /// **'Previous month'**
  String get activityPreviousMonth;

  /// No description provided for @activityNextMonth.
  ///
  /// In en, this message translates to:
  /// **'Next month'**
  String get activityNextMonth;

  /// No description provided for @activityRecoveryDay.
  ///
  /// In en, this message translates to:
  /// **'Recovery day'**
  String get activityRecoveryDay;

  /// No description provided for @activityNoSession.
  ///
  /// In en, this message translates to:
  /// **'No workout is scheduled for this day.'**
  String get activityNoSession;

  /// No description provided for @activityExerciseCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 exercise} other{{count} exercises}}'**
  String activityExerciseCount(num count);

  /// No description provided for @activitySessionCompleted.
  ///
  /// In en, this message translates to:
  /// **'Workout completed'**
  String get activitySessionCompleted;

  /// No description provided for @activityWorkoutInProgress.
  ///
  /// In en, this message translates to:
  /// **'Workout in progress'**
  String get activityWorkoutInProgress;

  /// No description provided for @activityContinueWorkout.
  ///
  /// In en, this message translates to:
  /// **'Continue workout'**
  String get activityContinueWorkout;

  /// No description provided for @activityRepeatWorkout.
  ///
  /// In en, this message translates to:
  /// **'Repeat workout'**
  String get activityRepeatWorkout;

  /// No description provided for @activityStartSession.
  ///
  /// In en, this message translates to:
  /// **'Start workout'**
  String get activityStartSession;

  /// No description provided for @activityScheduledSession.
  ///
  /// In en, this message translates to:
  /// **'Scheduled workout'**
  String get activityScheduledSession;

  /// No description provided for @activityCompletedOutside.
  ///
  /// In en, this message translates to:
  /// **'I trained outside the app'**
  String get activityCompletedOutside;

  /// No description provided for @activitySkipSession.
  ///
  /// In en, this message translates to:
  /// **'Skip workout'**
  String get activitySkipSession;

  /// No description provided for @activitySessionSkipped.
  ///
  /// In en, this message translates to:
  /// **'Workout skipped'**
  String get activitySessionSkipped;

  /// No description provided for @activityStatusRescheduled.
  ///
  /// In en, this message translates to:
  /// **'Rescheduled'**
  String get activityStatusRescheduled;

  /// No description provided for @activityStatusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get activityStatusInProgress;

  /// No description provided for @activityCalendarLegendAction.
  ///
  /// In en, this message translates to:
  /// **'View statuses'**
  String get activityCalendarLegendAction;

  /// No description provided for @activityCalendarLegendTitle.
  ///
  /// In en, this message translates to:
  /// **'Calendar statuses'**
  String get activityCalendarLegendTitle;

  /// No description provided for @activityCalendarLegendClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get activityCalendarLegendClose;

  /// No description provided for @activityPlannedRoutine.
  ///
  /// In en, this message translates to:
  /// **'Planned routine'**
  String get activityPlannedRoutine;

  /// No description provided for @activityActualRecord.
  ///
  /// In en, this message translates to:
  /// **'Workout record'**
  String get activityActualRecord;

  /// No description provided for @activityOutsideAppDataNote.
  ///
  /// In en, this message translates to:
  /// **'The workout is recorded, but no sets or repetitions were saved.'**
  String get activityOutsideAppDataNote;

  /// No description provided for @activitySetCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 set recorded} other{{count} sets recorded}}'**
  String activitySetCount(int count);

  /// No description provided for @activityMoreActions.
  ///
  /// In en, this message translates to:
  /// **'More actions'**
  String get activityMoreActions;

  /// No description provided for @activityConfirmExternalTitle.
  ///
  /// In en, this message translates to:
  /// **'Record an outside workout'**
  String get activityConfirmExternalTitle;

  /// No description provided for @activityConfirmExternalMessage.
  ///
  /// In en, this message translates to:
  /// **'It will be saved as completed without set or repetition data. Continue?'**
  String get activityConfirmExternalMessage;

  /// No description provided for @activityConfirmSkipTitle.
  ///
  /// In en, this message translates to:
  /// **'Skip workout'**
  String get activityConfirmSkipTitle;

  /// No description provided for @activityConfirmSkipMessage.
  ///
  /// In en, this message translates to:
  /// **'This workout will be marked as skipped. You can undo this later.'**
  String get activityConfirmSkipMessage;

  /// No description provided for @activityConfirmAction.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get activityConfirmAction;

  /// No description provided for @activityUndoSkip.
  ///
  /// In en, this message translates to:
  /// **'Undo skip'**
  String get activityUndoSkip;

  /// No description provided for @activitySkipUndone.
  ///
  /// In en, this message translates to:
  /// **'Workout is pending again'**
  String get activitySkipUndone;

  /// No description provided for @activityChangeDay.
  ///
  /// In en, this message translates to:
  /// **'Change day'**
  String get activityChangeDay;

  /// No description provided for @rescheduleTitle.
  ///
  /// In en, this message translates to:
  /// **'Reschedule workout'**
  String get rescheduleTitle;

  /// No description provided for @rescheduleEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get rescheduleEyebrow;

  /// No description provided for @rescheduleHeading.
  ///
  /// In en, this message translates to:
  /// **'Move your workout'**
  String get rescheduleHeading;

  /// No description provided for @rescheduleCurrentDate.
  ///
  /// In en, this message translates to:
  /// **'Current date: {date}'**
  String rescheduleCurrentDate(Object date);

  /// No description provided for @rescheduleAvailableDates.
  ///
  /// In en, this message translates to:
  /// **'Available dates'**
  String get rescheduleAvailableDates;

  /// No description provided for @rescheduleNoDates.
  ///
  /// In en, this message translates to:
  /// **'No other date is available in the next two weeks.'**
  String get rescheduleNoDates;

  /// No description provided for @rescheduleConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm new date'**
  String get rescheduleConfirm;

  /// No description provided for @reschedulePersistenceNote.
  ///
  /// In en, this message translates to:
  /// **'Changes are kept while the app is open.'**
  String get reschedulePersistenceNote;

  /// No description provided for @rescheduleAvailableDateSemantics.
  ///
  /// In en, this message translates to:
  /// **'{date}, available date'**
  String rescheduleAvailableDateSemantics(Object date);

  /// No description provided for @profileEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get profileEyebrow;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get profileEdit;

  /// No description provided for @profileEditSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Name and training goal'**
  String get profileEditSubtitle;

  /// No description provided for @profileAccountAccess.
  ///
  /// In en, this message translates to:
  /// **'Account and access'**
  String get profileAccountAccess;

  /// No description provided for @profileAccountAccessSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Optional · sync is enabled separately'**
  String get profileAccountAccessSubtitle;

  /// No description provided for @profileGoogleConnected.
  ///
  /// In en, this message translates to:
  /// **'Connected with Google'**
  String get profileGoogleConnected;

  /// No description provided for @profileNoAccount.
  ///
  /// In en, this message translates to:
  /// **'No account'**
  String get profileNoAccount;

  /// No description provided for @profileAccountChecking.
  ///
  /// In en, this message translates to:
  /// **'Checking account'**
  String get profileAccountChecking;

  /// No description provided for @profileAccountCheckingDescription.
  ///
  /// In en, this message translates to:
  /// **'Checking whether an account is connected.'**
  String get profileAccountCheckingDescription;

  /// No description provided for @profileGuestDescription.
  ///
  /// In en, this message translates to:
  /// **'No account · data saved on this device'**
  String get profileGuestDescription;

  /// No description provided for @profilePrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get profilePrivacy;

  /// No description provided for @profilePrivate.
  ///
  /// In en, this message translates to:
  /// **'Private profile'**
  String get profilePrivate;

  /// No description provided for @profileVisible.
  ///
  /// In en, this message translates to:
  /// **'Visible profile'**
  String get profileVisible;

  /// No description provided for @profileTraining.
  ///
  /// In en, this message translates to:
  /// **'Training'**
  String get profileTraining;

  /// No description provided for @nutritionProfileSection.
  ///
  /// In en, this message translates to:
  /// **'Nutrition'**
  String get nutritionProfileSection;

  /// No description provided for @nutritionProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Nutrition profile'**
  String get nutritionProfileTitle;

  /// No description provided for @nutritionProfileNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'Optional · personalize nutrition'**
  String get nutritionProfileNotConfigured;

  /// No description provided for @nutritionProfileConfigured.
  ///
  /// In en, this message translates to:
  /// **'Optional profile · {summary}'**
  String nutritionProfileConfigured(Object summary);

  /// No description provided for @nutritionProfileIntro.
  ///
  /// In en, this message translates to:
  /// **'Optional preferences are saved on this device. They do not prescribe a diet or change your training plan.'**
  String get nutritionProfileIntro;

  /// No description provided for @nutritionProfilePersonalSection.
  ///
  /// In en, this message translates to:
  /// **'About you'**
  String get nutritionProfilePersonalSection;

  /// No description provided for @nutritionProfileAge.
  ///
  /// In en, this message translates to:
  /// **'Age (years)'**
  String get nutritionProfileAge;

  /// No description provided for @nutritionProfileOptional.
  ///
  /// In en, this message translates to:
  /// **'Optional · only used if you choose to provide it'**
  String get nutritionProfileOptional;

  /// No description provided for @nutritionProfileAgeError.
  ///
  /// In en, this message translates to:
  /// **'Enter an age from 13 to 120, or leave it blank.'**
  String get nutritionProfileAgeError;

  /// No description provided for @nutritionProfileHeight.
  ///
  /// In en, this message translates to:
  /// **'Height (cm)'**
  String get nutritionProfileHeight;

  /// No description provided for @nutritionProfileHeightHint.
  ///
  /// In en, this message translates to:
  /// **'Optional · enter only if you know it'**
  String get nutritionProfileHeightHint;

  /// No description provided for @nutritionProfileHeightError.
  ///
  /// In en, this message translates to:
  /// **'Enter a height from 100 to 250 cm, or leave it blank.'**
  String get nutritionProfileHeightError;

  /// No description provided for @nutritionProfilePreferencesSection.
  ///
  /// In en, this message translates to:
  /// **'Food preferences'**
  String get nutritionProfilePreferencesSection;

  /// No description provided for @nutritionProfileBodyType.
  ///
  /// In en, this message translates to:
  /// **'Somatotype (optional)'**
  String get nutritionProfileBodyType;

  /// No description provided for @nutritionBodyTypeEctomorph.
  ///
  /// In en, this message translates to:
  /// **'Ectomorph'**
  String get nutritionBodyTypeEctomorph;

  /// No description provided for @nutritionBodyTypeMesomorph.
  ///
  /// In en, this message translates to:
  /// **'Mesomorph'**
  String get nutritionBodyTypeMesomorph;

  /// No description provided for @nutritionBodyTypeEndomorph.
  ///
  /// In en, this message translates to:
  /// **'Endomorph'**
  String get nutritionBodyTypeEndomorph;

  /// No description provided for @nutritionBodyTypeMixed.
  ///
  /// In en, this message translates to:
  /// **'Mixed'**
  String get nutritionBodyTypeMixed;

  /// No description provided for @nutritionBodyTypeUnknown.
  ///
  /// In en, this message translates to:
  /// **'I don\'t know'**
  String get nutritionBodyTypeUnknown;

  /// No description provided for @nutritionProfileDiet.
  ///
  /// In en, this message translates to:
  /// **'Eating pattern'**
  String get nutritionProfileDiet;

  /// No description provided for @nutritionProfileGoal.
  ///
  /// In en, this message translates to:
  /// **'Nutrition goal'**
  String get nutritionProfileGoal;

  /// No description provided for @nutritionProfileGoalUnset.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get nutritionProfileGoalUnset;

  /// No description provided for @nutritionGoalWellbeing.
  ///
  /// In en, this message translates to:
  /// **'General wellbeing'**
  String get nutritionGoalWellbeing;

  /// No description provided for @nutritionGoalTraining.
  ///
  /// In en, this message translates to:
  /// **'Support my training'**
  String get nutritionGoalTraining;

  /// No description provided for @nutritionGoalGain.
  ///
  /// In en, this message translates to:
  /// **'Gain weight'**
  String get nutritionGoalGain;

  /// No description provided for @nutritionGoalLose.
  ///
  /// In en, this message translates to:
  /// **'Lose weight'**
  String get nutritionGoalLose;

  /// No description provided for @nutritionGoalMaintain.
  ///
  /// In en, this message translates to:
  /// **'Maintain weight'**
  String get nutritionGoalMaintain;

  /// No description provided for @nutritionProfileSomatotypeNote.
  ///
  /// In en, this message translates to:
  /// **'Somatotypes are descriptive and are not diagnoses or diet formulas. Leave this as unknown if unsure.'**
  String get nutritionProfileSomatotypeNote;

  /// No description provided for @nutritionProfileDietAny.
  ///
  /// In en, this message translates to:
  /// **'No preference'**
  String get nutritionProfileDietAny;

  /// No description provided for @nutritionProfileDietVegetarian.
  ///
  /// In en, this message translates to:
  /// **'Vegetarian'**
  String get nutritionProfileDietVegetarian;

  /// No description provided for @nutritionProfileDietVegan.
  ///
  /// In en, this message translates to:
  /// **'Vegan'**
  String get nutritionProfileDietVegan;

  /// No description provided for @nutritionProfileDietPescatarian.
  ///
  /// In en, this message translates to:
  /// **'Pescatarian'**
  String get nutritionProfileDietPescatarian;

  /// No description provided for @nutritionProfileBudget.
  ///
  /// In en, this message translates to:
  /// **'Relative budget'**
  String get nutritionProfileBudget;

  /// No description provided for @nutritionProfileBudgetLow.
  ///
  /// In en, this message translates to:
  /// **'Economical'**
  String get nutritionProfileBudgetLow;

  /// No description provided for @nutritionProfileBudgetBalanced.
  ///
  /// In en, this message translates to:
  /// **'Balanced'**
  String get nutritionProfileBudgetBalanced;

  /// No description provided for @nutritionProfileBudgetAny.
  ///
  /// In en, this message translates to:
  /// **'No preference'**
  String get nutritionProfileBudgetAny;

  /// No description provided for @nutritionProfileCountry.
  ///
  /// In en, this message translates to:
  /// **'Country of purchase (ISO code)'**
  String get nutritionProfileCountry;

  /// No description provided for @nutritionProfileCountryHint.
  ///
  /// In en, this message translates to:
  /// **'Optional · for example, CO or VE; not inferred from language or location'**
  String get nutritionProfileCountryHint;

  /// No description provided for @nutritionProfileCountryError.
  ///
  /// In en, this message translates to:
  /// **'Enter a two-letter country code or leave it blank.'**
  String get nutritionProfileCountryError;

  /// No description provided for @nutritionProfileRegion.
  ///
  /// In en, this message translates to:
  /// **'Region or area (optional)'**
  String get nutritionProfileRegion;

  /// No description provided for @nutritionProfileRegionHint.
  ///
  /// In en, this message translates to:
  /// **'Used only to improve regional suggestions; no precise location is collected'**
  String get nutritionProfileRegionHint;

  /// No description provided for @nutritionCountrySearch.
  ///
  /// In en, this message translates to:
  /// **'Search country'**
  String get nutritionCountrySearch;

  /// No description provided for @nutritionCountryGeneral.
  ///
  /// In en, this message translates to:
  /// **'General catalog'**
  String get nutritionCountryGeneral;

  /// No description provided for @nutritionCountryGeneralHint.
  ///
  /// In en, this message translates to:
  /// **'Use broad suggestions when your country is not listed'**
  String get nutritionCountryGeneralHint;

  /// No description provided for @nutritionCountryNoResults.
  ///
  /// In en, this message translates to:
  /// **'No countries found'**
  String get nutritionCountryNoResults;

  /// No description provided for @nutritionCountryArgentina.
  ///
  /// In en, this message translates to:
  /// **'Argentina'**
  String get nutritionCountryArgentina;

  /// No description provided for @nutritionCountryColombia.
  ///
  /// In en, this message translates to:
  /// **'Colombia'**
  String get nutritionCountryColombia;

  /// No description provided for @nutritionCountryDominicanRepublic.
  ///
  /// In en, this message translates to:
  /// **'Dominican Republic'**
  String get nutritionCountryDominicanRepublic;

  /// No description provided for @nutritionCountrySpain.
  ///
  /// In en, this message translates to:
  /// **'Spain'**
  String get nutritionCountrySpain;

  /// No description provided for @nutritionCountryMexico.
  ///
  /// In en, this message translates to:
  /// **'Mexico'**
  String get nutritionCountryMexico;

  /// No description provided for @nutritionProfileRestrictionsSection.
  ///
  /// In en, this message translates to:
  /// **'Safety and exclusions'**
  String get nutritionProfileRestrictionsSection;

  /// No description provided for @nutritionProfileAllergies.
  ///
  /// In en, this message translates to:
  /// **'Allergies'**
  String get nutritionProfileAllergies;

  /// No description provided for @nutritionProfileIntolerances.
  ///
  /// In en, this message translates to:
  /// **'Intolerances'**
  String get nutritionProfileIntolerances;

  /// No description provided for @nutritionProfileExcluded.
  ///
  /// In en, this message translates to:
  /// **'Ingredients to avoid'**
  String get nutritionProfileExcluded;

  /// No description provided for @nutritionProfileListHint.
  ///
  /// In en, this message translates to:
  /// **'Optional · separate items with commas; review food labels every time'**
  String get nutritionProfileListHint;

  /// No description provided for @nutritionProfilePrivacyNote.
  ///
  /// In en, this message translates to:
  /// **'You can skip these fields. No account is required. Age and height are not used to calculate calorie or macro targets.'**
  String get nutritionProfilePrivacyNote;

  /// No description provided for @nutritionProfileSaveError.
  ///
  /// In en, this message translates to:
  /// **'Could not save the nutrition profile.'**
  String get nutritionProfileSaveError;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get commonSaving;

  /// No description provided for @profileMyPlan.
  ///
  /// In en, this message translates to:
  /// **'My training plan'**
  String get profileMyPlan;

  /// No description provided for @profilePlanSummary.
  ///
  /// In en, this message translates to:
  /// **'{goal} · {days} days · ~{minutes}-min budget'**
  String profilePlanSummary(Object days, Object goal, Object minutes);

  /// No description provided for @profilePreferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get profilePreferences;

  /// No description provided for @profileAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get profileAppearance;

  /// No description provided for @profileWeightUnit.
  ///
  /// In en, this message translates to:
  /// **'Weight {unit}'**
  String profileWeightUnit(Object unit);

  /// No description provided for @profileWeekStart.
  ///
  /// In en, this message translates to:
  /// **'week starts {day}'**
  String profileWeekStart(Object day);

  /// No description provided for @profileHaptics.
  ///
  /// In en, this message translates to:
  /// **'haptics {status}'**
  String profileHaptics(Object status);

  /// No description provided for @profileHapticsOn.
  ///
  /// In en, this message translates to:
  /// **'on'**
  String get profileHapticsOn;

  /// No description provided for @profileHapticsOff.
  ///
  /// In en, this message translates to:
  /// **'off'**
  String get profileHapticsOff;

  /// No description provided for @profileBackup.
  ///
  /// In en, this message translates to:
  /// **'Export and restore data'**
  String get profileBackup;

  /// No description provided for @profileBackupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create a backup or restore your data'**
  String get profileBackupSubtitle;

  /// No description provided for @profileNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get profileNotifications;

  /// No description provided for @profileReminderAt.
  ///
  /// In en, this message translates to:
  /// **'Reminder at {time}'**
  String profileReminderAt(Object time);

  /// No description provided for @profileRemindersOff.
  ///
  /// In en, this message translates to:
  /// **'Reminders off'**
  String get profileRemindersOff;

  /// No description provided for @profileSessionPreferencesNote.
  ///
  /// In en, this message translates to:
  /// **'Preferences are kept while the app is open.'**
  String get profileSessionPreferencesNote;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get commonRetry;

  /// No description provided for @commonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// No description provided for @commonFinish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get commonFinish;

  /// No description provided for @commonRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get commonRemove;

  /// No description provided for @homeWeekdayStatus.
  ///
  /// In en, this message translates to:
  /// **'{day}: {status}'**
  String homeWeekdayStatus(Object day, Object status);

  /// No description provided for @profileEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get profileEditTitle;

  /// No description provided for @profileNameField.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get profileNameField;

  /// No description provided for @profileEmailField.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get profileEmailField;

  /// No description provided for @profileGoalField.
  ///
  /// In en, this message translates to:
  /// **'Training goal'**
  String get profileGoalField;

  /// No description provided for @profileReviewChanges.
  ///
  /// In en, this message translates to:
  /// **'Review changes'**
  String get profileReviewChanges;

  /// No description provided for @profilePreferencesTitle.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get profilePreferencesTitle;

  /// No description provided for @profileWeightUnitTitle.
  ///
  /// In en, this message translates to:
  /// **'Weight unit'**
  String get profileWeightUnitTitle;

  /// No description provided for @profileWeekStartTitle.
  ///
  /// In en, this message translates to:
  /// **'Week starts on'**
  String get profileWeekStartTitle;

  /// No description provided for @profileHapticTitle.
  ///
  /// In en, this message translates to:
  /// **'Haptic feedback'**
  String get profileHapticTitle;

  /// No description provided for @profileSavePreferences.
  ///
  /// In en, this message translates to:
  /// **'Save preferences'**
  String get profileSavePreferences;

  /// No description provided for @profileSettingsLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Your preferences could not be loaded. Please try again.'**
  String get profileSettingsLoadFailed;

  /// No description provided for @profileSettingsSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Your preferences could not be saved. Please try again.'**
  String get profileSettingsSaveFailed;

  /// No description provided for @profileNotificationsPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get profileNotificationsPageTitle;

  /// No description provided for @profileWorkoutReminders.
  ///
  /// In en, this message translates to:
  /// **'Workout reminders'**
  String get profileWorkoutReminders;

  /// No description provided for @profileReminderDescription.
  ///
  /// In en, this message translates to:
  /// **'We\'ll remind you around this time on days with a pending workout.'**
  String get profileReminderDescription;

  /// No description provided for @profileReminderPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Allow notifications on your device to receive workout reminders.'**
  String get profileReminderPermissionDenied;

  /// No description provided for @profileReminderScheduleFailed.
  ///
  /// In en, this message translates to:
  /// **'Workout reminders could not be updated. Please try again.'**
  String get profileReminderScheduleFailed;

  /// No description provided for @workoutReminderNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'FORZA · today\'s workout'**
  String get workoutReminderNotificationTitle;

  /// No description provided for @workoutReminderNotificationBody.
  ///
  /// In en, this message translates to:
  /// **'You have a workout scheduled for today. You can do this!'**
  String get workoutReminderNotificationBody;

  /// No description provided for @profileReminderTime.
  ///
  /// In en, this message translates to:
  /// **'Reminder time'**
  String get profileReminderTime;

  /// No description provided for @profileWeeklySummary.
  ///
  /// In en, this message translates to:
  /// **'Weekly summary'**
  String get profileWeeklySummary;

  /// No description provided for @profileWeeklySummaryDescription.
  ///
  /// In en, this message translates to:
  /// **'A review of your activity.'**
  String get profileWeeklySummaryDescription;

  /// No description provided for @profilePersonalRecords.
  ///
  /// In en, this message translates to:
  /// **'Personal records'**
  String get profilePersonalRecords;

  /// No description provided for @profileSaveNotifications.
  ///
  /// In en, this message translates to:
  /// **'Save preferences'**
  String get profileSaveNotifications;

  /// No description provided for @profilePrivacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy and account'**
  String get profilePrivacyTitle;

  /// No description provided for @profilePrivateTitle.
  ///
  /// In en, this message translates to:
  /// **'Private profile'**
  String get profilePrivateTitle;

  /// No description provided for @profilePrivateDescription.
  ///
  /// In en, this message translates to:
  /// **'Only you can see your profile.'**
  String get profilePrivateDescription;

  /// No description provided for @profileShareActivityTitle.
  ///
  /// In en, this message translates to:
  /// **'Share activity'**
  String get profileShareActivityTitle;

  /// No description provided for @profileShareActivityDescription.
  ///
  /// In en, this message translates to:
  /// **'Allow your progress to be shown in the app.'**
  String get profileShareActivityDescription;

  /// No description provided for @profileConfirmAccount.
  ///
  /// In en, this message translates to:
  /// **'Confirm account details'**
  String get profileConfirmAccount;

  /// No description provided for @profileSavePrivacy.
  ///
  /// In en, this message translates to:
  /// **'Save privacy'**
  String get profileSavePrivacy;

  /// No description provided for @profileReviewComplete.
  ///
  /// In en, this message translates to:
  /// **'Data review complete.'**
  String get profileReviewComplete;

  /// No description provided for @profileAccountConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Review profile'**
  String get profileAccountConfirmation;

  /// No description provided for @profileReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Review profile'**
  String get profileReviewTitle;

  /// No description provided for @profileName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get profileName;

  /// No description provided for @profileEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get profileEmail;

  /// No description provided for @profileGoal.
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get profileGoal;

  /// No description provided for @profileConfirmDetails.
  ///
  /// In en, this message translates to:
  /// **'Save details'**
  String get profileConfirmDetails;

  /// No description provided for @profileSaveDetails.
  ///
  /// In en, this message translates to:
  /// **'Save profile'**
  String get profileSaveDetails;

  /// No description provided for @profileThemeDevice.
  ///
  /// In en, this message translates to:
  /// **'Follow device'**
  String get profileThemeDevice;

  /// No description provided for @profileThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get profileThemeLight;

  /// No description provided for @profileThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get profileThemeDark;

  /// No description provided for @profileThemeAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get profileThemeAppearance;

  /// No description provided for @profileThemeDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose how you want FORZA to look.'**
  String get profileThemeDescription;

  /// No description provided for @profileWeightKg.
  ///
  /// In en, this message translates to:
  /// **'Kilograms (kg)'**
  String get profileWeightKg;

  /// No description provided for @profileWeightLb.
  ///
  /// In en, this message translates to:
  /// **'Pounds (lb)'**
  String get profileWeightLb;

  /// No description provided for @profileWeekMonday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get profileWeekMonday;

  /// No description provided for @profileWeekSunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get profileWeekSunday;

  /// No description provided for @backupTitle.
  ///
  /// In en, this message translates to:
  /// **'Export and restore'**
  String get backupTitle;

  /// No description provided for @backupEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Your data'**
  String get backupEyebrow;

  /// No description provided for @backupHeading.
  ///
  /// In en, this message translates to:
  /// **'A backup you control'**
  String get backupHeading;

  /// No description provided for @backupDescription.
  ///
  /// In en, this message translates to:
  /// **'The file includes your plan, workout history and sets, schedule, goals, saved measurements, active workout, appearance, and preferences. It is saved as JSON wherever you choose. As a guest, your data stays on this device; sign in with Google from Profile to enable cloud sync. The file is independent of that sync.'**
  String get backupDescription;

  /// No description provided for @backupExport.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get backupExport;

  /// No description provided for @backupExportDescription.
  ///
  /// In en, this message translates to:
  /// **'Create a file you can save or transfer to another device.'**
  String get backupExportDescription;

  /// No description provided for @backupCreate.
  ///
  /// In en, this message translates to:
  /// **'Create backup'**
  String get backupCreate;

  /// No description provided for @backupRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get backupRestore;

  /// No description provided for @backupRestoreDescription.
  ///
  /// In en, this message translates to:
  /// **'Review the contents and confirm before replacing local data.'**
  String get backupRestoreDescription;

  /// No description provided for @backupChooseFile.
  ///
  /// In en, this message translates to:
  /// **'Choose backup file'**
  String get backupChooseFile;

  /// No description provided for @backupSaveDialog.
  ///
  /// In en, this message translates to:
  /// **'Save FORZA backup'**
  String get backupSaveDialog;

  /// No description provided for @backupPickDialog.
  ///
  /// In en, this message translates to:
  /// **'Select FORZA backup'**
  String get backupPickDialog;

  /// No description provided for @backupSaved.
  ///
  /// In en, this message translates to:
  /// **'Backup saved.'**
  String get backupSaved;

  /// No description provided for @backupRestored.
  ///
  /// In en, this message translates to:
  /// **'Backup restored.'**
  String get backupRestored;

  /// No description provided for @backupConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore backup'**
  String get backupConfirmTitle;

  /// No description provided for @backupConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Local data will be replaced with the backup from {date}. It includes {records} workout history entries, {schedule} scheduled workouts, {goals} goals, and {measurements} measurement entries. This cannot be undone.'**
  String backupConfirmMessage(
    Object date,
    Object goals,
    Object measurements,
    Object records,
    Object schedule,
  );

  /// No description provided for @backupReplace.
  ///
  /// In en, this message translates to:
  /// **'Replace data'**
  String get backupReplace;

  /// No description provided for @backupGenericError.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t process the file. Try again.'**
  String get backupGenericError;

  /// No description provided for @profileResetSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset local data'**
  String get profileResetSectionTitle;

  /// No description provided for @profileResetSectionDescription.
  ///
  /// In en, this message translates to:
  /// **'Delete workout data from this device. You can save a backup first; app preferences and appearance will be kept.'**
  String get profileResetSectionDescription;

  /// No description provided for @profileResetAction.
  ///
  /// In en, this message translates to:
  /// **'Reset data'**
  String get profileResetAction;

  /// No description provided for @profileResetConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete local data?'**
  String get profileResetConfirmTitle;

  /// No description provided for @profileResetConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This deletes your plan, schedule, workout history and sets, goals, measurements, and active workout. Language, theme, units, haptics, privacy, and reminder settings will be kept. The exercise catalog is not deleted.'**
  String get profileResetConfirmMessage;

  /// No description provided for @profileResetBackupOption.
  ///
  /// In en, this message translates to:
  /// **'Save a JSON backup before deleting'**
  String get profileResetBackupOption;

  /// No description provided for @profileResetConfirmButton.
  ///
  /// In en, this message translates to:
  /// **'Delete data'**
  String get profileResetConfirmButton;

  /// No description provided for @profileResetBackupCancelled.
  ///
  /// In en, this message translates to:
  /// **'No data was deleted because the backup was not saved.'**
  String get profileResetBackupCancelled;

  /// No description provided for @profileResetCompleted.
  ///
  /// In en, this message translates to:
  /// **'Data deleted. Set up a new plan to continue.'**
  String get profileResetCompleted;

  /// No description provided for @profileResetFailed.
  ///
  /// In en, this message translates to:
  /// **'Data could not be deleted. The reset was not completed.'**
  String get profileResetFailed;

  /// No description provided for @accountWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'An account is optional.'**
  String get accountWelcomeTitle;

  /// No description provided for @accountWelcomeDescription.
  ///
  /// In en, this message translates to:
  /// **'You can train without an account. Signing in with Google does not upload your data; you can turn on sync separately in Profile.'**
  String get accountWelcomeDescription;

  /// No description provided for @accountSignInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get accountSignInWithGoogle;

  /// No description provided for @accountSwitchGoogle.
  ///
  /// In en, this message translates to:
  /// **'Switch Google account'**
  String get accountSwitchGoogle;

  /// No description provided for @accountContinueWithoutAccount.
  ///
  /// In en, this message translates to:
  /// **'Continue without an account'**
  String get accountContinueWithoutAccount;

  /// No description provided for @accountSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get accountSignOut;

  /// No description provided for @accountSignOutTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign out?'**
  String get accountSignOutTitle;

  /// No description provided for @accountSignOutMessage.
  ///
  /// In en, this message translates to:
  /// **'This disconnects your Google account from Forza. Your local workouts and preferences stay on this device.'**
  String get accountSignOutMessage;

  /// No description provided for @accountLocalDataNote.
  ///
  /// In en, this message translates to:
  /// **'Your data stays on this device until you choose to enable sync in Profile.'**
  String get accountLocalDataNote;

  /// No description provided for @accountConfigurationRequired.
  ///
  /// In en, this message translates to:
  /// **'Google sign-in could not start. Check the Android or iOS OAuth setup and try again.'**
  String get accountConfigurationRequired;

  /// No description provided for @accountProviderUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Google is unavailable. Check your connection or try again.'**
  String get accountProviderUnavailable;

  /// No description provided for @accountAuthenticationFailed.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t complete sign-in. Try again.'**
  String get accountAuthenticationFailed;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get onboardingSkip;

  /// No description provided for @onboardingCreatePlan.
  ///
  /// In en, this message translates to:
  /// **'Create your plan'**
  String get onboardingCreatePlan;

  /// No description provided for @onboardingPreview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get onboardingPreview;

  /// No description provided for @onboardingBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get onboardingBack;

  /// No description provided for @onboardingPreviousStep.
  ///
  /// In en, this message translates to:
  /// **'Previous step'**
  String get onboardingPreviousStep;

  /// No description provided for @onboardingContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get onboardingContinue;

  /// No description provided for @onboardingStepLabel.
  ///
  /// In en, this message translates to:
  /// **'Step {step} of {total}'**
  String onboardingStepLabel(Object step, Object total);

  /// No description provided for @onboardingGoalTitle.
  ///
  /// In en, this message translates to:
  /// **'What would you like to achieve?'**
  String get onboardingGoalTitle;

  /// No description provided for @onboardingGoalDescription.
  ///
  /// In en, this message translates to:
  /// **'We\'ll choose a starting point that suits you. You can change it later.'**
  String get onboardingGoalDescription;

  /// No description provided for @onboardingStrengthGoal.
  ///
  /// In en, this message translates to:
  /// **'Build strength'**
  String get onboardingStrengthGoal;

  /// No description provided for @onboardingMuscleGoal.
  ///
  /// In en, this message translates to:
  /// **'Build muscle'**
  String get onboardingMuscleGoal;

  /// No description provided for @onboardingHabitGoal.
  ///
  /// In en, this message translates to:
  /// **'Build a habit'**
  String get onboardingHabitGoal;

  /// No description provided for @onboardingStrengthGoalDescription.
  ///
  /// In en, this message translates to:
  /// **'Make progress in your lifts'**
  String get onboardingStrengthGoalDescription;

  /// No description provided for @onboardingMuscleGoalDescription.
  ///
  /// In en, this message translates to:
  /// **'Build muscle consistently'**
  String get onboardingMuscleGoalDescription;

  /// No description provided for @onboardingHabitGoalDescription.
  ///
  /// In en, this message translates to:
  /// **'Build a sustainable routine'**
  String get onboardingHabitGoalDescription;

  /// No description provided for @onboardingExperienceTitle.
  ///
  /// In en, this message translates to:
  /// **'What\'s your experience level?'**
  String get onboardingExperienceTitle;

  /// No description provided for @onboardingExperienceDescription.
  ///
  /// In en, this message translates to:
  /// **'We\'ll use your answer to adjust the starting sets for each exercise.'**
  String get onboardingExperienceDescription;

  /// No description provided for @onboardingExperienceBeginner.
  ///
  /// In en, this message translates to:
  /// **'I\'m just getting started'**
  String get onboardingExperienceBeginner;

  /// No description provided for @onboardingExperienceSome.
  ///
  /// In en, this message translates to:
  /// **'I have some experience'**
  String get onboardingExperienceSome;

  /// No description provided for @onboardingExperienceLong.
  ///
  /// In en, this message translates to:
  /// **'I\'ve been training for a while'**
  String get onboardingExperienceLong;

  /// No description provided for @onboardingExperienceBeginnerDescription.
  ///
  /// In en, this message translates to:
  /// **'I want to learn and progress step by step'**
  String get onboardingExperienceBeginnerDescription;

  /// No description provided for @onboardingExperienceSomeDescription.
  ///
  /// In en, this message translates to:
  /// **'I know some of the movements'**
  String get onboardingExperienceSomeDescription;

  /// No description provided for @onboardingExperienceLongDescription.
  ///
  /// In en, this message translates to:
  /// **'I have a routine and want new challenges'**
  String get onboardingExperienceLongDescription;

  /// No description provided for @onboardingExperienceNote.
  ///
  /// In en, this message translates to:
  /// **'Your experience helps tailor your training.'**
  String get onboardingExperienceNote;

  /// No description provided for @onboardingScheduleTitle.
  ///
  /// In en, this message translates to:
  /// **'Which days can you train?'**
  String get onboardingScheduleTitle;

  /// No description provided for @onboardingScheduleDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose the days that usually work for you. You can change them later.'**
  String get onboardingScheduleDescription;

  /// No description provided for @onboardingSessionsPerWeek.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 session per week} other{{count} sessions per week}}'**
  String onboardingSessionsPerWeek(num count);

  /// No description provided for @onboardingRecoveryTitle.
  ///
  /// In en, this message translates to:
  /// **'Training frequency and recovery'**
  String get onboardingRecoveryTitle;

  /// No description provided for @onboardingRecoveryOnce.
  ///
  /// In en, this message translates to:
  /// **'One session is a good start. To improve strength, ACSM recommends training the major muscle groups at least twice a week for healthy adults. You can increase frequency when it feels sustainable.'**
  String get onboardingRecoveryOnce;

  /// No description provided for @onboardingRecoveryTwoToThree.
  ///
  /// In en, this message translates to:
  /// **'The plan schedules full-body sessions. When possible, leave a day between them to spread the effort and recover.'**
  String get onboardingRecoveryTwoToThree;

  /// No description provided for @onboardingRecoveryFour.
  ///
  /// In en, this message translates to:
  /// **'The plan alternates upper and lower body. Space sessions to give each muscle group time to recover.'**
  String get onboardingRecoveryFour;

  /// No description provided for @onboardingRecoveryFiveToSix.
  ///
  /// In en, this message translates to:
  /// **'The plan alternates upper and lower body. This is a high frequency: schedule breaks based on your recovery and move days if needed.'**
  String get onboardingRecoveryFiveToSix;

  /// No description provided for @onboardingRecoverySeven.
  ///
  /// In en, this message translates to:
  /// **'You can select all seven days, but that leaves no full day without strength training. We recommend reserving at least one day for rest or light activity; you can change your schedule anytime.'**
  String get onboardingRecoverySeven;

  /// No description provided for @onboardingRecoverySource.
  ///
  /// In en, this message translates to:
  /// **'ACSM resistance training guidance'**
  String get onboardingRecoverySource;

  /// No description provided for @onboardingProgressionTemplateNote.
  ///
  /// In en, this message translates to:
  /// **'This plan is an initial template. Suggestions use your logged sets and never change the plan automatically; you decide whether to apply them.'**
  String get onboardingProgressionTemplateNote;

  /// No description provided for @sessionProgressionTitle.
  ///
  /// In en, this message translates to:
  /// **'Progression suggestion'**
  String get sessionProgressionTitle;

  /// No description provided for @sessionProgressionNoHistory.
  ///
  /// In en, this message translates to:
  /// **'There are not enough records for this exercise yet. Complete your sets and log reps and load if you used weight.'**
  String get sessionProgressionNoHistory;

  /// No description provided for @sessionProgressionKeepBuilding.
  ///
  /// In en, this message translates to:
  /// **'Keep the same load and focus on technique; do not increase yet. Before suggesting more load, we require {sessions} consecutive workouts with at least {repetitions} reps in every set.'**
  String sessionProgressionKeepBuilding(int sessions, int repetitions);

  /// No description provided for @sessionProgressionReadyToIncrease.
  ///
  /// In en, this message translates to:
  /// **'You reached {repetitions} reps in every set for {sessions} consecutive workouts. If it felt comfortable, pain-free, and controlled, try the smallest available load increase and return to the lower end of the rep range.'**
  String sessionProgressionReadyToIncrease(int repetitions, int sessions);

  /// No description provided for @sessionProgressionBodyweightReady.
  ///
  /// In en, this message translates to:
  /// **'You completed {repetitions} reps in every set for {sessions} consecutive workouts. If your technique stayed steady, you can try a slightly harder bodyweight variation.'**
  String sessionProgressionBodyweightReady(int repetitions, int sessions);

  /// No description provided for @sessionProgressionHabitFocus.
  ///
  /// In en, this message translates to:
  /// **'For a habit-building goal, prioritize consistency and technique. You do not need to increase load automatically.'**
  String get sessionProgressionHabitFocus;

  /// No description provided for @sessionProgressionReturningAfterBreak.
  ///
  /// In en, this message translates to:
  /// **'It has been over a month since you logged this exercise. Resume with a comfortable load and complete new sessions before considering an increase.'**
  String get sessionProgressionReturningAfterBreak;

  /// No description provided for @sessionProgressionTimedKeepBuilding.
  ///
  /// In en, this message translates to:
  /// **'Log the seconds and keep the movement controlled. Before suggesting a harder variation, we require {sessions} consecutive workouts with {seconds} seconds in every set.'**
  String sessionProgressionTimedKeepBuilding(int sessions, int seconds);

  /// No description provided for @sessionProgressionTimedReadyToVary.
  ///
  /// In en, this message translates to:
  /// **'You completed {seconds} seconds in every set for {sessions} consecutive workouts. If you stayed in control, you can try a slightly harder variation; do not add weight.'**
  String sessionProgressionTimedReadyToVary(int sessions, int seconds);

  /// No description provided for @sessionProgressionTemplateNote.
  ///
  /// In en, this message translates to:
  /// **'Suggestions are based on your logs. The plan is a template and does not change automatically; you decide whether to apply them.'**
  String get sessionProgressionTemplateNote;

  /// No description provided for @onboardingSessionTime.
  ///
  /// In en, this message translates to:
  /// **'Time budget per session'**
  String get onboardingSessionTime;

  /// No description provided for @onboardingSessionBudgetNote.
  ///
  /// In en, this message translates to:
  /// **'The plan adjusts the number of exercises to this budget. Actual time varies with your pace and how long you spend warming up and cooling down. The timer between exercises is a 45-second guide.'**
  String get onboardingSessionBudgetNote;

  /// No description provided for @onboardingMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String onboardingMinutes(Object minutes);

  /// No description provided for @onboardingEquipmentTitle.
  ///
  /// In en, this message translates to:
  /// **'What equipment do you have?'**
  String get onboardingEquipmentTitle;

  /// No description provided for @onboardingEquipmentDescription.
  ///
  /// In en, this message translates to:
  /// **'We\'ll use this to choose exercises you can do.'**
  String get onboardingEquipmentDescription;

  /// No description provided for @onboardingEquipmentRequired.
  ///
  /// In en, this message translates to:
  /// **'Choose at least one option to prepare your workouts.'**
  String get onboardingEquipmentRequired;

  /// No description provided for @onboardingAvoidMovementTitle.
  ///
  /// In en, this message translates to:
  /// **'Movements you prefer to avoid (optional)'**
  String get onboardingAvoidMovementTitle;

  /// No description provided for @onboardingAvoidMovementDescription.
  ///
  /// In en, this message translates to:
  /// **'Select exercises you prefer to leave out. This preference is not a medical diagnosis; consult a professional if you have health concerns.'**
  String get onboardingAvoidMovementDescription;

  /// No description provided for @onboardingAvoidedMovementSummary.
  ///
  /// In en, this message translates to:
  /// **'Excluded movements: {movements}'**
  String onboardingAvoidedMovementSummary(String movements);

  /// No description provided for @onboardingAvoidedMovementApplied.
  ///
  /// In en, this message translates to:
  /// **'The plan prioritizes compatible options when available. Review each exercise before starting.'**
  String get onboardingAvoidedMovementApplied;

  /// No description provided for @onboardingNoCompatibleExercises.
  ///
  /// In en, this message translates to:
  /// **'No exercises match the selected equipment and exclusions. Adjust your preferences to generate a plan.'**
  String get onboardingNoCompatibleExercises;

  /// No description provided for @onboardingPreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Here\'s your week'**
  String get onboardingPreviewTitle;

  /// No description provided for @onboardingPreviewDescription.
  ///
  /// In en, this message translates to:
  /// **'This is a starting point. You can adjust your plan from Profile.'**
  String get onboardingPreviewDescription;

  /// No description provided for @onboardingEditGoal.
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get onboardingEditGoal;

  /// No description provided for @onboardingEditExperience.
  ///
  /// In en, this message translates to:
  /// **'Experience'**
  String get onboardingEditExperience;

  /// No description provided for @onboardingEditSchedule.
  ///
  /// In en, this message translates to:
  /// **'Days and duration'**
  String get onboardingEditSchedule;

  /// No description provided for @onboardingEditEquipment.
  ///
  /// In en, this message translates to:
  /// **'Equipment and exclusions'**
  String get onboardingEditEquipment;

  /// No description provided for @onboardingReturnToPreview.
  ///
  /// In en, this message translates to:
  /// **'Return to plan summary'**
  String get onboardingReturnToPreview;

  /// No description provided for @onboardingEmptySessionConflict.
  ///
  /// In en, this message translates to:
  /// **'At least one session has no compatible exercises. Adjust training days, equipment, or excluded movements before creating the plan.'**
  String get onboardingEmptySessionConflict;

  /// No description provided for @onboardingSessionSummary.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 exercise} other{{count} exercises}} · ~{minutes} min estimated'**
  String onboardingSessionSummary(int count, int minutes);

  /// No description provided for @onboardingTimedPrescription.
  ///
  /// In en, this message translates to:
  /// **'{sets} sets · 20–40 seconds'**
  String onboardingTimedPrescription(int sets);

  /// No description provided for @onboardingRepPrescription.
  ///
  /// In en, this message translates to:
  /// **'{sets} sets · {target}'**
  String onboardingRepPrescription(int sets, String target);

  /// No description provided for @onboardingStrengthRepRange.
  ///
  /// In en, this message translates to:
  /// **'6–8 reps'**
  String get onboardingStrengthRepRange;

  /// No description provided for @onboardingMuscleRepRange.
  ///
  /// In en, this message translates to:
  /// **'8–12 reps'**
  String get onboardingMuscleRepRange;

  /// No description provided for @onboardingHabitRepRange.
  ///
  /// In en, this message translates to:
  /// **'8–12 reps at a comfortable pace'**
  String get onboardingHabitRepRange;

  /// No description provided for @onboardingPlanExperience.
  ///
  /// In en, this message translates to:
  /// **'Experience: {experience}'**
  String onboardingPlanExperience(Object experience);

  /// No description provided for @onboardingPlanEquipment.
  ///
  /// In en, this message translates to:
  /// **'Equipment: {equipment}'**
  String onboardingPlanEquipment(Object equipment);

  /// No description provided for @onboardingPlanExerciseCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 exercise} other{{count} exercises}}'**
  String onboardingPlanExerciseCount(num count);

  /// No description provided for @onboardingSafetyNote.
  ///
  /// In en, this message translates to:
  /// **'General guidance. If you have pain, an injury, or a medical condition, consult a professional before exercising.'**
  String get onboardingSafetyNote;

  /// No description provided for @onboardingCreateMyPlan.
  ///
  /// In en, this message translates to:
  /// **'Create my plan'**
  String get onboardingCreateMyPlan;

  /// No description provided for @sessionPause.
  ///
  /// In en, this message translates to:
  /// **'Pause workout'**
  String get sessionPause;

  /// No description provided for @sessionWarmup.
  ///
  /// In en, this message translates to:
  /// **'Warm-up'**
  String get sessionWarmup;

  /// No description provided for @sessionPreparation.
  ///
  /// In en, this message translates to:
  /// **'Getting ready'**
  String get sessionPreparation;

  /// No description provided for @sessionExercises.
  ///
  /// In en, this message translates to:
  /// **'Exercises'**
  String get sessionExercises;

  /// No description provided for @sessionSet.
  ///
  /// In en, this message translates to:
  /// **'Set {number}'**
  String sessionSet(Object number);

  /// No description provided for @sessionRest.
  ///
  /// In en, this message translates to:
  /// **'Rest'**
  String get sessionRest;

  /// No description provided for @sessionPaused.
  ///
  /// In en, this message translates to:
  /// **'Workout paused'**
  String get sessionPaused;

  /// No description provided for @sessionExitTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave workout'**
  String get sessionExitTitle;

  /// No description provided for @sessionCompletedTitle.
  ///
  /// In en, this message translates to:
  /// **'Workout complete'**
  String get sessionCompletedTitle;

  /// No description provided for @sessionGoodWork.
  ///
  /// In en, this message translates to:
  /// **'Well done'**
  String get sessionGoodWork;

  /// No description provided for @sessionSummary.
  ///
  /// In en, this message translates to:
  /// **'Workout summary'**
  String get sessionSummary;

  /// No description provided for @sessionDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get sessionDuration;

  /// No description provided for @sessionExerciseCount.
  ///
  /// In en, this message translates to:
  /// **'Exercises'**
  String get sessionExerciseCount;

  /// No description provided for @sessionGoal.
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get sessionGoal;

  /// No description provided for @sessionViewWarmup.
  ///
  /// In en, this message translates to:
  /// **'View warm-up'**
  String get sessionViewWarmup;

  /// No description provided for @sessionStart.
  ///
  /// In en, this message translates to:
  /// **'Start workout'**
  String get sessionStart;

  /// No description provided for @sessionSkipWarmup.
  ///
  /// In en, this message translates to:
  /// **'Skip warm-up'**
  String get sessionSkipWarmup;

  /// No description provided for @sessionSkipRest.
  ///
  /// In en, this message translates to:
  /// **'Skip rest'**
  String get sessionSkipRest;

  /// No description provided for @sessionContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue workout'**
  String get sessionContinue;

  /// No description provided for @sessionAbandon.
  ///
  /// In en, this message translates to:
  /// **'Leave workout'**
  String get sessionAbandon;

  /// No description provided for @sessionAbandonConfirm.
  ///
  /// In en, this message translates to:
  /// **'Yes, leave'**
  String get sessionAbandonConfirm;

  /// No description provided for @sessionKeep.
  ///
  /// In en, this message translates to:
  /// **'Keep training'**
  String get sessionKeep;

  /// No description provided for @sessionViewSummary.
  ///
  /// In en, this message translates to:
  /// **'View workout summary'**
  String get sessionViewSummary;

  /// No description provided for @sessionFinish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get sessionFinish;

  /// No description provided for @sessionRepetitions.
  ///
  /// In en, this message translates to:
  /// **'Repetitions'**
  String get sessionRepetitions;

  /// No description provided for @sessionSeconds.
  ///
  /// In en, this message translates to:
  /// **'Seconds'**
  String get sessionSeconds;

  /// No description provided for @sessionLoad.
  ///
  /// In en, this message translates to:
  /// **'External load (kg)'**
  String get sessionLoad;

  /// No description provided for @sessionAddExternalLoad.
  ///
  /// In en, this message translates to:
  /// **'Add external load'**
  String get sessionAddExternalLoad;

  /// No description provided for @sessionRemoveExternalLoad.
  ///
  /// In en, this message translates to:
  /// **'Remove external load'**
  String get sessionRemoveExternalLoad;

  /// No description provided for @sessionSetCountSummary.
  ///
  /// In en, this message translates to:
  /// **'Recommended: {recommended} · This session: {planned}'**
  String sessionSetCountSummary(int recommended, int planned);

  /// No description provided for @sessionAdditionalSet.
  ///
  /// In en, this message translates to:
  /// **'Additional set {number}'**
  String sessionAdditionalSet(int number);

  /// No description provided for @sessionAddSet.
  ///
  /// In en, this message translates to:
  /// **'Add set'**
  String get sessionAddSet;

  /// No description provided for @sessionRemovePendingSet.
  ///
  /// In en, this message translates to:
  /// **'Remove last set'**
  String get sessionRemovePendingSet;

  /// No description provided for @sessionRemoveCompletedSet.
  ///
  /// In en, this message translates to:
  /// **'Delete completed set'**
  String get sessionRemoveCompletedSet;

  /// No description provided for @sessionRemoveCompletedSetTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete set results?'**
  String get sessionRemoveCompletedSetTitle;

  /// No description provided for @sessionRemoveCompletedSetMessage.
  ///
  /// In en, this message translates to:
  /// **'The results for the last set in this session will be deleted. Your weekly prescription will stay the same.'**
  String get sessionRemoveCompletedSetMessage;

  /// No description provided for @sessionProgress.
  ///
  /// In en, this message translates to:
  /// **'Exercise {current} of {total}'**
  String sessionProgress(Object current, Object total);

  /// No description provided for @sessionSavedFeedback.
  ///
  /// In en, this message translates to:
  /// **'Workout saved! Your results are now part of your progress.'**
  String get sessionSavedFeedback;

  /// No description provided for @sessionNextExercise.
  ///
  /// In en, this message translates to:
  /// **'Next exercise'**
  String get sessionNextExercise;

  /// No description provided for @sessionPreviousExercise.
  ///
  /// In en, this message translates to:
  /// **'Previous exercise'**
  String get sessionPreviousExercise;

  /// No description provided for @sessionSetComplete.
  ///
  /// In en, this message translates to:
  /// **'Set complete'**
  String get sessionSetComplete;

  /// No description provided for @progressEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progressEyebrow;

  /// No description provided for @progressGoals.
  ///
  /// In en, this message translates to:
  /// **'Personal goals'**
  String get progressGoals;

  /// No description provided for @progressHistory.
  ///
  /// In en, this message translates to:
  /// **'Workout history'**
  String get progressHistory;

  /// No description provided for @progressRemoveGoalTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove goal'**
  String get progressRemoveGoalTitle;

  /// No description provided for @progressRemoveGoalBody.
  ///
  /// In en, this message translates to:
  /// **'Do you want to remove this goal from your progress?'**
  String get progressRemoveGoalBody;

  /// No description provided for @progressEditGoal.
  ///
  /// In en, this message translates to:
  /// **'Edit goal'**
  String get progressEditGoal;

  /// No description provided for @progressGoalRemoved.
  ///
  /// In en, this message translates to:
  /// **'Goal removed.'**
  String get progressGoalRemoved;

  /// No description provided for @progressDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get progressDuration;

  /// No description provided for @progressExercises.
  ///
  /// In en, this message translates to:
  /// **'Exercises'**
  String get progressExercises;

  /// No description provided for @progressSessionDetails.
  ///
  /// In en, this message translates to:
  /// **'Workout details'**
  String get progressSessionDetails;

  /// No description provided for @progressStrengthTrend.
  ///
  /// In en, this message translates to:
  /// **'Strength trend'**
  String get progressStrengthTrend;

  /// No description provided for @progressBodyTrend.
  ///
  /// In en, this message translates to:
  /// **'Body measurements'**
  String get progressBodyTrend;

  /// No description provided for @progressStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get progressStart;

  /// No description provided for @progressCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get progressCurrent;

  /// No description provided for @progressLastEntry.
  ///
  /// In en, this message translates to:
  /// **'Latest entry'**
  String get progressLastEntry;

  /// No description provided for @progressPeriodChange.
  ///
  /// In en, this message translates to:
  /// **'Change over the period'**
  String get progressPeriodChange;

  /// No description provided for @progressRecentMeasurements.
  ///
  /// In en, this message translates to:
  /// **'Recent measurements'**
  String get progressRecentMeasurements;

  /// No description provided for @progressRegisterMeasurements.
  ///
  /// In en, this message translates to:
  /// **'Log measurements'**
  String get progressRegisterMeasurements;

  /// No description provided for @progressMeasurementDate.
  ///
  /// In en, this message translates to:
  /// **'Entry date'**
  String get progressMeasurementDate;

  /// No description provided for @progressBodyWeight.
  ///
  /// In en, this message translates to:
  /// **'Body weight'**
  String get progressBodyWeight;

  /// No description provided for @progressWaist.
  ///
  /// In en, this message translates to:
  /// **'Waist'**
  String get progressWaist;

  /// No description provided for @progressChest.
  ///
  /// In en, this message translates to:
  /// **'Chest'**
  String get progressChest;

  /// No description provided for @progressHips.
  ///
  /// In en, this message translates to:
  /// **'Hips'**
  String get progressHips;

  /// No description provided for @progressArm.
  ///
  /// In en, this message translates to:
  /// **'Arm'**
  String get progressArm;

  /// No description provided for @progressSaveEntry.
  ///
  /// In en, this message translates to:
  /// **'Save entry'**
  String get progressSaveEntry;

  /// No description provided for @progressPersonalRecords.
  ///
  /// In en, this message translates to:
  /// **'Personal records'**
  String get progressPersonalRecords;

  /// No description provided for @progressNewGoal.
  ///
  /// In en, this message translates to:
  /// **'New goal'**
  String get progressNewGoal;

  /// No description provided for @progressGoalType.
  ///
  /// In en, this message translates to:
  /// **'Goal type'**
  String get progressGoalType;

  /// No description provided for @progressWeeklySessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions per week'**
  String get progressWeeklySessions;

  /// No description provided for @progressExerciseLoadRecord.
  ///
  /// In en, this message translates to:
  /// **'Exercise weight record'**
  String get progressExerciseLoadRecord;

  /// No description provided for @progressExerciseName.
  ///
  /// In en, this message translates to:
  /// **'Exercise name'**
  String get progressExerciseName;

  /// No description provided for @progressSelectExercise.
  ///
  /// In en, this message translates to:
  /// **'Select exercise'**
  String get progressSelectExercise;

  /// No description provided for @progressSearchExercises.
  ///
  /// In en, this message translates to:
  /// **'Search exercises'**
  String get progressSearchExercises;

  /// No description provided for @progressNoExercisesFound.
  ///
  /// In en, this message translates to:
  /// **'No exercises found.'**
  String get progressNoExercisesFound;

  /// No description provided for @progressExerciseCatalogRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry loading catalog'**
  String get progressExerciseCatalogRetry;

  /// No description provided for @progressExerciseCatalogLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading exercises…'**
  String get progressExerciseCatalogLoading;

  /// No description provided for @progressGoalExerciseNeedsResolution.
  ///
  /// In en, this message translates to:
  /// **'The older goal “{name}” needs you to choose the correct exercise so records are not combined.'**
  String progressGoalExerciseNeedsResolution(String name);

  /// No description provided for @progressExerciseHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Goblet squat'**
  String get progressExerciseHint;

  /// No description provided for @progressSaveGoal.
  ///
  /// In en, this message translates to:
  /// **'Save goal'**
  String get progressSaveGoal;

  /// No description provided for @progressExerciseCount.
  ///
  /// In en, this message translates to:
  /// **'{count} exercises'**
  String progressExerciseCount(Object count);

  /// No description provided for @progressEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No progress data yet'**
  String get progressEmptyTitle;

  /// No description provided for @progressEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'Complete a workout and log your sets to start seeing your results.'**
  String get progressEmptyDescription;

  /// No description provided for @progressNoHistory.
  ///
  /// In en, this message translates to:
  /// **'Complete a workout to see your recent activity here.'**
  String get progressNoHistory;

  /// No description provided for @progressGoalSessionsValue.
  ///
  /// In en, this message translates to:
  /// **'{done} of {target} workouts this week'**
  String progressGoalSessionsValue(Object done, Object target);

  /// No description provided for @progressGoalLoadValue.
  ///
  /// In en, this message translates to:
  /// **'Target: {weight} {unit}'**
  String progressGoalLoadValue(Object unit, Object weight);

  /// No description provided for @progressGoalProgress.
  ///
  /// In en, this message translates to:
  /// **'{current} of {target}'**
  String progressGoalProgress(Object current, Object target);

  /// No description provided for @progressRecentSessions.
  ///
  /// In en, this message translates to:
  /// **'Recent workouts'**
  String get progressRecentSessions;

  /// No description provided for @progressViewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get progressViewAll;

  /// No description provided for @progressReps.
  ///
  /// In en, this message translates to:
  /// **'Repetitions'**
  String get progressReps;

  /// No description provided for @progressSets.
  ///
  /// In en, this message translates to:
  /// **'Sets'**
  String get progressSets;

  /// No description provided for @progressVolume.
  ///
  /// In en, this message translates to:
  /// **'Volume'**
  String get progressVolume;

  /// No description provided for @progressNoMeasurements.
  ///
  /// In en, this message translates to:
  /// **'No measurements have been logged.'**
  String get progressNoMeasurements;

  /// No description provided for @progressNoRecords.
  ///
  /// In en, this message translates to:
  /// **'No personal records yet.'**
  String get progressNoRecords;

  /// No description provided for @progressWeightUnitKg.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get progressWeightUnitKg;

  /// No description provided for @progressWeightUnitLb.
  ///
  /// In en, this message translates to:
  /// **'lb'**
  String get progressWeightUnitLb;

  /// No description provided for @progressTrendDescription.
  ///
  /// In en, this message translates to:
  /// **'Your progress is calculated from saved workouts and sets.'**
  String get progressTrendDescription;

  /// No description provided for @progressGoalStatusComplete.
  ///
  /// In en, this message translates to:
  /// **'Goal complete'**
  String get progressGoalStatusComplete;

  /// No description provided for @progressGoalStatusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get progressGoalStatusInProgress;

  /// No description provided for @progressSessionCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 workout} other{{count} workouts}}'**
  String progressSessionCount(num count);

  /// No description provided for @onboardingUpperBody.
  ///
  /// In en, this message translates to:
  /// **'Upper body'**
  String get onboardingUpperBody;

  /// No description provided for @onboardingLowerBody.
  ///
  /// In en, this message translates to:
  /// **'Lower body'**
  String get onboardingLowerBody;

  /// No description provided for @onboardingFullBody.
  ///
  /// In en, this message translates to:
  /// **'Full body'**
  String get onboardingFullBody;

  /// No description provided for @accountPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your password.'**
  String get accountPasswordRequired;

  /// No description provided for @accountContinueAction.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get accountContinueAction;

  /// No description provided for @profileYourInformation.
  ///
  /// In en, this message translates to:
  /// **'Your information'**
  String get profileYourInformation;

  /// No description provided for @profileUpdateInformation.
  ///
  /// In en, this message translates to:
  /// **'Update the information shown on your profile.'**
  String get profileUpdateInformation;

  /// No description provided for @profileNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your name.'**
  String get profileNameRequired;

  /// No description provided for @profileNameTooLong.
  ///
  /// In en, this message translates to:
  /// **'Name must be 80 characters or fewer.'**
  String get profileNameTooLong;

  /// No description provided for @profileUseGoogleName.
  ///
  /// In en, this message translates to:
  /// **'Use Google name'**
  String get profileUseGoogleName;

  /// No description provided for @profileNameLocalNote.
  ///
  /// In en, this message translates to:
  /// **'This display name is saved on this device only.'**
  String get profileNameLocalNote;

  /// No description provided for @profileShowNavigationLabels.
  ///
  /// In en, this message translates to:
  /// **'Show navigation labels'**
  String get profileShowNavigationLabels;

  /// No description provided for @profileShowNavigationLabelsHint.
  ///
  /// In en, this message translates to:
  /// **'Show each section name below its icon.'**
  String get profileShowNavigationLabelsHint;

  /// No description provided for @profileEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address.'**
  String get profileEmailInvalid;

  /// No description provided for @profileGoalRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a goal.'**
  String get profileGoalRequired;

  /// No description provided for @settingsThemeDescription.
  ///
  /// In en, this message translates to:
  /// **'Use your device theme or choose one for FORZA.'**
  String get settingsThemeDescription;

  /// No description provided for @profileTailoredTitle.
  ///
  /// In en, this message translates to:
  /// **'Made for you'**
  String get profileTailoredTitle;

  /// No description provided for @profileTailoredDescription.
  ///
  /// In en, this message translates to:
  /// **'Adjust units and how FORZA organizes your week.'**
  String get profileTailoredDescription;

  /// No description provided for @onboardingPreferencesLater.
  ///
  /// In en, this message translates to:
  /// **'You can change these preferences later in Profile.'**
  String get onboardingPreferencesLater;

  /// No description provided for @profileKilograms.
  ///
  /// In en, this message translates to:
  /// **'Kilograms (kg)'**
  String get profileKilograms;

  /// No description provided for @profilePounds.
  ///
  /// In en, this message translates to:
  /// **'Pounds (lb)'**
  String get profilePounds;

  /// No description provided for @profileHapticDescription.
  ///
  /// In en, this message translates to:
  /// **'Gentle vibration when using supported controls.'**
  String get profileHapticDescription;

  /// No description provided for @profileNotificationsHeading.
  ///
  /// In en, this message translates to:
  /// **'Get only what matters.'**
  String get profileNotificationsHeading;

  /// No description provided for @profileNotificationsDescription.
  ///
  /// In en, this message translates to:
  /// **'Reminders use your schedule and need device permission.'**
  String get profileNotificationsDescription;

  /// No description provided for @profilePrivacyPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy and account'**
  String get profilePrivacyPageTitle;

  /// No description provided for @profilePrivacyHeading.
  ///
  /// In en, this message translates to:
  /// **'You decide what to share.'**
  String get profilePrivacyHeading;

  /// No description provided for @profilePrivacyDescription.
  ///
  /// In en, this message translates to:
  /// **'Your privacy preferences.'**
  String get profilePrivacyDescription;

  /// No description provided for @profileAccountData.
  ///
  /// In en, this message translates to:
  /// **'Account details'**
  String get profileAccountData;

  /// No description provided for @cloudSyncTitle.
  ///
  /// In en, this message translates to:
  /// **'Cloud sync'**
  String get cloudSyncTitle;

  /// No description provided for @cloudSyncDescription.
  ///
  /// In en, this message translates to:
  /// **'Sync is optional. Your data stays available offline and is sent to your private Firestore account only after you turn sync on.'**
  String get cloudSyncDescription;

  /// No description provided for @cloudSyncToggleTitle.
  ///
  /// In en, this message translates to:
  /// **'Sync my data'**
  String get cloudSyncToggleTitle;

  /// No description provided for @cloudSyncToggleDescription.
  ///
  /// In en, this message translates to:
  /// **'Includes your plan, schedule, workouts, sets, goals, measurements, and app settings.'**
  String get cloudSyncToggleDescription;

  /// No description provided for @cloudSyncStatusHeading.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get cloudSyncStatusHeading;

  /// No description provided for @cloudSyncStatusSignedOut.
  ///
  /// In en, this message translates to:
  /// **'Sign in to sync.'**
  String get cloudSyncStatusSignedOut;

  /// No description provided for @cloudSyncStatusDisabled.
  ///
  /// In en, this message translates to:
  /// **'Off · changes are saved on this device only.'**
  String get cloudSyncStatusDisabled;

  /// No description provided for @cloudSyncStatusSyncing.
  ///
  /// In en, this message translates to:
  /// **'Syncing your data…'**
  String get cloudSyncStatusSyncing;

  /// No description provided for @cloudSyncStatusSynced.
  ///
  /// In en, this message translates to:
  /// **'Everything is up to date.'**
  String get cloudSyncStatusSynced;

  /// No description provided for @cloudSyncStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Changes are waiting to sync.'**
  String get cloudSyncStatusPending;

  /// No description provided for @cloudSyncStatusFailed.
  ///
  /// In en, this message translates to:
  /// **'Sync failed. You can try again.'**
  String get cloudSyncStatusFailed;

  /// No description provided for @cloudSyncAccount.
  ///
  /// In en, this message translates to:
  /// **'Connected account'**
  String get cloudSyncAccount;

  /// No description provided for @cloudSyncStatusOffline.
  ///
  /// In en, this message translates to:
  /// **'Offline. Changes are pending until the connection returns.'**
  String get cloudSyncStatusOffline;

  /// No description provided for @cloudSyncFrequency.
  ///
  /// In en, this message translates to:
  /// **'Sync frequency'**
  String get cloudSyncFrequency;

  /// No description provided for @cloudSyncFrequencyChanges.
  ///
  /// In en, this message translates to:
  /// **'When changes are detected'**
  String get cloudSyncFrequencyChanges;

  /// No description provided for @cloudSyncFrequencyDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get cloudSyncFrequencyDaily;

  /// No description provided for @cloudSyncFrequencyWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get cloudSyncFrequencyWeekly;

  /// No description provided for @cloudSyncFrequencyMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get cloudSyncFrequencyMonthly;

  /// No description provided for @cloudSyncFrequencyManual.
  ///
  /// In en, this message translates to:
  /// **'Manual only'**
  String get cloudSyncFrequencyManual;

  /// No description provided for @cloudSyncFrequencyNote.
  ///
  /// In en, this message translates to:
  /// **'Automatic intervals are targets while the app can run and a connection is available. The OS may pause it; sync is not guaranteed while the app is closed. Manual only never uploads changes automatically.'**
  String get cloudSyncFrequencyNote;

  /// No description provided for @cloudSyncFrequencySaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not save the frequency. Try again.'**
  String get cloudSyncFrequencySaveFailed;

  /// No description provided for @cloudSyncNow.
  ///
  /// In en, this message translates to:
  /// **'Sync now'**
  String get cloudSyncNow;

  /// No description provided for @cloudSyncIncludedHeading.
  ///
  /// In en, this message translates to:
  /// **'Included data'**
  String get cloudSyncIncludedHeading;

  /// No description provided for @cloudSyncIncludedDescription.
  ///
  /// In en, this message translates to:
  /// **'Training plan and days, schedule, workout and set history, goals, saved measurements, active session, appearance, language and preferences, reminders, and privacy settings. Local file export and import remain available separately under Backup.'**
  String get cloudSyncIncludedDescription;

  /// No description provided for @cloudSyncNutritionTitle.
  ///
  /// In en, this message translates to:
  /// **'Sync nutrition data'**
  String get cloudSyncNutritionTitle;

  /// No description provided for @cloudSyncNutritionDescription.
  ///
  /// In en, this message translates to:
  /// **'Off by default. If enabled, your nutrition profile preferences and meal history are copied to your private Firestore account. Turning this off stops future sync; your local data stays on this device. Delete an existing cloud copy below when you want it removed.'**
  String get cloudSyncNutritionDescription;

  /// No description provided for @cloudSyncNutritionConsentTitle.
  ///
  /// In en, this message translates to:
  /// **'Sync nutrition data?'**
  String get cloudSyncNutritionConsentTitle;

  /// No description provided for @cloudSyncNutritionConsentDescription.
  ///
  /// In en, this message translates to:
  /// **'This sends your food preferences, exclusions, and recorded meals to the private Firestore backup for this account. These data are not sent to analytics. You can revoke this choice later.'**
  String get cloudSyncNutritionConsentDescription;

  /// No description provided for @cloudSyncNutritionConsentAccept.
  ///
  /// In en, this message translates to:
  /// **'Allow nutrition sync'**
  String get cloudSyncNutritionConsentAccept;

  /// No description provided for @cloudSyncNutritionSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not update nutrition sync consent.'**
  String get cloudSyncNutritionSaveFailed;

  /// No description provided for @cloudSyncNutritionDeleteButton.
  ///
  /// In en, this message translates to:
  /// **'Delete nutrition copy from cloud'**
  String get cloudSyncNutritionDeleteButton;

  /// No description provided for @cloudSyncNutritionDeleteHint.
  ///
  /// In en, this message translates to:
  /// **'This only deletes the nutrition copy from Firestore. Other synced data and your local profile and history are kept.'**
  String get cloudSyncNutritionDeleteHint;

  /// No description provided for @cloudSyncNutritionDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete cloud nutrition data?'**
  String get cloudSyncNutritionDeleteConfirmTitle;

  /// No description provided for @cloudSyncNutritionDeleteConfirmDescription.
  ///
  /// In en, this message translates to:
  /// **'This removes nutrition data from this account\'s Firestore backup. Your on-device profile and meal history remain.'**
  String get cloudSyncNutritionDeleteConfirmDescription;

  /// No description provided for @cloudSyncNutritionDeleted.
  ///
  /// In en, this message translates to:
  /// **'Nutrition data was removed from the cloud backup.'**
  String get cloudSyncNutritionDeleted;

  /// No description provided for @cloudSyncNutritionNoRemoteData.
  ///
  /// In en, this message translates to:
  /// **'No nutrition data was present in the cloud backup.'**
  String get cloudSyncNutritionNoRemoteData;

  /// No description provided for @cloudSyncNutritionDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not remove nutrition data from the cloud. Check your connection and try again.'**
  String get cloudSyncNutritionDeleteFailed;

  /// No description provided for @cloudSyncLastSync.
  ///
  /// In en, this message translates to:
  /// **'Last sync'**
  String get cloudSyncLastSync;

  /// No description provided for @cloudSyncRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry now'**
  String get cloudSyncRetry;

  /// No description provided for @cloudSyncConsentTitle.
  ///
  /// In en, this message translates to:
  /// **'Turn on sync'**
  String get cloudSyncConsentTitle;

  /// No description provided for @cloudSyncConsentDescription.
  ///
  /// In en, this message translates to:
  /// **'A copy of your plan and schedule, workouts and sets, goals, measurements, active workout, appearance and preferences, notifications, and privacy settings will be uploaded to your private Firestore account. Existing cloud and local data will be combined, keeping your local version when records conflict. You can turn sync off later.'**
  String get cloudSyncConsentDescription;

  /// No description provided for @cloudSyncConsentAccept.
  ///
  /// In en, this message translates to:
  /// **'Turn on and sync'**
  String get cloudSyncConsentAccept;

  /// No description provided for @cloudSyncEnableFailed.
  ///
  /// In en, this message translates to:
  /// **'Sync could not be enabled. Try again.'**
  String get cloudSyncEnableFailed;

  /// No description provided for @cloudSyncDisableTitle.
  ///
  /// In en, this message translates to:
  /// **'Turn off sync'**
  String get cloudSyncDisableTitle;

  /// No description provided for @cloudSyncDisableDescription.
  ///
  /// In en, this message translates to:
  /// **'New changes will stay on this device. The existing cloud copy will not be deleted.'**
  String get cloudSyncDisableDescription;

  /// No description provided for @cloudSyncDisableButton.
  ///
  /// In en, this message translates to:
  /// **'Turn off'**
  String get cloudSyncDisableButton;

  /// No description provided for @cloudSyncDeleteSection.
  ///
  /// In en, this message translates to:
  /// **'Cloud copy'**
  String get cloudSyncDeleteSection;

  /// No description provided for @cloudSyncDeleteDescription.
  ///
  /// In en, this message translates to:
  /// **'Deletes your Firestore profile and synced copy. Your local data and Google account stay in place.'**
  String get cloudSyncDeleteDescription;

  /// No description provided for @cloudSyncDeleteButton.
  ///
  /// In en, this message translates to:
  /// **'Delete cloud copy'**
  String get cloudSyncDeleteButton;

  /// No description provided for @cloudSyncDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete your cloud copy?'**
  String get cloudSyncDeleteTitle;

  /// No description provided for @cloudSyncDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'This removes your Firestore profile and all synced data. Data on this device and your Google account will be kept.'**
  String get cloudSyncDeleteConfirm;

  /// No description provided for @cloudSyncDeleteCompleted.
  ///
  /// In en, this message translates to:
  /// **'The Firestore copy was deleted. Local data was kept.'**
  String get cloudSyncDeleteCompleted;

  /// No description provided for @cloudSyncDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'The cloud copy could not be deleted. Check your connection and try again.'**
  String get cloudSyncDeleteFailed;

  /// No description provided for @profileConfirmHeading.
  ///
  /// In en, this message translates to:
  /// **'Confirm your details'**
  String get profileConfirmHeading;

  /// No description provided for @profileConfirmDescription.
  ///
  /// In en, this message translates to:
  /// **'Review this information before returning to your profile.'**
  String get profileConfirmDescription;

  /// No description provided for @backupInvalid.
  ///
  /// In en, this message translates to:
  /// **'The backup is invalid or damaged. Check the file and try again.'**
  String get backupInvalid;

  /// No description provided for @profileRecordsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Alerts when you reach a new record.'**
  String get profileRecordsSubtitle;

  /// No description provided for @progressTitle.
  ///
  /// In en, this message translates to:
  /// **'Your progress'**
  String get progressTitle;

  /// No description provided for @progressSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your consistency, in perspective.'**
  String get progressSubtitle;

  /// No description provided for @progressLast30Days.
  ///
  /// In en, this message translates to:
  /// **'Last 30 days'**
  String get progressLast30Days;

  /// No description provided for @progressNoHistoryInPeriod.
  ///
  /// In en, this message translates to:
  /// **'No workouts in this period.'**
  String get progressNoHistoryInPeriod;

  /// No description provided for @progressLastWorkout.
  ///
  /// In en, this message translates to:
  /// **'Last workout · {date}'**
  String progressLastWorkout(Object date);

  /// No description provided for @progressGoToActivity.
  ///
  /// In en, this message translates to:
  /// **'Go to Activity'**
  String get progressGoToActivity;

  /// No description provided for @progressNoSetData.
  ///
  /// In en, this message translates to:
  /// **'No sets logged'**
  String get progressNoSetData;

  /// No description provided for @progressWeightChange.
  ///
  /// In en, this message translates to:
  /// **'Change since previous measurement: {change} kg'**
  String progressWeightChange(String change);

  /// No description provided for @progressRecentRecord.
  ///
  /// In en, this message translates to:
  /// **'Recent record · {exercise}: {value} {unit} · {date}'**
  String progressRecentRecord(
    String exercise,
    String value,
    String unit,
    String date,
  );

  /// No description provided for @progressSessions.
  ///
  /// In en, this message translates to:
  /// **'workouts'**
  String get progressSessions;

  /// No description provided for @progressTimeTotal.
  ///
  /// In en, this message translates to:
  /// **'{hours} hr {minutes} min'**
  String progressTimeTotal(Object hours, Object minutes);

  /// No description provided for @progressSetsAndReps.
  ///
  /// In en, this message translates to:
  /// **'{sets} sets · {reps} reps'**
  String progressSetsAndReps(Object reps, Object sets);

  /// No description provided for @progressVolumeExplanation.
  ///
  /// In en, this message translates to:
  /// **'Volume adds reps × weight for sets that include both values.'**
  String get progressVolumeExplanation;

  /// No description provided for @progressAddGoal.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get progressAddGoal;

  /// No description provided for @progressGoalDescription.
  ///
  /// In en, this message translates to:
  /// **'Set a weekly goal or a weight target to track your progress.'**
  String get progressGoalDescription;

  /// No description provided for @progressLoadGoal.
  ///
  /// In en, this message translates to:
  /// **'Weight goal'**
  String get progressLoadGoal;

  /// No description provided for @progressGoalCurrentTarget.
  ///
  /// In en, this message translates to:
  /// **'{current} of {target} {unit}'**
  String progressGoalCurrentTarget(Object current, Object target, Object unit);

  /// No description provided for @progressWeeklyGoalDescription.
  ///
  /// In en, this message translates to:
  /// **'Workouts completed Monday through Sunday.'**
  String get progressWeeklyGoalDescription;

  /// No description provided for @progressLoadGoalDescription.
  ///
  /// In en, this message translates to:
  /// **'Heaviest weight recorded in your sets for this exercise.'**
  String get progressLoadGoalDescription;

  /// No description provided for @progressSessionSemantics.
  ///
  /// In en, this message translates to:
  /// **'{title}, {date}'**
  String progressSessionSemantics(Object date, Object title);

  /// No description provided for @progressHistorySummary.
  ///
  /// In en, this message translates to:
  /// **'{date} · {minutes} min · {count} exercises{volume}'**
  String progressHistorySummary(
    Object count,
    Object date,
    Object minutes,
    Object volume,
  );

  /// No description provided for @progressNoLoadData.
  ///
  /// In en, this message translates to:
  /// **'No weight data'**
  String get progressNoLoadData;

  /// No description provided for @progressVolumeKg.
  ///
  /// In en, this message translates to:
  /// **'{value} kg'**
  String progressVolumeKg(Object value);

  /// No description provided for @progressGoalEditorDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose a goal you can track in FORZA.'**
  String get progressGoalEditorDescription;

  /// No description provided for @progressTargetLoad.
  ///
  /// In en, this message translates to:
  /// **'Target weight'**
  String get progressTargetLoad;

  /// No description provided for @progressSessionsUnit.
  ///
  /// In en, this message translates to:
  /// **'workouts'**
  String get progressSessionsUnit;

  /// No description provided for @progressExerciseNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter the exercise name as it appears in your workout.'**
  String get progressExerciseNameRequired;

  /// No description provided for @progressPositiveValueRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a value greater than zero.'**
  String get progressPositiveValueRequired;

  /// No description provided for @progressWeeklyTargetRange.
  ///
  /// In en, this message translates to:
  /// **'Choose between 1 and 7 whole workouts.'**
  String get progressWeeklyTargetRange;

  /// No description provided for @progressSessionDetail.
  ///
  /// In en, this message translates to:
  /// **'Workout details'**
  String get progressSessionDetail;

  /// No description provided for @progressOutsideAppNote.
  ///
  /// In en, this message translates to:
  /// **'You marked this workout as completed outside FORZA. Exercise and weight details aren\'t available.'**
  String get progressOutsideAppNote;

  /// No description provided for @progressExerciseHeading.
  ///
  /// In en, this message translates to:
  /// **'Exercises · {count}'**
  String progressExerciseHeading(Object count);

  /// No description provided for @progressStrengthEvolution.
  ///
  /// In en, this message translates to:
  /// **'Strength progress'**
  String get progressStrengthEvolution;

  /// No description provided for @progressStrengthHeadline.
  ///
  /// In en, this message translates to:
  /// **'Build strength, one step at a time.'**
  String get progressStrengthHeadline;

  /// No description provided for @progressStrengthDescription.
  ///
  /// In en, this message translates to:
  /// **'Compare the heaviest logged load per workout for each exercise.'**
  String get progressStrengthDescription;

  /// No description provided for @progressWorkingWeight.
  ///
  /// In en, this message translates to:
  /// **'Working weight (kg)'**
  String get progressWorkingWeight;

  /// No description provided for @progressStrengthChartSummary.
  ///
  /// In en, this message translates to:
  /// **'The load changed from {start} to {current} kilograms across {sessions} logged workouts.'**
  String progressStrengthChartSummary(
    String start,
    String current,
    int sessions,
  );

  /// No description provided for @progressStrengthMetric.
  ///
  /// In en, this message translates to:
  /// **'Heaviest weight logged per workout (kg). Sets without a load are excluded.'**
  String get progressStrengthMetric;

  /// No description provided for @progressStrengthSinglePoint.
  ///
  /// In en, this message translates to:
  /// **'Only one workout has a logged load for this exercise.'**
  String get progressStrengthSinglePoint;

  /// No description provided for @progressStrengthEmpty.
  ///
  /// In en, this message translates to:
  /// **'There are no weighted sets for this period. Log the weight used for your sets during a workout.'**
  String get progressStrengthEmpty;

  /// No description provided for @progressStrengthChange.
  ///
  /// In en, this message translates to:
  /// **'Change between the first and last workout: {sign}{change} kg.'**
  String progressStrengthChange(String sign, String change);

  /// No description provided for @progressPeriodLabel.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get progressPeriodLabel;

  /// No description provided for @progressPeriod30Days.
  ///
  /// In en, this message translates to:
  /// **'30 days'**
  String get progressPeriod30Days;

  /// No description provided for @progressPeriod90Days.
  ///
  /// In en, this message translates to:
  /// **'90 days'**
  String get progressPeriod90Days;

  /// No description provided for @progressPeriodYear.
  ///
  /// In en, this message translates to:
  /// **'1 year'**
  String get progressPeriodYear;

  /// No description provided for @progressPeriodAll.
  ///
  /// In en, this message translates to:
  /// **'All time'**
  String get progressPeriodAll;

  /// No description provided for @progressBodyEvolution.
  ///
  /// In en, this message translates to:
  /// **'Body measurements'**
  String get progressBodyEvolution;

  /// No description provided for @progressBodyHeadline.
  ///
  /// In en, this message translates to:
  /// **'Changes you can track.'**
  String get progressBodyHeadline;

  /// No description provided for @progressBodyDescription.
  ///
  /// In en, this message translates to:
  /// **'Measurements are for reference, not targets.'**
  String get progressBodyDescription;

  /// No description provided for @progressWeightChartSummary.
  ///
  /// In en, this message translates to:
  /// **'Body weight changed from {start} to {current} kilograms.'**
  String progressWeightChartSummary(Object current, Object start);

  /// No description provided for @progressMeasurementHeadline.
  ///
  /// In en, this message translates to:
  /// **'Log your progress.'**
  String get progressMeasurementHeadline;

  /// No description provided for @progressMeasurementDescription.
  ///
  /// In en, this message translates to:
  /// **'Weight is required. Other measurements are optional.'**
  String get progressMeasurementDescription;

  /// No description provided for @progressMeasurementsSavedNote.
  ///
  /// In en, this message translates to:
  /// **'Your measurements are saved on this device.'**
  String get progressMeasurementsSavedNote;

  /// No description provided for @progressMeasurementsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No measurements yet. Log your weight and measurements to track changes over time.'**
  String get progressMeasurementsEmpty;

  /// No description provided for @progressEditMeasurement.
  ///
  /// In en, this message translates to:
  /// **'Edit measurement'**
  String get progressEditMeasurement;

  /// No description provided for @progressDeleteMeasurement.
  ///
  /// In en, this message translates to:
  /// **'Delete measurement'**
  String get progressDeleteMeasurement;

  /// No description provided for @progressDeleteMeasurementTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete entry'**
  String get progressDeleteMeasurementTitle;

  /// No description provided for @progressDeleteMeasurementBody.
  ///
  /// In en, this message translates to:
  /// **'Do you want to remove the measurements from this day? This cannot be undone.'**
  String get progressDeleteMeasurementBody;

  /// No description provided for @progressSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'The entry could not be saved. Try again.'**
  String get progressSaveFailed;

  /// No description provided for @progressValueRange.
  ///
  /// In en, this message translates to:
  /// **'Allowed range: {minimum}–{maximum} {unit}'**
  String progressValueRange(Object maximum, Object minimum, Object unit);

  /// No description provided for @progressInvalidValue.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid value.'**
  String get progressInvalidValue;

  /// No description provided for @progressWeightRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your body weight.'**
  String get progressWeightRequired;

  /// No description provided for @progressRecordsHeadline.
  ///
  /// In en, this message translates to:
  /// **'Your bests.'**
  String get progressRecordsHeadline;

  /// No description provided for @progressRecordsDescription.
  ///
  /// In en, this message translates to:
  /// **'Records calculated from your saved sets, with date and unit. Ties keep the first date.'**
  String get progressRecordsDescription;

  /// No description provided for @progressRecordsEmpty.
  ///
  /// In en, this message translates to:
  /// **'There are no records yet. Log repetitions, load, or duration in a set to get started.'**
  String get progressRecordsEmpty;

  /// No description provided for @progressRecordNoMeasurements.
  ///
  /// In en, this message translates to:
  /// **'Body weight'**
  String get progressRecordNoMeasurements;

  /// No description provided for @progressKilograms.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get progressKilograms;

  /// No description provided for @progressRepetitionsUnit.
  ///
  /// In en, this message translates to:
  /// **'reps'**
  String get progressRepetitionsUnit;

  /// No description provided for @progressSecondsUnit.
  ///
  /// In en, this message translates to:
  /// **'s'**
  String get progressSecondsUnit;

  /// No description provided for @progressSetSummary.
  ///
  /// In en, this message translates to:
  /// **'Set {number} · {values}'**
  String progressSetSummary(Object number, Object values);

  /// No description provided for @progressMinutesUnit.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get progressMinutesUnit;

  /// No description provided for @progressChangeFromStart.
  ///
  /// In en, this message translates to:
  /// **'Change from start'**
  String get progressChangeFromStart;

  /// No description provided for @progressDateFormatShort.
  ///
  /// In en, this message translates to:
  /// **'{date}'**
  String progressDateFormatShort(Object date);

  /// No description provided for @sessionBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get sessionBack;

  /// No description provided for @sessionBackStep.
  ///
  /// In en, this message translates to:
  /// **'Back to previous step'**
  String get sessionBackStep;

  /// No description provided for @sessionTitlePreparation.
  ///
  /// In en, this message translates to:
  /// **'Getting ready'**
  String get sessionTitlePreparation;

  /// No description provided for @sessionTitleWarmup.
  ///
  /// In en, this message translates to:
  /// **'Warm-up'**
  String get sessionTitleWarmup;

  /// No description provided for @sessionTitleWorkout.
  ///
  /// In en, this message translates to:
  /// **'Your workout'**
  String get sessionTitleWorkout;

  /// No description provided for @sessionTitleRest.
  ///
  /// In en, this message translates to:
  /// **'Rest'**
  String get sessionTitleRest;

  /// No description provided for @sessionTitlePaused.
  ///
  /// In en, this message translates to:
  /// **'Workout paused'**
  String get sessionTitlePaused;

  /// No description provided for @sessionTitleConfirmAbandon.
  ///
  /// In en, this message translates to:
  /// **'Confirm leaving'**
  String get sessionTitleConfirmAbandon;

  /// No description provided for @sessionTitleCompleted.
  ///
  /// In en, this message translates to:
  /// **'Workout complete'**
  String get sessionTitleCompleted;

  /// No description provided for @sessionTitleCooldown.
  ///
  /// In en, this message translates to:
  /// **'Cool-down'**
  String get sessionTitleCooldown;

  /// No description provided for @sessionTitleSummary.
  ///
  /// In en, this message translates to:
  /// **'Workout summary'**
  String get sessionTitleSummary;

  /// No description provided for @sessionWarmupHeadline.
  ///
  /// In en, this message translates to:
  /// **'Get your body ready'**
  String get sessionWarmupHeadline;

  /// No description provided for @sessionWarmupDescription.
  ///
  /// In en, this message translates to:
  /// **'Brief movements for {session}. Keep a comfortable pace; you can skip them whenever you like.'**
  String sessionWarmupDescription(Object session);

  /// No description provided for @warmupShoulderCircles.
  ///
  /// In en, this message translates to:
  /// **'Shoulder circles'**
  String get warmupShoulderCircles;

  /// No description provided for @warmupShoulderCirclesInstructions.
  ///
  /// In en, this message translates to:
  /// **'Make gentle circles forward and backward.'**
  String get warmupShoulderCirclesInstructions;

  /// No description provided for @warmupThoracicRotation.
  ///
  /// In en, this message translates to:
  /// **'Thoracic rotation'**
  String get warmupThoracicRotation;

  /// No description provided for @warmupThoracicInstructions.
  ///
  /// In en, this message translates to:
  /// **'Rotate your torso without straining your neck.'**
  String get warmupThoracicInstructions;

  /// No description provided for @warmupInclinePushups.
  ///
  /// In en, this message translates to:
  /// **'Incline push-ups'**
  String get warmupInclinePushups;

  /// No description provided for @warmupInclineInstructions.
  ///
  /// In en, this message translates to:
  /// **'Place your hands on a sturdy surface and move with control.'**
  String get warmupInclineInstructions;

  /// No description provided for @warmupMarch.
  ///
  /// In en, this message translates to:
  /// **'March in place'**
  String get warmupMarch;

  /// No description provided for @warmupMarchInstructions.
  ///
  /// In en, this message translates to:
  /// **'Raise your knees at a comfortable pace.'**
  String get warmupMarchInstructions;

  /// No description provided for @warmupHipHinge.
  ///
  /// In en, this message translates to:
  /// **'Hip hinge'**
  String get warmupHipHinge;

  /// No description provided for @warmupHipHingeInstructions.
  ///
  /// In en, this message translates to:
  /// **'Move your hips back while keeping your back comfortable.'**
  String get warmupHipHingeInstructions;

  /// No description provided for @warmupBodyweightSquat.
  ///
  /// In en, this message translates to:
  /// **'Bodyweight squat'**
  String get warmupBodyweightSquat;

  /// No description provided for @warmupBodyweightSquatInstructions.
  ///
  /// In en, this message translates to:
  /// **'Lower only as far as you can control.'**
  String get warmupBodyweightSquatInstructions;

  /// No description provided for @warmupMarchArms.
  ///
  /// In en, this message translates to:
  /// **'March with arm swings'**
  String get warmupMarchArms;

  /// No description provided for @warmupMarchArmsInstructions.
  ///
  /// In en, this message translates to:
  /// **'March in place and swing your arms with the movement.'**
  String get warmupMarchArmsInstructions;

  /// No description provided for @warmupTorsoRotations.
  ///
  /// In en, this message translates to:
  /// **'Torso rotations'**
  String get warmupTorsoRotations;

  /// No description provided for @warmupTorsoInstructions.
  ///
  /// In en, this message translates to:
  /// **'Rotate gently from side to side without bouncing.'**
  String get warmupTorsoInstructions;

  /// No description provided for @warmupThirtySeconds.
  ///
  /// In en, this message translates to:
  /// **'30 sec'**
  String get warmupThirtySeconds;

  /// No description provided for @warmupThirtySecondsEachSide.
  ///
  /// In en, this message translates to:
  /// **'30 sec per side'**
  String get warmupThirtySecondsEachSide;

  /// No description provided for @warmupFortyFiveSeconds.
  ///
  /// In en, this message translates to:
  /// **'45 sec'**
  String get warmupFortyFiveSeconds;

  /// No description provided for @warmupEightReps.
  ///
  /// In en, this message translates to:
  /// **'8 reps'**
  String get warmupEightReps;

  /// No description provided for @sessionPreparationHeadline.
  ///
  /// In en, this message translates to:
  /// **'Ready to begin'**
  String get sessionPreparationHeadline;

  /// No description provided for @sessionPreparationDescription.
  ///
  /// In en, this message translates to:
  /// **'Take a moment to prepare your space and review today\'s workout.'**
  String get sessionPreparationDescription;

  /// No description provided for @sessionDraftReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Review saved workout'**
  String get sessionDraftReviewTitle;

  /// No description provided for @sessionDraftReviewDateMismatch.
  ///
  /// In en, this message translates to:
  /// **'There is a saved workout from {date}. You can resume it with its original routine or discard it to start the selected session.'**
  String sessionDraftReviewDateMismatch(String date);

  /// No description provided for @sessionDraftReviewLegacy.
  ///
  /// In en, this message translates to:
  /// **'This draft is from an older version and did not save the exact routine. You can continue using the current routine; your partial logs will be kept. You can also discard it.'**
  String get sessionDraftReviewLegacy;

  /// No description provided for @sessionDraftReviewCorrupt.
  ///
  /// In en, this message translates to:
  /// **'The saved draft cannot be read. It will be kept until you choose to discard it and start a new session.'**
  String get sessionDraftReviewCorrupt;

  /// No description provided for @sessionContinueSavedWorkout.
  ///
  /// In en, this message translates to:
  /// **'Continue saved workout'**
  String get sessionContinueSavedWorkout;

  /// No description provided for @sessionContinueWithCurrentPlan.
  ///
  /// In en, this message translates to:
  /// **'Continue with current routine'**
  String get sessionContinueWithCurrentPlan;

  /// No description provided for @sessionDiscardWorkoutDraft.
  ///
  /// In en, this message translates to:
  /// **'Discard draft and start this session'**
  String get sessionDiscardWorkoutDraft;

  /// No description provided for @sessionRestoredOriginalPlan.
  ///
  /// In en, this message translates to:
  /// **'The original saved routine was restored so each set stays linked to the same exercise.'**
  String get sessionRestoredOriginalPlan;

  /// No description provided for @sessionUnknownDate.
  ///
  /// In en, this message translates to:
  /// **'another date'**
  String get sessionUnknownDate;

  /// No description provided for @sessionWaterBottle.
  ///
  /// In en, this message translates to:
  /// **'Water bottle'**
  String get sessionWaterBottle;

  /// No description provided for @sessionClearSpace.
  ///
  /// In en, this message translates to:
  /// **'Clear space'**
  String get sessionClearSpace;

  /// No description provided for @sessionEquipmentReady.
  ///
  /// In en, this message translates to:
  /// **'Equipment ready'**
  String get sessionEquipmentReady;

  /// No description provided for @sessionExerciseHeadline.
  ///
  /// In en, this message translates to:
  /// **'Keep going'**
  String get sessionExerciseHeadline;

  /// No description provided for @sessionExerciseCountProgress.
  ///
  /// In en, this message translates to:
  /// **'Exercise {current} of {total}'**
  String sessionExerciseCountProgress(Object current, Object total);

  /// No description provided for @sessionSetsProgress.
  ///
  /// In en, this message translates to:
  /// **'{current} of {total} sets completed'**
  String sessionSetsProgress(int current, int total);

  /// No description provided for @sessionViewRoutine.
  ///
  /// In en, this message translates to:
  /// **'View routine'**
  String get sessionViewRoutine;

  /// No description provided for @sessionRoutineTitle.
  ///
  /// In en, this message translates to:
  /// **'This session\'s routine'**
  String get sessionRoutineTitle;

  /// No description provided for @sessionRoutineDescription.
  ///
  /// In en, this message translates to:
  /// **'Review every exercise. You can open the current or a previous exercise; upcoming ones unlock as you progress.'**
  String get sessionRoutineDescription;

  /// No description provided for @sessionRoutineCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get sessionRoutineCompleted;

  /// No description provided for @sessionRoutineCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get sessionRoutineCurrent;

  /// No description provided for @sessionRoutinePending.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get sessionRoutinePending;

  /// No description provided for @sessionCloseRoutine.
  ///
  /// In en, this message translates to:
  /// **'Close routine'**
  String get sessionCloseRoutine;

  /// No description provided for @sessionSetLog.
  ///
  /// In en, this message translates to:
  /// **'Set log'**
  String get sessionSetLog;

  /// No description provided for @sessionNextSet.
  ///
  /// In en, this message translates to:
  /// **'Next set'**
  String get sessionNextSet;

  /// No description provided for @sessionCompleteSetAction.
  ///
  /// In en, this message translates to:
  /// **'Complete set'**
  String get sessionCompleteSetAction;

  /// No description provided for @sessionUndoSet.
  ///
  /// In en, this message translates to:
  /// **'Unmark set'**
  String get sessionUndoSet;

  /// No description provided for @sessionPreviousSetSuggestion.
  ///
  /// In en, this message translates to:
  /// **'Suggestion from previous set'**
  String get sessionPreviousSetSuggestion;

  /// No description provided for @sessionRestHeadline.
  ///
  /// In en, this message translates to:
  /// **'Take a breather'**
  String get sessionRestHeadline;

  /// No description provided for @sessionRestBetweenSets.
  ///
  /// In en, this message translates to:
  /// **'Rest between sets'**
  String get sessionRestBetweenSets;

  /// No description provided for @sessionRestBetweenExercises.
  ///
  /// In en, this message translates to:
  /// **'Exercise changeover'**
  String get sessionRestBetweenExercises;

  /// No description provided for @sessionRestDuration.
  ///
  /// In en, this message translates to:
  /// **'Rest duration'**
  String get sessionRestDuration;

  /// No description provided for @sessionNextSetAfterRest.
  ///
  /// In en, this message translates to:
  /// **'Next: set {number}'**
  String sessionNextSetAfterRest(int number);

  /// No description provided for @sessionStartWhenReady.
  ///
  /// In en, this message translates to:
  /// **'Start when you’re ready'**
  String get sessionStartWhenReady;

  /// No description provided for @sessionBeforeExercise.
  ///
  /// In en, this message translates to:
  /// **'Before {exercise}'**
  String sessionBeforeExercise(Object exercise);

  /// No description provided for @sessionTimerNote.
  ///
  /// In en, this message translates to:
  /// **'The timer is only a guide and runs while this screen is active.'**
  String get sessionTimerNote;

  /// No description provided for @sessionPauseHeadline.
  ///
  /// In en, this message translates to:
  /// **'Pause whenever you need'**
  String get sessionPauseHeadline;

  /// No description provided for @sessionPauseDescription.
  ///
  /// In en, this message translates to:
  /// **'Your workout is paused. You can resume or end it.'**
  String get sessionPauseDescription;

  /// No description provided for @sessionProgressCount.
  ///
  /// In en, this message translates to:
  /// **'{current} of {total} exercises'**
  String sessionProgressCount(Object current, Object total);

  /// No description provided for @sessionAbandonHeadline.
  ///
  /// In en, this message translates to:
  /// **'Leave this workout?'**
  String get sessionAbandonHeadline;

  /// No description provided for @sessionAbandonDescription.
  ///
  /// In en, this message translates to:
  /// **'This workout will close. Your progress won\'t be saved to your history.'**
  String get sessionAbandonDescription;

  /// No description provided for @sessionWorkoutFinishedFor.
  ///
  /// In en, this message translates to:
  /// **'You finished your {session} workout.'**
  String sessionWorkoutFinishedFor(Object session);

  /// No description provided for @sessionExercisesCompleted.
  ///
  /// In en, this message translates to:
  /// **'{count} exercises completed'**
  String sessionExercisesCompleted(Object count);

  /// No description provided for @sessionSummaryHeadline.
  ///
  /// In en, this message translates to:
  /// **'Your workout summary'**
  String get sessionSummaryHeadline;

  /// No description provided for @sessionSummaryDescription.
  ///
  /// In en, this message translates to:
  /// **'A summary of today\'s activity.'**
  String get sessionSummaryDescription;

  /// No description provided for @sessionCompleteWorkout.
  ///
  /// In en, this message translates to:
  /// **'Complete workout'**
  String get sessionCompleteWorkout;

  /// No description provided for @sessionCompleteExercise.
  ///
  /// In en, this message translates to:
  /// **'Complete exercise'**
  String get sessionCompleteExercise;

  /// No description provided for @sessionWarmupButton.
  ///
  /// In en, this message translates to:
  /// **'View warm-up'**
  String get sessionWarmupButton;

  /// No description provided for @sessionStartButton.
  ///
  /// In en, this message translates to:
  /// **'Start workout'**
  String get sessionStartButton;

  /// No description provided for @sessionSkipWarmupButton.
  ///
  /// In en, this message translates to:
  /// **'Skip warm-up'**
  String get sessionSkipWarmupButton;

  /// No description provided for @sessionSkipRestButton.
  ///
  /// In en, this message translates to:
  /// **'Skip rest'**
  String get sessionSkipRestButton;

  /// No description provided for @sessionAbandonButton.
  ///
  /// In en, this message translates to:
  /// **'Leave workout'**
  String get sessionAbandonButton;

  /// No description provided for @sessionConfirmAbandonButton.
  ///
  /// In en, this message translates to:
  /// **'Yes, leave'**
  String get sessionConfirmAbandonButton;

  /// No description provided for @sessionContinueButton.
  ///
  /// In en, this message translates to:
  /// **'Keep training'**
  String get sessionContinueButton;

  /// No description provided for @sessionSummaryButton.
  ///
  /// In en, this message translates to:
  /// **'View workout summary'**
  String get sessionSummaryButton;

  /// No description provided for @sessionCooldownOfferDescription.
  ///
  /// In en, this message translates to:
  /// **'You can finish with gentle movements for the areas you worked. This is optional and you can skip it at any time.'**
  String get sessionCooldownOfferDescription;

  /// No description provided for @sessionCooldownStart.
  ///
  /// In en, this message translates to:
  /// **'View cool-down'**
  String get sessionCooldownStart;

  /// No description provided for @sessionCooldownNext.
  ///
  /// In en, this message translates to:
  /// **'Next movement'**
  String get sessionCooldownNext;

  /// No description provided for @sessionCooldownSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip cool-down and view summary'**
  String get sessionCooldownSkip;

  /// No description provided for @sessionCooldownHeadline.
  ///
  /// In en, this message translates to:
  /// **'Ease out at your own pace'**
  String get sessionCooldownHeadline;

  /// No description provided for @sessionCooldownDescription.
  ///
  /// In en, this message translates to:
  /// **'Move slowly and stay within a pain-free range. You can skip any step.'**
  String get sessionCooldownDescription;

  /// No description provided for @sessionCooldownHipsTitle.
  ///
  /// In en, this message translates to:
  /// **'Hip flexor stretch'**
  String get sessionCooldownHipsTitle;

  /// No description provided for @sessionCooldownHipsInstructions.
  ///
  /// In en, this message translates to:
  /// **'Kneel on one knee with your other foot forward. Gently move your hips forward without arching your back. Switch sides.'**
  String get sessionCooldownHipsInstructions;

  /// No description provided for @sessionCooldownBackTitle.
  ///
  /// In en, this message translates to:
  /// **'Cat-cow'**
  String get sessionCooldownBackTitle;

  /// No description provided for @sessionCooldownBackInstructions.
  ///
  /// In en, this message translates to:
  /// **'Start on your hands and knees. Gently round your back, then return to a comfortable position without straining your neck.'**
  String get sessionCooldownBackInstructions;

  /// No description provided for @sessionCooldownChestTitle.
  ///
  /// In en, this message translates to:
  /// **'Chest opener'**
  String get sessionCooldownChestTitle;

  /// No description provided for @sessionCooldownChestInstructions.
  ///
  /// In en, this message translates to:
  /// **'Place your forearm on a sturdy doorframe and gently turn your torso away. Switch sides.'**
  String get sessionCooldownChestInstructions;

  /// No description provided for @sessionCooldownShouldersTitle.
  ///
  /// In en, this message translates to:
  /// **'Cross-body shoulder stretch'**
  String get sessionCooldownShouldersTitle;

  /// No description provided for @sessionCooldownShouldersInstructions.
  ///
  /// In en, this message translates to:
  /// **'Bring one arm across your chest and gently draw it closer with your other hand. Keep your shoulder relaxed and switch sides.'**
  String get sessionCooldownShouldersInstructions;

  /// No description provided for @sessionCooldownCoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Gentle torso rotation'**
  String get sessionCooldownCoreTitle;

  /// No description provided for @sessionCooldownCoreInstructions.
  ///
  /// In en, this message translates to:
  /// **'Standing tall, gently turn your torso from side to side without bouncing and stay within a comfortable range.'**
  String get sessionCooldownCoreInstructions;

  /// No description provided for @sessionCooldownArmsTitle.
  ///
  /// In en, this message translates to:
  /// **'Triceps stretch'**
  String get sessionCooldownArmsTitle;

  /// No description provided for @sessionCooldownArmsInstructions.
  ///
  /// In en, this message translates to:
  /// **'Raise one arm, bend your elbow, and gently assist with your other hand. Do not pull on your neck; switch sides.'**
  String get sessionCooldownArmsInstructions;

  /// No description provided for @sessionCooldownTwentySecondsEachSide.
  ///
  /// In en, this message translates to:
  /// **'20 sec per side'**
  String get sessionCooldownTwentySecondsEachSide;

  /// No description provided for @sessionCooldownSixReps.
  ///
  /// In en, this message translates to:
  /// **'6 gentle repetitions'**
  String get sessionCooldownSixReps;

  /// No description provided for @sessionRecordNote.
  ///
  /// In en, this message translates to:
  /// **'This workout will be saved to your activity when you finish.'**
  String get sessionRecordNote;

  /// No description provided for @sessionSetsTarget.
  ///
  /// In en, this message translates to:
  /// **'{sets} sets · {target}'**
  String sessionSetsTarget(Object sets, Object target);

  /// No description provided for @sessionSetUnit.
  ///
  /// In en, this message translates to:
  /// **'sets'**
  String get sessionSetUnit;

  /// No description provided for @sessionRepTargetLow.
  ///
  /// In en, this message translates to:
  /// **'6–8 reps'**
  String get sessionRepTargetLow;

  /// No description provided for @sessionRepTargetMid.
  ///
  /// In en, this message translates to:
  /// **'8–12 reps'**
  String get sessionRepTargetMid;

  /// No description provided for @sessionRepTargetComfortable.
  ///
  /// In en, this message translates to:
  /// **'8–12 reps at a comfortable pace'**
  String get sessionRepTargetComfortable;

  /// No description provided for @sessionTimeTarget.
  ///
  /// In en, this message translates to:
  /// **'20–40 seconds'**
  String get sessionTimeTarget;

  /// No description provided for @sessionWarmupFallback.
  ///
  /// In en, this message translates to:
  /// **'your workout'**
  String get sessionWarmupFallback;

  /// No description provided for @measurementValue.
  ///
  /// In en, this message translates to:
  /// **'{label} {value} cm'**
  String measurementValue(Object label, Object value);

  /// No description provided for @progressValueWithUnit.
  ///
  /// In en, this message translates to:
  /// **'{value} {unit}'**
  String progressValueWithUnit(Object unit, Object value);

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'{label} *'**
  String requiredField(Object label);

  /// No description provided for @navigationHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navigationHome;

  /// No description provided for @shellPlanSaveError.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t save your plan.'**
  String get shellPlanSaveError;

  /// No description provided for @shellWorkoutSaved.
  ///
  /// In en, this message translates to:
  /// **'Workout saved to your activity.'**
  String get shellWorkoutSaved;

  /// No description provided for @shellWorkoutSaveError.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t save this workout.'**
  String get shellWorkoutSaveError;

  /// No description provided for @trainingNameDumbbellPress.
  ///
  /// In en, this message translates to:
  /// **'Dumbbell press'**
  String get trainingNameDumbbellPress;

  /// No description provided for @trainingNameGobletSquat.
  ///
  /// In en, this message translates to:
  /// **'Goblet squat'**
  String get trainingNameGobletSquat;

  /// No description provided for @trainingNameDumbbellRow.
  ///
  /// In en, this message translates to:
  /// **'Dumbbell row'**
  String get trainingNameDumbbellRow;

  /// No description provided for @trainingNameRomanianDeadlift.
  ///
  /// In en, this message translates to:
  /// **'Romanian deadlift'**
  String get trainingNameRomanianDeadlift;

  /// No description provided for @trainingNameShoulderPress.
  ///
  /// In en, this message translates to:
  /// **'Shoulder press'**
  String get trainingNameShoulderPress;

  /// No description provided for @trainingNameBarbellSquat.
  ///
  /// In en, this message translates to:
  /// **'Barbell squat'**
  String get trainingNameBarbellSquat;

  /// No description provided for @trainingNameBarbellBench.
  ///
  /// In en, this message translates to:
  /// **'Barbell bench press'**
  String get trainingNameBarbellBench;

  /// No description provided for @trainingNameBarbellRow.
  ///
  /// In en, this message translates to:
  /// **'Barbell row'**
  String get trainingNameBarbellRow;

  /// No description provided for @trainingNameBarbellDeadlift.
  ///
  /// In en, this message translates to:
  /// **'Barbell deadlift'**
  String get trainingNameBarbellDeadlift;

  /// No description provided for @trainingNameBandChestPress.
  ///
  /// In en, this message translates to:
  /// **'Band chest press'**
  String get trainingNameBandChestPress;

  /// No description provided for @trainingNameBandRow.
  ///
  /// In en, this message translates to:
  /// **'Band row'**
  String get trainingNameBandRow;

  /// No description provided for @trainingNameBandSquat.
  ///
  /// In en, this message translates to:
  /// **'Banded squat'**
  String get trainingNameBandSquat;

  /// No description provided for @trainingNameBandPullApart.
  ///
  /// In en, this message translates to:
  /// **'Band pull-apart'**
  String get trainingNameBandPullApart;

  /// No description provided for @trainingNameMachineChestPress.
  ///
  /// In en, this message translates to:
  /// **'Machine chest press'**
  String get trainingNameMachineChestPress;

  /// No description provided for @trainingNameLegPress.
  ///
  /// In en, this message translates to:
  /// **'Leg press'**
  String get trainingNameLegPress;

  /// No description provided for @trainingNameLatPulldown.
  ///
  /// In en, this message translates to:
  /// **'Lat pulldown'**
  String get trainingNameLatPulldown;

  /// No description provided for @trainingNameSeatedRow.
  ///
  /// In en, this message translates to:
  /// **'Seated row'**
  String get trainingNameSeatedRow;

  /// No description provided for @trainingNamePushUp.
  ///
  /// In en, this message translates to:
  /// **'Push-up'**
  String get trainingNamePushUp;

  /// No description provided for @trainingNameInclinePushUp.
  ///
  /// In en, this message translates to:
  /// **'Incline push-up'**
  String get trainingNameInclinePushUp;

  /// No description provided for @trainingNamePikePushUp.
  ///
  /// In en, this message translates to:
  /// **'Pike push-up'**
  String get trainingNamePikePushUp;

  /// No description provided for @trainingNameLunges.
  ///
  /// In en, this message translates to:
  /// **'Lunges'**
  String get trainingNameLunges;

  /// No description provided for @trainingNameBodyweightSquat.
  ///
  /// In en, this message translates to:
  /// **'Bodyweight squat'**
  String get trainingNameBodyweightSquat;

  /// No description provided for @trainingNameCalfRaise.
  ///
  /// In en, this message translates to:
  /// **'Calf raise'**
  String get trainingNameCalfRaise;

  /// No description provided for @trainingNameGluteBridge.
  ///
  /// In en, this message translates to:
  /// **'Glute bridge'**
  String get trainingNameGluteBridge;

  /// No description provided for @trainingNameBirdDog.
  ///
  /// In en, this message translates to:
  /// **'Bird-dog'**
  String get trainingNameBirdDog;

  /// No description provided for @trainingNameDeadBug.
  ///
  /// In en, this message translates to:
  /// **'Dead bug'**
  String get trainingNameDeadBug;

  /// No description provided for @trainingNamePlank.
  ///
  /// In en, this message translates to:
  /// **'Plank'**
  String get trainingNamePlank;

  /// No description provided for @activityFocusUpper.
  ///
  /// In en, this message translates to:
  /// **'Chest, back, and shoulders'**
  String get activityFocusUpper;

  /// No description provided for @activityFocusLower.
  ///
  /// In en, this message translates to:
  /// **'Legs and core'**
  String get activityFocusLower;

  /// No description provided for @activityFocusFull.
  ///
  /// In en, this message translates to:
  /// **'Full-body workout'**
  String get activityFocusFull;

  /// No description provided for @profileDefaultName.
  ///
  /// In en, this message translates to:
  /// **'FORZA athlete'**
  String get profileDefaultName;

  /// No description provided for @progressTotalStrength.
  ///
  /// In en, this message translates to:
  /// **'Total-body strength'**
  String get progressTotalStrength;

  /// No description provided for @progressLegsCore.
  ///
  /// In en, this message translates to:
  /// **'Legs and core'**
  String get progressLegsCore;

  /// No description provided for @progressUpperBody.
  ///
  /// In en, this message translates to:
  /// **'Upper body'**
  String get progressUpperBody;

  /// No description provided for @sessionStartTimedSet.
  ///
  /// In en, this message translates to:
  /// **'Start 30 second set'**
  String get sessionStartTimedSet;

  /// No description provided for @sessionTimedSetRunning.
  ///
  /// In en, this message translates to:
  /// **'Pause timed set'**
  String get sessionTimedSetRunning;

  /// No description provided for @trainingNameBandReverseFly.
  ///
  /// In en, this message translates to:
  /// **'Band reverse fly'**
  String get trainingNameBandReverseFly;

  /// No description provided for @trainingNamePikeToCobra.
  ///
  /// In en, this message translates to:
  /// **'Pike-to-cobra push-up'**
  String get trainingNamePikeToCobra;

  /// No description provided for @trainingNameJumpSquat.
  ///
  /// In en, this message translates to:
  /// **'Jump squat'**
  String get trainingNameJumpSquat;

  /// No description provided for @trainingNameSidePlank.
  ///
  /// In en, this message translates to:
  /// **'Incline side plank'**
  String get trainingNameSidePlank;

  /// No description provided for @nutritionHubTitle.
  ///
  /// In en, this message translates to:
  /// **'Nutrition'**
  String get nutritionHubTitle;

  /// No description provided for @nutritionOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get nutritionOpen;

  /// No description provided for @homeNutritionSummary.
  ///
  /// In en, this message translates to:
  /// **'Review this week’s menu and shopping list.'**
  String get homeNutritionSummary;

  /// No description provided for @nutritionMyPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'My nutrition plan'**
  String get nutritionMyPlanTitle;

  /// No description provided for @nutritionMyPlanSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly menu and shopping list'**
  String get nutritionMyPlanSubtitle;

  /// No description provided for @nutritionWeekSummary.
  ///
  /// In en, this message translates to:
  /// **'Suggested weekly plan'**
  String get nutritionWeekSummary;

  /// No description provided for @nutritionEstimatesNote.
  ///
  /// In en, this message translates to:
  /// **'Amounts are recipe estimates, not a nutrition prescription.'**
  String get nutritionEstimatesNote;

  /// No description provided for @nutritionGeneralCatalogNote.
  ///
  /// In en, this message translates to:
  /// **'Showing general options; local availability is not confirmed.'**
  String get nutritionGeneralCatalogNote;

  /// No description provided for @nutritionTabToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get nutritionTabToday;

  /// No description provided for @nutritionTabWeek.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get nutritionTabWeek;

  /// No description provided for @nutritionTabRecipes.
  ///
  /// In en, this message translates to:
  /// **'Recipes'**
  String get nutritionTabRecipes;

  /// No description provided for @nutritionTabShopping.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get nutritionTabShopping;

  /// No description provided for @nutritionWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Plan meals around your preferences'**
  String get nutritionWelcomeTitle;

  /// No description provided for @nutritionWelcomeDescription.
  ///
  /// In en, this message translates to:
  /// **'Set your preferences to see a simple weekly menu. Nutrition is optional.'**
  String get nutritionWelcomeDescription;

  /// No description provided for @nutritionConfigureProfile.
  ///
  /// In en, this message translates to:
  /// **'Set preferences'**
  String get nutritionConfigureProfile;

  /// No description provided for @nutritionEditPreferences.
  ///
  /// In en, this message translates to:
  /// **'Edit preferences'**
  String get nutritionEditPreferences;

  /// No description provided for @nutritionNoSafeRecipes.
  ///
  /// In en, this message translates to:
  /// **'We can’t build a menu that meets your restrictions with the available data.'**
  String get nutritionNoSafeRecipes;

  /// No description provided for @nutritionAllergenUnknownNote.
  ///
  /// In en, this message translates to:
  /// **'The catalog does not yet have verified allergen information for every recipe. We will not remove your filters to fill the menu.'**
  String get nutritionAllergenUnknownNote;

  /// No description provided for @nutritionNoMealsToday.
  ///
  /// In en, this message translates to:
  /// **'There are no meals to show today.'**
  String get nutritionNoMealsToday;

  /// No description provided for @nutritionTrainingDay.
  ///
  /// In en, this message translates to:
  /// **'Training day'**
  String get nutritionTrainingDay;

  /// No description provided for @nutritionRestDay.
  ///
  /// In en, this message translates to:
  /// **'Rest day'**
  String get nutritionRestDay;

  /// No description provided for @nutritionShoppingEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your shopping list is empty.'**
  String get nutritionShoppingEmpty;

  /// No description provided for @nutritionLoadError.
  ///
  /// In en, this message translates to:
  /// **'We couldn’t load the meal catalog. Check local storage and try again.'**
  String get nutritionLoadError;

  /// No description provided for @nutritionRecipeEstimate.
  ///
  /// In en, this message translates to:
  /// **'Estimated {kcal} kcal per recipe'**
  String nutritionRecipeEstimate(int kcal);

  /// No description provided for @nutritionMyPlanAction.
  ///
  /// In en, this message translates to:
  /// **'View nutrition plan'**
  String get nutritionMyPlanAction;

  /// No description provided for @nutritionBackToPlan.
  ///
  /// In en, this message translates to:
  /// **'Back to plan'**
  String get nutritionBackToPlan;

  /// No description provided for @nutritionLogAddFood.
  ///
  /// In en, this message translates to:
  /// **'Log another food'**
  String get nutritionLogAddFood;

  /// No description provided for @nutritionLoggedItems.
  ///
  /// In en, this message translates to:
  /// **'Foods logged today'**
  String get nutritionLoggedItems;

  /// No description provided for @nutritionLogMarkConsumed.
  ///
  /// In en, this message translates to:
  /// **'Mark as eaten'**
  String get nutritionLogMarkConsumed;

  /// No description provided for @nutritionLogUndo.
  ///
  /// In en, this message translates to:
  /// **'Undo log'**
  String get nutritionLogUndo;

  /// No description provided for @nutritionLogAdjust.
  ///
  /// In en, this message translates to:
  /// **'Adjust serving'**
  String get nutritionLogAdjust;

  /// No description provided for @nutritionLogDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete log'**
  String get nutritionLogDelete;

  /// No description provided for @nutritionLoggedFromPlan.
  ///
  /// In en, this message translates to:
  /// **'From plan'**
  String get nutritionLoggedFromPlan;

  /// No description provided for @nutritionLoggedManually.
  ///
  /// In en, this message translates to:
  /// **'Manual entry'**
  String get nutritionLoggedManually;

  /// No description provided for @nutritionFoodSearchLabel.
  ///
  /// In en, this message translates to:
  /// **'Search foods'**
  String get nutritionFoodSearchLabel;

  /// No description provided for @nutritionFoodSearchEmpty.
  ///
  /// In en, this message translates to:
  /// **'No foods match your search.'**
  String get nutritionFoodSearchEmpty;

  /// No description provided for @nutritionLogGrams.
  ///
  /// In en, this message translates to:
  /// **'Amount in grams'**
  String get nutritionLogGrams;

  /// No description provided for @nutritionLogPortions.
  ///
  /// In en, this message translates to:
  /// **'Servings'**
  String get nutritionLogPortions;

  /// No description provided for @nutritionLogInvalidGrams.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount greater than zero grams.'**
  String get nutritionLogInvalidGrams;

  /// No description provided for @nutritionLogInvalidPortions.
  ///
  /// In en, this message translates to:
  /// **'Enter a serving amount greater than zero.'**
  String get nutritionLogInvalidPortions;

  /// No description provided for @nutritionLogSaveError.
  ///
  /// In en, this message translates to:
  /// **'We couldn’t save this entry. Try again.'**
  String get nutritionLogSaveError;

  /// No description provided for @nutritionHistoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'You haven’t logged meals yet. You can add a meal even if it was not in your plan.'**
  String get nutritionHistoryEmpty;

  /// No description provided for @nutritionTabHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get nutritionTabHistory;

  /// No description provided for @healthConnectionsSection.
  ///
  /// In en, this message translates to:
  /// **'Connections'**
  String get healthConnectionsSection;

  /// No description provided for @healthConnectionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Health connections'**
  String get healthConnectionsTitle;

  /// No description provided for @healthConnectionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Import activity and wellbeing from your device'**
  String get healthConnectionsSubtitle;

  /// No description provided for @healthConnectionsDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose which health data to import into FORZA. Connecting is optional and you can keep using the app without it.'**
  String get healthConnectionsDescription;

  /// No description provided for @healthLocalOnlyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your data stays on this device'**
  String get healthLocalOnlyTitle;

  /// No description provided for @healthLocalOnlyDescription.
  ///
  /// In en, this message translates to:
  /// **'Imported data is stored locally. FORZA does not send it to Firestore or other services.'**
  String get healthLocalOnlyDescription;

  /// No description provided for @healthStatusUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t check availability'**
  String get healthStatusUnavailable;

  /// No description provided for @healthTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Check your connection and try again.'**
  String get healthTryAgain;

  /// No description provided for @healthDeviceUnsupported.
  ///
  /// In en, this message translates to:
  /// **'Health connections aren’t available on this device'**
  String get healthDeviceUnsupported;

  /// No description provided for @healthDeviceUnsupportedDescription.
  ///
  /// In en, this message translates to:
  /// **'You can keep using FORZA without connecting a health platform.'**
  String get healthDeviceUnsupportedDescription;

  /// No description provided for @healthIosPendingTitle.
  ///
  /// In en, this message translates to:
  /// **'Apple Health isn’t enabled yet'**
  String get healthIosPendingTitle;

  /// No description provided for @healthIosPendingDescription.
  ///
  /// In en, this message translates to:
  /// **'This connection needs HealthKit setup and validation. FORZA still works without it.'**
  String get healthIosPendingDescription;

  /// No description provided for @healthChooseData.
  ///
  /// In en, this message translates to:
  /// **'Choose what to import'**
  String get healthChooseData;

  /// No description provided for @healthSteps.
  ///
  /// In en, this message translates to:
  /// **'Steps'**
  String get healthSteps;

  /// No description provided for @healthWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get healthWeight;

  /// No description provided for @healthSleep.
  ///
  /// In en, this message translates to:
  /// **'Sleep'**
  String get healthSleep;

  /// No description provided for @healthWorkouts.
  ///
  /// In en, this message translates to:
  /// **'Workouts'**
  String get healthWorkouts;

  /// No description provided for @healthStepsReason.
  ///
  /// In en, this message translates to:
  /// **'To give context to your daily activity.'**
  String get healthStepsReason;

  /// No description provided for @healthWeightReason.
  ///
  /// In en, this message translates to:
  /// **'To view measurements recorded in your health platform.'**
  String get healthWeightReason;

  /// No description provided for @healthSleepReason.
  ///
  /// In en, this message translates to:
  /// **'To view sleep sessions; this won’t change your plan.'**
  String get healthSleepReason;

  /// No description provided for @healthWorkoutReason.
  ///
  /// In en, this message translates to:
  /// **'To view recorded sessions; workout calories and steps aren’t added to totals.'**
  String get healthWorkoutReason;

  /// No description provided for @healthPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Allow data access'**
  String get healthPermissionTitle;

  /// No description provided for @healthPermissionExplanation.
  ///
  /// In en, this message translates to:
  /// **'FORZA will request read-only access to the selected categories. Your health platform lets you accept or deny each permission.'**
  String get healthPermissionExplanation;

  /// No description provided for @healthContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get healthContinue;

  /// No description provided for @healthSelectAtLeastOne.
  ///
  /// In en, this message translates to:
  /// **'Select at least one data type.'**
  String get healthSelectAtLeastOne;

  /// No description provided for @healthPermissionUnverifiable.
  ///
  /// In en, this message translates to:
  /// **'iOS doesn’t disclose whether read access was granted.'**
  String get healthPermissionUnverifiable;

  /// No description provided for @healthPermissionGranted.
  ///
  /// In en, this message translates to:
  /// **'Permission granted'**
  String get healthPermissionGranted;

  /// No description provided for @healthPermissionNotGranted.
  ///
  /// In en, this message translates to:
  /// **'Permission not granted'**
  String get healthPermissionNotGranted;

  /// No description provided for @healthIosPermissionCaveat.
  ///
  /// In en, this message translates to:
  /// **'Apple Health doesn’t reveal when read access is denied. If no data appears, check FORZA’s permissions in the Health app.'**
  String get healthIosPermissionCaveat;

  /// No description provided for @healthImporting.
  ///
  /// In en, this message translates to:
  /// **'Importing…'**
  String get healthImporting;

  /// No description provided for @healthImportNow.
  ///
  /// In en, this message translates to:
  /// **'Import now'**
  String get healthImportNow;

  /// No description provided for @healthConnect.
  ///
  /// In en, this message translates to:
  /// **'Connect and allow read access'**
  String get healthConnect;

  /// No description provided for @healthImportComplete.
  ///
  /// In en, this message translates to:
  /// **'Import complete.'**
  String get healthImportComplete;

  /// No description provided for @healthImportFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t import. Check your permissions and try again.'**
  String get healthImportFailed;

  /// No description provided for @healthLastImport.
  ///
  /// In en, this message translates to:
  /// **'Last import:'**
  String get healthLastImport;

  /// No description provided for @healthImportedRecordCount.
  ///
  /// In en, this message translates to:
  /// **'Imported records:'**
  String get healthImportedRecordCount;

  /// No description provided for @healthRecentData.
  ///
  /// In en, this message translates to:
  /// **'Recent data and source'**
  String get healthRecentData;

  /// No description provided for @healthDisconnectTitle.
  ///
  /// In en, this message translates to:
  /// **'Disconnect health data'**
  String get healthDisconnectTitle;

  /// No description provided for @healthDisconnectExplanation.
  ///
  /// In en, this message translates to:
  /// **'Data imported by FORZA on this device will be deleted. Android revokes Health Connect permissions and applies the change after FORZA restarts. Apple Health permissions are managed in the Health app.'**
  String get healthDisconnectExplanation;

  /// No description provided for @healthDisconnect.
  ///
  /// In en, this message translates to:
  /// **'Disconnect and delete data'**
  String get healthDisconnect;

  /// No description provided for @commonUndo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get commonUndo;

  /// No description provided for @commonEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get commonEdit;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @hydrationTitle.
  ///
  /// In en, this message translates to:
  /// **'Water and drinks'**
  String get hydrationTitle;

  /// No description provided for @hydrationGlass.
  ///
  /// In en, this message translates to:
  /// **'Glass'**
  String get hydrationGlass;

  /// No description provided for @hydrationBottle.
  ///
  /// In en, this message translates to:
  /// **'Bottle'**
  String get hydrationBottle;

  /// No description provided for @hydrationManual.
  ///
  /// In en, this message translates to:
  /// **'Custom amount'**
  String get hydrationManual;

  /// No description provided for @hydrationAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get hydrationAmount;

  /// No description provided for @hydrationDrinkType.
  ///
  /// In en, this message translates to:
  /// **'Drink'**
  String get hydrationDrinkType;

  /// No description provided for @hydrationWater.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get hydrationWater;

  /// No description provided for @hydrationOtherBeverage.
  ///
  /// In en, this message translates to:
  /// **'Other beverage'**
  String get hydrationOtherBeverage;

  /// No description provided for @hydrationTodayTotal.
  ///
  /// In en, this message translates to:
  /// **'Logged today: {amount}'**
  String hydrationTodayTotal(String amount);

  /// No description provided for @hydrationProgress.
  ///
  /// In en, this message translates to:
  /// **'Recorded {amount} of personal goal {goal}'**
  String hydrationProgress(String amount, String goal);

  /// No description provided for @hydrationAdded.
  ///
  /// In en, this message translates to:
  /// **'Added {amount}'**
  String hydrationAdded(String amount);

  /// No description provided for @hydrationDeleted.
  ///
  /// In en, this message translates to:
  /// **'Water record deleted'**
  String get hydrationDeleted;

  /// No description provided for @hydrationHistory.
  ///
  /// In en, this message translates to:
  /// **'Water history'**
  String get hydrationHistory;

  /// No description provided for @hydrationEmpty.
  ///
  /// In en, this message translates to:
  /// **'No drinks recorded for this day.'**
  String get hydrationEmpty;

  /// No description provided for @hydrationEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit water record'**
  String get hydrationEdit;

  /// No description provided for @hydrationPreferences.
  ///
  /// In en, this message translates to:
  /// **'Water preferences'**
  String get hydrationPreferences;

  /// No description provided for @hydrationGoalOptional.
  ///
  /// In en, this message translates to:
  /// **'Personal daily goal (optional)'**
  String get hydrationGoalOptional;

  /// No description provided for @hydrationShowIndicator.
  ///
  /// In en, this message translates to:
  /// **'Show progress toward my goal'**
  String get hydrationShowIndicator;

  /// No description provided for @hydrationInvalidAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount from 1 to 10,000 ml.'**
  String get hydrationInvalidAmount;

  /// No description provided for @hydrationSaveError.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t save the water record. Try again.'**
  String get hydrationSaveError;

  /// No description provided for @hydrationLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t load water records. Retry.'**
  String get hydrationLoadError;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
