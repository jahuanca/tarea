import 'package:flutter/material.dart';
import 'package:flutter_tareo/core/colors.dart';
import 'package:flutter_tareo/core/dimens.dart';
import 'package:flutter_tareo/ui/pages/nueva_clasificacion/nueva_clasificacion_controller.dart';
import 'package:flutter_tareo/ui/utils/string_formats.dart';
import 'package:flutter_tareo/ui/widgets/app_bar_widget.dart';
import 'package:flutter_tareo/ui/widgets/date_picker_widget.dart';
import 'package:flutter_tareo/ui/widgets/dropdown_search_widget.dart';
import 'package:flutter_tareo/ui/widgets/input_label_widget.dart';
import 'package:flutter_tareo/ui/widgets/item_configuracion_swicth_widget.dart';
import 'package:get/get.dart';

class NuevaClasificacionPage extends StatelessWidget {
  final NuevaClasificacionController controller = Get.find<NuevaClasificacionController>();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return GetBuilder<NuevaClasificacionController>(
      init: controller,
      builder: (_) => Stack(
        children: [
          Scaffold(
            appBar: getAppBar(
                controller.editando ? 'Editando Clasifido' : 'Nuevo Clasificado',
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
                    GetBuilder<NuevaClasificacionController>(
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
                    GetBuilder<NuevaClasificacionController>(
                      id: 'tipo_tarea',
                      builder: (_) => DropdownSearchWidget(
                        label: 'Tipo de tarea',
                        error: _.errorTipoTarea,
                        labelText: 'name',
                        labelValue: '_id',
                        selectedItem: _.nuevaClasificacion?.tipoTarea == null
                            ? null
                            : {
                                'name':
                                    '${_.nuevaClasificacion.tipoTarea?.descripcion?.trim()}',
                                '_id': _.nuevaClasificacion.tipoTarea?.idtipotarea,
                              },
                        onChanged: _.changeTipoTarea,
                        items: controller.tipoTareas.length == 0
                            ? []
                            : controller.tipoTareas
                                .map((e) => {
                                      'name':
                                          '${e.descripcion?.trim()}',
                                      '_id': e.idtipotarea,
                                    })
                                .toList(),
                      ),
                    ),
                    GetBuilder<NuevaClasificacionController>(
                      id: 'centro_costo',
                      builder: (_) => DropdownSearchWidget(
                        label: 'Centro',
                        error: _.errorCentroCosto,
                        labelText: 'name',
                        labelValue: '_id',
                        selectedItem: _.nuevaClasificacion?.centroCosto == null
                            ? null
                            : {
                                'name':
                                    '${_.nuevaClasificacion.centroCosto.detallecentrocosto.trim()} ${_.nuevaClasificacion.centroCosto.codigoempresa}',
                                '_id': _.nuevaClasificacion.centroCosto.idcentrocosto,
                              },
                        onChanged: _.changeCentroCosto,
                        items: controller.centrosCosto.length == 0
                            ? []
                            : controller.centrosCosto
                                .map((e) => {
                                      'name':
                                          '${e.detallecentrocosto.trim()} ${e.codigoempresa}',
                                      '_id': e.idcentrocosto,
                                    })
                                .toList(),
                      ),
                    ),
                    /* GetBuilder<NuevaClasificacionController>(
                      id: 'actividades',
                      builder: (_) => DropdownSearchWidget(
                        label: 'Actividad',
                        labelText: 'name',
                        error: _.errorActividad,
                        labelValue: '_id',
                        selectedItem: _.nuevaClasificacion?.laboresCultivoPacking?.actividad == null
                            ? null
                            : {
                                'name':
                                    _.nuevaClasificacion.laboresCultivoPacking.actividad.descripcion.trim(),
                                '_id': _.nuevaClasificacion.laboresCultivoPacking.actividad.idactividad,
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
                    /* GetBuilder<NuevaClasificacionController>(
                      id: 'labores',
                      builder: (_) => DropdownSearchWidget(
                        label: 'Labor',
                        labelText: 'name',
                        labelValue: '_id',
                        error: _.errorLabor,
                        onChanged: _.changeLabor,
                        selectedItem: _.nuevaClasificacion?.laboresCultivoPacking?.labor == null
                            ? null
                            : {
                                'name': '${_.nuevaClasificacion.laboresCultivoPacking.labor.descripcion}',
                                '_id': _.nuevaClasificacion.laboresCultivoPacking.labor.idlabor,
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
                    GetBuilder<NuevaClasificacionController>(
                      id: 'supervisors',
                      builder: (_) => DropdownSearchWidget(
                          label: 'Supervisor',
                          labelText: 'name',
                          labelValue: 'codigoempresa',
                          error: _.errorSupervisor,
                          onChanged: _.changeSupervisor,
                          selectedItem: _.nuevaClasificacion?.supervisor == null
                              ? null
                              : {
                                  'name':
                                      '${_.nuevaClasificacion.supervisor.apellidopaterno} ${_.nuevaClasificacion.supervisor.apellidomaterno}, ${_.nuevaClasificacion.supervisor.nombres}',
                                  '_id': _.nuevaClasificacion.supervisor.codigoempresa,
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
                    GetBuilder<NuevaClasificacionController>(
                      id: 'digitadors',
                      builder: (_) => DropdownSearchWidget(
                          label: 'Digitador',
                          labelText: 'name',
                          labelValue: 'codigoempresa',
                          error: _.errorDigitador,
                          onChanged: _.changeDigitador,
                          selectedItem: _.nuevaClasificacion?.digitador == null
                              ? null
                              : {
                                  'name':
                                      '${_.nuevaClasificacion.digitador.apellidopaterno} ${_.nuevaClasificacion.digitador.apellidomaterno}, ${_.nuevaClasificacion.digitador.nombres}',
                                  '_id': _.nuevaClasificacion.digitador.codigoempresa,
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
                    GetBuilder<NuevaClasificacionController>(
                      id: 'turno',
                      builder: (_) => DropdownSearchWidget(
                          label: 'Turno',
                          labelText: 'name',
                          labelValue: '_id',
                          selectedItem: {
                            'name': _.nuevaClasificacion.turnotareo == 'D'
                                ? 'Dia'
                                : 'Noche',
                            '_id': _.nuevaClasificacion.turnotareo
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
                    GetBuilder<NuevaClasificacionController>(
                      id: 'dia_siguiente',
                      builder: (_) => ItemConfiguracionSwitchWidget(
                        onChanged: _.changeDiaSiguiente,
                        size: size,
                        label: 'Dia siguiente',
                        tituloTrue: 'Es dia siguiente',
                        tituloFalse: 'No es dia siguiente',
                        value: _.nuevaClasificacion.diasiguiente ?? false,
                      ),
                    ),
                    GetBuilder<NuevaClasificacionController>(
                      id: 'hora_inicio',
                      builder: (_) => InputLabelWidget(
                          enabled: false,
                          error: _.errorHoraInicio,
                          onTap: () async {
                            _.nuevaClasificacion.horainicio = await DatePickerWidget(
                              onlyDate: true,
                              dateSelected: DateTime.now(),
                            ).selectTime(context, _.nuevaClasificacion.horainicio);
                            _.changeHoraInicio();
                          },
                          label: 'Hora inicio',
                          textEditingController: TextEditingController(
                              text: formatoHora(_.nuevaClasificacion.horainicio)),
                          hintText: 'Hora inicio'),
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    GetBuilder<NuevaClasificacionController>(
                      id: 'hora_fin',
                      builder: (_) => InputLabelWidget(
                          enabled: false,
                          error: _.errorHoraFin,
                          onTap: () async {
                            _.nuevaClasificacion.horafin = await DatePickerWidget(
                              onlyDate: true,
                              //minDate: _.nuevaClasificacion?.turnotareo=='D' ?  _.nuevaClasificacion.horainicio : null,
                              minDate: null,
                              dateSelected: _.nuevaClasificacion?.horafin ?? DateTime.now(),
                              onChanged: () {},
                            ).selectTime(context, _.nuevaClasificacion.horafin);
                            _.changeHoraFin();
                          },
                          label: 'Hora fin',
                          textEditingController: TextEditingController(
                              text: formatoHora(_.nuevaClasificacion.horafin)),
                          hintText: 'Hora fin'),
                    ),
                    GetBuilder<NuevaClasificacionController>(
                        id: 'inicio_pausa',
                        builder: (_) => (_.nuevaClasificacion.horainicio != null &&
                                _.nuevaClasificacion.horafin != null)
                            ? Column(
                                children: [
                                  InputLabelWidget(
                                      enabled: false,
                                      error: _.errorPausaInicio,
                                      iconOverlay: Icons.delete,
                                      onPressedIconOverlay: _.deleteInicioPausa,
                                      onTap: () async {
                                        _.nuevaClasificacion.pausainicio = await DatePickerWidget(
                                          onlyDate: true,
                                          dateSelected: _.nuevaClasificacion?.pausainicio ?? DateTime.now(),
                                          onChanged: () {},
                                        ).selectTime(
                                            context, null );
                                        _.changeInicioPausa();
                                      },
                                      textEditingController:
                                          TextEditingController(
                                              text: formatoHora(_.nuevaClasificacion.pausainicio)),
                                      label: 'Inicio de pausa',
                                      hintText: 'Inicio de pausa'),
                                  SizedBox(
                                    height: size.height * 0.01,
                                  ),
                                ],
                              )
                            : Container()),
                    GetBuilder<NuevaClasificacionController>(
                        id: 'fin_pausa',
                        builder: (_) => (_.nuevaClasificacion.horainicio != null &&
                                _.nuevaClasificacion.horafin != null)
                            ? InputLabelWidget(
                                enabled: false,
                                iconOverlay: Icons.delete,
                                onPressedIconOverlay: _.deleteFinPausa,
                                error: _.errorPausaFin,
                                onTap: () async {
                                  _.nuevaClasificacion.pausafin = await DatePickerWidget(
                                    onlyDate: true,
                                    dateSelected: DateTime.now(),
                                    //minDate: _.nuevaClasificacion.horainicio,
                                    minDate: null,
                                  ).selectTime(context, null);
                                  _.changeFinPausa();
                                },
                                textEditingController: TextEditingController(
                                    text: formatoHora(_.nuevaClasificacion.pausafin)),
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
          GetBuilder<NuevaClasificacionController>(
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
              child: GetBuilder<NuevaClasificacionController>(
                id: 'personal',
                builder: (_) => Container(
                  alignment: Alignment.center,
                  child: Text(
                    '${_.nuevaClasificacion.detalles.length} personas',
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
                        //onPressed: controller.goListadoPersonas,
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
