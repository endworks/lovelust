import 'package:get_it/get_it.dart';
import 'package:lovelust/services/api_service.dart';
import 'package:lovelust/services/common_service.dart';
import 'package:lovelust/services/storage_service.dart';
import 'package:lovelust/services/storage_service_local.dart';

final getIt = GetIt.instance;

setupServiceLocator() {
  getIt.registerLazySingleton<StorageService>(() => StorageServiceLocal());
  getIt.registerLazySingleton(() => ApiService());
  getIt.registerLazySingleton(() => CommonService());
}
