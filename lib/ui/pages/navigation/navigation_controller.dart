
import 'package:flutter_tareo/ui/pages/home/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tareo/ui/pages/home/home_page.dart';
import 'package:flutter_tareo/ui/pages/tareas/tareas_page.dart';
import 'package:get/get.dart';

class NavigationController extends GetxController{

  NavigationController();

  final List<Widget> lista=[
    TareasPage(),
    HomePage(),
    Container(),
    Container(),
    Container(),
    Container(),
    Container(),
    Container(),
  ];

  int indexWidget=1;
  String titulo='Inicio';

  List<Widget> actions=[];

  void eventos(int index, GlobalKey<ScaffoldState> scaffoldKey){
    switch (index) {
      case 0:
        //scaffoldKey.currentState.openDrawer();
        actions.add(
          IconButton(onPressed: (){}, icon: Icon(Icons.search))
        );
        titulo='Tareas';
        scaffoldKey.currentState.openEndDrawer();
        indexWidget=index;
        update(['bottom_navigation']);
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