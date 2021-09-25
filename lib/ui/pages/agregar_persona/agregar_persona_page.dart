import 'package:flutter/material.dart';
import 'package:flutter_tareo/core/colors.dart';
import 'package:flutter_tareo/domain/entities/personal_empresa_entity.dart';
import 'package:flutter_tareo/ui/pages/agregar_persona/agregar_persona_controller.dart';
import 'package:flutter_tareo/ui/utils/string_formats.dart';
import 'package:flutter_tareo/ui/widgets/app_bar_widget.dart';
import 'package:flutter_tareo/ui/widgets/button_login_widget.dart';
import 'package:flutter_tareo/ui/widgets/date_picker_widget.dart';
import 'package:flutter_tareo/ui/widgets/dropdown_search_widget.dart';
import 'package:flutter_tareo/ui/widgets/input_label_widget.dart';
import 'package:get/get.dart';

class AgregarPersonaPage extends StatelessWidget {

  final AgregarPersonaController controller=Get.find<AgregarPersonaController>();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return GetBuilder<AgregarPersonaController>(
      init: controller,
      builder: (_) => Scaffold(
        appBar: getAppBar('Agregar persona', [
          
        ], true),
        backgroundColor: secondColor,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                child: Column(
                  children: [
                    if(_.cantidadEnviada==0)
                    GetBuilder<AgregarPersonaController>(
                      id: 'personal',
                      builder: (_) => DropdownSearchWidget(
                          label: 'Personal',
                          labelText: 'name',
                          labelValue: 'codigoempresa',
                          onChanged: _.changePersonal,
                          items: controller.personalEmpresa.length==0 ? [] : controller.personalEmpresa.map((PersonalEmpresaEntity e) => {
                                  'name': '${e.apellidopaterno} ${e.apellidomaterno}, ${e.nombres}',
                                  'codigoempresa': e.codigoempresa,
                                }).toList()),
                    ),
                    if(_.cantidadEnviada!=0)
                    Container(
                      padding: EdgeInsets.only(top: 30, bottom: 30),
                      child: InputLabelWidget(
                        enabled: false,
                        hintText: '${controller.personalEmpresa.length} personas',
                      ),
                    ),
                    GetBuilder<AgregarPersonaController>(
                    id: 'hora_inicio',
                    builder: (_) => InputLabelWidget(
                        enabled: false,
                        onTap: () async {
                          _.horaInicio = await DatePickerWidget(
                            onlyDate: true,
                            minDate:
                                DateTime.now().subtract(Duration(days: 10)),
                            dateSelected: DateTime.now(),
                          ).selectTime(context, new DateTime.now());
                          _.changeHoraInicio();
                        },
                        label: 'Hora inicio',
                        textEditingController: TextEditingController(
                            text: formatoHora(_.personalTareaProcesoEntity.horainicio, 'Hora Inicio')),
                        hintText: 'Hora inicio'),
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  GetBuilder<AgregarPersonaController>(
                    id: 'hora_fin',
                    builder: (_) => InputLabelWidget(
                        enabled: false,
                        onTap: () async {
                          _.horaFin = await DatePickerWidget(
                            onlyDate: true,
                            minDate:
                                DateTime.now().subtract(Duration(days: 10)),
                            dateSelected: DateTime.now(),
                            onChanged: () {},
                          ).selectTime(context, new DateTime.now());
                          _.changeHoraFin();
                        },
                        label: 'Hora fin',
                        textEditingController: TextEditingController(
                            text: formatoHora(_.personalTareaProcesoEntity.horafin, 'Hora Fin')),
                        hintText: 'Hora fin'),
                  ),
                  GetBuilder<AgregarPersonaController>(
                    id: 'inicio_pausa',
                    builder: (_) => InputLabelWidget(
                        enabled: false,
                        onTap: () async {
                          _.inicioPausa = await DatePickerWidget(
                            onlyDate: true,
                            minDate:
                                DateTime.now().subtract(Duration(days: 10)),
                            dateSelected: DateTime.now(),
                            onChanged: () {},
                          ).selectTime(context, new DateTime.now());
                          _.changeInicioPausa();
                        },
                        textEditingController: TextEditingController(
                            text:
                                formatoHora(_.personalTareaProcesoEntity.pausainicio, 'Inicio de pausa')),
                        label: 'Inicio de pausa',
                        hintText: 'Inicio de pausa'),
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  GetBuilder<AgregarPersonaController>(
                    id: 'fin_pausa',
                    builder: (_) => InputLabelWidget(
                        enabled: false,
                        onTap: () async {
                          _.finPausa = await DatePickerWidget(
                            onlyDate: true,
                            minDate:
                                DateTime.now().subtract(Duration(days: 10)),
                            dateSelected: DateTime.now(),
                          ).selectTime(context, new DateTime.now());
                          _.changeFinPausa();
                        },
                        textEditingController: TextEditingController(
                            text: formatoHora(_.personalTareaProcesoEntity.pausafin, 'Fin de pausa')),
                        label: 'Fin de pausa',
                        hintText: 'Fin de pausa'),
                  ),
                    GetBuilder<AgregarPersonaController>(
                      id: 'cantidad',
                      builder: (_) => InputLabelWidget(
                        hintText: 'Cantidad',
                        textInputType: TextInputType.number,
                        label: 'Cantidad',
                      ),
                    ),              
                    GetBuilder<AgregarPersonaController>(
                      id: 'unidad_avance',
                      builder: (_) => DropdownSearchWidget(
                          label: 'Unidad de avance',
                          labelText: 'name',
                          labelValue: '_id',
                          onChanged: (value) {},
                          items: [
                            {
                              'name': 'Unidad 1',
                              '_id': '1',
                            },
                            {
                              'name': 'Unidad 2',
                              '_id': '2',
                            },
                          ]),
                    ),
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                    ButtonLogin(texto: 'Guardar', onTap: _.guardar,),
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                  ],
                ),
              ),
            ),
            GetBuilder<AgregarPersonaController>(
                id: 'validando',
                builder: (_)=> _.validando ? Container(
                  color: Colors.black45,
                  child: Center(child: CircularProgressIndicator()),
                ) : Container(),
              ),
          ],
        ),
      ),
    );
  }
}
