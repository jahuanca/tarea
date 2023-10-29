import 'package:flutter_tareo/core/utils/colors.dart';
import 'package:flutter_tareo/core/utils/dimens.dart';
import 'package:flutter_tareo/core/utils/styles.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:flutter/material.dart';

class ItemConfiguracionSwitchWidget extends StatelessWidget {
  final Size size;
  final String tituloTrue;
  final String tituloFalse;
  final bool value;
  final String label;
  final void Function(bool) onChanged;

  ItemConfiguracionSwitchWidget({
    this.size,
    this.label,
    this.tituloTrue,
    this.tituloFalse,
    this.value = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (label != null)
          Container(
            alignment: Alignment.centerLeft,
            height: size.height * inputDimension * 0.9,
            child: Text(
              label,
              style: primaryTextStyle(),
            ),
          ),
        Container(
          alignment: Alignment.centerLeft,
          height: size.height * inputDimension,
          decoration: BoxDecoration(
            color: PreferenciasUsuario().modoDark ? black : white,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(width: 1, color: primaryColor),
          ),
          child: Row(
            children: [
              Expanded(child: Container(), flex: 1),
              Expanded(
                  flex: 20,
                  child: Container(
                    child: SwitchListTile(
                      title: Container(
                        child: Text(
                          value ? tituloTrue : tituloFalse,
                          textAlign: TextAlign.start,
                          style: PreferenciasUsuario().modoDark
                              ? primaryTextDarkStyle()
                              : primaryTextStyle(),
                        ),
                      ),
                      value: value,
                      onChanged: onChanged,
                    ),
                  )),
              Expanded(child: Container(), flex: 1),
            ],
          ),
        ),
      ],
    );
  }
}
