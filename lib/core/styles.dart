
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tareo/core/colors.dart';
import 'package:flutter_tareo/core/dimens.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';

TextStyle botonSocialStyle() {
  return TextStyle(
      color: primaryColor, fontSize: 20, fontWeight: FontWeight.bold);
}

TextStyle botonLoginStyle() {
  return TextStyle(color: cardColor, fontSize: 20, fontWeight: FontWeight.bold);
}

TextStyle inputLoginStyle() {
  return TextStyle(
      color: Colors.black, fontSize: 20, fontWeight: FontWeight.w400);
}

TextStyle hintLoginStyle() {
  return TextStyle(
      color: Colors.black, fontSize: 18, fontWeight: FontWeight.w400);
}

TextStyle hintLoginStyleDark() {
  return TextStyle(
      color: Colors.white, fontSize: 18, fontWeight: FontWeight.w400);
}

TextStyle hintComentarioStyle() {
  return TextStyle(
      color: borderColor, fontSize: 16, fontWeight: FontWeight.w400);
}

TextStyle header1Style() {
  return TextStyle(
      color: Colors.black, fontSize: header1Dimen, fontWeight: FontWeight.w400);
}

TextStyle header1StyleDark() {
  return TextStyle(
      color: Colors.white, fontSize: header1Dimen, fontWeight: FontWeight.w400);
}

TextStyle header0Style() {
  return TextStyle(
      color: Colors.black, fontSize: header0Dimen, fontWeight: FontWeight.w400);
}

TextStyle header0StyleDark() {
  return TextStyle(
      color: Colors.white, fontSize: header0Dimen, fontWeight: FontWeight.w400);
}

TextStyle separadorStyle() {
  return TextStyle(
      color: separadorTextColor,
      fontSize: header2Dimen,
      fontWeight: FontWeight.w500);
}

TextStyle primaryTextStyle() {
  return TextStyle(
      color: PreferenciasUsuario().modoDark ? primaryTextDarkColor :  primaryTextColor,
      fontSize: secondTextSize,
      fontWeight: FontWeight.w400);
}

TextStyle primaryTextDarkStyle() {
  return TextStyle(
      color: primaryTextDarkColor,
      fontSize: secondTextSize,
      fontWeight: FontWeight.w400);
}

TextStyle drawerOptionStyle() {
  return TextStyle(
      color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400);
}

TextStyle drawerOptionDarkStyle() {
  return TextStyle(
      color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400);
}

TextStyle primaryHintStyle() {
  return TextStyle(
      color: PreferenciasUsuario().modoDark ? primaryTextDarkColor : primaryTextColor,
      fontSize: secondTextSize,
      fontWeight: FontWeight.w300);
}

TextStyle primaryComentarioStyle() {
  return TextStyle(
      color: PreferenciasUsuario().modoDark ? primaryColor : primaryColorDark,
      fontSize: header0Dimen,
      fontWeight: FontWeight.w400);
}

TextStyle autorOpinionStyle() {
  return TextStyle(
      color: PreferenciasUsuario().modoDark ? Colors.white : Colors.black87,
      fontSize: header0Dimen,
      fontWeight: FontWeight.w400);
}

TextStyle mensajeOpinionStyle() {
  return TextStyle(
      color: PreferenciasUsuario().modoDark ? Colors.white : Colors.black87,
      fontSize: header1Dimen,
      fontWeight: FontWeight.w400);
}

TextStyle metadataComentarioStyle() {
  return TextStyle(
      color: borderColor, fontSize: 14, fontWeight: FontWeight.w400);
}

InputBorder inputBorder() {
  return OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide(width: 1, color: primaryColor));
}

InputBorder inputBorderError() {
  return OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide(width: 1, color: dangerColor));
}
