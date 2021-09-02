
import 'package:flutter/material.dart';
import 'package:flutter_tareo/ui/pages/navigation/navigation_controller.dart';
import 'package:flutter_tareo/ui/widgets/app_bar_widget.dart';
import 'package:flutter_tareo/ui/widgets/bottom_navigation/bottom_navigation_widget.dart';
import 'package:flutter_tareo/ui/widgets/navigation_drawer/navigation_drawer_widget.dart';
import 'package:get/get.dart';

class NavigationPage extends GetWidget<NavigationController> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final NavigationController navigationController=Get.find<NavigationController>();

  @override
  Widget build(BuildContext context) {

    final Size size=MediaQuery.of(context).size;
    
    
    return GetBuilder<NavigationController>(
      init: NavigationController(),
      id: 'modo',
      builder: (_)=> SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          appBar: getAppBar('Inicio', true),
          drawer: getDrawer(size),
          /* bottomNavigationBar: GetBuilder<NavigationController>(
            id: 'bottom_navigation',
            builder: (_)=> getNavigationBar(_scaffoldKey)
          ), */
          body: GetBuilder<NavigationController>(
            id: 'bottom_navigation',
            builder: (_)=> navigationController.lista[navigationController.indexWidget]),
        ),
      ),
    );
  }
}