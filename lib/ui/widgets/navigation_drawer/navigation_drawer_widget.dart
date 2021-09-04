
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
      builder: (_)=> Container(
        color: (PreferenciasUsuario().modoDark) ? secondColorDark : secondColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: size.height*0.35,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: (PreferenciasUsuario().modoDark) ? primaryColorDark : primaryColor,
                ),
                child: Container(
                  
                  child: Column(
                    children: [
                      Flexible(child: Container(
                        child: GetBuilder<NavigationDrawerController>(
                          builder: (_)=> GestureDetector(
                            onTap: _.goProfile,
                            child: Hero(
                              tag: 'profile',
                              child: CircleAvatar(
                                radius: 180,
                                backgroundColor: Colors.transparent,
                                child: Image.network('https://flavioalvares.com.br/img/profile.png', fit: BoxFit.fitWidth,),
                              ),
                            ),
                          ),
                        ),
                      ), flex: 2,),
                      Flexible(child: Container(
                        
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Text('José Antonio Huanca Ancajima', 
                                style: TextStyle(
                                  color: (PreferenciasUsuario().modoDark) ? cardColorDark : cardColor,
                                  fontSize: 16
                                ),
                              )
                            ),
                            Center(
                              child: Text('joan.huanca19@gmail.com', 
                                style: TextStyle(color: (PreferenciasUsuario().modoDark) ? cardColorDark : cardColor),
                              )
                            ),
                          ],
                        ),
                      ), flex: 1,),
                    ],
                  ),
                ),
              ),
            ),
            //TODO: tareador: todo menos aprobación
            //TODO: supervisor: todo
            _itemDrawer(size, Icons.home, 'Inicio', ()=> _.goHome(scaffoldKey)),
            _itemDrawer(size, Icons.task, 'Tareas', ()=> _.goTareas(scaffoldKey)),
            _itemDrawer(size, Icons.check, 'Aprobación', _.goMisEventos),
            _itemDrawer(size, Icons.sync_rounded, 'Migrar', ()=> _.goMigrar(scaffoldKey)),
            _itemDrawer(size, Icons.construction , 'Herramientas', _.goMisEventos),
            _itemDrawer(size, Icons.settings, 'Configuración', _.goMisEventos), 
            _itemDrawer(size, Icons.exit_to_app, 'Cerrar sesión', _.cerrarSesion),
          ],
        ),
      ),
    ),
  );
}

Widget _itemDrawer(Size size, IconData icon, String texto, void Function() onTap){
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: size.height*inputDimension*0.9,
      child: Row(
        children: [
          Flexible(child: Container(
            alignment: Alignment.center,
            child:Icon(icon, color: starColor),
          ), flex: 1),
          Flexible(child: Container(
            alignment: Alignment.centerLeft,
            child: Text(texto, 
              style: PreferenciasUsuario().modoDark ? drawerOptionDarkStyle() : drawerOptionStyle(),
            ),
          ), flex: 4),
        ],
      ),
    ),
  );
}

