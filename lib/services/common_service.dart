import 'package:lovelust/models/activity.dart';
import 'package:lovelust/models/partner.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/storage_service.dart';

class CommonService {
  final StorageService _storageService = getIt<StorageService>();

  Future<Activity?> getActivityById(String id) async {
    List<Activity> activity = await _storageService.getActivity();
    return activity.firstWhere((element) => element.id == id);
  }

  Future<Partner?> getPartnerById(String id) async {
    List<Partner> partners = await _storageService.getPartners();
    return partners.firstWhere((element) => element.id == id);
  }
}
