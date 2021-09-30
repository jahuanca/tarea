import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<dynamic> basicDialog(
    BuildContext context,
    String titulo,
    String contenido,
    String pressed,
    String cancel,
    void Function() onPressed,
    void Function() onCancel) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(titulo),
      content: Text(contenido),
      actions: <Widget>[
        FlatButton(
          onPressed: onCancel,
          child: Text(cancel),
        ),
        FlatButton(
          onPressed: onPressed,
          child: Text(pressed),
        ),
      ],
    ),
  );
}

Future<dynamic> basicAlert(
    BuildContext context,
    String titulo,
    String contenido,
    String pressed,
    void Function() onPressed) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(titulo),
      content: Text(contenido),
      actions: <Widget>[
        FlatButton(
          onPressed: onPressed,
          child: Text(pressed),
        ),
      ],
    ),
  );
}

void toastExito(String titulo, String mensaje, [int duration = 3000]) {
  Get.snackbar(
    titulo,
    mensaje,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.green,
    colorText: Colors.white,
    duration: Duration(milliseconds: duration),
  );
}

void toastMensaje(String titulo, String mensaje) {
  Get.snackbar(titulo, mensaje,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white);
}

void toastAdvertencia(String titulo, String mensaje) {
  Get.snackbar(titulo, mensaje,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Color(0xFFF5CC31),
      colorText: Colors.white);
}

void toastError(String titulo, String mensaje) {
  Get.snackbar(titulo, mensaje,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white);
}
