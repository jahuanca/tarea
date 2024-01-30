import 'package:flutter/material.dart';
import 'package:flutter_tareo/ui/home/utils/strings_contants.dart';
import 'package:flutter_tareo/ui/utils/type_toast.dart';
import 'package:get/get.dart';

Future<dynamic> basicDialog(
    {BuildContext context,
    String title = ALERT_STRING,
    @required String message,
    String textPositive = YES_STRING,
    String textNegative = NO_STRING,
    @required void Function() onPressed,
    @required void Function() onCancel}) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: <Widget>[
        FlatButton(
          onPressed: onCancel,
          child: Text(textNegative),
        ),
        FlatButton(
          onPressed: onPressed,
          child: Text(textPositive),
        ),
      ],
    ),
  );
}

Future<dynamic> basicAlert(
    {BuildContext context,
    String title = ALERT_STRING,
    @required String message,
    String textButton = ACCEPT_STRING,
    void Function() onPressed}) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: <Widget>[
        FlatButton(
          onPressed: onPressed,
          child: Text(textButton),
        ),
      ],
    ),
  );
}

void toast(
    {@required TypeToast type,
    String title,
    @required String message,
    int duration}) {
  Get.snackbar(
    title ?? typesToast[type].title,
    message,
    //instantInit: BOOLEAN_FALSE_VALUE,
    snackPosition: typesToast[type].snackPosition,
    backgroundColor: typesToast[type].backgroundColor,
    colorText: typesToast[type].colorText,
    duration: (duration != null)
        ? Duration(milliseconds: duration)
        : typesToast[type].duration,
  );
}
