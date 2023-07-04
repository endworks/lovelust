import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lovelust/models/activity.dart';
import 'package:lovelust/models/id_name.dart';
import 'package:lovelust/models/partner.dart';
import 'package:lovelust/services/storage_service.dart';

class StorageServiceLocal extends StorageService {
  IOSOptions get _iosOptions => const IOSOptions(
        // accountName: 'lovelust',
        accessibility: KeychainAccessibility.first_unlock,
      );

  AndroidOptions get _androidOptions => const AndroidOptions(
      // encryptedSharedPreferences: true,
      // sharedPreferencesName: 'Test2',
      // preferencesKeyPrefix: 'Test'
      );
  final _storage = const FlutterSecureStorage();

  @override
  Future<String> getTheme() async {
    return await _storage.read(
          key: 'theme',
          aOptions: _androidOptions,
          iOptions: _iosOptions,
        ) ??
        'system';
  }

  @override
  Future<void> setTheme(String value) async {
    return await _storage.write(
      key: 'theme',
      value: value,
      aOptions: _androidOptions,
      iOptions: _iosOptions,
    );
  }

  @override
  Future<String> getColorScheme() async {
    return await _storage.read(
          key: 'color_scheme',
          aOptions: _androidOptions,
          iOptions: _iosOptions,
        ) ??
        'dynamic';
  }

  @override
  Future<void> setColorScheme(String value) async {
    return await _storage.write(
      key: 'color_scheme',
      value: value,
      aOptions: _androidOptions,
      iOptions: _iosOptions,
    );
  }

  @override
  Future<String?> getAccessToken() async {
    return await _storage.read(
      key: 'access_token',
      aOptions: _androidOptions,
      iOptions: _iosOptions,
    );
  }

  @override
  Future<void> setAccessToken(String? value) async {
    if (value != null) {
      return await _storage.write(
        key: 'access_token',
        value: value,
        aOptions: _androidOptions,
        iOptions: _iosOptions,
      );
    } else {
      return await _storage.delete(
        key: 'access_token',
        aOptions: _androidOptions,
        iOptions: _iosOptions,
      );
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    return await _storage.read(
      key: 'refresh_token',
      aOptions: _androidOptions,
      iOptions: _iosOptions,
    );
  }

  @override
  Future<void> setRefreshToken(String? value) async {
    if (value != null) {
      return await _storage.write(
        key: 'refresh_token',
        value: value,
        aOptions: _androidOptions,
        iOptions: _iosOptions,
      );
    } else {
      return await _storage.delete(
        key: 'refresh_token',
        aOptions: _androidOptions,
        iOptions: _iosOptions,
      );
    }
  }

  @override
  Future<List<Activity>> getActivity() async {
    final persisted = await _storage.read(
      key: 'activity',
      aOptions: _androidOptions,
      iOptions: _iosOptions,
    );
    if (persisted != null) {
      return jsonDecode(persisted)
          .map<Activity>((map) => Activity.fromJson(map))
          .toList();
    }
    return [];
  }

  @override
  Future<void> setActivity(List<Activity> value) async {
    return await _storage.write(
      key: 'activity',
      value: jsonEncode(value),
      aOptions: _androidOptions,
      iOptions: _iosOptions,
    );
  }

  @override
  Future<List<Partner>> getPartners() async {
    final persisted = await _storage.read(
      key: 'partners',
      aOptions: _androidOptions,
      iOptions: _iosOptions,
    );
    if (persisted != null) {
      return jsonDecode(persisted)
          .map<Partner>((map) => Partner.fromJson(map))
          .toList();
    }
    return [];
  }

  @override
  Future<void> setPartners(List<Partner> value) async {
    return await _storage.write(
      key: 'partners',
      value: jsonEncode(value),
      aOptions: _androidOptions,
      iOptions: _iosOptions,
    );
  }

  @override
  Future<List<IdName>> getBirthControls() async {
    final persisted = await _storage.read(
      key: 'birth_controls',
      aOptions: _androidOptions,
      iOptions: _iosOptions,
    );
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
      key: 'birth_controls',
      value: jsonEncode(value),
      aOptions: _androidOptions,
      iOptions: _iosOptions,
    );
  }

