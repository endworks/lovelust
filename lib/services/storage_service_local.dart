import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lovelust/models/activity.dart';
import 'package:lovelust/models/partner.dart';
import 'package:lovelust/services/storage_service.dart';

class StorageServiceLocal extends StorageService {
  final storage = const FlutterSecureStorage();

  @override
  Future<String?> getAccessToken() async {
    return storage.read(key: 'access_token');
  }

  @override
  Future<void> setAccessToken(String value) async {
    await storage.write(key: 'access_token', value: value);
  }

  @override
  Future<String?> getRefreshToken() {
    return storage.read(key: 'refresh_token');
  }

  @override
  Future<void> setRefreshToken(String value) async {
    await storage.write(key: 'refresh_token', value: value);
  }

  @override
  Future<List<Activity>> getActivity() async {
    final persistedActivity = await storage.read(key: 'activity');
    if (persistedActivity != null) {
      return jsonDecode(persistedActivity)
          .map<Activity>((map) => Activity.fromJson(map))
          .toList();
    }
    return [];
  }

  @override
  Future<void> setActivity(List<Activity> value) async {
    await storage.write(key: 'activity', value: jsonEncode(value));
  }

  @override
  Future<List<Partner>> getPartners() async {
    final persistedPartners = await storage.read(key: 'partners');
    if (persistedPartners != null) {
      return jsonDecode(persistedPartners)
          .map<Partner>((map) => Partner.fromJson(map))
          .toList();
    }
    return [];
  }

  @override
  Future<void> setPartners(List<Partner> value) async {
    await storage.write(key: 'partners', value: jsonEncode(value));
  }

  @override
  Future<bool> getCalendarView() async {
    final persistedCalendarView = await storage.read(key: 'calendar_view');
    if (persistedCalendarView != null) {
      return jsonDecode(persistedCalendarView);
    }
    return false;
  }

  @override
  Future<void> setCalendarView(bool value) async {
    await storage.write(key: 'calendar_view', value: jsonEncode(value));
  }
}
