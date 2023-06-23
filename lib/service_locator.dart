import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:lovelust/services/common_service.dart';
import 'package:lovelust/services/storage_service.dart';
import 'package:lovelust/services/storage_service_cloudkit.dart';
import 'package:lovelust/services/storage_service_local.dart';

final getIt = GetIt.instance;

setupServiceLocator() {
  if (Platform.isIOS) {
    getIt.registerLazySingleton<StorageService>(() => StorageServiceCloudKit());
  } else {
    getIt.registerLazySingleton<StorageService>(() => StorageServiceLocal());
  }
  getIt.registerLazySingleton(() => CommonService());
}
