import 'package:flutter/material.dart';
import 'package:flutter_tareo/data/repositories/storage_repository_implementation.dart';
import 'package:flutter_tareo/di/login/login_binding.dart';
import 'package:flutter_tareo/domain/entities/usuario_entity.dart';
import 'package:flutter_tareo/ui/home/controllers/navigation_controller.dart';
import 'package:flutter_tareo/ui/home/utils/dynamics.dart';
import 'package:flutter_tareo/ui/login/pages/login_page.dart';
import 'package:flutter_tareo/ui/utils/alert_dialogs.dart';
import 'package:get/get.dart';

class NavigationDrawerController extends GetxController {
  UsuarioEntity usuarioEntity;

  NavigationDrawerController();

  int index = 0;

  @override
  void onInit() async {
    super.onInit();
    usuarioEntity = await StorageRepositoryImplementation().getUser();
    index = Get.find<NavigationController>().indexWidget ?? 0;
    update(['usuario', 'navigation']);
  }

  void goEvent(titles value, GlobalKey<ScaffoldState> scaffoldKey) {
    index = NAVIGATIONS[value].value;
    NAVIGATIONS[value].dependencies;
    update(['navigation']);
    Get.find<NavigationController>().eventos(index, scaffoldKey);
  }

  void cerrarSesion() {
    basicDialog(
      context: Get.overlayContext,
      message: '¿Esta seguro de cerrar sesión?',
      onPressed: () {
        Get.back();
        StorageRepositoryImplementation().clearAllData();
        LoginBinding().dependencies();
        Get.offAll(() => LoginPage());
      },
      onCancel: () => Get.back(),
    );
  }

  void goProfile() {
    /* ProfileBinding().dependencies();
    Get.to(()=> ProfilePage()); */
  }
}
