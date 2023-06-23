import 'dart:convert';

import 'package:cloud_kit/cloud_kit.dart';
import 'package:lovelust/models/activity.dart';
import 'package:lovelust/models/partner.dart';
import 'package:lovelust/services/storage_service.dart';

class StorageServiceCloudKit extends StorageService {
  CloudKit cloudKit = CloudKit('iCloud.works.end.LoveLust');

  @override
  Future<String?> getAccessToken() async {
    accessToken = await cloudKit.get('access_token');
    return accessToken;
  }

  @override
  Future<void> setAccessToken(String? value) async {
    accessToken = value;
    if (value != null) {
      await cloudKit.save('access_token', value);
    } else {
      await cloudKit.delete('access_token');
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    refreshToken = await cloudKit.get('refresh_token');
    return refreshToken;
  }

  @override
  Future<void> setRefreshToken(String? value) async {
    refreshToken = value;
    if (value != null) {
      await cloudKit.save('refresh_token', value);
    } else {
      await cloudKit.delete('refresh_token');
    }
  }

  @override
  Future<List<Activity>> getActivity() async {
    final persistedActivity = await cloudKit.get('activity');
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
    await cloudKit.save('activity', jsonEncode(value));
  }

  @override
  Future<List<Partner>> getPartners() async {
    final persistedPartners = await cloudKit.get('partners');
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
    await cloudKit.save('partners', jsonEncode(value));
  }

  @override
  Future<bool> getCalendarView() async {
    final persistedCalendarView = await cloudKit.get('calendar_view');
    if (persistedCalendarView != null) {
      calendarView = jsonDecode(persistedCalendarView);
      return calendarView;
    }
    return false;
  }

  @override
  Future<void> setCalendarView(bool value) async {
    calendarView = value;
    await cloudKit.save('calendar_view', jsonEncode(value));
  }
}
