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
/// import 'l10n/app_localizations.dart';
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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es')
  ];

  /// The conventional newborn programmer greeting
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @journal.
  ///
  /// In en, this message translates to:
  /// **'Journal'**
  String get journal;

  /// No description provided for @partners.
  ///
  /// In en, this message translates to:
  /// **'Partners'**
  String get partners;

  /// No description provided for @learn.
  ///
  /// In en, this message translates to:
  /// **'Learn'**
  String get learn;

  /// No description provided for @allEntries.
  ///
  /// In en, this message translates to:
  /// **'All entries'**
  String get allEntries;

  /// No description provided for @onlySex.
  ///
  /// In en, this message translates to:
  /// **'Only sex'**
  String get onlySex;

  /// No description provided for @onlySolo.
  ///
  /// In en, this message translates to:
  /// **'Only solo'**
  String get onlySolo;

  /// No description provided for @logActivity.
  ///
  /// In en, this message translates to:
  /// **'Log activity'**
  String get logActivity;

  /// No description provided for @safety.
  ///
  /// In en, this message translates to:
  /// **'Safety'**
  String get safety;

  /// No description provided for @safe.
  ///
  /// In en, this message translates to:
  /// **'Protected'**
  String get safe;

  /// No description provided for @safeSex.
  ///
  /// In en, this message translates to:
  /// **'Protected sex'**
  String get safeSex;

  /// No description provided for @safeMsg.
  ///
  /// In en, this message translates to:
  /// **'Although condom use is associated with a very low risk of STIs, there is no such thing as 100% risk-free sex.'**
  String get safeMsg;

  /// No description provided for @unsafe.
  ///
  /// In en, this message translates to:
  /// **'Very unsafe'**
  String get unsafe;

  /// No description provided for @unsafeSex.
  ///
  /// In en, this message translates to:
  /// **'Very unsafe sex'**
  String get unsafeSex;

  /// No description provided for @unsafeMsg.
  ///
  /// In en, this message translates to:
  /// **'High level of risk due to contraception not been used'**
  String get unsafeMsg;

  /// No description provided for @partiallyUnsafe.
  ///
  /// In en, this message translates to:
  /// **'Partially unsafe'**
  String get partiallyUnsafe;

  /// No description provided for @partiallyUnsafeSex.
  ///
  /// In en, this message translates to:
  /// **'Partially unsafe sex'**
  String get partiallyUnsafeSex;

  /// No description provided for @partiallyUnsafeMsg.
  ///
  /// In en, this message translates to:
  /// **'Partially unsafe because even if it is potentially prevented against pregnancy you can still contract Sexually Transmitted Infections (STIs)'**
  String get partiallyUnsafeMsg;

  /// No description provided for @birthControl.
  ///
  /// In en, this message translates to:
  /// **'Birth control'**
  String get birthControl;

  /// No description provided for @min.
  ///
  /// In en, this message translates to:
  /// **'min.'**
  String get min;

  /// No description provided for @byMe.
  ///
  /// In en, this message translates to:
  /// **'by me'**
  String get byMe;

  /// No description provided for @byPartner.
  ///
  /// In en, this message translates to:
  /// **'by partner'**
  String get byPartner;

  /// No description provided for @byBoth.
  ///
  /// In en, this message translates to:
  /// **'by both'**
  String get byBoth;

  /// No description provided for @performance.
  ///
  /// In en, this message translates to:
  /// **'Performance'**
  String get performance;

  /// No description provided for @highlights.
  ///
  /// In en, this message translates to:
  /// **'Highlights'**
  String get highlights;

  /// Orgams by me
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{orgasm by me} other{orgasms by me}}'**
  String orgasmsByMe(num count);

  /// Orgams by partner
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{orgasm by partner} other{orgasms by partner}}'**
  String orgasmsByPartner(num count);

  /// No description provided for @practices.
  ///
  /// In en, this message translates to:
  /// **'Practices'**
  String get practices;

  /// No description provided for @sexualActivity.
  ///
  /// In en, this message translates to:
  /// **'Sexual activity'**
  String get sexualActivity;

  /// Who initiated it
  ///
  /// In en, this message translates to:
  /// **'{initiator, select, other{initiated it}}'**
  String initiatedIt(String initiator);

  /// No description provided for @editActivity.
  ///
  /// In en, this message translates to:
  /// **'Edit activity'**
  String get editActivity;

  /// No description provided for @addPartner.
  ///
  /// In en, this message translates to:
  /// **'Add partner'**
  String get addPartner;

  /// No description provided for @createPartner.
  ///
  /// In en, this message translates to:
  /// **'Create partner'**
  String get createPartner;

  /// No description provided for @editPartner.
  ///
  /// In en, this message translates to:
  /// **'Edit partner'**
  String get editPartner;

  /// No description provided for @man.
  ///
  /// In en, this message translates to:
  /// **'Man'**
  String get man;

  /// No description provided for @transMan.
  ///
  /// In en, this message translates to:
  /// **'Trans man'**
  String get transMan;

  /// No description provided for @woman.
  ///
  /// In en, this message translates to:
  /// **'Woman'**
  String get woman;

  /// No description provided for @transWoman.
  ///
  /// In en, this message translates to:
  /// **'Trans woman'**
  String get transWoman;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @nonBinary.
  ///
  /// In en, this message translates to:
  /// **'Non binary'**
  String get nonBinary;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @nameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter name...'**
  String get nameHint;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @notesHint.
  ///
  /// In en, this message translates to:
  /// **'Enter notes...'**
  String get notesHint;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @moreFields.
  ///
  /// In en, this message translates to:
  /// **'More fields'**
  String get moreFields;

  /// No description provided for @lessFields.
  ///
  /// In en, this message translates to:
  /// **'Less fields'**
  String get lessFields;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration (in min.)'**
  String get duration;

  /// No description provided for @orgasms.
  ///
  /// In en, this message translates to:
  /// **'Orgasms'**
  String get orgasms;

  /// No description provided for @partnerOrgasms.
  ///
  /// In en, this message translates to:
  /// **'Partner orgasms'**
  String get partnerOrgasms;

  /// No description provided for @meetingDate.
  ///
  /// In en, this message translates to:
  /// **'Meeting date'**
  String get meetingDate;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @sex.
  ///
  /// In en, this message translates to:
  /// **'Biological sex'**
  String get sex;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @unknownPartner.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknownPartner;

  /// No description provided for @unknownPlace.
  ///
  /// In en, this message translates to:
  /// **'Unknown place'**
  String get unknownPlace;

  /// No description provided for @solo.
  ///
  /// In en, this message translates to:
  /// **'Solo'**
  String get solo;

  /// No description provided for @sexualIntercourse.
  ///
  /// In en, this message translates to:
  /// **'Sexual intercourse'**
  String get sexualIntercourse;

  /// No description provided for @masturbation.
  ///
  /// In en, this message translates to:
  /// **'Masturbation'**
  String get masturbation;

  /// No description provided for @activityType.
  ///
  /// In en, this message translates to:
  /// **'Activity type'**
  String get activityType;

  /// No description provided for @partner.
  ///
  /// In en, this message translates to:
  /// **'Partner'**
  String get partner;

  /// No description provided for @me.
  ///
  /// In en, this message translates to:
  /// **'Me'**
  String get me;

  /// No description provided for @both.
  ///
  /// In en, this message translates to:
  /// **'Both'**
  String get both;

  /// No description provided for @partnerBirthControl.
  ///
  /// In en, this message translates to:
  /// **'Partner birth control'**
  String get partnerBirthControl;

  /// No description provided for @noBirthControl.
  ///
  /// In en, this message translates to:
  /// **'No birth control'**
  String get noBirthControl;

  /// No description provided for @noInitiator.
  ///
  /// In en, this message translates to:
  /// **'No initiator'**
  String get noInitiator;

  /// No description provided for @place.
  ///
  /// In en, this message translates to:
  /// **'Place'**
  String get place;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @initiator.
  ///
  /// In en, this message translates to:
  /// **'Initiator'**
  String get initiator;

  /// No description provided for @mood.
  ///
  /// In en, this message translates to:
  /// **'Mood'**
  String get mood;

  /// No description provided for @noSexualActivity.
  ///
  /// In en, this message translates to:
  /// **'No sexual activity...'**
  String get noSexualActivity;

  /// No description provided for @noContent.
  ///
  /// In en, this message translates to:
  /// **'No content to show'**
  String get noContent;

  /// No description provided for @noStatistics.
  ///
  /// In en, this message translates to:
  /// **'No statistics yet'**
  String get noStatistics;

  /// No description provided for @noSummary.
  ///
  /// In en, this message translates to:
  /// **'No summary yet'**
  String get noSummary;

  /// No description provided for @noActivity.
  ///
  /// In en, this message translates to:
  /// **'Your journal is empty'**
  String get noActivity;

  /// No description provided for @noPartners.
  ///
  /// In en, this message translates to:
  /// **'No partners yet'**
  String get noPartners;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @colorScheme.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get colorScheme;

  /// No description provided for @defaultColorScheme.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get defaultColorScheme;

  /// No description provided for @dynamicColorScheme.
  ///
  /// In en, this message translates to:
  /// **'Dynamic'**
  String get dynamicColorScheme;

  /// No description provided for @love.
  ///
  /// In en, this message translates to:
  /// **'Pink Love'**
  String get love;

  /// No description provided for @lust.
  ///
  /// In en, this message translates to:
  /// **'Purple Lust'**
  String get lust;

  /// No description provided for @lovelust.
  ///
  /// In en, this message translates to:
  /// **'Pink LoveLust'**
  String get lovelust;

  /// No description provided for @lustfullove.
  ///
  /// In en, this message translates to:
  /// **'Pink and Purple'**
  String get lustfullove;

  /// No description provided for @lovefullust.
  ///
  /// In en, this message translates to:
  /// **'Purple and Pink'**
  String get lovefullust;

  /// No description provided for @lipstick.
  ///
  /// In en, this message translates to:
  /// **'Red Lipstick'**
  String get lipstick;

  /// No description provided for @shimapan.
  ///
  /// In en, this message translates to:
  /// **'Teal Shimapan'**
  String get shimapan;

  /// No description provided for @blue.
  ///
  /// In en, this message translates to:
  /// **'Blue Movie'**
  String get blue;

  /// No description provided for @monochrome.
  ///
  /// In en, this message translates to:
  /// **'Monochrome'**
  String get monochrome;

  /// No description provided for @experimental.
  ///
  /// In en, this message translates to:
  /// **'Experimental'**
  String get experimental;

  /// No description provided for @trueBlack.
  ///
  /// In en, this message translates to:
  /// **'True black'**
  String get trueBlack;

  /// No description provided for @trueBlackDescription.
  ///
  /// In en, this message translates to:
  /// **'Use true black for OLED screens'**
  String get trueBlackDescription;

  /// No description provided for @material.
  ///
  /// In en, this message translates to:
  /// **'Material'**
  String get material;

  /// No description provided for @materialDescription.
  ///
  /// In en, this message translates to:
  /// **'Use Material UI'**
  String get materialDescription;

  /// No description provided for @modernUI.
  ///
  /// In en, this message translates to:
  /// **'Modern UI'**
  String get modernUI;

  /// No description provided for @modernUIDescription.
  ///
  /// In en, this message translates to:
  /// **'Try the experimental new UI'**
  String get modernUIDescription;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @chooseTheme.
  ///
  /// In en, this message translates to:
  /// **'Choose theme'**
  String get chooseTheme;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get system;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @defaultAppIcon.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get defaultAppIcon;

  /// No description provided for @beta.
  ///
  /// In en, this message translates to:
  /// **'Beta'**
  String get beta;

  /// No description provided for @white.
  ///
  /// In en, this message translates to:
  /// **'White Kiss'**
  String get white;

  /// No description provided for @black.
  ///
  /// In en, this message translates to:
  /// **'Black Leather'**
  String get black;

  /// No description provided for @filled.
  ///
  /// In en, this message translates to:
  /// **'Filled'**
  String get filled;

  /// No description provided for @filledWhite.
  ///
  /// In en, this message translates to:
  /// **'Filled White'**
  String get filledWhite;

  /// No description provided for @filledBlack.
  ///
  /// In en, this message translates to:
  /// **'Filled Black'**
  String get filledBlack;

  /// No description provided for @pink.
  ///
  /// In en, this message translates to:
  /// **'Pink'**
  String get pink;

  /// No description provided for @purple.
  ///
  /// In en, this message translates to:
  /// **'Purple'**
  String get purple;

  /// No description provided for @deepPurple.
  ///
  /// In en, this message translates to:
  /// **'Purple Deep'**
  String get deepPurple;

  /// No description provided for @neon.
  ///
  /// In en, this message translates to:
  /// **'Neon'**
  String get neon;

  /// No description provided for @glow.
  ///
  /// In en, this message translates to:
  /// **'Glow'**
  String get glow;

  /// No description provided for @pride.
  ///
  /// In en, this message translates to:
  /// **'Pride'**
  String get pride;

  /// No description provided for @prideRainbow.
  ///
  /// In en, this message translates to:
  /// **'Pride: Rainbow'**
  String get prideRainbow;

  /// No description provided for @prideClassic.
  ///
  /// In en, this message translates to:
  /// **'Pride: Classic'**
  String get prideClassic;

  /// No description provided for @prideBi.
  ///
  /// In en, this message translates to:
  /// **'Pride: Bi'**
  String get prideBi;

  /// No description provided for @prideTrans.
  ///
  /// In en, this message translates to:
  /// **'Pride: Trans'**
  String get prideTrans;

  /// No description provided for @prideAce.
  ///
  /// In en, this message translates to:
  /// **'Pride: Ace'**
  String get prideAce;

  /// No description provided for @prideRomania.
  ///
  /// In en, this message translates to:
  /// **'Pride: Romania'**
  String get prideRomania;

  /// No description provided for @sexapill.
  ///
  /// In en, this message translates to:
  /// **'Sexapill'**
  String get sexapill;

  /// No description provided for @health.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get health;

  /// No description provided for @health2.
  ///
  /// In en, this message translates to:
  /// **'Health 2'**
  String get health2;

  /// No description provided for @requireFingerprint.
  ///
  /// In en, this message translates to:
  /// **'Require fingerprint'**
  String get requireFingerprint;

  /// No description provided for @requireFingerprintDescription.
  ///
  /// In en, this message translates to:
  /// **'Require fingerprint to access the app'**
  String get requireFingerprintDescription;

  /// No description provided for @requireFace.
  ///
  /// In en, this message translates to:
  /// **'Require face recognition'**
  String get requireFace;

  /// No description provided for @requireFaceDescription.
  ///
  /// In en, this message translates to:
  /// **'Require face recognition to access the app'**
  String get requireFaceDescription;

  /// No description provided for @requireFaceID.
  ///
  /// In en, this message translates to:
  /// **'Require FaceID'**
  String get requireFaceID;

  /// No description provided for @requireFaceIDDescription.
  ///
  /// In en, this message translates to:
  /// **'Require FaceID to access the app'**
  String get requireFaceIDDescription;

  /// No description provided for @requireTouchID.
  ///
  /// In en, this message translates to:
  /// **'Require TouchID'**
  String get requireTouchID;

  /// No description provided for @requireTouchIDDescription.
  ///
  /// In en, this message translates to:
  /// **'Require TouchID to access the app'**
  String get requireTouchIDDescription;

  /// No description provided for @requirePasscode.
  ///
  /// In en, this message translates to:
  /// **'Require passcode'**
  String get requirePasscode;

  /// No description provided for @requirePasscodeDescription.
  ///
  /// In en, this message translates to:
  /// **'Require passcode to access the app'**
  String get requirePasscodeDescription;

  /// No description provided for @requireAuth.
  ///
  /// In en, this message translates to:
  /// **'Require authentication'**
  String get requireAuth;

  /// No description provided for @requireAuthDescription.
  ///
  /// In en, this message translates to:
  /// **'Require authentication to access the app'**
  String get requireAuthDescription;

  /// No description provided for @requireAuthToAccess.
  ///
  /// In en, this message translates to:
  /// **'Authentication required to access'**
  String get requireAuthToAccess;

  /// No description provided for @requireAuthToConfirm.
  ///
  /// In en, this message translates to:
  /// **'Authentication required to confirm'**
  String get requireAuthToConfirm;

  /// No description provided for @authFailed.
  ///
  /// In en, this message translates to:
  /// **'Authentication failed'**
  String get authFailed;

  /// No description provided for @authRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry authentication'**
  String get authRetry;

  /// No description provided for @contentHidden.
  ///
  /// In en, this message translates to:
  /// **'Content hidden'**
  String get contentHidden;

  /// No description provided for @sensitiveContent.
  ///
  /// In en, this message translates to:
  /// **'Sensitive content'**
  String get sensitiveContent;

  /// No description provided for @privacyMode.
  ///
  /// In en, this message translates to:
  /// **'Privacy mode'**
  String get privacyMode;

  /// No description provided for @privacyModeDescription.
  ///
  /// In en, this message translates to:
  /// **'Hides sensitive data like partner names'**
  String get privacyModeDescription;

  /// No description provided for @sensitiveMode.
  ///
  /// In en, this message translates to:
  /// **'Profanity filter'**
  String get sensitiveMode;

  /// No description provided for @sensitiveModeDescription.
  ///
  /// In en, this message translates to:
  /// **'Hides sugestive labels and text'**
  String get sensitiveModeDescription;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @clearData.
  ///
  /// In en, this message translates to:
  /// **'Clear all data'**
  String get clearData;

  /// No description provided for @clearDataDescription.
  ///
  /// In en, this message translates to:
  /// **'Deletes the local storage of the device'**
  String get clearDataDescription;

  /// No description provided for @clearPersonalData.
  ///
  /// In en, this message translates to:
  /// **'Clear personal data'**
  String get clearPersonalData;

  /// No description provided for @clearPersonalDataDescription.
  ///
  /// In en, this message translates to:
  /// **'Removes journal and partners'**
  String get clearPersonalDataDescription;

  /// No description provided for @initialFetch.
  ///
  /// In en, this message translates to:
  /// **'Download data'**
  String get initialFetch;

  /// No description provided for @initialFetchDescription.
  ///
  /// In en, this message translates to:
  /// **'Retrieves saved data from server'**
  String get initialFetchDescription;

  /// No description provided for @fetchStaticData.
  ///
  /// In en, this message translates to:
  /// **'Fetch static data'**
  String get fetchStaticData;

  /// No description provided for @loggedIn.
  ///
  /// In en, this message translates to:
  /// **'Logged in'**
  String get loggedIn;

  /// No description provided for @fetch.
  ///
  /// In en, this message translates to:
  /// **'Fetch'**
  String get fetch;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'App version'**
  String get version;

  /// No description provided for @buildNumber.
  ///
  /// In en, this message translates to:
  /// **'Build number'**
  String get buildNumber;

  /// No description provided for @installerStore.
  ///
  /// In en, this message translates to:
  /// **'Installer store'**
  String get installerStore;

  /// No description provided for @confirmClearDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear data'**
  String get confirmClearDataTitle;

  /// No description provided for @confirmClearDataDescription.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear the data?'**
  String get confirmClearDataDescription;

  /// No description provided for @appIcon.
  ///
  /// In en, this message translates to:
  /// **'App icon'**
  String get appIcon;

  /// No description provided for @condom.
  ///
  /// In en, this message translates to:
  /// **'Condom'**
  String get condom;

  /// No description provided for @cervicalCap.
  ///
  /// In en, this message translates to:
  /// **'Cervical cap'**
  String get cervicalCap;

  /// No description provided for @contraceptiveImplant.
  ///
  /// In en, this message translates to:
  /// **'Contraceptive implant'**
  String get contraceptiveImplant;

  /// No description provided for @contraceptivePatch.
  ///
  /// In en, this message translates to:
  /// **'Contraceptive patch'**
  String get contraceptivePatch;

  /// No description provided for @contraceptiveShot.
  ///
  /// In en, this message translates to:
  /// **'Contraceptive shot'**
  String get contraceptiveShot;

  /// No description provided for @diaphragm.
  ///
  /// In en, this message translates to:
  /// **'Diaphragm'**
  String get diaphragm;

  /// No description provided for @infertility.
  ///
  /// In en, this message translates to:
  /// **'Infertility'**
  String get infertility;

  /// No description provided for @internalCondom.
  ///
  /// In en, this message translates to:
  /// **'Internal condom'**
  String get internalCondom;

  /// No description provided for @intrauterineDevice.
  ///
  /// In en, this message translates to:
  /// **'Intrauterine Device (IUD)'**
  String get intrauterineDevice;

  /// No description provided for @outercourse.
  ///
  /// In en, this message translates to:
  /// **'Outercourse'**
  String get outercourse;

  /// No description provided for @pill.
  ///
  /// In en, this message translates to:
  /// **'Pill'**
  String get pill;

  /// No description provided for @pullOut.
  ///
  /// In en, this message translates to:
  /// **'Pull out'**
  String get pullOut;

  /// No description provided for @sponge.
  ///
  /// In en, this message translates to:
  /// **'Sponge'**
  String get sponge;

  /// No description provided for @vaginalRing.
  ///
  /// In en, this message translates to:
  /// **'Vaginal ring'**
  String get vaginalRing;

  /// No description provided for @tubalLigation.
  ///
  /// In en, this message translates to:
  /// **'Tubal ligation'**
  String get tubalLigation;

  /// No description provided for @vasectomy.
  ///
  /// In en, this message translates to:
  /// **'Vasectomy'**
  String get vasectomy;

  /// No description provided for @unsafeContraceptive.
  ///
  /// In en, this message translates to:
  /// **'Unsafe contraceptive'**
  String get unsafeContraceptive;

  /// No description provided for @backyard.
  ///
  /// In en, this message translates to:
  /// **'Backyard'**
  String get backyard;

  /// No description provided for @bar.
  ///
  /// In en, this message translates to:
  /// **'Bar'**
  String get bar;

  /// No description provided for @bathroom.
  ///
  /// In en, this message translates to:
  /// **'Bathroom'**
  String get bathroom;

  /// No description provided for @beach.
  ///
  /// In en, this message translates to:
  /// **'Beach'**
  String get beach;

  /// No description provided for @bedroom.
  ///
  /// In en, this message translates to:
  /// **'Bedroom'**
  String get bedroom;

  /// No description provided for @car.
  ///
  /// In en, this message translates to:
  /// **'Car'**
  String get car;

  /// No description provided for @chair.
  ///
  /// In en, this message translates to:
  /// **'Chair'**
  String get chair;

  /// No description provided for @cinema.
  ///
  /// In en, this message translates to:
  /// **'Cinema'**
  String get cinema;

  /// No description provided for @elevator.
  ///
  /// In en, this message translates to:
  /// **'Elevator'**
  String get elevator;

  /// No description provided for @forest.
  ///
  /// In en, this message translates to:
  /// **'Forest'**
  String get forest;

  /// No description provided for @garage.
  ///
  /// In en, this message translates to:
  /// **'Garage'**
  String get garage;

  /// No description provided for @hotel.
  ///
  /// In en, this message translates to:
  /// **'Hotel'**
  String get hotel;

  /// No description provided for @jacuzzi.
  ///
  /// In en, this message translates to:
  /// **'Jacuzzi'**
  String get jacuzzi;

  /// No description provided for @kitchen.
  ///
  /// In en, this message translates to:
  /// **'Kitchen'**
  String get kitchen;

  /// No description provided for @livingRoom.
  ///
  /// In en, this message translates to:
  /// **'Living room'**
  String get livingRoom;

  /// No description provided for @museum.
  ///
  /// In en, this message translates to:
  /// **'Museum'**
  String get museum;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @party.
  ///
  /// In en, this message translates to:
  /// **'Party'**
  String get party;

  /// No description provided for @plane.
  ///
  /// In en, this message translates to:
  /// **'Plane'**
  String get plane;

  /// No description provided for @pool.
  ///
  /// In en, this message translates to:
  /// **'Pool'**
  String get pool;

  /// No description provided for @public.
  ///
  /// In en, this message translates to:
  /// **'Public'**
  String get public;

  /// No description provided for @restroom.
  ///
  /// In en, this message translates to:
  /// **'Restroom'**
  String get restroom;

  /// No description provided for @roof.
  ///
  /// In en, this message translates to:
  /// **'Roof'**
  String get roof;

  /// No description provided for @school.
  ///
  /// In en, this message translates to:
  /// **'School'**
  String get school;

  /// No description provided for @ship.
  ///
  /// In en, this message translates to:
  /// **'Ship'**
  String get ship;

  /// No description provided for @shower.
  ///
  /// In en, this message translates to:
  /// **'Shower'**
  String get shower;

  /// No description provided for @sofa.
  ///
  /// In en, this message translates to:
  /// **'Sofa'**
  String get sofa;

  /// No description provided for @table.
  ///
  /// In en, this message translates to:
  /// **'Table'**
  String get table;

  /// No description provided for @theatre.
  ///
  /// In en, this message translates to:
  /// **'Theatre'**
  String get theatre;

  /// No description provided for @train.
  ///
  /// In en, this message translates to:
  /// **'Train'**
  String get train;

  /// No description provided for @work.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get work;

  /// No description provided for @anal.
  ///
  /// In en, this message translates to:
  /// **'Anal'**
  String get anal;

  /// No description provided for @bdsm.
  ///
  /// In en, this message translates to:
  /// **'BDSM'**
  String get bdsm;

  /// No description provided for @bondage.
  ///
  /// In en, this message translates to:
  /// **'Bondage'**
  String get bondage;

  /// No description provided for @choking.
  ///
  /// In en, this message translates to:
  /// **'Choking'**
  String get choking;

  /// No description provided for @cuddling.
  ///
  /// In en, this message translates to:
  /// **'Cuddling'**
  String get cuddling;

  /// No description provided for @domination.
  ///
  /// In en, this message translates to:
  /// **'Domination'**
  String get domination;

  /// No description provided for @fingering.
  ///
  /// In en, this message translates to:
  /// **'Fingering'**
  String get fingering;

  /// No description provided for @handjob.
  ///
  /// In en, this message translates to:
  /// **'Handjob'**
  String get handjob;

  /// No description provided for @oral.
  ///
  /// In en, this message translates to:
  /// **'Oral'**
  String get oral;

  /// No description provided for @toy.
  ///
  /// In en, this message translates to:
  /// **'Toy'**
  String get toy;

  /// No description provided for @vaginal.
  ///
  /// In en, this message translates to:
  /// **'Vaginal'**
  String get vaginal;

  /// No description provided for @anilingus.
  ///
  /// In en, this message translates to:
  /// **'Anilingus'**
  String get anilingus;

  /// No description provided for @blowjob.
  ///
  /// In en, this message translates to:
  /// **'Blowjob'**
  String get blowjob;

  /// No description provided for @cunnilingus.
  ///
  /// In en, this message translates to:
  /// **'Cunnilingus'**
  String get cunnilingus;

  /// No description provided for @titjob.
  ///
  /// In en, this message translates to:
  /// **'Titjob'**
  String get titjob;

  /// No description provided for @whiteKiss.
  ///
  /// In en, this message translates to:
  /// **'White kiss'**
  String get whiteKiss;

  /// No description provided for @creampie.
  ///
  /// In en, this message translates to:
  /// **'Creampie'**
  String get creampie;

  /// No description provided for @adventurous.
  ///
  /// In en, this message translates to:
  /// **'Adventurous'**
  String get adventurous;

  /// No description provided for @comfortable.
  ///
  /// In en, this message translates to:
  /// **'Comfortable'**
  String get comfortable;

  /// No description provided for @crazy.
  ///
  /// In en, this message translates to:
  /// **'Crazy'**
  String get crazy;

  /// No description provided for @horny.
  ///
  /// In en, this message translates to:
  /// **'Horny'**
  String get horny;

  /// No description provided for @lazy.
  ///
  /// In en, this message translates to:
  /// **'Lazy'**
  String get lazy;

  /// No description provided for @playful.
  ///
  /// In en, this message translates to:
  /// **'Playful'**
  String get playful;

  /// No description provided for @relaxed.
  ///
  /// In en, this message translates to:
  /// **'Relaxed'**
  String get relaxed;

  /// No description provided for @safeMood.
  ///
  /// In en, this message translates to:
  /// **'Safe'**
  String get safeMood;

  /// No description provided for @scared.
  ///
  /// In en, this message translates to:
  /// **'Scared'**
  String get scared;

  /// No description provided for @surprised.
  ///
  /// In en, this message translates to:
  /// **'Surprised'**
  String get surprised;

  /// No description provided for @angry.
  ///
  /// In en, this message translates to:
  /// **'Angry'**
  String get angry;

  /// No description provided for @unsafeMood.
  ///
  /// In en, this message translates to:
  /// **'Unsafe'**
  String get unsafeMood;

  /// No description provided for @noMood.
  ///
  /// In en, this message translates to:
  /// **'No mood'**
  String get noMood;

  /// No description provided for @unsupportedStatistic.
  ///
  /// In en, this message translates to:
  /// **'Unsupported statistic'**
  String get unsupportedStatistic;

  /// No description provided for @unsupportedStatisticDescription.
  ///
  /// In en, this message translates to:
  /// **'No widget for this type of statistic'**
  String get unsupportedStatisticDescription;

  /// No description provided for @daysWithoutSex.
  ///
  /// In en, this message translates to:
  /// **'Days without sex'**
  String get daysWithoutSex;

  /// No description provided for @daysWithoutMasturbation.
  ///
  /// In en, this message translates to:
  /// **'Days without masturbation'**
  String get daysWithoutMasturbation;

  /// No description provided for @lastRelationship.
  ///
  /// In en, this message translates to:
  /// **'Last relationship'**
  String get lastRelationship;

  /// No description provided for @lastMasturbation.
  ///
  /// In en, this message translates to:
  /// **'Last masturbation'**
  String get lastMasturbation;

  /// No description provided for @weeklyReport.
  ///
  /// In en, this message translates to:
  /// **'Weekly report'**
  String get weeklyReport;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get days;

  /// No description provided for @withoutSex.
  ///
  /// In en, this message translates to:
  /// **'without sex'**
  String get withoutSex;

  /// No description provided for @withoutMasturbation.
  ///
  /// In en, this message translates to:
  /// **'without solo'**
  String get withoutMasturbation;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
