import '../models/activity.dart';
import '../models/partner.dart';

abstract class StorageService {
  Future<void> clear();
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
  Future<bool> getPrivacyMode();
  Future<void> setPrivacyMode(bool value);
  Future<bool> getRequireAuth();
  Future<void> setRequireAuth(bool value);
  Future<bool> getCalendarView();
  Future<void> setCalendarView(bool value);
  Future<String?> getActivityFilter();
  Future<void> setActivityFilter(String? value);
  Future<bool> getModernUI();
  Future<void> setModernUI(bool value);
}