  @override
  Future<List<IdName>> getPractices() async {
    final persisted = await _storage.read(
      key: 'practices',
      aOptions: _androidOptions,
      iOptions: _iosOptions,
    );
    if (persisted != null) {
      return jsonDecode(persisted)
          .map<IdName>((map) => IdName.fromJson(map))
          .toList();
    }
    return [];
  }

  @override
  Future<void> setPractices(List<IdName> value) async {
    return await _storage.write(
      key: 'practices',
      value: jsonEncode(value),
      aOptions: _androidOptions,
      iOptions: _iosOptions,
    );
  }

  @override
  Future<List<IdName>> getPlaces() async {
    final persisted = await _storage.read(
      key: 'places',
      aOptions: _androidOptions,
      iOptions: _iosOptions,
    );
    if (persisted != null) {
      return jsonDecode(persisted)
          .map<IdName>((map) => IdName.fromJson(map))
          .toList();
    }
    return [];
  }

  @override
  Future<void> setPlaces(List<IdName> value) async {
    return await _storage.write(
      key: 'places',
      value: jsonEncode(value),
      aOptions: _androidOptions,
      iOptions: _iosOptions,
    );
  }

  @override
  Future<List<IdName>> getInitiators() async {
    final persisted = await _storage.read(
      key: 'initiators',
      aOptions: _androidOptions,
      iOptions: _iosOptions,
    );
    if (persisted != null) {
      return jsonDecode(persisted)
          .map<IdName>((map) => IdName.fromJson(map))
          .toList();
    }
    return [];
  }

  @override
  Future<void> setInitiators(List<IdName> value) async {
    return await _storage.write(
      key: 'initiators',
      value: jsonEncode(value),
      aOptions: _androidOptions,
      iOptions: _iosOptions,
    );
  }

  @override
  Future<List<IdName>> getGenders() async {
    final persisted = await _storage.read(
      key: 'genders',
      aOptions: _androidOptions,
      iOptions: _iosOptions,
    );
    if (persisted != null) {
      return jsonDecode(persisted)
          .map<IdName>((map) => IdName.fromJson(map))
          .toList();
    }
    return [];
  }

  @override
  Future<void> setGenders(List<IdName> value) async {
    return await _storage.write(
      key: 'genders',
      value: jsonEncode(value),
      aOptions: _androidOptions,
      iOptions: _iosOptions,
    );
  }

  @override
  Future<List<IdName>> getActivityTypes() async {
    final persisted = await _storage.read(
      key: 'activity_types',
      aOptions: _androidOptions,
      iOptions: _iosOptions,
    );
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
      key: 'activity_types',
      value: jsonEncode(value),
      aOptions: _androidOptions,
      iOptions: _iosOptions,
    );
  }

  @override
  Future<bool> getCalendarView() async {
    final persistedCalendarView = await _storage.read(
      key: 'calendar_view',
      aOptions: _androidOptions,
      iOptions: _iosOptions,
    );
    if (persistedCalendarView != null) {
      return jsonDecode(persistedCalendarView);
    }
    return false;
  }

  @override
  Future<void> setCalendarView(bool value) async {
    return await _storage.write(
      key: 'calendar_view',
      value: jsonEncode(value),
      aOptions: _androidOptions,
      iOptions: _iosOptions,
    );
  }

  @override
  Future<String> getActivityFilter() async {
    return await _storage.read(
          key: 'activity_filter',
          aOptions: _androidOptions,
          iOptions: _iosOptions,
        ) ??
        'all';
  }

  @override
  Future<void> setActivityFilter(String value) async {
    return await _storage.write(
      key: 'activity_filter',
      value: value,
      aOptions: _androidOptions,
      iOptions: _iosOptions,
    );
  }
}
