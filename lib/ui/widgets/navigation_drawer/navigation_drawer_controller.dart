

import 'package:flutter_tareo/ui/pages/login/login_page.dart';
import 'package:flutter_tareo/ui/utils/alert_dialogs.dart';
import 'package:get/get.dart';

class NavigationDrawerController extends GetxController{


  void goConfiguracion(){
    /* Get.to(()=> ConfiguracionPage()); */
  }

  void goFavoritos(){
    /* FavoritosBinding().dependencies();
    Get.to(()=> FavoritosPage()); */
  }

  void goMisEventos(){
    /* MisEventosBinding().dependencies();
    Get.to(()=> MisEventosPage()); */
  }


  void cerrarSesion(){

    basicDialog(
      Get.overlayContext, 
      'Alerta', 
      '¿Esta seguro de cerrar sesión?', 
      'Si', 
      'No', 
      (){
        Get.back();
        /* LocalStorageRepository().clearAllData(); */
        Get.offAll(()=> LoginPage());
      }, 
      ()=> Get.back(),
    );
  }

  void goProfile(){
    /* ProfileBinding().dependencies();
    Get.to(()=> ProfilePage()); */
  }
}