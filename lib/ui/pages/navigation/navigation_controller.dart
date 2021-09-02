

import 'package:flutter_tareo/ui/pages/home/home_page.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationController extends GetxController{

  NavigationController();

  final List<Widget> lista=[
    Container(),
    HomePage(),
    null,
    Container(),
    null,
    Container()
  ];

  int indexWidget=1;

  void eventos(int index, GlobalKey<ScaffoldState> scaffoldKey){
    switch (index) {
      case 0:
        scaffoldKey.currentState.openDrawer();
        break;

      case 3:
        /* Get.to(
          ()=> NuevoEventoPage(),
          duration: Duration(seconds: 1),
          transition: Transition.downToUp
        );
        NuevoEventoBinding().dependencies();
        Get.to(()=> NuevoEventoPage()); */
        break;

      default:
        indexWidget=index;
        update(['bottom_navigation']);
        break;
    }

  }

  void change(){
    update(['modo']);
  }
}