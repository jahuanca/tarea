import 'dart:async';

import 'package:flutter_tareo/core/utils/numbers.dart';
import 'package:flutter_tareo/data/repositories/storage_repository_implementation.dart';
import 'package:flutter_tareo/di/login/login_binding.dart';
import 'package:flutter_tareo/ui/home/utils/dynamics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tareo/ui/home/utils/strings_contants.dart';
import 'package:flutter_tareo/ui/login/pages/login_page.dart';
import 'package:flutter_tareo/ui/pages/search/search_page.dart';
import 'package:flutter_tareo/ui/utils/alert_dialogs.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class NavigationController extends GetxController {
  NavigationController();

  @override
  void onReady() async {
    super.onReady();
  }

  int indexWidget = ZERO_INT_VALUE;
  String titulo = NAVIGATIONS[titles.start].title;

  List<Widget> actions = [];

  void eventos(int value, GlobalKey<ScaffoldState> scaffoldKey) {
    titles currentTitle = getTitle(value);
    if (NAVIGATIONS[currentTitle].widget != null) {
      indexWidget = NAVIGATIONS[currentTitle].value;
      titulo = NAVIGATIONS[currentTitle].description ??
          NAVIGATIONS[currentTitle].title;
      actions.clear();
    }
    scaffoldKey.currentState.openEndDrawer();
    switch (currentTitle) {
      case titles.start:
        break;

      case titles.tareas:
        actions
            .add(IconButton(onPressed: showSearch, icon: Icon(Icons.search)));
        break;

      case titles.packing:
        actions.add(IconButton(onPressed: () {}, icon: Icon(Icons.search)));
        break;

      case titles.esparrago:
        break;

      case titles.herramientas:
        break;

      case titles.asistencias:
        break;
      case titles.logout:
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
        break;
      default:
        break;
    }
    update([HOME_PAGE_ID_BOTTOM_NAVIGATION]);
  }

  void showSearch() {
    showMaterialModalBottomSheet(
      context: Get.overlayContext,
      backgroundColor: Colors.black12,
      isDismissible: true,
      builder: (context) => SearchPage(),
    );
  }

  void change() {
    update(['modo']);
  }

  Future<bool> goBack() async {
    if (indexWidget != ZERO_INT_VALUE) {
      indexWidget = ZERO_INT_VALUE;
      indexWidget = NAVIGATIONS[titles.start].value;
      titulo = NAVIGATIONS[titles.start].title;
      update([HOME_PAGE_ID_BOTTOM_NAVIGATION]);
      return false;
    }

    return await basicDialog(
      context: Get.overlayContext,
      message: 'Saldra de la aplicación, ¿esta seguro?',
      onPressed: () => Get.back(result: true),
      onCancel: () => Get.back(result: false),
    );
  }
}
