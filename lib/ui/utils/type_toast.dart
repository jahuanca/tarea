import 'package:flutter/material.dart';
import 'package:flutter_tareo/ui/home/utils/strings_contants.dart';
import 'package:get/get.dart';

enum TypeToast {
  SUCCESS,
  ERROR,
  WARNING,
  INFO,
}

class Toast {
  String title;
  SnackPosition snackPosition;
  Color backgroundColor;
  Color colorText;
  Duration duration;
  Toast(
      {this.title,
      this.snackPosition = SnackPosition.BOTTOM,
      this.backgroundColor,
      this.colorText = Colors.white,
      this.duration = const Duration(milliseconds: 800)});
}

Map<TypeToast, Toast> typesToast = {
  TypeToast.SUCCESS: Toast(
      title: SUCCESS_STRING,
      backgroundColor: Colors.green,
      duration: Duration(milliseconds: 500)),
  TypeToast.ERROR: Toast(
      title: ERROR_STRING,
      backgroundColor: Colors.red,
      duration: Duration(milliseconds: 1000)),
  TypeToast.WARNING: Toast(
      title: ERROR_STRING,
      backgroundColor: Color(0xFFF5CC31),
      duration: Duration(milliseconds: 1000))
};
