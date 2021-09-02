
import 'package:flutter/material.dart';
import 'package:flutter_tareo/core/colors.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';

AppBar getAppBar(String titulo, [bool bandera = false]) {
  return AppBar(
    automaticallyImplyLeading: bandera,
    iconTheme: IconThemeData(
      color: (PreferenciasUsuario().modoDark) ? Colors.white : Colors.black, 
    ),
    title: Text(
      titulo,
      style: TextStyle(
          color: PreferenciasUsuario().modoDark ? Colors.white : Colors.black),
    ),
    backgroundColor: PreferenciasUsuario().modoDark ? cardColorDark : cardColor,
    shadowColor: PreferenciasUsuario().modoDark ? borderColorDark : borderColor,
  );
}
