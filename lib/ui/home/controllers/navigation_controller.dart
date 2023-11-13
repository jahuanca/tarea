import 'dart:async';

import 'package:flutter_tareo/ui/home/utils/dynamics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  int indexWidget = 0;
  String titulo = NAVIGATIONS[titles.start].title;

  List<Widget> actions = [];

  void eventos(int value, GlobalKey<ScaffoldState> scaffoldKey) {
    titles currentTitle = getTitle(value);
    actions.clear();
    titulo = NAVIGATIONS[currentTitle].title;
    indexWidget = NAVIGATIONS[currentTitle].value;
    scaffoldKey.currentState.openEndDrawer();
    switch (currentTitle) {
      case titles.start:
        break;

      case titles.tareas:
        actions
            .add(IconButton(onPressed: showSearch, icon: Icon(Icons.search)));
        break;

      /*case titles.aprobacion:
        actions.add(IconButton(
            onPressed: () => Get.to(() => SearchPage()),
            icon: Icon(Icons.search)));
        break;

      case titles.migracion:
        actions.add(IconButton(onPressed: () {}, icon: Icon(Icons.search)));
        break;

      case titles.arandano:
        actions.add(IconButton(onPressed: () {}, icon: Icon(Icons.search)));
        break;*/

      case titles.packing:
        actions.add(IconButton(onPressed: () {}, icon: Icon(Icons.search)));
        break;

      case titles.esparrago:
        break;

      case titles.herramientas:
        break;

      case titles.asistencias:
        break;
      default:
        break;
    }
    update(['bottom_navigation']);
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
    return await basicDialog(
      context: Get.overlayContext,
      message: 'Saldra de la aplicación, ¿esta seguro?',
      onPressed: () => Get.back(result: true),
      onCancel: () => Get.back(result: false),
    );
  }
}
