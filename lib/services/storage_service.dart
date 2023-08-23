import 'package:lovelust/models/settings.dart';

import '../models/activity.dart';
import '../models/partner.dart';

abstract class StorageService {
  Future<void> clear();
  Future<void> setSettings(Settings value);
  Future<Settings> getSettings();
  Future<List<Activity>> getActivity();
  Future<void> setActivity(List<Activity> value);
  Future<List<Partner>> getPartners();
  Future<void> setPartners(List<Partner> value);
}
