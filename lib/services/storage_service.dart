import 'package:lovelust/models/id_name.dart';

import '../models/activity.dart';
import '../models/partner.dart';

abstract class StorageService {
  Future<String> getTheme();
  Future<void> setTheme(String value);
  Future<String?> getColorScheme();
  Future<void> setColorScheme(String? value);
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
  Future<bool> getPrivacyMode();
  Future<void> setPrivacyMode(bool value);
  Future<bool> getRequireAuth();
  Future<void> setRequireAuth(bool value);
  Future<bool> getCalendarView();
  Future<void> setCalendarView(bool value);
  Future<String?> getActivityFilter();
  Future<void> setActivityFilter(String? value);
}
