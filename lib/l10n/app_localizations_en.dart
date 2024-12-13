import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get start => 'Home';

  @override
  String get journal => 'Journal';

  @override
  String get partners => 'Partners';

  @override
  String get learn => 'Learn';

  @override
  String get all => 'All';

  @override
  String get allEntries => 'All entries';

  @override
  String get onlySex => 'Only sex';

  @override
  String get onlySolo => 'Only solo';

  @override
  String get calendar => 'Calendar';

  @override
  String get timeline => 'Timeline';

  @override
  String get logActivity => 'Log activity';

  @override
  String get safety => 'Safety';

  @override
  String get safe => 'Protected';

  @override
  String get safeSex => 'Protected sex';

  @override
  String get safeMsg => 'Although condom use is associated with a very low risk of STIs, there is no such thing as 100% risk-free sex.';

  @override
  String get unsafe => 'Very unsafe';

  @override
  String get unsafeSex => 'Very unsafe sex';

  @override
  String get unsafeMsg => 'High level of risk due to contraception not been used';

  @override
  String get partiallyUnsafe => 'Partially unsafe';

  @override
  String get partiallyUnsafeSex => 'Partially unsafe sex';

  @override
  String get partiallyUnsafeMsg => 'Partially unsafe because even if it is potentially prevented against pregnancy you can still contract Sexually Transmitted Infections (STIs)';

  @override
  String get birthControl => 'Birth control';

  @override
  String get min => 'min.';

  @override
  String get byMe => 'by me';

  @override
  String get byPartner => 'by partner';

  @override
  String get byBoth => 'by both';

  @override
  String get performance => 'Performance';

  @override
  String get highlights => 'Highlights';

  @override
  String orgasmsByMe(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
      
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'orgasms by me',
      one: 'orgasm by me',
    );
    return '$_temp0';
  }

  @override
  String orgasmsByPartner(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
      
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'orgasms by partner',
      one: 'orgasm by partner',
    );
    return '$_temp0';
  }

  @override
  String get practices => 'Practices';

  @override
  String get sexualActivity => 'Sexual activity';

  @override
  String initiatedIt(String initiator) {
    String _temp0 = intl.Intl.selectLogic(
      initiator,
      {
        'other': 'initiated it',
      },
    );
    return '$_temp0';
  }

  @override
  String get editActivity => 'Edit activity';

  @override
  String get addPartner => 'Add partner';

  @override
  String get createPartner => 'Create partner';

  @override
  String get editPartner => 'Edit partner';

  @override
  String get man => 'Man';

  @override
  String get transMan => 'Trans man';

  @override
  String get woman => 'Woman';

  @override
  String get transWoman => 'Trans woman';

  @override
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get nonBinary => 'Non binary';

  @override
  String get name => 'Name';

  @override
  String get nameHint => 'Enter name...';

  @override
  String get notes => 'Notes';

  @override
  String get notesHint => 'Enter notes...';

  @override
  String get date => 'Date';

  @override
  String get time => 'Time';

  @override
  String get moreFields => 'More fields';

  @override
  String get lessFields => 'Less fields';

  @override
  String get rating => 'Rating';

  @override
  String get duration => 'Duration (in min.)';

  @override
  String get orgasms => 'Orgasms';

  @override
  String get partnerOrgasms => 'Partner orgasms';

  @override
  String get meetingDate => 'First encounter date';

  @override
  String get birthDay => 'Birthday';

  @override
  String get gender => 'Gender';

  @override
  String get sex => 'Biological sex';

  @override
  String get unknown => 'Unknown';

  @override
  String get unknownPartner => 'Unknown';

  @override
  String get unknownPlace => 'Unknown place';

  @override
  String get solo => 'Solo';

  @override
  String get sexualIntercourse => 'Sexual intercourse';

  @override
  String get masturbation => 'Masturbation';

  @override
  String get activityType => 'Activity type';

  @override
  String get partner => 'Partner';

  @override
  String get me => 'Me';

  @override
  String get both => 'Both';

  @override
  String get partnerBirthControl => 'Partner birth control';

  @override
  String get noBirthControl => 'No birth control';

  @override
  String get noInitiator => 'No initiator';

  @override
  String get place => 'Place';

  @override
  String get location => 'Location';

  @override
  String get initiator => 'Initiator';

  @override
  String get mood => 'Mood';

  @override
  String get ejaculation => 'Ejaculation';

  @override
  String get ejaculationAss => 'Inside the ass';

  @override
  String get ejaculationBack => 'On the back';

  @override
  String get ejaculationButtocks => 'On the buttocks';

  @override
  String get ejaculationChest => 'On the chest';

  @override
  String get ejaculationFace => 'On the face';

  @override
  String get ejaculationMouth => 'Inside the mouth';

  @override
  String get ejaculationVagina => 'Inside the vagina';

  @override
  String get noEjaculation => 'No ejaculation';

  @override
  String get watchedPorn => 'I watched porn';

  @override
  String get socials => 'Social networks';

  @override
  String get phone => 'Phone';

  @override
  String get instagram => 'Instagram';

  @override
  String get x => 'X / Twitter';

  @override
  String get snapchat => 'Snapchat';

  @override
  String get onlyfans => 'OnlyFans';

  @override
  String get noSexualActivity => 'No sexual activity...';

  @override
  String get noContent => 'No content to show';

  @override
  String get noStatistics => 'No statistics yet';

  @override
  String get noSummary => 'No summary yet';

  @override
  String get noActivity => 'Your journal is empty';

  @override
  String get noActivityToday => 'No activity today';

  @override
  String get noPartners => 'No partners yet';

  @override
  String get settings => 'Settings';

  @override
  String get colorScheme => 'Color';

  @override
  String get defaultColorScheme => 'Default';

  @override
  String get dynamicColorScheme => 'Dynamic';

  @override
  String get love => 'Pink Love';

  @override
  String get lust => 'Purple Lust';

  @override
  String get lovelust => 'Pink LoveLust';

  @override
  String get lustfullove => 'Pink and Purple';

  @override
  String get lovefullust => 'Purple and Pink';

  @override
  String get lipstick => 'Red Lipstick';

  @override
  String get shimapan => 'Teal Shimapan';

  @override
  String get blue => 'Blue Movie';

  @override
  String get monochrome => 'Monochrome';

  @override
  String get experimental => 'Experimental';

  @override
  String get trueBlack => 'True black';

  @override
  String get trueBlackDescription => 'Use true black for OLED screens';

  @override
  String get material => 'Material';

  @override
  String get materialDescription => 'Use Material UI';

  @override
  String get modernUI => 'Modern UI';

  @override
  String get modernUIDescription => 'Try the experimental new UI';

  @override
  String get appearance => 'Appearance';

  @override
  String get theme => 'Theme';

  @override
  String get chooseTheme => 'Choose theme';

  @override
  String get system => 'System default';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get defaultAppIcon => 'Default';

  @override
  String get beta => 'Beta';

  @override
  String get white => 'White';

  @override
  String get black => 'Black';

  @override
  String get monoWhite => 'White Kiss';

  @override
  String get monoBlack => 'Black Leather';

  @override
  String get filled => 'Filled';

  @override
  String get filled2 => 'Filled II';

  @override
  String get filledWhite => 'Filled White';

  @override
  String get filledWhite2 => 'Filled White II';

  @override
  String get pink => 'Pink';

  @override
  String get purple => 'Purple';

  @override
  String get deepPurple => 'Purple Deep';

  @override
  String get orange => 'Orange';

  @override
  String get neon => 'Neon';

  @override
  String get glow => 'Glow';

  @override
  String get pride => 'Pride';

  @override
  String get prideRainbow => 'Pride: Rainbow';

  @override
  String get prideRainbowLine => 'Pride: Rainbow Line';

  @override
  String get prideBi => 'Pride: Bi';

  @override
  String get prideTrans => 'Pride: Trans';

  @override
  String get prideAce => 'Pride: Ace';

  @override
  String get prideRomania => 'Pride: Romania';

  @override
  String get sexapill => 'Sexapill';

  @override
  String get sexapillWhite => 'Sexapill White';

  @override
  String get health => 'Health';

  @override
  String get health2 => 'Health II';

  @override
  String get health3 => 'Health III';

  @override
  String get health4 => 'Health IV';

  @override
  String get journal2 => 'Journal II';

  @override
  String get bold => 'Bold';

  @override
  String get butt => 'Butt';

  @override
  String get genital => 'Genital';

  @override
  String get abstractIcon => 'Abstract';

  @override
  String get pastel => 'Pastel';

  @override
  String get pills => 'Pills';

  @override
  String get pills2 => 'Pills II';

  @override
  String get pills3 => 'Pills III';

  @override
  String get fire => 'Fire';

  @override
  String get paper => 'Paper';

  @override
  String get overflow => 'Overflow';

  @override
  String get renamesApp => 'Changes the name of the app';

  @override
  String get requireFingerprint => 'Require fingerprint';

  @override
  String get requireFingerprintDescription => 'Require fingerprint to access the app';

  @override
  String get requireFace => 'Require face recognition';

  @override
  String get requireFaceDescription => 'Require face recognition to access the app';

  @override
  String get requireFaceID => 'Require FaceID';

  @override
  String get requireFaceIDDescription => 'Require FaceID to access the app';

  @override
  String get requireTouchID => 'Require TouchID';

  @override
  String get requireTouchIDDescription => 'Require TouchID to access the app';

  @override
  String get requirePasscode => 'Require passcode';

  @override
  String get requirePasscodeDescription => 'Require passcode to access the app';

  @override
  String get requireAuth => 'Require authentication';

  @override
  String get requireAuthDescription => 'Require authentication to access the app';

  @override
  String get requireAuthToAccess => 'Authentication required to access';

  @override
  String get requireAuthToConfirm => 'Authentication required to confirm';

  @override
  String get authFailed => 'Authentication failed';

  @override
  String get authRetry => 'Retry authentication';

  @override
  String get contentHidden => 'Content hidden';

  @override
  String get sensitiveContent => 'Sensitive content';

  @override
  String get privacyMode => 'Privacy mode';

  @override
  String get privacyModeDescription => 'Hides sensitive data like partner names';

  @override
  String get sensitiveMode => 'Profanity filter';

  @override
  String get sensitiveModeDescription => 'Hides sugestive labels and text';

  @override
  String get username => 'Username';

  @override
  String get password => 'Password';

  @override
  String get signIn => 'Sign in';

  @override
  String get signOut => 'Sign out';

  @override
  String get clearData => 'Clear all data';

  @override
  String get clearDataDescription => 'Deletes the local storage of the device';

  @override
  String get clearPersonalData => 'Clear personal data';

  @override
  String get clearPersonalDataDescription => 'Removes journal and partners';

  @override
  String get initialFetch => 'Download data';

  @override
  String get initialFetchDescription => 'Retrieves saved data from server';

  @override
  String get fetchStaticData => 'Fetch static data';

  @override
  String get loggedIn => 'Logged in';

  @override
  String get healthIntegration => 'Health integration';

  @override
  String get healthIntegrationDescription => 'Integrate with native health data app';

  @override
  String get healthIntegrationDescriptionAndroid => 'Integrate with Health Connect';

  @override
  String get healthIntegrationDescriptionIOS => 'Integrate with HealthKit';

  @override
  String get healthPermissions => 'Permissions';

  @override
  String get healthImport => 'Import data';

  @override
  String get healthExport => 'Export data';

  @override
  String get healthInstall => 'Install Health Connect';

  @override
  String get healthOpen => 'Open Health';

  @override
  String get fetch => 'Fetch';

  @override
  String get version => 'App version';

  @override
  String get buildNumber => 'Build number';

  @override
  String get installerStore => 'Installer store';

  @override
  String get confirmClearDataTitle => 'Clear data';

  @override
  String get confirmClearDataDescription => 'Are you sure you want to clear the data?';

  @override
  String get appIcon => 'App icon';

  @override
  String get condom => 'Condom';

  @override
  String get cervicalCap => 'Cervical cap';

  @override
  String get contraceptiveImplant => 'Contraceptive implant';

  @override
  String get contraceptivePatch => 'Contraceptive patch';

  @override
  String get contraceptiveShot => 'Contraceptive shot';

  @override
  String get diaphragm => 'Diaphragm';

  @override
  String get infertility => 'Infertility';

  @override
  String get internalCondom => 'Internal condom';

  @override
  String get intrauterineDevice => 'Intrauterine Device (IUD)';

  @override
  String get outercourse => 'Without penetration';

  @override
  String get pill => 'Pill';

  @override
  String get pullOut => 'Pull out';

  @override
  String get sponge => 'Sponge';

  @override
  String get vaginalRing => 'Vaginal ring';

  @override
  String get tubalLigation => 'Tubal ligation';

  @override
  String get vasectomy => 'Vasectomy';

  @override
  String get unsafeContraceptive => 'Unsafe contraceptive';

  @override
  String get backyard => 'Backyard';

  @override
  String get bar => 'Bar';

  @override
  String get bathroom => 'Bathroom';

  @override
  String get beach => 'Beach';

  @override
  String get bedroom => 'Bedroom';

  @override
  String get car => 'Car';

  @override
  String get chair => 'Chair';

  @override
  String get cinema => 'Cinema';

  @override
  String get elevator => 'Elevator';

  @override
  String get forest => 'Forest';

  @override
  String get garage => 'Garage';

  @override
  String get home => 'Home';

  @override
  String get hotel => 'Hotel';

  @override
  String get jacuzzi => 'Jacuzzi';

  @override
  String get kitchen => 'Kitchen';

  @override
  String get livingRoom => 'Living room';

  @override
  String get museum => 'Museum';

  @override
  String get other => 'Other';

  @override
  String get party => 'Party';

  @override
  String get plane => 'Plane';

  @override
  String get pool => 'Pool';

  @override
  String get public => 'Public';

  @override
  String get restroom => 'Restroom';

  @override
  String get roof => 'Roof';

  @override
  String get school => 'School';

  @override
  String get ship => 'Ship';

  @override
  String get shower => 'Shower';

  @override
  String get sofa => 'Sofa';

  @override
  String get table => 'Table';

  @override
  String get theatre => 'Theatre';

  @override
  String get train => 'Train';

  @override
  String get work => 'Work';

  @override
  String get anal => 'Anal';

  @override
  String get bdsm => 'BDSM';

  @override
  String get bondage => 'Bondage';

  @override
  String get choking => 'Choking';

  @override
  String get cuddling => 'Cuddling';

  @override
  String get domination => 'Domination';

  @override
  String get fingering => 'Fingering';

  @override
  String get handjob => 'Handjob';

  @override
  String get oral => 'Oral';

  @override
  String get toy => 'Toy';

  @override
  String get vaginal => 'Vaginal';

  @override
  String get anilingus => 'Anilingus';

  @override
  String get blowjob => 'Blowjob';

  @override
  String get cunnilingus => 'Cunnilingus';

  @override
  String get titjob => 'Titjob';

  @override
  String get whiteKiss => 'White kiss';

  @override
  String get creampie => 'Creampie';

  @override
  String get adventurous => 'Adventurous';

  @override
  String get comfortable => 'Comfortable';

  @override
  String get crazy => 'Crazy';

  @override
  String get horny => 'Horny';

  @override
  String get lazy => 'Lazy';

  @override
  String get playful => 'Playful';

  @override
  String get relaxed => 'Relaxed';

  @override
  String get safeMood => 'Safe';

  @override
  String get scared => 'Scared';

  @override
  String get surprised => 'Surprised';

  @override
  String get angry => 'Angry';

  @override
  String get unsafeMood => 'Unsafe';

  @override
  String get noMood => 'No mood';

  @override
  String get statistics => 'Statistics';

  @override
  String get unsupportedStatistic => 'Unsupported statistic';

  @override
  String get unsupportedStatisticDescription => 'No widget for this type of statistic';

  @override
  String get daysWithoutSex => 'Days without sex';

  @override
  String get daysWithoutMasturbation => 'Days without fap';

  @override
  String get lastSexualActivity => 'Last sexual activity';

  @override
  String get lastMasturbation => 'Last masturbation';

  @override
  String get weeklyChart => 'Weekly chart';

  @override
  String get monthlyChart => 'Monthly chart';

  @override
  String get yearlyChart => 'Yearly chart';

  @override
  String get globalChart => 'Global chart';

  @override
  String get days => 'Days';

  @override
  String get withoutSex => 'without sex';

  @override
  String get withoutMasturbation => 'without fap';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get save => 'Save';

  @override
  String get help => 'Help';

  @override
  String get mostPopularPartner => 'Most popular partner';

  @override
  String get mostPopularPractice => 'Most popular practice';

  @override
  String get mostPopularMood => 'Most popular mood';

  @override
  String get mostPopularEjaculationPlace => 'Most popular ejaculation place';

  @override
  String get mostPopularPlace => 'Most popular place';

  @override
  String get mostActiveYear => 'Most active year';

  @override
  String get mostActiveMonth => 'Most active month';

  @override
  String get mostActiveHour => 'Most active hour';

  @override
  String get mostActiveWeekday => 'Most active weekday';

  @override
  String get orgasmRatio => 'Orgasm ratio';

  @override
  String get averageDuration => 'Average duration';
}
