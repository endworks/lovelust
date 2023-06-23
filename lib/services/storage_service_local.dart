import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lovelust/models/activity.dart';
import 'package:lovelust/models/partner.dart';
import 'package:lovelust/services/storage_service.dart';

class StorageServiceLocal extends StorageService {
  final storage = const FlutterSecureStorage();

  @override
  Future<String?> getAccessToken() async {
    accessToken = await storage.read(key: 'access_token');
    return accessToken;
  }

  @override
  Future<void> setAccessToken(String? value) async {
    accessToken = value;
    if (value != null) {
      await storage.write(key: 'access_token', value: value);
    } else {
      await storage.delete(key: 'access_token');
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    refreshToken = await storage.read(key: 'refresh_token');
    return refreshToken;
  }

  @override
  Future<void> setRefreshToken(String? value) async {
    refreshToken = value;
    if (value != null) {
      await storage.write(key: 'refresh_token', value: value);
    } else {
      await storage.delete(key: 'refresh_token');
    }
  }

  @override
  Future<List<Activity>> getActivity() async {
    final persistedActivity = await storage.read(key: 'activity');
    if (persistedActivity != null) {
      activity = jsonDecode(persistedActivity)
          .map<Activity>((map) => Activity.fromJson(map))
          .toList();
      return activity;
    }
    return [];
  }

  @override
  Future<void> setActivity(List<Activity> value) async {
    activity = value;
    await storage.write(key: 'activity', value: jsonEncode(value));
  }

  @override
  Future<List<Partner>> getPartners() async {
    final persistedPartners = await storage.read(key: 'partners');
    if (persistedPartners != null) {
      partners = jsonDecode(persistedPartners)
          .map<Partner>((map) => Partner.fromJson(map))
          .toList();
      return partners;
    }
    return [];
  }

  @override
  Future<void> setPartners(List<Partner> value) async {
    partners = value;
    await storage.write(key: 'partners', value: jsonEncode(value));
  }

  @override
  Future<bool> getCalendarView() async {
    final persistedCalendarView = await storage.read(key: 'calendar_view');
    if (persistedCalendarView != null) {
      calendarView = jsonDecode(persistedCalendarView);
      return calendarView;
    }
    return false;
  }

  @override
  Future<void> setCalendarView(bool value) async {
    calendarView = value;
    await storage.write(key: 'calendar_view', value: jsonEncode(value));
  }
}
