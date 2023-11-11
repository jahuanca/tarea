import 'package:flutter_tareo/core/utils/colors.dart';
import 'package:flutter_tareo/core/utils/dimens.dart';
import 'package:flutter_tareo/core/utils/numbers.dart';
import 'package:flutter_tareo/core/utils/styles.dart';
import 'package:flutter_tareo/ui/home/utils/dynamics.dart';
import 'package:flutter_tareo/ui/home/utils/strings_contants.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:flutter_tareo/ui/home/controllers/navigation_drawer_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Drawer getDrawer({Size size, GlobalKey<ScaffoldState> scaffoldKey}) {
  return Drawer(
    child: GetBuilder<NavigationDrawerController>(
      init: NavigationDrawerController(),
      id: NAVIGATION_DRAWER_WIDGET_ID_NAVIGATION,
      builder: (_) => Container(
        color: (PreferenciasUsuario().modoDark) ? secondColorDark : secondColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: size.height * 0.35,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: (PreferenciasUsuario().modoDark)
                      ? primaryColorDark
                      : primaryColor,
                ),
                child: Container(
                  child: Column(
                    children: [
                      Flexible(
                        child: Container(
                          child: GetBuilder<NavigationDrawerController>(
                            builder: (_) => GestureDetector(
                              onTap: _.goProfile,
                              child: Hero(
                                tag: NAVIGATION_DRAWER_WIDGET_TAG_PROFILE,
                                child: Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: new DecorationImage(
                                            fit: BoxFit.contain,
                                            image:
                                                AssetImage(HOME_URL_AVATAR)))),
                              ),
                            ),
                          ),
                        ),
                        flex: TWO_INT_VALUE,
                      ),
                      Flexible(
                        child: Container(
                          child: GetBuilder<NavigationDrawerController>(
                            id: NAVIGATION_DRAWER_WIDGET_ID_USER,
                            builder: (_) => Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                    child: Text(
                                  _.usuarioEntity?.apellidosnombres ?? '',
                                  style: TextStyle(
                                      color: (PreferenciasUsuario().modoDark)
                                          ? cardColorDark
                                          : cardColor,
                                      fontSize: 16),
                                )),
                                Center(
                                    child: Text(
                                  _.usuarioEntity?.alias ?? '',
                                  style: TextStyle(
                                      color: (PreferenciasUsuario().modoDark)
                                          ? cardColorDark
                                          : cardColor),
                                )),
                              ],
                            ),
                          ),
                        ),
                        flex: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Column(
              children: titles.values
                  .map((e) => _itemDrawer(
                      size,
                      NAVIGATIONS[e].icon,
                      NAVIGATIONS[e].title,
                      () => _.goEvent(e, scaffoldKey),
                      _.index == NAVIGATIONS[e].value))
                  .toList(),
            )
          ],
        ),
      ),
    ),
  );
}

Widget _itemDrawer(Size size, dynamic icon, String texto, void Function() onTap,
    bool isSelected) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: size.height * inputDimension * 0.9,
      color: isSelected ? Colors.white : Colors.transparent,
      child: Row(
        children: [
          Flexible(
              child: Container(
                alignment: Alignment.center,
                child: (icon is IconData)
                    ? Icon(icon, color: starColor)
                    : ImageIcon(AssetImage(icon), color: starColor),
              ),
              flex: 1),
          Flexible(
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  texto,
                  style: PreferenciasUsuario().modoDark
                      ? drawerOptionDarkStyle()
                      : drawerOptionStyle(),
                ),
              ),
              flex: 4),
        ],
      ),
    ),
  );
}
