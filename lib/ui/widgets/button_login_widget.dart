

import 'package:flutter_tareo/core/colors.dart';
import 'package:flutter_tareo/core/dimens.dart';
import 'package:flutter_tareo/core/styles.dart';
import 'package:flutter/material.dart';

class ButtonLogin extends StatelessWidget {

  final String texto;
  final IconData icon;
  final void Function() onTap;

  ButtonLogin({
    @required this.texto,
    this.icon,
    this.onTap,
    }
  );
  
  @override
  Widget build(BuildContext context) {

    final Size size=MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: size.height*inputDimension,
        width: size.width,
        decoration: BoxDecoration(
          color: primaryColor,
          border: Border.all(
            color: primaryColor
          ),
          borderRadius: BorderRadius.circular(borderRadius)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            if(icon!=null)
            Flexible(child: Container(
              child: Icon(icon, color: primaryColor,),
            ), flex: 1),
            Flexible(child: Container(
              alignment: Alignment.center,
              child: Text(texto, 
                style: botonLoginStyle()
              ),
            ), flex: 2),
          ],
        ),
      ),
    );
  }
}