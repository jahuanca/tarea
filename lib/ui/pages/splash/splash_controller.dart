
import 'package:flutter_tareo/domain/use_cases/splash/get_token_use_case.dart';
import 'package:get/get.dart';

class SplashController extends GetxController{

  GetTokenUseCase _getTokenUseCase;

  SplashController(this._getTokenUseCase);

  @override
  void onInit(){
    super.onInit();
  }

  @override
  void onReady()async{
    super.onReady();
    await Future.delayed(Duration(seconds: 2));
    String token=await _getTokenUseCase.execute();
    if(token!=null){
      Get.offAndToNamed('navigation');
    }else{
      Get.offAndToNamed('login');
    }
  }
}