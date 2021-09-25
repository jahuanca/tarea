
import 'package:flutter/material.dart';
import 'package:flutter_tareo/core/colors.dart';
import 'package:flutter_tareo/core/dimens.dart';
import 'package:flutter_tareo/ui/pages/nueva_tarea/nueva_tarea_controller.dart';
import 'package:flutter_tareo/ui/utils/string_formats.dart';
import 'package:flutter_tareo/ui/widgets/app_bar_widget.dart';
import 'package:flutter_tareo/ui/widgets/date_picker_widget.dart';
import 'package:flutter_tareo/ui/widgets/dropdown_search_widget.dart';
import 'package:flutter_tareo/ui/widgets/input_label_widget.dart';
import 'package:flutter_tareo/ui/widgets/item_configuracion_swicth_widget.dart';
import 'package:get/get.dart';

class NuevaTareaPage extends StatelessWidget {
  final NuevaTareaController controller = Get.find<NuevaTareaController>();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return GetBuilder<NuevaTareaController>(
      init: controller,
      builder: (_) => Stack(
        children: [
          Scaffold(
            appBar: getAppBar(controller.editando ? 'Editando tarea': 'Nueva tarea', [], true),
            backgroundColor: secondColor,
            floatingActionButton: FloatingActionButton(
              onPressed: controller.goBack,
              child: Icon(Icons.check),
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                child: Column(
                  children: [
                    GetBuilder<NuevaTareaController>(
                      id: 'fecha',
                      builder: (_) => InputLabelWidget(
                          onTap: () async {
                            _.fecha = await DatePickerWidget(
                              onlyDate: true,
                              minDate:
                                  DateTime.now().subtract(Duration(days: 10)),
                              dateSelected: DateTime.now(),
                              onChanged: () {},
                            ).selectDate(context);
                            _.changeFecha();
                          },
                          textEditingController:
                              TextEditingController(text: formatoFecha(_.fecha)),
                          label: 'Fecha',
                          enabled: false,
                          hintText: 'Fecha'),
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    DropdownSearchWidget(
                        label: 'Centro',
                        labelText: 'name',
                        labelValue: '_id',
                        onChanged: (value) {},
                        items: [
                          {
                            'name': 'Centro de Costo',
                            '_id': '1',
                          },
                          {
                            'name': 'Centro de Costo - Fundo',
                            '_id': '2',
                          },
                        ]),
                    GetBuilder<NuevaTareaController>(
                      id: 'rendimiento',
                      builder: (_) => ItemConfiguracionSwitchWidget(
                        onChanged: _.changeRendimiento,
                        size: size,
                        label: 'Rendimiento/Jornal',
                        tituloTrue: 'Es jornal',
                        tituloFalse: 'Es rendimiento',
                        value: _.rendimiento ?? false,
                      ),
                    ),
                    GetBuilder<NuevaTareaController>(
                      id: 'actividades',
                      builder: (_) => DropdownSearchWidget(
                        label: 'Actividad',
                        labelText: 'name',
                        labelValue: '_id',
                        selectedItem: _.nuevaTarea?.actividad == null ? null : {
                          'name' : '${_.nuevaTarea.actividad.actividad} ${_.nuevaTarea.actividad.idsociedad}',
                          '_id' : _.nuevaTarea.actividad.actividad,
                        },
                        onChanged: _.changeActividad,
                        items: controller.actividades.length == 0
                            ? [
                                {
                                  '_id': '1',
                                  'name': 'General',
                                }
                              ]
                            : controller.actividades
                                .map((e) => {
                                      'name': '${e.actividad} ${e.idsociedad}',
                                      '_id': e.actividad,
                                    })
                                .toList(),
                      ),
                    ),
                    GetBuilder<NuevaTareaController>(
                      id: 'labores',
                      builder: (_) => DropdownSearchWidget(
                        label: 'Labor',
                        labelText: 'name',
                        labelValue: '_id',
                        onChanged: (value) {},
                        selectedItem: _.nuevaTarea?.labor == null ? null : {
                          'name' : '${_.nuevaTarea.labor.descLabor} ${_.nuevaTarea.labor.sociedad}',
                          '_id' : _.nuevaTarea.labor.labor,
                        },
                        items: controller.labores.length == 0
                            ? [
                                {
                                  '_id': '1',
                                  'name': 'General',
                                }
                              ]
                            : controller.labores
                                .map((e) => {
                                      'name': '${e.descLabor} ${e.sociedad}',
                                      '_id': e.labor,
                                    })
                                .toList(),
                      ),
                    ),
                    GetBuilder<NuevaTareaController>(
                      id: 'supervisors',
                      builder: (_) => DropdownSearchWidget(
                          label: 'Supervisor',
                          labelText: 'name',
                          labelValue: 'codigoempresa',
                          onChanged: _.changeSupervisor,
                          selectedItem: _.nuevaTarea?.supervisor == null ? null : {
                          'name' : '${_.nuevaTarea.supervisor.apellidopaterno} ${_.nuevaTarea.supervisor.apellidomaterno}, ${_.nuevaTarea.supervisor.nombres}',
                          '_id' : _.nuevaTarea.supervisor.codigoempresa,
                        },
                          items: _.supervisors.length == 0
                              ? []
                              : _.supervisors
                                  .map((e) => {
                                        'name':
                                            '${e.apellidopaterno} ${e.apellidomaterno}, ${e.nombres}',
                                        'codigoempresa': e.codigoempresa,
                                      })
                                  .toList()),
                    ),
                    DropdownSearchWidget(
                        label: 'Turno',
                        labelText: 'name',
                        labelValue: '_id',
                        onChanged: (value) {},
                        items: [
                          {
                            'name': 'Dia',
                            '_id': '1',
                          },
                          {
                            'name': 'Noche',
                            '_id': '2',
                          },
                        ]),
                    GetBuilder<NuevaTareaController>(
                      id: 'dia_siguiente',
                      builder: (_) => ItemConfiguracionSwitchWidget(
                        onChanged: _.changeDiaSiguiente,
                        size: size,
                        label: 'Dia siguiente',
                        tituloTrue: 'Es dia siguiente',
                        tituloFalse: 'No es dia siguiente',
                        value: _.nuevaTarea.diasiguiente ?? false,
                      ),
                    ),
                    GetBuilder<NuevaTareaController>(
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
                              text: formatoHora(_.nuevaTarea.horainicio, 'Hora Inicio')),
                          hintText: 'Hora inicio'),
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    GetBuilder<NuevaTareaController>(
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
                              text: formatoHora(_.horaFin, 'Hora Fin')),
                          hintText: 'Hora fin'),
                    ),
                    GetBuilder<NuevaTareaController>(
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
                            print('inicio');
                          },
                          textEditingController: TextEditingController(
                              text:
                                  formatoHora(_.inicioPausa, 'Inicio de pausa')),
                          label: 'Inicio de pausa',
                          hintText: 'Inicio de pausa'),
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    GetBuilder<NuevaTareaController>(
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
                              text: formatoHora(_.finPausa, 'Fin de pausa')),
                          label: 'Fin de pausa',
                          hintText: 'Fin de pausa'),
                    ),
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                    _agregarMultimedia(size, context),
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                  ],
                ),
              ),
            ),
          ),
          GetBuilder<NuevaTareaController>(
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

  Widget _agregarMultimedia(Size size, BuildContext context) {
    return Container(
      height: size.height * 0.17,
      decoration: BoxDecoration(
          border: Border.all(
            color: primaryColor,
          ),
          borderRadius: BorderRadius.circular(borderRadius),
          color: primaryColor.withAlpha(50)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(child: Container(), flex: 1),
          Flexible(
              child: GetBuilder<NuevaTareaController>(
                id: 'personal',
                builder: (_) => Container(
                  alignment: Alignment.center,
                  child: Text(
                    '${_.nuevaTarea.personal.length} personas',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
              flex: 2),
          Flexible(child: Container(), flex: 1),
          Flexible(
            flex: 3,
            child: Row(
              children: [
                Flexible(
                  child: Container(),
                  flex: 1,
                ),
                Flexible(
                    child: Container(
                      alignment: Alignment.center,
                      child: IconButton(
                        onPressed: controller.goListadoPersonas,
                        icon: Icon(Icons.search, size: 40),
                      ),
                    ),
                    flex: 1),
                Flexible(
                  child: Container(),
                  flex: 1,
                ),
                Flexible(
                    child: Container(
                      alignment: Alignment.center,
                      child: IconButton(
                        onPressed: controller.goAgregarPersona,
                        icon: Icon(Icons.person_add, size: 40),
                      ),
                    ),
                    flex: 1),
                Flexible(
                  child: Container(),
                  flex: 1,
                ),
              ],
            ),
          ),
          Flexible(child: Container(), flex: 1),
        ],
      ),
    );
  }
}
