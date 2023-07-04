import 'package:lovelust/models/id_name.dart';

import '../models/activity.dart';
import '../models/partner.dart';

abstract class StorageService {
  String theme = 'dynamic';
  String? accessToken;
  String? refreshToken;
  List<Activity> activity = [];
  List<Partner> partners = [];
  List<IdName> birthControls = [];
  List<IdName> practices = [];
  List<IdName> places = [];
  List<IdName> initiators = [];
  List<IdName> genders = [];
  List<IdName> activityTypes = [];
  bool calendarView = false;

  Future<String> getTheme();
  Future<void> setTheme(String value);
  Future<String?> getAccessToken();
  Future<void> setAccessToken(String? value);
  Future<String?> getRefreshToken();
  Future<void> setRefreshToken(String? value);
  Future<List<Activity>> getActivity();
  Future<void> setActivity(List<Activity> value);
  Future<List<Partner>> getPartners();
  Future<void> setPartners(List<Partner> value);
  Future<List<IdName>> getBirthControls();
  Future<void> setBirthControls(List<IdName> value);
  Future<List<IdName>> getPractices();
  Future<void> setPractices(List<IdName> value);
  Future<List<IdName>> getPlaces();
  Future<void> setPlaces(List<IdName> value);
  Future<List<IdName>> getInitiators();
  Future<void> setInitiators(List<IdName> value);
  Future<List<IdName>> getGenders();
  Future<void> setGenders(List<IdName> value);
  Future<List<IdName>> getActivityTypes();
  Future<void> setActivityTypes(List<IdName> value);
  Future<bool> getCalendarView();
  Future<void> setCalendarView(bool value);
}
