import 'package:flutter_tareo/ui/pages/aprobar/aprobar_page.dart';
import 'package:flutter_tareo/ui/pages/esparragos/esparragos_page.dart';
import 'package:flutter_tareo/ui/pages/herramientas/herramientas_page.dart';
import 'package:flutter_tareo/ui/pages/home/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tareo/ui/pages/migrar/migrar_page.dart';
import 'package:flutter_tareo/ui/pages/pre_tareos/pre_tareos_page.dart';
import 'package:flutter_tareo/ui/pages/pre_tareos_uva/pre_tareos_uva_page.dart';
import 'package:flutter_tareo/ui/pages/search/search_page.dart';
import 'package:flutter_tareo/ui/pages/tareas/tareas_page.dart';
import 'package:flutter_tareo/ui/utils/alert_dialogs.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class NavigationController extends GetxController {
  NavigationController();

  final List<Widget> lista = [
    HomePage(),
    TareasPage(),
    AprobarPage(),
    MigrarPage(),
    PreTareosPage(),
    PreTareosUvaPage(),
    EsparragosPage(),
    HerramientasPage(),
  ];

  int indexWidget = 0;
  String titulo = 'Inicio';

  List<Widget> actions = [];

  void eventos(int index, GlobalKey<ScaffoldState> scaffoldKey) {
    actions.clear();
    switch (index) {
      case 0:
        titulo = 'Inicio';
        scaffoldKey.currentState.openEndDrawer();
        indexWidget = index;
        update(['bottom_navigation']);
        break;

      case 1:
        //scaffoldKey.currentState.openDrawer();
        actions.add(IconButton(
            //onPressed: () => Get.to(() => SearchPage()),
            onPressed: showSearch,
            icon: Icon(Icons.search)));
        titulo = 'Tareas';
        scaffoldKey.currentState.openEndDrawer();
        indexWidget = index;
        update(['bottom_navigation']);
        break;

      case 2:
        //scaffoldKey.currentState.openDrawer();
        actions.add(IconButton(
            onPressed: () => Get.to(() => SearchPage()),
            icon: Icon(Icons.search)));
        titulo = 'Aprobación';
        scaffoldKey.currentState.openEndDrawer();
        indexWidget = index;
        update(['bottom_navigation']);
        break;

      case 3:
        actions.add(IconButton(onPressed: () {}, icon: Icon(Icons.search)));
        titulo = 'Migración';
        scaffoldKey.currentState.openEndDrawer();
        indexWidget = index;
        update(['bottom_navigation']);
        break;

      case 4:
        actions.add(IconButton(onPressed: () {}, icon: Icon(Icons.search)));
        titulo = 'Arándano';
        scaffoldKey.currentState.openEndDrawer();
        indexWidget = index;
        update(['bottom_navigation']);
        break;

      case 5:
        actions.add(IconButton(onPressed: () {}, icon: Icon(Icons.search)));
        titulo = 'Packing';
        scaffoldKey.currentState.openEndDrawer();
        indexWidget = index;
        update(['bottom_navigation']);
        break;
      
      case 6:
        titulo = 'Esparrago';
        scaffoldKey.currentState.openEndDrawer();
        indexWidget = index;
        update(['bottom_navigation']);
        break;

      case 7:
        titulo = 'Herramientas';
        scaffoldKey.currentState.openEndDrawer();
        indexWidget = index;
        update(['bottom_navigation']);
        break;

      default:
        indexWidget = index;
        update(['bottom_navigation']);
        break;
    }
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
      Get.overlayContext,
      'Alerta',
      'Saldra de la aplicación, ¿esta seguro?',
      'Si',
      'No',
      () => Get.back(result: true),
      () => Get.back(result: false),
    );
  }
}
