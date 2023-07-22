import 'dart:ui';

import 'package:flutter/material.dart';
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
    if (activity.birthControl == Contraceptive.condom ||
        activity.partnerBirthControl == Contraceptive.condom) {
      return ActivitySafety.safe;
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
    }
    return null;
  }

  static Place? getPlaceByValue(String? value) {
    if (value == 'BEDROOM') {
      return Place.bedroom;
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
