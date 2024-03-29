import 'package:flutter_tareo/core/colors.dart';
import 'package:flutter_tareo/core/dimens.dart';
import 'package:flutter_tareo/core/styles.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:flutter_tareo/ui/widgets/navigation_drawer/navigation_drawer_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Drawer getDrawer(Size size, GlobalKey<ScaffoldState> scaffoldKey){
  return Drawer(
    child: GetBuilder<NavigationDrawerController>(
      init: NavigationDrawerController(),
      id: 'navigation',
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
                                tag: 'profile',
                                child: Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: new DecorationImage(
                                            fit: BoxFit.contain,
                                            image: AssetImage(
                                                'assets/images/ic_avatar.png')))),
                              ),
                            ),
                          ),
                        ),
                        flex: 2,
                      ),
                      Flexible(
                        child: Container(
                          child: GetBuilder<NavigationDrawerController>(
                            id: 'usuario',
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
            _itemDrawer(
                size, Icons.home, 'Inicio', () => _.goHome(scaffoldKey),  _.index == 0),
            _itemDrawer(
                size, Icons.file_copy, 'Tareas', () => _.goTareas(scaffoldKey),  _.index == 1),
            if (PreferenciasUsuario().idSede == 7)
              _itemDrawer(size, 'assets/images/uva_icon.png', 'Packing',
                  () => _.goPreTareoUva(scaffoldKey),  _.index == 5),
            if (PreferenciasUsuario().idSede == 7)
              _itemDrawer(size, 'assets/images/arandano_icon.png', 'Esparrago',
                  () => _.goEsparragos(scaffoldKey),  _.index == 6),

            _itemDrawer(
                size, Icons.construction, 'Herramientas', () => _.goHerramientas(scaffoldKey),  _.index == 7),
            _itemDrawer(size, Icons.settings, 'Configuración', _.goMisEventos,  _.index == -1),
            _itemDrawer(
                size, Icons.exit_to_app, 'Cerrar sesión', _.cerrarSesion,  _.index == -1),
          ],
        ),
      ),
    ),
  );
}

Widget _itemDrawer(
    Size size, dynamic icon, String texto, void Function() onTap, bool isSelected) {
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
