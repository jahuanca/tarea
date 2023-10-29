import 'package:flutter_tareo/data/repositories/storage_repository_implementation.dart';
import 'package:flutter_tareo/domain/repositories/storage_repository.dart';
import 'package:flutter_tareo/domain/use_cases/splash/get_token_use_case.dart';
import 'package:flutter_tareo/ui/login/controllers/splash_controller.dart';
import 'package:get/get.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StorageRepository>(() => StorageRepositoryImplementation());

    Get.lazyPut<GetTokenUseCase>(() => GetTokenUseCase(Get.find()));

    Get.lazyPut<SplashController>(() => SplashController(Get.find()));
  }
}
