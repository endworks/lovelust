import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_standalone.dart';
import 'package:lovelust/models/activity.dart';
import 'package:lovelust/models/enum.dart';
import 'package:lovelust/models/partner.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/api_service.dart';
import 'package:lovelust/services/storage_service.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SharedService extends ChangeNotifier {
  final StorageService _storage = getIt<StorageService>();
  final ApiService _api = getIt<ApiService>();

  String _theme = 'system';
  String? _colorScheme;
  String? _accessToken;
  String? _refreshToken;
  List<Activity> _activity = [];
  List<Partner> _partners = [];
  bool _privacyMode = false;
  bool _requireAuth = false;
  bool _calendarView = false;
  String? _activityFilter;
  PackageInfo? packageInfo;

  Future<void> initialLoad() async {
    debugPrint('initialLoad');
    List<Future> futures = <Future>[
      _storage.getTheme(),
      _storage.getColorScheme(),
      _storage.getAccessToken(),
      _storage.getRefreshToken(),
      _storage.getActivity(),
      _storage.getPartners(),
      _storage.getPrivacyMode(),
      _storage.getRequireAuth(),
      _storage.getCalendarView(),
      _storage.getActivityFilter(),
      findSystemLocale(),
      PackageInfo.fromPlatform(),
    ];

    List result = await Future.wait(futures);
    _theme = result[0];
    _colorScheme = result[1];
    _accessToken = result[2];
    _refreshToken = result[3];
    _activity = result[4];
    _partners = result[5];
    _privacyMode = result[6];
    _requireAuth = result[7];
    _calendarView = result[8];
    _activityFilter = result[9];
    Intl.systemLocale = result[10];
    packageInfo = result[11];
  }

  Future<void> initialFetch() async {
    debugPrint('initialFetch');
    activity = await _api.getActivity();
    partners = await _api.getPartners();
  }

  bool get isLoggedIn {
    return accessToken != null;
  }

  void signOut() {
    debugPrint('signOut');
    accessToken = null;
    refreshToken = null;
  }

  void clearPersonalData() {
    debugPrint('clearPersonalData');
    theme = 'system';
    colorScheme = null;
    accessToken = null;
    refreshToken = null;
    activity = [];
    partners = [];
  }

  void clearData() async {
    debugPrint('clearData');
    await _storage.clear();
  }

  Widget sensitiveText(String text, {TextStyle? style}) {
    return blurText(text, style: style);
  }

  Widget blurText(String text, {TextStyle? style}) {
    Text widget = Text(text, style: style);
    double blurRadius = style != null ? style.fontSize! / 4 : 5;
    if (privacyMode) {
      return ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: blurRadius, sigmaY: blurRadius),
        child: Container(child: widget),
      );
    }
    return widget;
  }

  Widget obscureText(String text, {TextStyle? style}) {
    return Text(privacyMode ? text.replaceAll(RegExp(r"."), "●") : text,
        style: style);
  }

  ActivitySafety calculateSafety(Activity activity) {
    List<Contraceptive> safe = [
      Contraceptive.condom,
      Contraceptive.internalCondom,
      Contraceptive.outercourse,
    ];
    List<Contraceptive?> unsafe = [
      null,
      Contraceptive.pullOut,
      Contraceptive.unsafeContraceptive
    ];

    if (safe.contains(activity.birthControl) ||
        safe.contains(activity.partnerBirthControl)) {
      return ActivitySafety.safe;
    }

    if (unsafe.contains(activity.birthControl) &&
        unsafe.contains(activity.partnerBirthControl)) {
      return ActivitySafety.unsafe;
    }

    return ActivitySafety.partlySafe;
  }

  Activity? getActivityById(String id) {
    if (id.isEmpty) {
      return null;
    }
    return activity.firstWhere((element) => element.id == id);
  }

  List<Activity> getActivityByPartner(String? id) {
    return activity.where((element) => element.partner == id).toList();
  }

  Partner? getPartnerById(String id) {
    if (id.isEmpty) {
      return null;
    }
    return partners.firstWhere((element) => element.id == id);
  }

  static Contraceptive? getContraceptiveByValue(String? value) {
    if (value == 'CERVICAL_CAP') {
      return Contraceptive.cervicalCap;
    } else if (value == 'CONDOM') {
      return Contraceptive.condom;
    } else if (value == 'DIAPHRAGM') {
      return Contraceptive.diaphragm;
    } else if (value == 'IMPLANT') {
      return Contraceptive.contraceptiveImplant;
    } else if (value == 'INFERTILITY') {
      return Contraceptive.infertility;
    } else if (value == 'INTERNAL_CONDOM') {
      return Contraceptive.internalCondom;
    } else if (value == 'IUD') {
      return Contraceptive.intrauterineDevice;
    } else if (value == 'OUTERCOURSE') {
      return Contraceptive.outercourse;
    } else if (value == 'PATCH') {
      return Contraceptive.contraceptivePatch;
    } else if (value == 'PILL') {
      return Contraceptive.pill;
    } else if (value == 'PULL_OUT') {
      return Contraceptive.pullOut;
    } else if (value == 'SHOT') {
      return Contraceptive.contraceptiveShot;
    } else if (value == 'SPONGE') {
      return Contraceptive.sponge;
    } else if (value == 'TUBAL_LIGATION') {
      return Contraceptive.tubalLigation;
    } else if (value == 'UNSAFE_BIRTH_CONTROL') {
      return Contraceptive.unsafeContraceptive;
    } else if (value == 'VAGINAL_RING') {
      return Contraceptive.vaginalRing;
    } else if (value == 'VASECTOMY') {
      return Contraceptive.vasectomy;
    }
    return null;
  }

  static String? setValueByContraceptive(Contraceptive? value) {
    if (value == Contraceptive.cervicalCap) {
      return 'CERVICAL_CAP';
    } else if (value == Contraceptive.condom) {
      return 'CONDOM';
    } else if (value == Contraceptive.diaphragm) {
      return 'DIAPHRAGM';
    } else if (value == Contraceptive.contraceptiveImplant) {
      return 'IMPLANT';
    } else if (value == Contraceptive.infertility) {
      return 'INFERTILITY';
    } else if (value == Contraceptive.internalCondom) {
      return 'INTERNAL_CONDOM';
    } else if (value == Contraceptive.intrauterineDevice) {
      return 'IUD';
    } else if (value == Contraceptive.outercourse) {
      return 'OUTERCOURSE';
    } else if (value == Contraceptive.contraceptivePatch) {
      return 'PATCH';
    } else if (value == Contraceptive.pill) {
      return 'PILL';
    } else if (value == Contraceptive.pullOut) {
      return 'PULL_OUT';
    } else if (value == Contraceptive.contraceptiveShot) {
      return 'SHOT';
    } else if (value == Contraceptive.sponge) {
      return 'SPONGE';
    } else if (value == Contraceptive.tubalLigation) {
      return 'TUBAL_LIGATION';
    } else if (value == Contraceptive.unsafeContraceptive) {
      return 'UNSAFE_BIRTH_CONTROL';
    } else if (value == Contraceptive.vaginalRing) {
      return 'VAGINAL_RING';
    } else if (value == Contraceptive.vasectomy) {
      return 'VASECTOMY';
    }
    return null;
  }

  static Initiator? getInitiatorByValue(String? value) {
    if (value == 'ME') {
      return Initiator.me;
    } else if (value == 'PARTNER') {
      return Initiator.partner;
    } else if (value == 'BOTH') {
      return Initiator.both;
    } else if (value == 'OTHER') {
      return Initiator.other;
    }
    return null;
  }

  static String? setValueByInitiator(Initiator? value) {
    if (value == Initiator.me) {
      return 'ME';
    } else if (value == Initiator.partner) {
      return 'PARTNER';
    } else if (value == Initiator.both) {
      return 'BOTH';
    } else if (value == Initiator.other) {
      return 'OTHER';
    }
    return null;
  }

  static Place? getPlaceByValue(String? value) {
    if (value == 'BACKYARD') {
      return Place.backyard;
    } else if (value == 'BAR') {
      return Place.bar;
    } else if (value == 'BATHROOM') {
      return Place.bathroom;
    } else if (value == 'BEACH') {
      return Place.beach;
    } else if (value == 'BEDROOM') {
      return Place.bedroom;
    } else if (value == 'CAR') {
      return Place.car;
    } else if (value == 'CHAIR') {
      return Place.chair;
    } else if (value == 'CINEMA') {
      return Place.cinema;
    } else if (value == 'ELEVATOR') {
      return Place.elevator;
    } else if (value == 'FOREST') {
      return Place.forest;
    } else if (value == 'GARAGE') {
      return Place.garage;
    } else if (value == 'HOME') {
      return Place.home;
    } else if (value == 'HOTEL') {
      return Place.hotel;
    } else if (value == 'JACUZZI') {
      return Place.jacuzzi;
    } else if (value == 'KITCHEN') {
      return Place.kitchen;
    } else if (value == 'LIVING_ROOM') {
      return Place.livingRoom;
    } else if (value == 'MUSEUM') {
      return Place.museum;
    } else if (value == 'OTHER') {
      return Place.other;
    } else if (value == 'PARTY') {
      return Place.party;
    } else if (value == 'PLANE') {
      return Place.plane;
    } else if (value == 'POOL') {
      return Place.pool;
    } else if (value == 'PUBLIC') {
      return Place.public;
    } else if (value == 'RESTROOM') {
      return Place.restroom;
    } else if (value == 'ROOF') {
      return Place.roof;
    } else if (value == 'SCHOOL') {
      return Place.school;
    } else if (value == 'SHIP') {
      return Place.ship;
    } else if (value == 'SHOWER') {
      return Place.shower;
    } else if (value == 'SOFA') {
      return Place.sofa;
    } else if (value == 'TABLE') {
      return Place.table;
    } else if (value == 'THEATRE') {
      return Place.theatre;
    } else if (value == 'TRAIN') {
      return Place.train;
    } else if (value == 'WORK') {
      return Place.work;
    }
    return null;
  }

  static String? setValueByPlace(Place? value) {
    if (value == Place.backyard) {
      return 'BACKYARD';
    } else if (value == Place.bar) {
      return 'BAR';
    } else if (value == Place.bathroom) {
      return 'BATHROOM';
    } else if (value == Place.beach) {
      return 'BEACH';
    } else if (value == Place.bedroom) {
      return 'BEDROOM';
    } else if (value == Place.car) {
      return 'CAR';
    } else if (value == Place.chair) {
      return 'CHAIR';
    } else if (value == Place.cinema) {
      return 'CINEMA';
    } else if (value == Place.elevator) {
      return 'ELEVATOR';
    } else if (value == Place.forest) {
      return 'FOREST';
    } else if (value == Place.garage) {
      return 'GARAGE';
    } else if (value == Place.home) {
      return 'HOME';
    } else if (value == Place.hotel) {
      return 'HOTEL';
    } else if (value == Place.jacuzzi) {
      return 'JACUZZI';
    } else if (value == Place.kitchen) {
      return 'KITCHEN';
    } else if (value == Place.livingRoom) {
      return 'LIVING_ROOM';
    } else if (value == Place.museum) {
      return 'MUSEUM';
    } else if (value == Place.other) {
      return 'OTHER';
    } else if (value == Place.party) {
      return 'PARTY';
    } else if (value == Place.plane) {
      return 'PLANE';
    } else if (value == Place.pool) {
      return 'POOL';
    } else if (value == Place.public) {
      return 'PUBLIC';
    } else if (value == Place.restroom) {
      return 'RESTROOM';
    } else if (value == Place.roof) {
      return 'ROOF';
    } else if (value == Place.school) {
      return 'SCHOOL';
    } else if (value == Place.ship) {
      return 'SHIP';
    } else if (value == Place.shower) {
      return 'SHOWER';
    } else if (value == Place.sofa) {
      return 'SOFA';
    } else if (value == Place.table) {
      return 'TABLE';
    } else if (value == Place.theatre) {
      return 'THEATRE';
    } else if (value == Place.train) {
      return 'TRAIN';
    } else if (value == Place.work) {
      return 'WORK';
    }
    return null;
  }

  static ActivityType? getActivityTypeByValue(String? value) {
    if (value == 'MASTURBATION') {
      return ActivityType.masturbation;
    } else if (value == 'SEXUAL_INTERCOURSE') {
      return ActivityType.sexualIntercourse;
    }
    return null;
  }

  static String? setValueByActivityType(ActivityType? value) {
    if (value == ActivityType.masturbation) {
      return 'MASTURBATION';
    } else if (value == ActivityType.sexualIntercourse) {
      return 'SEXUAL_INTERCOURSE';
    }
    return null;
  }

  static BiologicalSex getBiologicalSexByValue(String value) {
    if (value == 'F') {
      return BiologicalSex.female;
    }
    return BiologicalSex.male;
  }

  static String setValueByBiologicalSex(BiologicalSex value) {
    if (value == BiologicalSex.female) {
      return 'F';
    } else if (value == BiologicalSex.male) {
      return 'M';
    }
    return 'NB';
  }

  static Gender getGenderByValue(String value) {
    if (value == 'F') {
      return Gender.female;
    } else if (value == 'M') {
      return Gender.male;
    }
    return Gender.nonBinary;
  }

  static String setValueByGender(Gender value) {
    if (value == Gender.female) {
      return 'F';
    } else if (value == Gender.male) {
      return 'M';
    }
    return 'NB';
  }

  static Practice? getPracticeByValue(String? value) {
    if (value == 'ANAL') {
      return Practice.anal;
    } else if (value == 'BDSM') {
      return Practice.bdsm;
    } else if (value == 'BONDAGE') {
      return Practice.bondage;
    } else if (value == 'CHOKING') {
      return Practice.choking;
    } else if (value == 'CUDDLING') {
      return Practice.cuddling;
    } else if (value == 'DOMINATION') {
      return Practice.domination;
    } else if (value == 'FINGERING') {
      return Practice.fingering;
    } else if (value == 'HANDJOB') {
      return Practice.handjob;
    } else if (value == 'MASTURBATION') {
      return Practice.masturbation;
    } else if (value == 'ORAL') {
      return Practice.oral;
    } else if (value == 'TOY') {
      return Practice.toy;
    } else if (value == 'VAGINAL') {
      return Practice.vaginal;
    } else if (value == 'ANILINGUS') {
      return Practice.anilingus;
    } else if (value == 'BLOWJOB') {
      return Practice.blowjob;
    } else if (value == 'CUNNILINGUS') {
      return Practice.cunnilingus;
    } else if (value == 'TITJOB') {
      return Practice.titjob;
    } else if (value == 'WHITE_KISS') {
      return Practice.whiteKiss;
    } else if (value == 'CREAMPIE') {
      return Practice.creampie;
    }
    return null;
  }

  static String? setValueByPractice(Practice? value) {
    if (value == Practice.anal) {
      return 'ANAL';
    } else if (value == Practice.bdsm) {
      return 'BDSM';
    } else if (value == Practice.bondage) {
      return 'BONDAGE';
    } else if (value == Practice.choking) {
      return 'CHOKING';
    } else if (value == Practice.cuddling) {
      return 'CUDDLING';
    } else if (value == Practice.domination) {
      return 'DOMINATION';
    } else if (value == Practice.fingering) {
      return 'FINGERING';
    } else if (value == Practice.handjob) {
      return 'HANDJOB';
    } else if (value == Practice.masturbation) {
      return 'MASTURBATION';
    } else if (value == Practice.oral) {
      return 'ORAL';
    } else if (value == Practice.toy) {
      return 'TOY';
    } else if (value == Practice.vaginal) {
      return 'VAGINAL';
    } else if (value == Practice.anilingus) {
      return 'ANILINGUS';
    } else if (value == Practice.blowjob) {
      return 'BLOWJOB';
    } else if (value == Practice.cunnilingus) {
      return 'CUNNILINGUS';
    } else if (value == Practice.titjob) {
      return 'TITJOB';
    } else if (value == Practice.whiteKiss) {
      return 'WHITE_KISS';
    } else if (value == Practice.creampie) {
      return 'CREAMPIE';
    }
    return null;
  }

  static Mood? getMoodByValue(String? value) {
    if (value == 'ADVENTUROUS') {
      return Mood.adventurous;
    } else if (value == 'COMFORTABLE') {
      return Mood.comfortable;
    } else if (value == 'CRAZY') {
      return Mood.crazy;
    } else if (value == 'HORNY') {
      return Mood.horny;
    } else if (value == 'LAZY') {
      return Mood.lazy;
    } else if (value == 'PLAYFUL') {
      return Mood.playful;
    } else if (value == 'RELAXED') {
      return Mood.relaxed;
    } else if (value == 'SAFE') {
      return Mood.safe;
    } else if (value == 'SCARED') {
      return Mood.scared;
    } else if (value == 'SURPRISED') {
      return Mood.surprised;
    } else if (value == 'UNSAFE') {
      return Mood.unsafe;
    } else if (value == 'OTHER') {
      return Mood.other;
    }
    return null;
  }

  static String? setValueByMood(Mood? value) {
    if (value == Mood.adventurous) {
      return 'ADVENTUROUS';
    } else if (value == Mood.comfortable) {
      return 'COMFORTABLE';
    } else if (value == Mood.crazy) {
      return 'CRAZY';
    } else if (value == Mood.horny) {
      return 'HORNY';
    } else if (value == Mood.lazy) {
      return 'LAZY';
    } else if (value == Mood.playful) {
      return 'PLAYFUL';
    } else if (value == Mood.relaxed) {
      return 'RELAXED';
    } else if (value == Mood.safe) {
      return 'SAFE';
    } else if (value == Mood.scared) {
      return 'SCARED';
    } else if (value == Mood.surprised) {
      return 'SURPRISED';
    } else if (value == Mood.unsafe) {
      return 'UNSAFE';
    } else if (value == Mood.other) {
      return 'OTHER';
    }
    return null;
  }

  static String getContraceptiveTranslation(context, Contraceptive? value) {
    if (value == Contraceptive.cervicalCap) {
      return AppLocalizations.of(context)!.cervicalCap;
    } else if (value == Contraceptive.condom) {
      return AppLocalizations.of(context)!.condom;
    } else if (value == Contraceptive.contraceptiveImplant) {
      return AppLocalizations.of(context)!.contraceptiveImplant;
    } else if (value == Contraceptive.contraceptivePatch) {
      return AppLocalizations.of(context)!.contraceptivePatch;
    } else if (value == Contraceptive.contraceptiveShot) {
      return AppLocalizations.of(context)!.contraceptiveShot;
    } else if (value == Contraceptive.diaphragm) {
      return AppLocalizations.of(context)!.diaphragm;
    } else if (value == Contraceptive.infertility) {
      return AppLocalizations.of(context)!.infertility;
    } else if (value == Contraceptive.internalCondom) {
      return AppLocalizations.of(context)!.internalCondom;
    } else if (value == Contraceptive.intrauterineDevice) {
      return AppLocalizations.of(context)!.intrauterineDevice;
    } else if (value == Contraceptive.outercourse) {
      return AppLocalizations.of(context)!.outercourse;
    } else if (value == Contraceptive.pill) {
      return AppLocalizations.of(context)!.pill;
    } else if (value == Contraceptive.pullOut) {
      return AppLocalizations.of(context)!.pullOut;
    } else if (value == Contraceptive.sponge) {
      return AppLocalizations.of(context)!.sponge;
    } else if (value == Contraceptive.tubalLigation) {
      return AppLocalizations.of(context)!.tubalLigation;
    } else if (value == Contraceptive.unsafeContraceptive) {
      return AppLocalizations.of(context)!.unsafeContraceptive;
    } else if (value == Contraceptive.vaginalRing) {
      return AppLocalizations.of(context)!.vaginalRing;
    } else if (value == Contraceptive.vasectomy) {
      return AppLocalizations.of(context)!.vasectomy;
    }
    return AppLocalizations.of(context)!.noBirthControl;
  }

  static String getPlaceTranslation(context, Place? value) {
    if (value == Place.backyard) {
      return AppLocalizations.of(context)!.backyard;
    } else if (value == Place.bar) {
      return AppLocalizations.of(context)!.bar;
    } else if (value == Place.bathroom) {
      return AppLocalizations.of(context)!.bathroom;
    } else if (value == Place.beach) {
      return AppLocalizations.of(context)!.beach;
    } else if (value == Place.bedroom) {
      return AppLocalizations.of(context)!.bedroom;
    } else if (value == Place.car) {
      return AppLocalizations.of(context)!.car;
    } else if (value == Place.chair) {
      return AppLocalizations.of(context)!.chair;
    } else if (value == Place.cinema) {
      return AppLocalizations.of(context)!.cinema;
    } else if (value == Place.elevator) {
      return AppLocalizations.of(context)!.elevator;
    } else if (value == Place.forest) {
      return AppLocalizations.of(context)!.forest;
    } else if (value == Place.garage) {
      return AppLocalizations.of(context)!.garage;
    } else if (value == Place.home) {
      return AppLocalizations.of(context)!.home;
    } else if (value == Place.hotel) {
      return AppLocalizations.of(context)!.hotel;
    } else if (value == Place.jacuzzi) {
      return AppLocalizations.of(context)!.jacuzzi;
    } else if (value == Place.kitchen) {
      return AppLocalizations.of(context)!.kitchen;
    } else if (value == Place.livingRoom) {
      return AppLocalizations.of(context)!.livingRoom;
    } else if (value == Place.museum) {
      return AppLocalizations.of(context)!.museum;
    } else if (value == Place.other) {
      return AppLocalizations.of(context)!.other;
    } else if (value == Place.party) {
      return AppLocalizations.of(context)!.party;
    } else if (value == Place.plane) {
      return AppLocalizations.of(context)!.plane;
    } else if (value == Place.pool) {
      return AppLocalizations.of(context)!.pool;
    } else if (value == Place.public) {
      return AppLocalizations.of(context)!.public;
    } else if (value == Place.restroom) {
      return AppLocalizations.of(context)!.restroom;
    } else if (value == Place.roof) {
      return AppLocalizations.of(context)!.roof;
    } else if (value == Place.school) {
      return AppLocalizations.of(context)!.school;
    } else if (value == Place.ship) {
      return AppLocalizations.of(context)!.ship;
    } else if (value == Place.shower) {
      return AppLocalizations.of(context)!.shower;
    } else if (value == Place.sofa) {
      return AppLocalizations.of(context)!.sofa;
    } else if (value == Place.table) {
      return AppLocalizations.of(context)!.table;
    } else if (value == Place.theatre) {
      return AppLocalizations.of(context)!.theatre;
    } else if (value == Place.train) {
      return AppLocalizations.of(context)!.train;
    } else if (value == Place.work) {
      return AppLocalizations.of(context)!.work;
    }
    return AppLocalizations.of(context)!.unknownPlace;
  }

  static String getInitiatorTranslation(context, Initiator? value) {
    if (value == Initiator.me) {
      return AppLocalizations.of(context)!.me;
    } else if (value == Initiator.partner) {
      return AppLocalizations.of(context)!.partner;
    } else if (value == Initiator.both) {
      return AppLocalizations.of(context)!.both;
    } else if (value == Initiator.other) {
      return AppLocalizations.of(context)!.other;
    }
    return AppLocalizations.of(context)!.noInitiator;
  }

  static String getPracticeTranslation(context, Practice? value) {
    if (value == Practice.anal) {
      return AppLocalizations.of(context)!.anal;
    } else if (value == Practice.bdsm) {
      return AppLocalizations.of(context)!.bdsm;
    } else if (value == Practice.bondage) {
      return AppLocalizations.of(context)!.bondage;
    } else if (value == Practice.choking) {
      return AppLocalizations.of(context)!.choking;
    } else if (value == Practice.cuddling) {
      return AppLocalizations.of(context)!.cuddling;
    } else if (value == Practice.domination) {
      return AppLocalizations.of(context)!.domination;
    } else if (value == Practice.fingering) {
      return AppLocalizations.of(context)!.fingering;
    } else if (value == Practice.handjob) {
      return AppLocalizations.of(context)!.handjob;
    } else if (value == Practice.masturbation) {
      return AppLocalizations.of(context)!.masturbation;
    } else if (value == Practice.oral) {
      return AppLocalizations.of(context)!.oral;
    } else if (value == Practice.toy) {
      return AppLocalizations.of(context)!.toy;
    } else if (value == Practice.vaginal) {
      return AppLocalizations.of(context)!.vaginal;
    } else if (value == Practice.anilingus) {
      return AppLocalizations.of(context)!.anilingus;
    } else if (value == Practice.blowjob) {
      return AppLocalizations.of(context)!.blowjob;
    } else if (value == Practice.cunnilingus) {
      return AppLocalizations.of(context)!.cunnilingus;
    } else if (value == Practice.titjob) {
      return AppLocalizations.of(context)!.titjob;
    } else if (value == Practice.whiteKiss) {
      return AppLocalizations.of(context)!.whiteKiss;
    } else if (value == Practice.creampie) {
      return AppLocalizations.of(context)!.creampie;
    }
    return AppLocalizations.of(context)!.unknown;
  }

  static String getMoodTranslation(context, Mood? value) {
    if (value == Mood.adventurous) {
      return AppLocalizations.of(context)!.adventurous;
    } else if (value == Mood.comfortable) {
      return AppLocalizations.of(context)!.comfortable;
    } else if (value == Mood.crazy) {
      return AppLocalizations.of(context)!.crazy;
    } else if (value == Mood.horny) {
      return AppLocalizations.of(context)!.horny;
    } else if (value == Mood.lazy) {
      return AppLocalizations.of(context)!.lazy;
    } else if (value == Mood.playful) {
      return AppLocalizations.of(context)!.playful;
    } else if (value == Mood.relaxed) {
      return AppLocalizations.of(context)!.relaxed;
    } else if (value == Mood.safe) {
      return AppLocalizations.of(context)!.safeMood;
    } else if (value == Mood.scared) {
      return AppLocalizations.of(context)!.scared;
    } else if (value == Mood.surprised) {
      return AppLocalizations.of(context)!.surprised;
    } else if (value == Mood.unsafe) {
      return AppLocalizations.of(context)!.unsafeMood;
    }
    return AppLocalizations.of(context)!.noMood;
  }

  static String? emptyStringToNull(String? value) {
    if (value != null) {
      return value.isEmpty ? null : value;
    }
    return null;
  }

  String get theme {
    return _theme;
  }

  set theme(String value) {
    _theme = value;
    _storage.setTheme(value);
    notifyListeners();
  }

  String? get colorScheme {
    return _colorScheme;
  }

  set colorScheme(String? value) {
    _colorScheme = value;
    _storage.setColorScheme(value);
    notifyListeners();
  }

  String? get accessToken {
    return _accessToken;
  }

  set accessToken(String? value) {
    _accessToken = value;
    _storage.setAccessToken(value);
    notifyListeners();
  }

  String? get refreshToken {
    return _refreshToken;
  }

  set refreshToken(String? value) {
    _refreshToken = value;
    _storage.setRefreshToken(value);
    notifyListeners();
  }

  List<Activity> get activity {
    return _activity;
  }

  set activity(List<Activity> value) {
    _activity = value;
    _storage.setActivity(value);
    notifyListeners();
  }

  List<Partner> get partners {
    return _partners;
  }

  set partners(List<Partner> value) {
    _partners = value;
    _storage.setPartners(value);
    notifyListeners();
  }

  bool get privacyMode {
    return _privacyMode;
  }

  set privacyMode(bool value) {
    _privacyMode = value;
    _storage.setPrivacyMode(value);
    notifyListeners();
  }

  bool get requireAuth {
    return _requireAuth;
  }

  set requireAuth(bool value) {
    _requireAuth = value;
    _storage.setRequireAuth(value);
    notifyListeners();
  }

  bool get calendarView {
    return _calendarView;
  }

  set calendarView(bool value) {
    _calendarView = value;
    _storage.setCalendarView(value);
    notifyListeners();
  }

  String? get activityFilter {
    return _activityFilter;
  }

  set activityFilter(String? value) {
    _activityFilter = value;
    _storage.setActivityFilter(value);
    notifyListeners();
  }
}
