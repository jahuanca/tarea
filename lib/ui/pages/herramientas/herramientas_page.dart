import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tareo/core/colors.dart';
import 'package:flutter_tareo/ui/pages/herramientas/herramientas_controller.dart';
import 'package:flutter_tareo/ui/widgets/button_social_widget.dart';
import 'package:get/get.dart';

class HerramientasPage extends StatelessWidget {
  final HerramientasController controller = Get.find<HerramientasController>();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return GetBuilder<HerramientasController>(
      init: controller,
      builder: (_) => Stack(
        children: [
          Scaffold(
            backgroundColor: secondColor,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  _itemExportar(size, 'Uva', _.createBackupFile),
                  _itemExportar(size, 'Tareos', _.createBackupFile),
                  _itemExportar(size, 'Poblar', _.importarData),
                  GetBuilder<HerramientasController>(
                    id: 'cantidad',
                    builder: (_) => _itemExportar(size, 'SQLITE '+_.cantidad.toString() , _.sqlite)),
                ],
              ),
            ),
          ),
          GetBuilder<HerramientasController>(
            id: 'validando',
            builder: (_) => _.validando
                ? Container(
                    color: Colors.black45,
                    child: Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        Text(_.texto),
                      ],
                    )),
                  )
                : Container(),
          ),
        ],
      ),
    );
  }

  Widget _itemExportar(Size size, String titulo, void Function() onTap) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: size.height * 0.025),
      child: Row(
        children: [
          Expanded(
            child: Container(),
            flex: 1,
          ),
          Expanded(
            flex: 4,
            child: Container(
                child: Text(
              titulo,
              style: TextStyle(
                  color: primaryTextColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            )),
          ),
          Expanded(
            child: Container(),
            flex: 1,
          ),
          Expanded(
              flex: 4,
              child: ButtonSocialWidget(
                texto: 'Exportar',
                onTap: onTap,
              )),
          Expanded(
            child: Container(),
            flex: 1,
          ),
        ],
      ),
    );
  }
}
