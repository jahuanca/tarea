

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tareo/ui/pages/login/login_page.dart';
import 'package:flutter_tareo/ui/pages/navigation/navigation_controller.dart';
import 'package:flutter_tareo/ui/pages/tareas/tareas_page.dart';
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

  void goTareas(GlobalKey<ScaffoldState> scaffoldKey){
    /* FavoritosBinding().dependencies();*/
    Get.find<NavigationController>().eventos(1, scaffoldKey);
  }

  void goMigrar(GlobalKey<ScaffoldState> scaffoldKey){
    /* FavoritosBinding().dependencies();*/
    Get.find<NavigationController>().eventos(3, scaffoldKey);
  }

  void goHome(GlobalKey<ScaffoldState> scaffoldKey){
    /* FavoritosBinding().dependencies();*/
    Get.find<NavigationController>().eventos(0, scaffoldKey);
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