import 'package:flutter_tareo/core/colors.dart';
import 'package:flutter_tareo/core/dimens.dart';
import 'package:flutter_tareo/core/styles.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:flutter/material.dart';

class RadioGroupWidget extends StatelessWidget {
  final String label;
  final Size size;
  final List<Map<String, dynamic>> items;
  final void Function(dynamic) onChanged;
  final int value;

  RadioGroupWidget({
    this.label,
    this.items,
    this.size,
    this.onChanged,
    this.value = 1,
  });

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
          child: Column(
            children: items
                .map((data) => Container(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Container(
                        decoration: BoxDecoration(
                            color: (PreferenciasUsuario().modoDark) ? cardColorDark : cardColor,
                            border: Border.all(color: primaryColor),
                            borderRadius: BorderRadius.circular(borderRadius)),
                        child: Theme(
                          data: ThemeData(
                              accentColor: (PreferenciasUsuario().modoDark) ? primaryColor : primaryColor,
                              unselectedWidgetColor: (PreferenciasUsuario().modoDark) ? primaryColor : primaryColor
                              ),
                          child: RadioListTile(
                            title: Text(
                              "${data['name']}",
                              style: mensajeOpinionStyle(),
                            ),
                            groupValue: value,
                            value: data['index'],
                            onChanged: onChanged,
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
        )
      ],
    );
  }
}
