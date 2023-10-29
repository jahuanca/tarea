import 'package:flutter/material.dart';
import 'package:flutter_tareo/core/colors.dart';
import 'package:flutter_tareo/ui/login/controllers/login_controller.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:flutter_tareo/ui/utils/string_formats.dart';
import 'package:flutter_tareo/ui/widgets/button_login_widget.dart';
import 'package:flutter_tareo/ui/widgets/button_social_widget.dart';
import 'package:flutter_tareo/ui/widgets/dropdown_search_widget.dart';
import 'package:flutter_tareo/ui/widgets/input_login_widget.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  final LoginController controller = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return GetBuilder<LoginController>(
      init: controller,
      builder: (_) => SafeArea(
        child: Stack(
          children: [
            Scaffold(
                backgroundColor: (PreferenciasUsuario().modoDark)
                    ? cardColorDark
                    : cardColor,
                body: SingleChildScrollView(
                  child: Container(
                    width: size.width,
                    height: size.height - MediaQuery.of(context).padding.top,
                    child: Row(
                      children: [
                        Flexible(child: Container(), flex: 1),
                        Flexible(
                            child: Container(
                              child: Column(
                                children: [
                                  cabecera(),
                                  ingreso(context),
                                ],
                              ),
                            ),
                            flex: 8),
                        Flexible(child: Container(), flex: 1),
                      ],
                    ),
                  ),
                )),
            GetBuilder<LoginController>(
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
      ),
    );
  }

  Widget cabecera() {
    return Flexible(
      child: Column(
        children: [
          Flexible(
            child: logoWithTexto(),
            flex: 3,
          ),
        ],
      ),
      flex: 2,
    );
  }

  Widget ingreso(BuildContext context) {
    return Flexible(
      child: Column(
        children: [
          Flexible(
            child: formulario(context),
            flex: 4,
          ),
          Flexible(
            child: registrate(),
            flex: 1,
          )
        ],
      ),
      flex: 4,
    );
  }

  Widget logoWithTexto() {
    return Container(
      child: Column(
        children: [
          Flexible(
              child: Container(
                padding: EdgeInsets.only(top: 20),
                child: ImageIcon(
                  AssetImage('assets/images/ic_logo.png'),
                  color: (PreferenciasUsuario().modoDark)
                      ? primaryColorDark
                      : primaryColor,
                  size: 120,
                ),
              ),
              flex: 2),
          Flexible(
              child: Container(
                alignment: Alignment.center,
                child: Text('Inicie sesion para continuar'),
              ),
              flex: 1),
        ],
      ),
    );
  }

  Widget formulario(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Flexible(
              flex: 1,
              child: Center(
                child: GetBuilder<LoginController>(
                  id: 'usuario',
                  builder: (_) => InputLoginWidget(
                      texto: 'Usuario',
                      maxLength: 80,
                      onChanged: _.onValidationUsuario,
                      error: _.errorUsuario,
                      icon: Icons.mail),
                ),
              )),
          Flexible(
              flex: 1,
              child: Center(
                child: GetBuilder<LoginController>(
                  id: 'password',
                  builder: (_) => InputLoginWidget(
                      texto: 'Contraseña',
                      isObscure: true,
                      onChanged: _.onValidationPassword,
                      error: _.errorPassword,
                      icon: Icons.lock),
                ),
              )),
          Flexible(
              flex: 1,
              child: Center(
                child: GetBuilder<LoginController>(
                  id: 'sedes',
                  builder: (_) => DropdownSearchWidget(
                    labelText: 'name',
                    labelValue: '_id',
                    selectedItem: _.sedeSelected == null
                        ? null
                        : {
                            'name':
                                '${_.sedeSelected.detallesubdivision} - ${_.sedeSelected.subdivision}',
                            '_id': _.sedeSelected.idsubdivision,
                          },
                    onChanged: _.changeSede,
                    items: controller.sedes.length == 0
                        ? []
                        : controller.sedes
                            .map((e) => {
                                  'name':
                                      '${e.detallesubdivision} - ${e.subdivision}',
                                  '_id': e.idsubdivision,
                                })
                            .toList(),
                  ),
                ),
              )),
          Flexible(
              flex: 1,
              child: Center(
                child: GetBuilder<LoginController>(
                  builder: (_) =>
                      ButtonLogin(onTap: _.ingresar, texto: 'Ingresar'),
                ),
              )),
          Flexible(
              flex: 1,
              child: Center(
                child: ButtonSocialWidget(
                    onTap: controller.goSincronizar, texto: 'Sincronizar'),
              ))
        ],
      ),
    );
  }

  Widget registrate() {
    return GetBuilder<LoginController>(
      id: 'version',
      builder: (_) => Container(
        child: Column(
          children: [
            Flexible(
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Version ${_.version}',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                flex: 1),
            Flexible(
                child: GestureDetector(
                  onTap: null,
                  child: Container(
                    child: Text(
                      'Ult. Sincronización: ' +
                          (_.ultimaSincronizacion == null
                              ? '----'
                              : formatoFechaHora(_.ultimaSincronizacion)),
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                flex: 1),
          ],
        ),
      ),
    );
  }
}
