import 'package:flutter_tareo/core/colors.dart';
import 'package:flutter_tareo/ui/pages/splash/splash_controller.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashPage extends GetWidget<SplashController> {

  final SplashController splashController=Get.find<SplashController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      init: splashController,
      builder: (_)=> SafeArea(
        child: Scaffold(
          backgroundColor: (PreferenciasUsuario().modoDark) ? cardColorDark : cardColor,
          body: Column(
            children: [
              Flexible(child: Container(), flex: 1),
              Flexible(child: Container(
                child: Row(
                  children: [
                    Flexible(child: Container(), flex: 1,),
                    Flexible(child: 
                      Container(
                        child: ImageIcon(
                          AssetImage('assets/images/ic_logo.png'),
                          size: 150, 
                          color: (PreferenciasUsuario().modoDark) ? primaryColorDark : primaryColor,
                        )
                      ), flex: 1,),
                    Flexible(child: Container(), flex: 1,),
                  ],
                ),
              ), flex: 1),
              Flexible(child: Container(), flex: 1)
            ],
          )
        ),
      ),
    );
  }
}