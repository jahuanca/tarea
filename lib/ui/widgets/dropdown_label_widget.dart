import 'package:flutter_tareo/core/utils/colors.dart';
import 'package:flutter_tareo/core/utils/dimens.dart';
import 'package:flutter_tareo/core/utils/styles.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:flutter/material.dart';

class DropdownLabelWidget extends StatelessWidget {
  final bool enabled;
  final int maxLength;
  final TextInputType textInputType;
  final bool isObscure;
  final String initialValue;
  final String label;
  final String labelText;
  final String labelValue;
  final List<Map<String, dynamic>> items;
  final void Function(String) onChanged;

  DropdownLabelWidget({
    @required this.items,
    this.labelText,
    this.labelValue,
    this.enabled = true,
    this.maxLength = 20,
    this.textInputType = TextInputType.name,
    this.isObscure = false,
    this.initialValue = '',
    this.label,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
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
          height: size.height * inputDimension,
          width: size.width,
          decoration: BoxDecoration(
              color:
                  (PreferenciasUsuario().modoDark) ? cardColorDark : cardColor,
              border: Border.all(color: primaryColor),
              borderRadius: BorderRadius.circular(borderRadius)),
          child: DropdownButtonFormField(
            dropdownColor:
                (PreferenciasUsuario().modoDark) ? cardColorDark : cardColor,
            decoration: InputDecoration(
              contentPadding: contentPaddingInputs,
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
            ),
            isExpanded: true,
            items: items
                .map((Map<String, dynamic> e) => DropdownMenuItem<String>(
                      value: '${e[labelValue]}',
                      child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '${e[labelText]}',
                            style: mensajeOpinionStyle(),
                          )),
                    ))
                .toList(),
            value: initialValue,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
