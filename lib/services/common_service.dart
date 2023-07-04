import 'package:flutter/material.dart';
import 'package:lovelust/models/activity.dart';
import 'package:lovelust/models/id_name.dart';
import 'package:lovelust/models/partner.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/api_service.dart';
import 'package:lovelust/services/storage_service.dart';

class CommonService {
  final StorageService storage = getIt<StorageService>();
  final ApiService api = getIt<ApiService>();

  Future<List<dynamic>> initialLoad() {
    debugPrint('initialLoad');
    var futures = <Future>[
      storage.getTheme(),
      storage.getAccessToken(),
      storage.getRefreshToken(),
      storage.getActivity(),
      storage.getPartners(),
      storage.getCalendarView(),
      loadStaticData()
    ];

    return Future.wait(futures);
  }

  Future<void> initialFetch() async {
    debugPrint('initialFetch');
    var futures = <Future>[
      api.getActivity(),
      api.getPartners(),
      fetchStaticData()
    ];

    List result = await Future.wait(futures);
    storage.setActivity(result[0]);
    storage.setPartners(result[1]);
  }

  Future<void> loadStaticData() {
    debugPrint('loadStaticData');
    var futures = <Future>[
      storage.getGenders(),
      storage.getInitiators(),
      storage.getPractices(),
      storage.getPlaces(),
      storage.getBirthControls(),
      storage.getActivityTypes(),
    ];

    return Future.wait(futures);
  }

  fetchStaticData() async {
    debugPrint('fetchStaticData');
    var futures = <Future>[
      api.getGenders(),
      api.getInitiators(),
      api.getPractices(),
      api.getPlaces(),
      api.getBirthControls(),
      api.getActivityTypes(),
    ];

    List result = await Future.wait(futures);
    storage.setGenders(result[0]);
    storage.setInitiators(result[1]);
    storage.setPractices(result[2]);
    storage.setPlaces(result[3]);
    storage.setBirthControls(result[4]);
    storage.setActivityTypes(result[5]);
  }

  bool isLoggedIn() {
    return storage.accessToken != null;
  }

  Future<void> signOut() {
    debugPrint('signOut');
    var futures = <Future>[
      storage.setAccessToken(null),
      storage.setRefreshToken(null),
      storage.setActivity([]),
      storage.setPartners([])
    ];
    return Future.wait(futures);
  }

  Activity? getActivityById(String id) {
    return storage.activity.firstWhere((element) => element.id == id);
  }

  Partner? getPartnerById(String id) {
    return storage.partners.firstWhere((element) => element.id == id);
  }

  IdName? getPracticeById(String id) {
    return storage.practices.firstWhere((element) => element.id == id);
  }

  IdName? getBirthControlById(String id) {
    return storage.birthControls.firstWhere((element) => element.id == id);
  }

  IdName? getPlaceById(String id) {
    return storage.places.firstWhere((element) => element.id == id);
  }
}
