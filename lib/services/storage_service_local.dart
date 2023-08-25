import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lovelust/models/activity.dart';
import 'package:lovelust/models/partner.dart';
import 'package:lovelust/models/settings.dart';
import 'package:lovelust/services/storage_service.dart';

class StorageServiceLocal extends StorageService {
  final _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
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
  Future<Settings> getSettings() async {
    debugPrint('getSettings');
    final persisted = await _storage.read(key: 'settings');
    if (persisted != null) {
      return Settings.fromJson(jsonDecode(persisted));
    }
    return defaultSettings;
  }

  @override
  Future<void> setSettings(Settings value) async {
    debugPrint('setSettings: ${value.toString()}');
    return await _storage.write(key: 'settings', value: jsonEncode(value));
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
}
