
import 'package:flutter/material.dart';
import 'package:flutter_tareo/core/colors.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';

AppBar getAppBar(String titulo, List<Widget> actions,[bool bandera = false]) {

  return AppBar(
    automaticallyImplyLeading: bandera,
    iconTheme: IconThemeData(
      color: (PreferenciasUsuario().modoDark) ? Colors.white : Colors.black, 
    ),
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          titulo,
          style: TextStyle(
              fontSize: 18,
              color: PreferenciasUsuario().modoDark ? Colors.white : Colors.black),
        ),

        Container(
          alignment: Alignment.bottomLeft,
          padding: EdgeInsets.only(left: 10),
          child: Text(
            '${PreferenciasUsuario().lastVersion} - ${PreferenciasUsuario().lastVersionDate}',
            style: TextStyle(
                fontSize: 11,
                color: PreferenciasUsuario().modoDark ? Colors.white : Colors.grey),
          ),
        ),
      ],
    ),
    backgroundColor: PreferenciasUsuario().modoDark ? cardColorDark : cardColor,
    shadowColor: PreferenciasUsuario().modoDark ? borderColorDark : borderColor,
    actions: actions,
  );
}
