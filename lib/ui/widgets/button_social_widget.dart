import 'package:flutter_tareo/core/utils/colors.dart';
import 'package:flutter_tareo/core/utils/dimens.dart';
import 'package:flutter_tareo/core/utils/styles.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:flutter/material.dart';

class ButtonSocialWidget extends StatelessWidget {
  final String texto;
  final IconData icon;
  final void Function() onTap;

  ButtonSocialWidget({
    @required this.texto,
    this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: size.height * inputDimension,
        width: size.width,
        decoration: BoxDecoration(
            color: (PreferenciasUsuario().modoDark) ? cardColorDark : cardColor,
            border: Border.all(
                color: (PreferenciasUsuario().modoDark)
                    ? primaryColorDark
                    : primaryColor),
            borderRadius: BorderRadius.circular(borderRadius)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            if (icon != null)
              Flexible(
                  child: Container(
                    child: Icon(
                      icon,
                      color: (PreferenciasUsuario().modoDark)
                          ? primaryColorDark
                          : primaryColor,
                    ),
                  ),
                  flex: 1),
            Flexible(
                child: Container(
                  alignment: Alignment.center,
                  child: Text(texto, style: botonSocialStyle()),
                ),
                flex: 2),
          ],
        ),
      ),
    );
  }
}
