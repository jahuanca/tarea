import 'package:flutter/material.dart';
import 'package:flutter_tareo/core/utils/numbers.dart';
import 'package:flutter_tareo/ui/home/controllers/navigation_controller.dart';
import 'package:flutter_tareo/ui/home/utils/strings_contants.dart';
import 'package:flutter_tareo/ui/home/widgets/navigation_drawer_widget.dart';
import 'package:flutter_tareo/ui/widgets/app_bar_widget.dart';

import 'package:get/get.dart';

class NavigationPage extends GetWidget<NavigationController> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final NavigationController navigationController =
      Get.find<NavigationController>();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return GetBuilder<NavigationController>(
      init: navigationController,
      id: HOME_PAGE_ID_BOTTOM_NAVIGATION,
      builder: (_) => SafeArea(
        child: WillPopScope(
          onWillPop: _.goBack,
          child: Scaffold(
            key: _scaffoldKey,
            appBar: getAppBar(
              navigationController.titulo,
              navigationController.actions,
              BOOLEAN_TRUE_VALUE,
            ),
            drawer: getDrawer(size: size, scaffoldKey: _scaffoldKey),
            body: GetBuilder<NavigationController>(
                builder: (_) => navigationController
                    .lista[navigationController.indexWidget]),
          ),
        ),
      ),
    );
  }
}
