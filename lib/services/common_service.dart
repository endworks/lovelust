import 'package:lovelust/models/activity.dart';
import 'package:lovelust/models/id_name.dart';
import 'package:lovelust/models/partner.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/api_service.dart';
import 'package:lovelust/services/storage_service.dart';

class CommonService {
  final StorageService storage = getIt<StorageService>();
  final ApiService api = getIt<ApiService>();

  initialLoad() async {
    var futures = <Future>[
      api.getActivity(),
      api.getPartners(),
    ];

    List result = await Future.wait(futures);
    storage.setActivity(result[0]);
    storage.setPartners(result[1]);

    getStaticData();
  }

  getStaticData() async {
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

  signOut() {
    storage.setAccessToken(null);
    storage.setRefreshToken(null);
    storage.setActivity([]);
    storage.setPartners([]);
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
