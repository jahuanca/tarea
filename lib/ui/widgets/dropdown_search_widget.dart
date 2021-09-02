
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_tareo/core/colors.dart';
import 'package:flutter_tareo/core/dimens.dart';
import 'package:flutter_tareo/core/styles.dart';
import 'package:flutter/material.dart';

class DropdownSearchWidget extends StatelessWidget {

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

  DropdownSearchWidget({
      @required this.items,
      this.labelText,
      this.labelValue,
      this.enabled=true,
      this.maxLength=20,
      this.textInputType=TextInputType.name,
      this.isObscure=false,
      this.initialValue='',
      this.label,
      this.onChanged,
    }
  );
  
  @override
  Widget build(BuildContext context) {

    final Size size=MediaQuery.of(context).size;
    return Column(
      children: [
        if(label!=null)
        Container(
          alignment: Alignment.centerLeft,
          height: size.height*inputDimension*0.9,
          child: Text(label,
            style: primaryTextStyle(),
          ),
        ),
        Container(
          height: size.height*inputDimension,
          width: size.width,
          child: DropdownSearch<String>(
                  mode: Mode.BOTTOM_SHEET,
                  dropdownSearchDecoration: InputDecoration(
              border: inputBorder(),
              enabledBorder: inputBorder(),
              focusedBorder: inputBorder(),
              filled: true,
              fillColor: cardColor,
              contentPadding: contentPaddingInputs,
              counterText: '',
              counterStyle: TextStyle(fontSize: 0),
              hintText: '',
              hintStyle: primaryHintStyle(),
            ),
                  showAsSuffixIcons: true,
                  showSearchBox: true,
                  showSelectedItem: true,
                  items: items.map((e) => e[labelText].toString())?.toList() ,
                  hint: "Sedes",
                  onChanged: print,
                  selectedItem: items.first[labelText]),
        ),
      ],
    );
  }
}