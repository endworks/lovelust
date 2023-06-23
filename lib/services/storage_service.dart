import '../models/activity.dart';
import '../models/partner.dart';

abstract class StorageService {
  String? accessToken;
  String? refreshToken;
  List<Activity> activity = [];
  List<Partner> partners = [];
  bool calendarView = false;

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
