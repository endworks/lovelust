import 'package:lovelust/models/activity.dart';
import 'package:lovelust/models/partner.dart';
import 'package:lovelust/service_locator.dart';
import 'package:lovelust/services/storage_service.dart';

class CommonService {
  final StorageService _storageService = getIt<StorageService>();

  Activity? getActivityById(String id) {
    return _storageService.activity.firstWhere((element) => element.id == id);
  }

  Partner? getPartnerById(String id) {
    return _storageService.partners.firstWhere((element) => element.id == id);
  }
}
