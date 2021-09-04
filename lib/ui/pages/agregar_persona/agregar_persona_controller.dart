
import 'package:get/get.dart';

class AgregarPersonaController extends GetxController{

  int cantidadEnviada=0;

  @override
  void onInit(){
    super.onInit();
    if(Get.arguments!=null){
      if(Get.arguments['cantidad']!=null){
        cantidadEnviada=Get.arguments['cantidad'] as int;
      }
    }
  }

  
}