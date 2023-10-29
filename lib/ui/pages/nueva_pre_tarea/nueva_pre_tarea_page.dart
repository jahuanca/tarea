import 'package:flutter/material.dart';
import 'package:flutter_tareo/core/utils/colors.dart';
import 'package:flutter_tareo/core/utils/dimens.dart';
import 'package:flutter_tareo/ui/pages/nueva_pre_tarea/nueva_pre_tarea_controller.dart';
import 'package:flutter_tareo/ui/utils/string_formats.dart';
import 'package:flutter_tareo/ui/widgets/app_bar_widget.dart';
import 'package:flutter_tareo/ui/widgets/date_picker_widget.dart';
import 'package:flutter_tareo/ui/widgets/dropdown_search_widget.dart';
import 'package:flutter_tareo/ui/widgets/input_label_widget.dart';
import 'package:flutter_tareo/ui/widgets/item_configuracion_swicth_widget.dart';
import 'package:get/get.dart';

class NuevaPreTareaPage extends StatelessWidget {
  final NuevaPreTareaController controller =
      Get.find<NuevaPreTareaController>();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return GetBuilder<NuevaPreTareaController>(
      init: controller,
      builder: (_) => Stack(
        children: [
          Scaffold(
            appBar: getAppBar(
                controller.editando ? 'Editando arándano' : 'Nuevo arándano',
                [],
                true),
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
                    GetBuilder<NuevaPreTareaController>(
                      id: 'fecha',
                      builder: (_) => InputLabelWidget(
                          error: _.errorFecha,
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
                          textEditingController: TextEditingController(
                              text: formatoFecha(_.fecha)),
                          label: 'Fecha',
                          enabled: false,
                          hintText: 'Fecha'),
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    GetBuilder<NuevaPreTareaController>(
                      id: 'presentacion',
                      builder: (_) => DropdownSearchWidget(
                        label: 'Presentación',
                        /* error: _.errorCentroCosto, */
                        labelText: 'name',
                        labelValue: '_id',
                        selectedItem: _.nuevaPreTarea?.laboresCultivoPacking
                                    ?.presentacionLinea ==
                                null
                            ? null
                            : {
                                'name':
                                    '${_.nuevaPreTarea.laboresCultivoPacking.presentacionLinea.descripcion.trim()}',
                                '_id':
                                    _.nuevaPreTarea.laboresCultivoPacking.item,
                              },
                        onChanged: _.changePresentacion,
                        items: controller.presentaciones.length == 0
                            ? []
                            : controller.presentaciones
                                .map((e) => {
                                      'name': '${e.descripcion.trim()}',
                                      '_id': e.idpresentacion,
                                    })
                                .toList(),
                      ),
                    ),
                    GetBuilder<NuevaPreTareaController>(
                      id: 'centro_costo',
                      builder: (_) => DropdownSearchWidget(
                        label: 'Centro',
                        error: _.errorCentroCosto,
                        labelText: 'name',
                        labelValue: '_id',
                        selectedItem: _.nuevaPreTarea?.centroCosto == null
                            ? null
                            : {
                                'name':
                                    '${_.nuevaPreTarea.centroCosto?.detallecentrocosto?.trim()} ${_.nuevaPreTarea?.centroCosto?.codigoempresa}',
                                '_id':
                                    _.nuevaPreTarea.centroCosto.idcentrocosto,
                              },
                        onChanged: _.changeCentroCosto,
                        items: controller.centrosCosto.length == 0
                            ? []
                            : controller.centrosCosto
                                .map((e) => {
                                      'name':
                                          '${e.detallecentrocosto?.trim()} ${e.codigoempresa}',
                                      '_id': e.idcentrocosto,
                                    })
                                .toList(),
                      ),
                    ),
                    GetBuilder<NuevaPreTareaController>(
                      id: 'actividades',
                      builder: (_) => DropdownSearchWidget(
                        label: 'Actividad',
                        labelText: 'name',
                        error: _.errorActividad,
                        labelValue: '_id',
                        selectedItem:
                            _.nuevaPreTarea?.laboresCultivoPacking?.actividad ==
                                    null
                                ? null
                                : {
                                    'name': _
                                        .nuevaPreTarea
                                        .laboresCultivoPacking
                                        .actividad
                                        .descripcion
                                        .trim(),
                                    '_id': _.nuevaPreTarea.laboresCultivoPacking
                                        .actividad.idactividad,
                                  },
                        onChanged: _.changeActividad,
                        items: controller.actividades.length == 0
                            ? []
                            : controller.actividades
                                .map((e) => {
                                      'name': e.descripcion.trim(),
                                      '_id': e.idactividad,
                                    })
                                .toList(),
                      ),
                    ),
                    GetBuilder<NuevaPreTareaController>(
                      id: 'labores',
                      builder: (_) => DropdownSearchWidget(
                        label: 'Labor',
                        labelText: 'name',
                        labelValue: '_id',
                        error: _.errorLabor,
                        onChanged: _.changeLabor,
                        selectedItem:
                            _.nuevaPreTarea?.laboresCultivoPacking?.labor ==
                                    null
                                ? null
                                : {
                                    'name':
                                        '${_.nuevaPreTarea.laboresCultivoPacking.labor.descripcion}',
                                    '_id': _.nuevaPreTarea.laboresCultivoPacking
                                        .labor.idlabor,
                                  },
                        items: controller.labores.length == 0
                            ? []
                            : controller.labores
                                .map((e) => {
                                      'name': '${e.descripcion}',
                                      '_id': e.idlabor,
                                    })
                                .toList(),
                      ),
                    ),
                    GetBuilder<NuevaPreTareaController>(
                      id: 'supervisors',
                      builder: (_) => DropdownSearchWidget(
                          label: 'Supervisor',
                          labelText: 'name',
                          labelValue: 'codigoempresa',
                          error: _.errorSupervisor,
                          onChanged: _.changeSupervisor,
                          selectedItem: _.nuevaPreTarea?.supervisor == null
                              ? null
                              : {
                                  'name':
                                      '${_.nuevaPreTarea.supervisor.apellidopaterno} ${_.nuevaPreTarea.supervisor.apellidomaterno}, ${_.nuevaPreTarea.supervisor.nombres}',
                                  '_id':
                                      _.nuevaPreTarea.supervisor.codigoempresa,
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
                    GetBuilder<NuevaPreTareaController>(
                      id: 'digitadors',
                      builder: (_) => DropdownSearchWidget(
                          label: 'Digitador',
                          labelText: 'name',
                          labelValue: 'codigoempresa',
                          error: _.errorDigitador,
                          onChanged: _.changeDigitador,
                          selectedItem: _.nuevaPreTarea?.digitador == null
                              ? null
                              : {
                                  'name':
                                      '${_.nuevaPreTarea.digitador.apellidopaterno} ${_.nuevaPreTarea.digitador.apellidomaterno}, ${_.nuevaPreTarea.digitador.nombres}',
                                  '_id':
                                      _.nuevaPreTarea.digitador.codigoempresa,
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
                    GetBuilder<NuevaPreTareaController>(
                      id: 'turno',
                      builder: (_) => DropdownSearchWidget(
                          label: 'Turno',
                          labelText: 'name',
                          labelValue: '_id',
                          selectedItem: {
                            'name': _.nuevaPreTarea.turnotareo == 'D'
                                ? 'Dia'
                                : 'Noche',
                            '_id': _.nuevaPreTarea.turnotareo
                          },
                          onChanged: _.changeTurno,
                          items: [
                            {
                              'name': 'Dia',
                              '_id': 'D',
                            },
                            {
                              'name': 'Noche',
                              '_id': 'N',
                            },
                          ]),
                    ),
                    GetBuilder<NuevaPreTareaController>(
                      id: 'dia_siguiente',
                      builder: (_) => ItemConfiguracionSwitchWidget(
                        onChanged: _.changeDiaSiguiente,
                        size: size,
                        label: 'Dia siguiente',
                        tituloTrue: 'Es dia siguiente',
                        tituloFalse: 'No es dia siguiente',
                        value: _.nuevaPreTarea.diasiguiente ?? false,
                      ),
                    ),
                    GetBuilder<NuevaPreTareaController>(
                      id: 'hora_inicio',
                      builder: (_) => InputLabelWidget(
                          enabled: false,
                          error: _.errorHoraInicio,
                          onTap: () async {
                            _.nuevaPreTarea.horainicio = await DatePickerWidget(
                              onlyDate: true,
                              dateSelected: DateTime.now(),
                            ).selectTime(context, _.nuevaPreTarea.horainicio);
                            _.changeHoraInicio();
                          },
                          label: 'Hora inicio',
                          textEditingController: TextEditingController(
                              text: formatoHora(_.nuevaPreTarea.horainicio)),
                          hintText: 'Hora inicio'),
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    GetBuilder<NuevaPreTareaController>(
                      id: 'hora_fin',
                      builder: (_) => InputLabelWidget(
                          enabled: false,
                          error: _.errorHoraFin,
                          onTap: () async {
                            _.nuevaPreTarea.horafin = await DatePickerWidget(
                              onlyDate: true,
                              //minDate: _.nuevaPreTarea?.turnotareo=='D' ?  _.nuevaPreTarea.horainicio : null,
                              minDate: null,
                              dateSelected:
                                  _.nuevaPreTarea.horafin ?? DateTime.now(),
                              onChanged: () {},
                            ).selectTime(context, _.nuevaPreTarea.horafin);
                            _.changeHoraFin();
                          },
                          label: 'Hora fin',
                          textEditingController: TextEditingController(
                              text: formatoHora(_.nuevaPreTarea.horafin)),
                          hintText: 'Hora fin'),
                    ),
                    GetBuilder<NuevaPreTareaController>(
                        id: 'inicio_pausa',
                        builder: (_) => (_.nuevaPreTarea.horainicio != null &&
                                _.nuevaPreTarea.horafin != null)
                            ? Column(
                                children: [
                                  InputLabelWidget(
                                      enabled: false,
                                      error: _.errorPausaInicio,
                                      iconOverlay: Icons.delete,
                                      onPressedIconOverlay: _.deleteInicioPausa,
                                      onTap: () async {
                                        _.nuevaPreTarea.pausainicio =
                                            await DatePickerWidget(
                                          onlyDate: true,
                                          dateSelected:
                                              _.nuevaPreTarea?.pausainicio ??
                                                  DateTime.now(),
                                          onChanged: () {},
                                        ).selectTime(context, null);
                                        _.changeInicioPausa();
                                      },
                                      textEditingController:
                                          TextEditingController(
                                              text: formatoHora(
                                                  _.nuevaPreTarea.pausainicio)),
                                      label: 'Inicio de pausa',
                                      hintText: 'Inicio de pausa'),
                                  SizedBox(
                                    height: size.height * 0.01,
                                  ),
                                ],
                              )
                            : Container()),
                    GetBuilder<NuevaPreTareaController>(
                        id: 'fin_pausa',
                        builder: (_) => (_.nuevaPreTarea.horainicio != null &&
                                _.nuevaPreTarea.horafin != null)
                            ? InputLabelWidget(
                                enabled: false,
                                iconOverlay: Icons.delete,
                                onPressedIconOverlay: _.deleteFinPausa,
                                error: _.errorPausaFin,
                                onTap: () async {
                                  _.nuevaPreTarea.pausafin =
                                      await DatePickerWidget(
                                    onlyDate: true,
                                    dateSelected: DateTime.now(),
                                    //minDate: _.nuevaPreTarea.horainicio,
                                    minDate: null,
                                  ).selectTime(context, null);
                                  _.changeFinPausa();
                                },
                                textEditingController: TextEditingController(
                                    text:
                                        formatoHora(_.nuevaPreTarea.pausafin)),
                                label: 'Fin de pausa',
                                hintText: 'Fin de pausa')
                            : Container()),
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                    _agregarMultimedia(size, context),
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                  ],
                ),
              ),
            ),
          ),
          GetBuilder<NuevaPreTareaController>(
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
              child: GetBuilder<NuevaPreTareaController>(
                id: 'personal',
                builder: (_) => Container(
                  alignment: Alignment.center,
                  child: Text(
                    '${_.nuevaPreTarea.detalles.length} personas',
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
                        onPressed: null, //controller.goListadoPersonas,
                        icon: Icon(Icons.search, size: 40),
                      ),
                    ),
                    flex: 1),
                Flexible(
                  child: Container(),
                  flex: 1,
                ),
                /* Flexible(
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
                ), */
              ],
            ),
          ),
          Flexible(child: Container(), flex: 1),
        ],
      ),
    );
  }
}
