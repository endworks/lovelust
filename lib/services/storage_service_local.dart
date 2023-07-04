import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lovelust/models/activity.dart';
import 'package:lovelust/models/id_name.dart';
import 'package:lovelust/models/partner.dart';
import 'package:lovelust/services/storage_service.dart';

class StorageServiceLocal extends StorageService {
  final storage = const FlutterSecureStorage();

  @override
  Future<String> getTheme() async {
    theme = await storage.read(key: 'theme') ?? 'system';
    return theme;
  }

  @override
  Future<void> setTheme(String value) async {
    theme = value;
    await storage.write(key: 'theme', value: value);
  }

  @override
  Future<String> getColorScheme() async {
    colorScheme = await storage.read(key: 'color_scheme') ?? 'dynamic';
    return colorScheme;
  }

  @override
  Future<void> setColorScheme(String value) async {
    colorScheme = value;
    await storage.write(key: 'color_scheme', value: value);
  }

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
    final persisted = await storage.read(key: 'activity');
    if (persisted != null) {
      activity = jsonDecode(persisted)
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
    final persisted = await storage.read(key: 'partners');
    if (persisted != null) {
      partners = jsonDecode(persisted)
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
  Future<List<IdName>> getBirthControls() async {
    final persisted = await storage.read(key: 'birth_controls');
    if (persisted != null) {
      birthControls = jsonDecode(persisted)
          .map<IdName>((map) => IdName.fromJson(map))
          .toList();
      return birthControls;
    }
    return [];
  }

  @override
  Future<void> setBirthControls(List<IdName> value) async {
    birthControls = value;
    await storage.write(key: 'birth_controls', value: jsonEncode(value));
  }

  @override
  Future<List<IdName>> getPractices() async {
    final persisted = await storage.read(key: 'practices');
    if (persisted != null) {
      practices = jsonDecode(persisted)
          .map<IdName>((map) => IdName.fromJson(map))
          .toList();
      return practices;
    }
    return [];
  }

  @override
  Future<void> setPractices(List<IdName> value) async {
    practices = value;
    await storage.write(key: 'practices', value: jsonEncode(value));
  }

  @override
  Future<List<IdName>> getPlaces() async {
    final persisted = await storage.read(key: 'places');
    if (persisted != null) {
      places = jsonDecode(persisted)
          .map<IdName>((map) => IdName.fromJson(map))
          .toList();
      return places;
    }
    return [];
  }

  @override
  Future<void> setPlaces(List<IdName> value) async {
    places = value;
    await storage.write(key: 'places', value: jsonEncode(value));
  }

  @override
  Future<List<IdName>> getInitiators() async {
    final persisted = await storage.read(key: 'initiators');
    if (persisted != null) {
      initiators = jsonDecode(persisted)
          .map<IdName>((map) => IdName.fromJson(map))
          .toList();
      return initiators;
    }
    return [];
  }

  @override
  Future<void> setInitiators(List<IdName> value) async {
    initiators = value;
    await storage.write(key: 'initiators', value: jsonEncode(value));
  }

  @override
  Future<List<IdName>> getGenders() async {
    final persisted = await storage.read(key: 'genders');
    if (persisted != null) {
      genders = jsonDecode(persisted)
          .map<IdName>((map) => IdName.fromJson(map))
          .toList();
      return genders;
    }
    return [];
  }

  @override
  Future<void> setGenders(List<IdName> value) async {
    genders = value;
    await storage.write(key: 'genders', value: jsonEncode(value));
  }

  @override
  Future<List<IdName>> getActivityTypes() async {
    final persisted = await storage.read(key: 'activity_types');
    if (persisted != null) {
      activityTypes = jsonDecode(persisted)
          .map<IdName>((map) => IdName.fromJson(map))
          .toList();
      return activityTypes;
    }
    return [];
  }

  @override
  Future<void> setActivityTypes(List<IdName> value) async {
    activityTypes = value;
    await storage.write(key: 'activity_types', value: jsonEncode(value));
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
