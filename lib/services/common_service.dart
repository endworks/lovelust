import 'package:flutter/material.dart';
import 'package:lovelust/models/activity.dart';
import 'package:lovelust/models/id_name.dart';
import 'package:lovelust/models/partner.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/api_service.dart';
import 'package:lovelust/services/storage_service.dart';

class CommonService {
  final StorageService _storage = getIt<StorageService>();
  final ApiService _api = getIt<ApiService>();

  String _theme = 'system';
  String _colorScheme = 'dynamic';
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
  bool _calendarView = false;
  String _activityFilter = 'all';

  Future<void> initialLoad() async {
    debugPrint('initialLoad');
    var futures = <Future>[
      _storage.getTheme(),
      _storage.getColorScheme(),
      _storage.getAccessToken(),
      _storage.getRefreshToken(),
      _storage.getActivity(),
      _storage.getPartners(),
      _storage.getCalendarView(),
      _storage.getActivityFilter(),
      loadStaticData()
    ];

    List result = await Future.wait(futures);
    theme = result[0];
    colorScheme = result[1];
    accessToken = result[2];
    refreshToken = result[3];
    activity = result[4];
    partners = result[5];
    calendarView = result[6];
    activityFilter = result[7];
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
    genders = result[0];
    initiators = result[1];
    practices = result[2];
    places = result[3];
    birthControls = result[4];
    activityTypes = result[5];
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

  void signOut() {
    debugPrint('signOut');
    accessToken = null;
    refreshToken = null;
  }

  void clearData() {
    debugPrint('clearData');
    accessToken = null;
    refreshToken = null;
    activity = [];
    partners = [];
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

  String get theme {
    return _theme;
  }

  set theme(String value) {
    _theme = value;
    _storage.setTheme(value);
  }

  String get colorScheme {
    return _colorScheme;
  }

  set colorScheme(String value) {
    _colorScheme = value;
    _storage.setColorScheme(value);
  }

  String? get accessToken {
    return _accessToken;
  }

  set accessToken(String? value) {
    _accessToken = value;
    _storage.setAccessToken(value);
  }

  String? get refreshToken {
    return _refreshToken;
  }

  set refreshToken(String? value) {
    _refreshToken = value;
    _storage.setRefreshToken(value);
  }

  List<Activity> get activity {
    return _activity;
  }

  set activity(List<Activity> value) {
    _activity = value;
    _storage.setActivity(value);
  }

  List<Partner> get partners {
    return _partners;
  }

  set partners(List<Partner> value) {
    _partners = value;
    _storage.setPartners(value);
  }

  bool get calendarView {
    return _calendarView;
  }

  set calendarView(bool value) {
    _calendarView = value;
    _storage.setCalendarView(value);
  }

  String get activityFilter {
    return _activityFilter;
  }

  set activityFilter(String value) {
    _activityFilter = value;
    _storage.setActivityFilter(value);
  }

  List<IdName> get birthControls {
    return _birthControls;
  }

  set birthControls(List<IdName> value) {
    _birthControls = value;
    _storage.setBirthControls(value);
  }

  List<IdName> get practices {
    return _practices;
  }

  set practices(List<IdName> value) {
    _practices = value;
    _storage.setPractices(value);
  }

  List<IdName> get places {
    return _places;
  }

  set places(List<IdName> value) {
    _places = value;
    _storage.setPlaces(value);
  }

  List<IdName> get initiators {
    return _initiators;
  }

  set initiators(List<IdName> value) {
    _initiators = value;
    _storage.setInitiators(value);
  }

  List<IdName> get genders {
    return _genders;
  }

  set genders(List<IdName> value) {
    _genders = value;
    _storage.setGenders(value);
  }

  List<IdName> get activityTypes {
    return _activityTypes;
  }

  set activityTypes(List<IdName> value) {
    _activityTypes = value;
    _storage.setActivityTypes(value);
  }
}
