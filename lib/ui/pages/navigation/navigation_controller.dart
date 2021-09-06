
import 'package:flutter_tareo/ui/pages/aprobar/aprobar_page.dart';
import 'package:flutter_tareo/ui/pages/home/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tareo/ui/pages/home/home_page.dart';
import 'package:flutter_tareo/ui/pages/migrar/migrar_page.dart';
import 'package:flutter_tareo/ui/pages/search/search_page.dart';
import 'package:flutter_tareo/ui/pages/tareas/tareas_page.dart';
import 'package:get/get.dart';

class NavigationController extends GetxController{

  NavigationController();

  final List<Widget> lista=[
    HomePage(),
    TareasPage(),
    AprobarPage(),
    MigrarPage(),
    Container(),
    Container(),
    Container(),
    Container(),
  ];

  int indexWidget=0;
  String titulo='Inicio';

  List<Widget> actions=[];

  void eventos(int index, GlobalKey<ScaffoldState> scaffoldKey){
    actions.clear();
    switch (index) {
      case 0:
        titulo='Inicio';
        scaffoldKey.currentState.openEndDrawer();
        indexWidget=index;
        update(['bottom_navigation']);
        break;
      
      case 1:
        //scaffoldKey.currentState.openDrawer();
        actions.add(
          IconButton(onPressed: ()=> Get.to(()=> SearchPage()), icon: Icon(Icons.search))
        );
        titulo='Tareas';
        scaffoldKey.currentState.openEndDrawer();
        indexWidget=index;
        update(['bottom_navigation']);
        break;

      case 2:
        //scaffoldKey.currentState.openDrawer();
        actions.add(
          IconButton(onPressed: ()=> Get.to(()=> SearchPage()), icon: Icon(Icons.search))
        );
        titulo='Aprobación';
        scaffoldKey.currentState.openEndDrawer();
        indexWidget=index;
        update(['bottom_navigation']);
        break;

      case 3:
        actions.add(
          IconButton(onPressed: (){}, icon: Icon(Icons.search))
        );
        titulo='Migración';
        scaffoldKey.currentState.openEndDrawer();
        indexWidget=index;
        update(['bottom_navigation']);
        break;
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