import 'package:flutter/material.dart';
import 'package:flutter/src/material/colors.dart';
import 'package:flutter_tareo/ui/home/utils/strings_contants.dart';
import 'package:get/get_navigation/src/snackbar/snack.dart';

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
  Toast({
    this.title,
    this.snackPosition = SnackPosition.BOTTOM,
    this.backgroundColor,
    this.colorText = Colors.white,
  });
}

Map<TypeToast, Toast> typesToast = {
  TypeToast.SUCCESS: Toast(
    title: SUCCESS_STRING,
    backgroundColor: Colors.green,
  ),
  TypeToast.ERROR: Toast(
    title: ERROR_STRING,
    backgroundColor: Colors.red,
  ),
  TypeToast.WARNING: Toast(
    title: ERROR_STRING,
    backgroundColor: Color(0xFFF5CC31),
  )
};
