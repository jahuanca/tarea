import 'package:flutter/material.dart';
import 'package:flutter_tareo/core/colors.dart';
import 'package:flutter_tareo/ui/pages/home/home_controller.dart';
import 'package:flutter_tareo/ui/widgets/input_label_widget.dart';
import 'package:flutter_tareo/ui/widgets/radio_group_widget.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return GetBuilder<HomeController>(
      init: controller,
      builder: (_) => Scaffold(
        backgroundColor: secondColor,
        body: Column(
          children: [
            Flexible(
                child: Container(
                  padding: EdgeInsets.all(15),
                  child: Image.asset('assets/images/ic_logo.png'),
                ),
                flex: 1),
            Flexible(
                child: GetBuilder<HomeController>(
                  id: 'version',
                  builder: (_) => Container(
                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                    child: InputLabelWidget(
                        enabled: false,
                        label: 'Versión',
                        hintText: _.lastVersion),
                  ),
                ),
                flex: 1),
            //TODO: AUTODETECTAR INTERNET, VERIFICAR CON EL SERVIDOR
            Flexible(
                child: GetBuilder<HomeController>(
                  id: 'version',
                  builder: (_) => Container(
                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                    child: InputLabelWidget(
                        enabled: false,
                        label: 'Ultima Sincronización',
                        hintText: _.lastVersionDate),
                  ),
                ),
                flex: 1),
            Flexible(
                child: GetBuilder<HomeController>(
                  id: 'modo',
                  builder: (_) => Container(
                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                    alignment: Alignment.center,
                    child: RadioGroupWidget(
                      label: 'Modo',
                      value: _.modo,
                      items: [
                        {'index': 0, 'name': "Off-line"},
                        {'index': 1, 'name': 'On-line'},
                      ],
                      size: size,
                      onChanged: _.changeModo,
                    ),
                  ),
                ),
                flex: 2),
            Flexible(
                child: Container(
                  alignment: Alignment.center,
                  child: GetBuilder<HomeController>(
                    id: 'refresh',
                    builder: (_) => CircleAvatar(
                      backgroundColor: _.modo == 0 ? Colors.grey : infoColor,
                        child: IconButton(
                      onPressed: _.modo == 0 ? null : _.goSincronizar,
                      icon: Icon(Icons.refresh, color: Colors.white,),
                    )),
                  ),
                ),
                flex: 1)
          ],
        ),
      ),
    );
  }
}
