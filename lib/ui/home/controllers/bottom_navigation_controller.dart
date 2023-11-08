import 'package:flutter_tareo/ui/home/utils/constants.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class BottomNavigationController extends GetxController {
  void eventos(int index, GlobalKey<ScaffoldState> scaffoldKey) {
    switch (index) {
      case OPEN_DRAWER:
        scaffoldKey.currentState.openDrawer();
        break;
      default:
        break;
    }
  }
}
