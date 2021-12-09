
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tareo/core/colors.dart';
import 'package:flutter_tareo/core/dimens.dart';
import 'package:flutter_tareo/ui/pages/esparragos/esparragos_controller.dart';
import 'package:get/get.dart';

class EsparragosPage extends StatelessWidget {
  final EsparragosController controller = Get.find<EsparragosController>();

  @override
  Widget build(BuildContext context) {

    return GetBuilder<EsparragosController>(
      init: controller,
      builder: (_) => Stack(
        children: [
          Scaffold(
              backgroundColor: secondColor,
              body: Column(
                children: [
                  Expanded(
                    child: Container(),
                    flex: 1,
                  ),
                  contenedor('CLASIFICADO', controller.goClasificados),
                  Expanded(
                    child: Container(),
                    flex: 1,
                  ),
                  contenedor('VARIOS', controller.goVarios),
                  Expanded(
                    child: Container(),
                    flex: 1,
                  ),
                  contenedor('SELECCIÓN', controller.goSeleccion),
                  Expanded(
                    child: Container(),
                    flex: 1,
                  ),
                ],
              )),
          GetBuilder<EsparragosController>(
            id: 'validando',
            builder: (_) => _.validando
                ? Container(
                    color: Colors.black45,
                    child: Center(child: CircularProgressIndicator()),
                  )
                : Container(),
          ),
        ],
      ),
    );
  }

  Widget contenedor(String texto, void Function() onTap){
    return Expanded(child: Container(
      child: Row(
        children: [
          Expanded(child: Container(), flex: 1,),
          Expanded(child: GestureDetector(
            onTap: onTap,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  width: 0.2
                ),
                borderRadius: BorderRadius.circular(borderRadius),
                
              ),
              child: Container(
                alignment: Alignment.center,
                child: Text(texto),
              ),
            ),
          ), flex: 8,),
          Expanded(child: Container(), flex: 1,),
        ],
      ),
    ), flex: 2,);
  }
}
