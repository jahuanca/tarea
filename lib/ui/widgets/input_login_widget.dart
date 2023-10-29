import 'package:flutter_tareo/core/utils/colors.dart';
import 'package:flutter_tareo/core/utils/dimens.dart';
import 'package:flutter_tareo/core/utils/styles.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InputLoginWidget extends StatelessWidget {
  final String texto;
  final IconData icon;
  final bool enabled;
  final int maxLength;
  final TextInputType textInputType;
  final bool isObscure;
  final String error;
  final String initialValue;
  final TextEditingController textEditingController;
  final bool isTextArea;
  final void Function(String) onChanged;

  InputLoginWidget({
    @required this.texto,
    @required this.icon,
    this.enabled = true,
    this.maxLength = 50,
    this.textInputType = TextInputType.name,
    this.isObscure = false,
    this.initialValue = '',
    this.textEditingController,
    this.isTextArea = false,
    this.onChanged,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * inputDimension,
      width: size.width,
      decoration: BoxDecoration(
          color: (PreferenciasUsuario().modoDark) ? cardColorDark : cardColor,
          border: Border.all(
              color: error != null
                  ? dangerColor
                  : (PreferenciasUsuario().modoDark)
                      ? primaryColorDark
                      : primaryColor),
          borderRadius: BorderRadius.circular(borderRadius)),
      child: Stack(
        /* mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch, */
        children: [
          Container(
            child: Row(
              children: [
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(borderRadius)),
                    child: Center(child: CircleAvatar(child: Icon(icon))),
                  ),
                  flex: 1,
                ),
                Flexible(flex: 4, child: Container()),
              ],
            ),
          ),
          Container(
            color: Colors.transparent,
            child: Row(
              children: [
                Flexible(
                    flex: 4,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(borderRadius)),
                      child: TextFormField(
                        enabled: enabled,
                        initialValue: initialValue,
                        maxLength: maxLength,
                        keyboardType: textInputType,
                        obscureText: isObscure,
                        maxLines: isTextArea ? 5 : 1,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal:
                                  (icon != null) ? size.width * 0.13 : 0),
                          filled: true,
                          fillColor: Colors.transparent,
                          //contentPadding: EdgeInsets.symmetric(vertical: (isTextArea) ? 5 : 1, horizontal: 10),
                          counterText: '',
                          counterStyle: TextStyle(fontSize: 0),
                          hintText: texto,
                          hintStyle: (PreferenciasUsuario().modoDark)
                              ? hintLoginStyleDark()
                              : hintLoginStyle(),
                          /* enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: error==null ? CupertinoColors.systemGrey4 : Colors.red, width: 1),
                        ), */
                        ),
                        controller: textEditingController,
                        onChanged: onChanged,
                        textAlign:
                            isTextArea ? TextAlign.left : TextAlign.center,
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
