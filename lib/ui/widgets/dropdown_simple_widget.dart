
import 'package:flutter_tareo/core/colors.dart';
import 'package:flutter_tareo/core/dimens.dart';
import 'package:flutter_tareo/core/styles.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:flutter/material.dart';

class DropdownSimpleWidget extends StatelessWidget {

  final bool enabled;
  final int maxLength;
  final TextInputType textInputType;
  final bool isObscure;
  final String initialValue;
  final String labelText;
  final String labelValue;
  final List<Map<String, dynamic>> items;
  final void Function(String) onChanged;

  DropdownSimpleWidget({
      @required this.items,
      this.labelText,
      this.labelValue,
      this.enabled=true,
      this.maxLength=20,
      this.textInputType=TextInputType.name,
      this.isObscure=false,
      this.initialValue='',
      this.onChanged,
    }
  );
  
  @override
  Widget build(BuildContext context) {

    final Size size=MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          height: size.height*inputDimension,
          width: size.width,
          decoration: BoxDecoration(
            color: cardColor,
            border: Border.all(
              color: primaryColor
            ),
            borderRadius: BorderRadius.circular(borderRadius)
          ),
          child: DropdownButtonFormField(
            
            dropdownColor: cardColor,
            decoration: InputDecoration(
              contentPadding: contentPaddingInputsSimple,
              enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide.none),
            ),
            
            isExpanded: true,
            items: items.map((Map<String, dynamic> e) =>
                DropdownMenuItem<String>(
                  value: '${e[labelValue]}',
                  child: Container(
                    alignment: Alignment.centerLeft,child: Text('${e[labelText]}', style: searchDropdownStyle(),)),
                )
              ).toList(),
            value: initialValue,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}