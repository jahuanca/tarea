
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class BottomNavigationController extends GetxController{


  void eventos(int index, GlobalKey<ScaffoldState> scaffoldKey){
    switch (index) {
      case 0:
        scaffoldKey.currentState.openDrawer();
        break;
      default:
    }

  }
}