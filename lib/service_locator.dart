import 'package:get_it/get_it.dart';
import 'package:lovelust/services/api_service.dart';
import 'package:lovelust/services/health_service.dart';
import 'package:lovelust/services/local_auth_service.dart';
import 'package:lovelust/services/navigation_service.dart';
import 'package:lovelust/services/shared_service.dart';
import 'package:lovelust/services/storage_service.dart';
import 'package:lovelust/services/storage_service_local.dart';

final getIt = GetIt.instance;

setupServiceLocator() {
  getIt.registerLazySingleton<StorageService>(() => StorageServiceLocal());
  getIt.registerLazySingleton(() => NavigationService());
  getIt.registerLazySingleton(() => ApiService());
  getIt.registerLazySingleton(() => LocalAuthService());
  getIt.registerLazySingleton(() => HealthService());
  getIt.registerLazySingleton(() => SharedService());
}
