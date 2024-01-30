import 'package:flutter/material.dart';
import 'package:flutter_tareo/core/utils/colors.dart';
import 'package:flutter_tareo/ui/packing/nuevo_packing/nuevo_packing_controller.dart';
import 'package:flutter_tareo/ui/utils/string_formats.dart';
import 'package:flutter_tareo/ui/widgets/app_bar_widget.dart';
import 'package:flutter_tareo/ui/widgets/date_picker_widget.dart';
import 'package:flutter_tareo/ui/widgets/dropdown_search_widget.dart';
import 'package:flutter_tareo/ui/widgets/input_label_widget.dart';
import 'package:flutter_tareo/ui/widgets/item_configuracion_swicth_widget.dart';
import 'package:get/get.dart';

class NuevoPackingPage extends StatelessWidget {
  final NuevoPackingController controller = Get.find<NuevoPackingController>();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return GetBuilder<NuevoPackingController>(
      init: controller,
      builder: (_) => Stack(
        children: [
          Scaffold(
            appBar: getAppBar(
                controller.editando ? 'Editando Packing' : 'Nuevo Packing',
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
                    GetBuilder<NuevoPackingController>(
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
                    /* GetBuilder<NuevaPreTareaUvaController>(
                      id: 'presentacion',
                      builder: (_) => DropdownSearchWidget(
                        label: 'Presentación',
                        /* error: _.errorCentroCosto, */
                        labelText: 'name',
                        labelValue: '_id',
                        selectedItem: _.nuevaPreTarea?.laboresCultivoPacking?.presentacionLinea == null
                            ? null
                            : {
                                'name':
                                    '${_.nuevaPreTarea.laboresCultivoPacking.presentacionLinea.descripcion.trim()}',
                                '_id': _.nuevaPreTarea.laboresCultivoPacking.item,
                              },
                        onChanged: _.changePresentacion,
                        items: controller.presentaciones.length == 0
                            ? []
                            : controller.presentaciones
                                .map((e) => {
                                      'name':
                                          '${e.descripcion.trim()}',
                                      '_id': e.idpresentacion,
                                    })
                                .toList(),
                      ),
                    ), */
                    GetBuilder<NuevoPackingController>(
                      id: 'cultivo',
                      builder: (_) => DropdownSearchWidget(
                        label: 'Cultivo',
                        error: _.errorCultivo,
                        labelText: 'name',
                        labelValue: '_id',
                        selectedItem: _.nuevaPreTarea?.cultivo == null
                            ? null
                            : {
                                'name':
                                    '${_.nuevaPreTarea.cultivo.detallecultivo.trim()} - ${_.nuevaPreTarea.cultivo.cultivo.trim()}',
                                '_id': _.nuevaPreTarea.cultivo.idcultivo,
                              },
                        onChanged: _.changeCultivo,
                        items: controller.cultivos.length == 0
                            ? []
                            : controller.cultivos
                                .map((e) => {
                                      'name':
                                          '${e.detallecultivo.trim()} - ${e.cultivo.trim()}',
                                      '_id': e.idcultivo,
                                    })
                                .toList(),
                      ),
                    ),
                    GetBuilder<NuevoPackingController>(
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
                                    '${_.nuevaPreTarea.centroCosto?.detallecentrocosto?.trim()} ${_.nuevaPreTarea.centroCosto?.codigoempresa}',
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
                    /* GetBuilder<NuevaPreTareaUvaController>(
                      id: 'actividades',
                      builder: (_) => DropdownSearchWidget(
                        label: 'Actividad',
                        labelText: 'name',
                        error: _.errorActividad,
                        labelValue: '_id',
                        selectedItem: _.nuevaPreTarea?.laboresCultivoPacking?.actividad == null
                            ? null
                            : {
                                'name':
                                    _.nuevaPreTarea.laboresCultivoPacking.actividad.descripcion.trim(),
                                '_id': _.nuevaPreTarea.laboresCultivoPacking.actividad.idactividad,
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
                    ), */
                    /* GetBuilder<NuevaPreTareaUvaController>(
                      id: 'labores',
                      builder: (_) => DropdownSearchWidget(
                        label: 'Labor',
                        labelText: 'name',
                        labelValue: '_id',
                        error: _.errorLabor,
                        onChanged: _.changeLabor,
                        selectedItem: _.nuevaPreTarea?.laboresCultivoPacking?.labor == null
                            ? null
                            : {
                                'name': '${_.nuevaPreTarea.laboresCultivoPacking.labor.descripcion}',
                                '_id': _.nuevaPreTarea.laboresCultivoPacking.labor.idlabor,
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
                    ), */
                    GetBuilder<NuevoPackingController>(
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
                    GetBuilder<NuevoPackingController>(
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
                    GetBuilder<NuevoPackingController>(
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
                    GetBuilder<NuevoPackingController>(
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
                    GetBuilder<NuevoPackingController>(
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
                    GetBuilder<NuevoPackingController>(
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
                                  _.nuevaPreTarea?.horafin ?? DateTime.now(),
                              onChanged: () {},
                            ).selectTime(context, _.nuevaPreTarea.horafin);
                            _.changeHoraFin();
                          },
                          label: 'Hora fin',
                          textEditingController: TextEditingController(
                              text: formatoHora(_.nuevaPreTarea.horafin)),
                          hintText: 'Hora fin'),
                    ),
                    GetBuilder<NuevoPackingController>(
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
                    GetBuilder<NuevoPackingController>(
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
                    //_agregarMultimedia(size, context),
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
          GetBuilder<NuevoPackingController>(
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
}