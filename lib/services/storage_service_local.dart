import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lovelust/models/activity.dart';
import 'package:lovelust/models/id_name.dart';
import 'package:lovelust/models/partner.dart';
import 'package:lovelust/services/storage_service.dart';

class StorageServiceLocal extends StorageService {
  final _storage = const FlutterSecureStorage(
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.unlocked,
      synchronizable: true,
    ),
    mOptions: MacOsOptions(
      accessibility: KeychainAccessibility.unlocked,
      synchronizable: true,
    ),
    aOptions: AndroidOptions(
      // encryptedSharedPreferences: true,
      sharedPreferencesName: 'lovelust',
    ),
    webOptions: WebOptions(
      dbName: 'lovelust',
    ),
  );

  @override
  Future<String> getTheme() async {
    return await _storage.read(key: 'theme') ?? 'system';
  }

  @override
  Future<void> setTheme(String value) async {
    return await _storage.write(key: 'theme', value: value);
  }

  @override
  Future<String?> getColorScheme() async {
    return await _storage.read(key: 'color_scheme');
  }

  @override
  Future<void> setColorScheme(String? value) async {
    return await _storage.write(key: 'color_scheme', value: value);
  }

  @override
  Future<String?> getAccessToken() async {
    return await _storage.read(key: 'access_token');
  }

  @override
  Future<void> setAccessToken(String? value) async {
    if (value != null) {
      return await _storage.write(key: 'access_token', value: value);
    } else {
      return await _storage.delete(key: 'access_token');
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: 'refresh_token');
  }

  @override
  Future<void> setRefreshToken(String? value) async {
    if (value != null) {
      return await _storage.write(key: 'refresh_token', value: value);
    } else {
      return await _storage.delete(key: 'refresh_token');
    }
  }

  @override
  Future<List<Activity>> getActivity() async {
    final persisted = await _storage.read(key: 'activity');
    if (persisted != null) {
      return jsonDecode(persisted)
          .map<Activity>((map) => Activity.fromJson(map))
          .toList();
    }
    return [];
  }

  @override
  Future<void> setActivity(List<Activity> value) async {
    return await _storage.write(key: 'activity', value: jsonEncode(value));
  }

  @override
  Future<List<Partner>> getPartners() async {
    final persisted = await _storage.read(key: 'partners');
    if (persisted != null) {
      return jsonDecode(persisted)
          .map<Partner>((map) => Partner.fromJson(map))
          .toList();
    }
    return [];
  }

  @override
  Future<void> setPartners(List<Partner> value) async {
    return await _storage.write(key: 'partners', value: jsonEncode(value));
  }

  @override
  Future<List<IdName>> getBirthControls() async {
    final persisted = await _storage.read(key: 'birth_controls');
    if (persisted != null) {
      return jsonDecode(persisted)
          .map<IdName>((map) => IdName.fromJson(map))
          .toList();
    }
    return [];
  }

  @override
  Future<void> setBirthControls(List<IdName> value) async {
    return await _storage.write(
        key: 'birth_controls', value: jsonEncode(value));
  }

  @override
  Future<List<IdName>> getPractices() async {
    final persisted = await _storage.read(key: 'practices');
    if (persisted != null) {
      return jsonDecode(persisted)
          .map<IdName>((map) => IdName.fromJson(map))
          .toList();
    }
    return [];
  }

  @override
  Future<void> setPractices(List<IdName> value) async {
    return await _storage.write(key: 'practices', value: jsonEncode(value));
  }

  @override
  Future<List<IdName>> getPlaces() async {
    final persisted = await _storage.read(key: 'places');
    if (persisted != null) {
      return jsonDecode(persisted)
          .map<IdName>((map) => IdName.fromJson(map))
          .toList();
    }
    return [];
  }

  @override
  Future<void> setPlaces(List<IdName> value) async {
    return await _storage.write(key: 'places', value: jsonEncode(value));
  }

  @override
  Future<List<IdName>> getInitiators() async {
    final persisted = await _storage.read(key: 'initiators');
    if (persisted != null) {
      return jsonDecode(persisted)
          .map<IdName>((map) => IdName.fromJson(map))
          .toList();
    }
    return [];
  }

  @override
  Future<void> setInitiators(List<IdName> value) async {
    return await _storage.write(key: 'initiators', value: jsonEncode(value));
  }

  @override
  Future<List<IdName>> getGenders() async {
    final persisted = await _storage.read(key: 'genders');
    if (persisted != null) {
      return jsonDecode(persisted)
          .map<IdName>((map) => IdName.fromJson(map))
          .toList();
    }
    return [];
  }

  @override
  Future<void> setGenders(List<IdName> value) async {
    return await _storage.write(key: 'genders', value: jsonEncode(value));
  }

  @override
  Future<List<IdName>> getActivityTypes() async {
    final persisted = await _storage.read(key: 'activity_types');
    if (persisted != null) {
      return jsonDecode(persisted)
          .map<IdName>((map) => IdName.fromJson(map))
          .toList();
    }
    return [];
  }

  @override
  Future<void> setActivityTypes(List<IdName> value) async {
    return await _storage.write(
        key: 'activity_types', value: jsonEncode(value));
  }

  @override
  Future<bool> getCalendarView() async {
    final persistedCalendarView = await _storage.read(key: 'calendar_view');
    if (persistedCalendarView != null) {
      return jsonDecode(persistedCalendarView);
    }
    return false;
  }

  @override
  Future<void> setCalendarView(bool value) async {
    return await _storage.write(key: 'calendar_view', value: jsonEncode(value));
  }

  @override
  Future<String> getActivityFilter() async {
    return await _storage.read(key: 'activity_filter') ?? 'all';
  }

  @override
  Future<void> setActivityFilter(String value) async {
    return await _storage.write(key: 'activity_filter', value: value);
  }
}
