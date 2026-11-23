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

  /// No description provided for @exerciseCatalogSpanishNotice.
  ///
  /// In en, this message translates to:
  /// **'Exercise names, categories, and instructions in this catalog are currently in Spanish.'**
  String get exerciseCatalogSpanishNotice;

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
