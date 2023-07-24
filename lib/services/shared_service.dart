import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_standalone.dart';
import 'package:lovelust/models/activity.dart';
import 'package:lovelust/models/enum.dart';
import 'package:lovelust/models/id_name.dart';
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
  List<IdName> _birthControls = [];
  List<IdName> _practices = [];
  List<IdName> _places = [];
  List<IdName> _initiators = [];
  List<IdName> _genders = [];
  List<IdName> _activityTypes = [];
  bool _privacyMode = false;
  bool _requireAuth = false;
  bool _calendarView = false;
  String? _activityFilter;
  PackageInfo? packageInfo;

  Future<void> initialLoad() async {
    debugPrint('initialLoad');
    _theme = await _storage.getTheme();
    _colorScheme = await _storage.getColorScheme();
    _accessToken = await _storage.getAccessToken();
    _refreshToken = await _storage.getRefreshToken();
    _activity = await _storage.getActivity();
    _partners = await _storage.getPartners();
    _privacyMode = await _storage.getPrivacyMode();
    _requireAuth = await _storage.getRequireAuth();
    _calendarView = await _storage.getCalendarView();
    _activityFilter = await _storage.getActivityFilter();
    Intl.systemLocale = await findSystemLocale();
    packageInfo = await PackageInfo.fromPlatform();
  }

  Future<void> initialFetch() async {
    debugPrint('initialFetch');
    activity = await _api.getActivity();
    partners = await _api.getPartners();
    // await fetchStaticData();
  }

  Future<void> loadStaticData() async {
    debugPrint('loadStaticData');
    var futures = <Future>[
      _storage.getGenders(),
      _storage.getInitiators(),
      _storage.getPractices(),
      _storage.getPlaces(),
      _storage.getBirthControls(),
      _storage.getActivityTypes(),
    ];

    List result = await Future.wait(futures);
    _genders = result[0];
    _initiators = result[1];
    _practices = result[2];
    _places = result[3];
    _birthControls = result[4];
    _activityTypes = result[5];
    if (_genders.isEmpty ||
        _initiators.isEmpty ||
        _practices.isEmpty ||
        _places.isEmpty ||
        _birthControls.isEmpty ||
        _activityTypes.isEmpty) {
      await fetchStaticData();
    }
    return Future.value(null);
  }

  fetchStaticData() async {
    debugPrint('fetchStaticData');
    genders = await _api.getGenders();
    initiators = await _api.getInitiators();
    practices = await _api.getPractices();
    places = await _api.getPlaces();
    birthControls = await _api.getBirthControls();
    activityTypes = await _api.getActivityTypes();
  }

  bool get isLoggedIn {
    return accessToken != null;
  }

  bool get monochrome {
    return colorScheme == 'monochrome';
  }

  int get alpha {
    return Colors.black38.alpha;
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

    if (activity.birthControl == null && activity.partnerBirthControl == null) {
      return ActivitySafety.unsafe;
    }

    return ActivitySafety.partlySafe;
  }

  Activity? getActivityById(String id) {
    return activity.firstWhere((element) => element.id == id);
  }

  List<Activity> getActivityByPartner(String id) {
    return activity.where((element) => element.partner == id).toList();
  }

  Partner? getPartnerById(String id) {
    return partners.firstWhere((element) => element.id == id);
  }

  IdName? getPracticeById(String id) {
    return practices.firstWhere((element) => element.id == id);
  }

  IdName? getBirthControlById(String id) {
    return birthControls.firstWhere((element) => element.id == id);
  }

  IdName? getPlaceById(String id) {
    return places.firstWhere((element) => element.id == id);
  }

  IdName? getInitiatorById(String id) {
    return initiators.firstWhere((element) => element.id == id);
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

  static String setValueByActivityType(ActivityType value) {
    if (value == ActivityType.masturbation) {
      return 'MASTURBATION';
    }
    return 'SEXUAL_INTERCOURSE';
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
    } else if (value == 'FINGER') {
      return Practice.finger;
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
    } else if (value == Practice.finger) {
      return 'FINGER';
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

  List<IdName> get birthControls {
    return _birthControls;
  }

  set birthControls(List<IdName> value) {
    _birthControls = value;
    _storage.setBirthControls(value);
    notifyListeners();
  }

  List<IdName> get practices {
    return _practices;
  }

  set practices(List<IdName> value) {
    _practices = value;
    _storage.setPractices(value);
    notifyListeners();
  }

  List<IdName> get places {
    return _places;
  }

  set places(List<IdName> value) {
    _places = value;
    _storage.setPlaces(value);
    notifyListeners();
  }

  List<IdName> get initiators {
    return _initiators;
  }

  set initiators(List<IdName> value) {
    _initiators = value;
    _storage.setInitiators(value);
    notifyListeners();
  }

  List<IdName> get genders {
    return _genders;
  }

  set genders(List<IdName> value) {
    _genders = value;
    _storage.setGenders(value);
    notifyListeners();
  }

  List<IdName> get activityTypes {
    return _activityTypes;
  }

  set activityTypes(List<IdName> value) {
    _activityTypes = value;
    _storage.setActivityTypes(value);
    notifyListeners();
  }
}
