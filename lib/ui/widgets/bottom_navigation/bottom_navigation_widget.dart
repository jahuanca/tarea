
import 'package:flutter/material.dart';
import 'package:flutter_tareo/core/colors.dart';
import 'package:flutter_tareo/ui/pages/navigation/navigation_controller.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:get/get.dart';

Widget getNavigationBar(GlobalKey key){

  final NavigationController navigationController=Get.find<NavigationController>();

  return GetBuilder<NavigationController>(
    init: navigationController,
    builder: (_)=> BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: (PreferenciasUsuario().modoDark) ? primaryColorDark : primaryColor,
      backgroundColor: (PreferenciasUsuario().modoDark) ? secondColorDark : Colors.white,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.menu),
          label: 'Drawer',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.explore),
          label: 'Explorar',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: 'Agregar',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Notificaciones',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Buscar',
        ),
      ],
      currentIndex: navigationController.indexWidget,
      onTap: (index)=> _.eventos(index, key),
    ),
  );
}