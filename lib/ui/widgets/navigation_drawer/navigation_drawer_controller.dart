

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tareo/data/repositories/storage_repository_implementation.dart';
import 'package:flutter_tareo/di/aprobar_binding.dart';
import 'package:flutter_tareo/di/esparragos_binding.dart';
import 'package:flutter_tareo/di/home_binding.dart';
import 'package:flutter_tareo/di/login_binding.dart';
import 'package:flutter_tareo/di/migrar_binding.dart';
import 'package:flutter_tareo/di/pre_tareos_binding.dart';
import 'package:flutter_tareo/di/pre_tareos_uva_binding.dart';
import 'package:flutter_tareo/di/tareas_binding.dart';
import 'package:flutter_tareo/domain/entities/usuario_entity.dart';
import 'package:flutter_tareo/ui/pages/login/login_page.dart';
import 'package:flutter_tareo/ui/pages/navigation/navigation_controller.dart';
import 'package:flutter_tareo/ui/utils/alert_dialogs.dart';
import 'package:get/get.dart';

class NavigationDrawerController extends GetxController{

  UsuarioEntity usuarioEntity;
  

  NavigationDrawerController();

  @override
  void onInit() async{
    super.onInit();
    usuarioEntity=await StorageRepositoryImplementation().getUser();
    update(['usuario']);
  }


  void goConfiguracion(){
    /* Get.to(()=> ConfiguracionPage()); */
  }

  void goFavoritos(){
    /* FavoritosBinding().dependencies();
    Get.to(()=> FavoritosPage()); */
  }

  void goTareas(GlobalKey<ScaffoldState> scaffoldKey){
    TareasBinding().dependencies();
    Get.find<NavigationController>().eventos(1, scaffoldKey);
  }

  void goMigrar(GlobalKey<ScaffoldState> scaffoldKey){
    MigrarBinding().dependencies();
    Get.find<NavigationController>().eventos(3, scaffoldKey);
  }

  void goPreTareo(GlobalKey<ScaffoldState> scaffoldKey){
    PreTareosBinding().dependencies();
    Get.find<NavigationController>().eventos(4, scaffoldKey);
  }

  void goEsparragos(GlobalKey<ScaffoldState> scaffoldKey){
    EsparragosBinding().dependencies();
    Get.find<NavigationController>().eventos(6, scaffoldKey);
  }

  void goPreTareoUva(GlobalKey<ScaffoldState> scaffoldKey){
    PreTareosUvaBinding().dependencies();
    Get.find<NavigationController>().eventos(5, scaffoldKey);
  }

  void goAprobar(GlobalKey<ScaffoldState> scaffoldKey){
    AprobarBinding().dependencies();
    Get.find<NavigationController>().eventos(2, scaffoldKey);
  }

  void goHome(GlobalKey<ScaffoldState> scaffoldKey){
    HomeBinding().dependencies();
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
        StorageRepositoryImplementation().clearAllData(); 
        LoginBinding().dependencies();
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