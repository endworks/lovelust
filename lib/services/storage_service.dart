import '../models/activity.dart';
import '../models/partner.dart';

abstract class StorageService {
  Future<String?> getAccessToken();
  Future<void> setAccessToken(String value);
  Future<String?> getRefreshToken();
  Future<void> setRefreshToken(String value);
  Future<List<Activity>> getActivity();
  Future<void> setActivity(List<Activity> value);
  Future<List<Partner>> getPartners();
  Future<void> setPartners(List<Partner> value);
  Future<bool> getCalendarView();
  Future<void> setCalendarView(bool value);
}
