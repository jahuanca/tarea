import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_tareo/core/utils/colors.dart';
import 'package:flutter_tareo/core/utils/dimens.dart';
import 'package:flutter_tareo/core/utils/styles.dart';
import 'package:flutter/material.dart';

class DropdownSearchWidget extends StatelessWidget {
  final bool enabled;
  final int maxLength;
  final TextInputType textInputType;
  final bool isObscure;
  final String label;
  final String labelText;
  final String labelValue;
  final String error;
  final List<Map<String, dynamic>> items;
  final Map<String, dynamic> selectedItem;
  final void Function(String) onChanged;

  DropdownSearchWidget({
    @required this.items,
    this.labelText,
    this.labelValue,
    this.enabled = true,
    this.maxLength = 20,
    this.textInputType = TextInputType.name,
    this.isObscure = false,
    this.selectedItem,
    this.label,
    this.error,
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
          child: DropdownSearch<Map<String, dynamic>>(
              enabled: enabled,
              emptyBuilder: (context, searchEntry) => Material(
                    child: Container(
                      alignment: Alignment.center,
                      child: Text('No se encontraron resultados.'),
                    ),
                  ),
              mode: Mode.BOTTOM_SHEET,
              dropdownSearchDecoration: InputDecoration(
                border: error == null ? inputBorder() : inputBorderError(),
                enabledBorder:
                    error == null ? inputBorder() : inputBorderError(),
                focusedBorder:
                    error == null ? inputBorder() : inputBorderError(),
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
              items: items,
              itemAsString: (item) => item[labelText],
              hint: label == null ? 'Sin datos' : "Sin ${label.toLowerCase()}",
              onChanged: (data) => onChanged(data[labelValue].toString()),
              selectedItem: selectedItem != null
                  ? selectedItem
                  : items.length == 0
                      ? null
                      : items.first),
        ),
      ],
    );
  }
}
