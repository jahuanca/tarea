import 'package:flutter_tareo/core/utils/colors.dart';
import 'package:flutter_tareo/core/utils/styles.dart';
import 'package:flutter/material.dart';

class SeparadorWidget extends StatelessWidget {
  final Size size;
  final String titulo;

  SeparadorWidget({this.size, this.titulo});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      height: size.height * 0.08,
      padding: EdgeInsets.only(left: size.width * 0.1),
      decoration: BoxDecoration(
        color: borderColor.withAlpha(128),
      ),
      child: Text(
        titulo,
        style: separadorStyle(),
      ),
    );
  }
}
