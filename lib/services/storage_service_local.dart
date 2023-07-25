import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lovelust/models/activity.dart';
import 'package:lovelust/models/partner.dart';
import 'package:lovelust/services/storage_service.dart';

class StorageServiceLocal extends StorageService {
  final _storage = const FlutterSecureStorage(
    iOptions: IOSOptions(
      synchronizable: true,
    ),
  );

  @override
  Future<void> clear() async {
    debugPrint('clear');
    return await _storage.deleteAll();
  }

  @override
  Future<String> getTheme() async {
    debugPrint('getTheme');
    return await _storage.read(key: 'theme') ?? 'system';
  }

  @override
  Future<void> setTheme(String value) async {
    debugPrint('setTheme: $value');
    return await _storage.write(key: 'theme', value: value);
  }

  @override
  Future<String?> getColorScheme() async {
    debugPrint('getColorScheme');
    return await _storage.read(key: 'color_scheme');
  }

  @override
  Future<void> setColorScheme(String? value) async {
    debugPrint('setColorScheme: $value');
    return await _storage.write(key: 'color_scheme', value: value);
  }

  @override
  Future<String?> getAccessToken() async {
    debugPrint('getAccessToken');
    return await _storage.read(key: 'access_token');
  }

  @override
  Future<void> setAccessToken(String? value) async {
    debugPrint('setAccessToken: $value');
    if (value != null) {
      return await _storage.write(key: 'access_token', value: value);
    } else {
      return await _storage.delete(key: 'access_token');
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    debugPrint('getRefreshToken');
    return await _storage.read(key: 'refresh_token');
  }

  @override
  Future<void> setRefreshToken(String? value) async {
    debugPrint('setRefreshToken: $value');
    if (value != null) {
      return await _storage.write(key: 'refresh_token', value: value);
    } else {
      return await _storage.delete(key: 'refresh_token');
    }
  }

  @override
  Future<List<Activity>> getActivity() async {
    debugPrint('getActivity');
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
    debugPrint('setActivity: ${value.toString()}');
    return await _storage.write(key: 'activity', value: jsonEncode(value));
  }

  @override
  Future<List<Partner>> getPartners() async {
    debugPrint('getPartners');
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
    debugPrint('setPartners: ${value.toString()}');
    return await _storage.write(key: 'partners', value: jsonEncode(value));
  }

  @override
  Future<bool> getPrivacyMode() async {
    debugPrint('getPrivacyMode');
    final persisted = await _storage.read(key: 'privacy_mode');
    if (persisted != null) {
      return jsonDecode(persisted);
    }
    return false;
  }

  @override
  Future<void> setPrivacyMode(bool value) async {
    debugPrint('setPrivacyMode: ${value.toString()}');
    return await _storage.write(key: 'privacy_mode', value: jsonEncode(value));
  }

  @override
  Future<bool> getRequireAuth() async {
    debugPrint('getRequireAuth');
    final persisted = await _storage.read(key: 'require_auth');
    if (persisted != null) {
      return jsonDecode(persisted);
    }
    return false;
  }

  @override
  Future<void> setRequireAuth(bool value) async {
    debugPrint('setRequireAuth: ${value.toString()}');
    return await _storage.write(key: 'require_auth', value: jsonEncode(value));
  }

  @override
  Future<bool> getCalendarView() async {
    debugPrint('getCalendarView');
    final persisted = await _storage.read(key: 'calendar_view');
    if (persisted != null) {
      return jsonDecode(persisted);
    }
    return false;
  }

  @override
  Future<void> setCalendarView(bool value) async {
    debugPrint('setCalendarView: ${value.toString()}');
    return await _storage.write(key: 'calendar_view', value: jsonEncode(value));
  }

  @override
  Future<String?> getActivityFilter() async {
    debugPrint('getActivityFilter');
    return await _storage.read(key: 'activity_filter');
  }

  @override
  Future<void> setActivityFilter(String? value) async {
    debugPrint('setActivityFilter: ${value.toString()}');
    if (value != null) {
      return await _storage.write(key: 'activity_filter', value: value);
    } else {
      return await _storage.delete(key: 'activity_filter');
    }
  }
}
