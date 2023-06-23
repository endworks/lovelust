import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:lovelust/models/activity.dart';
import 'package:lovelust/models/auth_tokens.dart';
import 'package:lovelust/models/id_name.dart';
import 'package:lovelust/models/partner.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/storage_service.dart';

class ApiService {
  final StorageService storageService = getIt<StorageService>();
  String apiUrl = 'lovelust-api.end.works';

  Future<AuthTokens> login(String username, String password) async {
    final response = await http.post(
      Uri.https(apiUrl, 'auth/login'),
      body: {
        'username': username,
        'password': password,
      },
    );

    if (response.statusCode == 201) {
      return AuthTokens.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<AuthTokens> signup(String username, String password, String sex,
      String gender, String birthDate) async {
    final response = await http.post(
      Uri.https(apiUrl, 'user/signup'),
      body: {
        'username': username,
        'password': password,
        'sex': sex,
        'gender': gender,
        'birth_date': birthDate,
      },
    );

    if (response.statusCode == 201) {
      return AuthTokens.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<List<Activity>> getActivity() async {
    final response = await http.get(
      Uri.https(apiUrl, 'activity'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer ${storageService.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      List json = jsonDecode(response.body);
      return json.map<Activity>((map) => Activity.fromJson(map)).toList();
    } else {
      throw Exception('Failed to load activity');
    }
  }

  Future<Activity> postActivity(Activity activity) async {
    final response = await http.post(
      Uri.https(apiUrl, 'activity/${activity.id}'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer ${storageService.accessToken}',
      },
      body: activity.toJson(),
    );

    if (response.statusCode == 200) {
      return Activity.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load activity');
    }
  }

  Future<void> deleteActivity(Activity activity) async {
    await http.delete(
      Uri.https(apiUrl, 'activity/${activity.id}'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer ${storageService.accessToken}',
      },
      body: activity.toJson(),
    );
  }

  Future<List<Activity>> patchActivity(Activity activity) async {
    final response = await http.patch(
      Uri.https(apiUrl, 'activity'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer ${storageService.accessToken}',
      },
      body: activity.toJson(),
    );

    if (response.statusCode == 200) {
      List json = jsonDecode(response.body);
      return json.map<Activity>((map) => Activity.fromJson(map)).toList();
    } else {
      throw Exception('Failed to load activity');
    }
  }

  Future<List<Partner>> getPartners() async {
    final response = await http.get(
      Uri.https(apiUrl, 'partner'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer ${storageService.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      List json = jsonDecode(response.body);
      return json.map<Partner>((map) => Partner.fromJson(map)).toList();
    } else {
      throw Exception('Failed to load partners');
    }
  }

  Future<List<IdName>> getBirthControls() async {
    final response = await http.get(Uri.https(apiUrl, 'data/birth-controls'));

    if (response.statusCode == 200) {
      List json = jsonDecode(response.body);
      return json.map<IdName>((map) => IdName.fromJson(map)).toList();
    } else {
      throw Exception('Failed to load birth controls');
    }
  }

  Future<List<IdName>> getActivityTypes() async {
    final response = await http.get(Uri.https(apiUrl, 'data/activity-types'));

    if (response.statusCode == 200) {
      List json = jsonDecode(response.body);
      return json.map<IdName>((map) => IdName.fromJson(map)).toList();
    } else {
      throw Exception('Failed to load activity types');
    }
  }

  Future<List<IdName>> getGenders() async {
    final response = await http.get(Uri.https(apiUrl, 'data/genders'));

    if (response.statusCode == 200) {
      List json = jsonDecode(response.body);
      return json.map<IdName>((map) => IdName.fromJson(map)).toList();
    } else {
      throw Exception('Failed to load genders');
    }
  }

  Future<List<IdName>> getPlaces() async {
    final response = await http.get(Uri.https(apiUrl, 'data/places'));

    if (response.statusCode == 200) {
      List json = jsonDecode(response.body);
      return json.map<IdName>((map) => IdName.fromJson(map)).toList();
    } else {
      throw Exception('Failed to load places');
    }
  }

  Future<List<IdName>> getPractices() async {
    final response = await http.get(Uri.https(apiUrl, 'data/practices'));

    if (response.statusCode == 200) {
      List json = jsonDecode(response.body);
      return json.map<IdName>((map) => IdName.fromJson(map)).toList();
    } else {
      throw Exception('Failed to load practices');
    }
  }

  Future<List<IdName>> getInitiators() async {
    final response = await http.get(Uri.https(apiUrl, 'data/initiators'));

    if (response.statusCode == 200) {
      List json = jsonDecode(response.body);
      return json.map<IdName>((map) => IdName.fromJson(map)).toList();
    } else {
      throw Exception('Failed to load initiators');
    }
  }
}
