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
    var futures = <Future>[
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
      loadStaticData(),
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
    Intl.systemLocale = result[11];
    packageInfo = result[12];
    return Future.value(null);
  }

  Future<void> initialFetch() async {
    debugPrint('initialFetch');
    var futures = <Future>[
      _api.getActivity(),
      _api.getPartners(),
      fetchStaticData()
    ];

    List result = await Future.wait(futures);
    activity = result[0];
    partners = result[1];
    return Future.value(null);
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
    var futures = <Future>[
      _api.getGenders(),
      _api.getInitiators(),
      _api.getPractices(),
      _api.getPlaces(),
      _api.getBirthControls(),
      _api.getActivityTypes(),
    ];

    List result = await Future.wait(futures);
    genders = result[0];
    initiators = result[1];
    practices = result[2];
    places = result[3];
    birthControls = result[4];
    activityTypes = result[5];
    return Future.value(null);
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
    return ActivitySafety.unsafe;
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
