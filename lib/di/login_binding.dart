

import 'package:flutter_tareo/data/repositories/auth_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/storage_repository_implementation.dart';
import 'package:flutter_tareo/domain/repositories/auth_repository.dart';
import 'package:flutter_tareo/domain/repositories/storage_repository.dart';
import 'package:flutter_tareo/domain/use_cases/login/save_token_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/login/save_user_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/login/sign_in_use_case.dart';
import 'package:flutter_tareo/ui/pages/login/login_controller.dart';
import 'package:get/get.dart';

class LoginBinding extends Bindings{


  @override
  void dependencies() {

    Get.lazyPut<AuthRepository>(() => AuthRepositoryImplementation());
    Get.lazyPut<StorageRepository>(() => StorageRepositoryImplementation());

    Get.lazyPut<SignInUseCase>(() => SignInUseCase(Get.find()));
    Get.lazyPut<SaveTokenUseCase>(() => SaveTokenUseCase(Get.find()));
    Get.lazyPut<SaveUserUseCase>(() => SaveUserUseCase(Get.find()));

    Get.lazyPut<LoginController>(() => LoginController(Get.find(), Get.find(), Get.find()));
    
  }

}