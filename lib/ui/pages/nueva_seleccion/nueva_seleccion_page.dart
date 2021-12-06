import 'package:flutter/material.dart';
import 'package:flutter_tareo/core/colors.dart';
import 'package:flutter_tareo/core/dimens.dart';
import 'package:flutter_tareo/ui/pages/nueva_seleccion/nueva_seleccion_controller.dart';
import 'package:flutter_tareo/ui/utils/string_formats.dart';
import 'package:flutter_tareo/ui/widgets/app_bar_widget.dart';
import 'package:flutter_tareo/ui/widgets/date_picker_widget.dart';
import 'package:flutter_tareo/ui/widgets/dropdown_search_widget.dart';
import 'package:flutter_tareo/ui/widgets/input_label_widget.dart';
import 'package:flutter_tareo/ui/widgets/item_configuracion_swicth_widget.dart';
import 'package:get/get.dart';

class NuevaSeleccionPage extends StatelessWidget {
  final NuevaSeleccionController controller = Get.find<NuevaSeleccionController>();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return GetBuilder<NuevaSeleccionController>(
      init: controller,
      builder: (_) => Stack(
        children: [
          Scaffold(
            appBar: getAppBar(
                controller.editando ? 'Editando Seleccion' : 'Nuevo Seleccion',
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
                    GetBuilder<NuevaSeleccionController>(
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
                    GetBuilder<NuevaSeleccionController>(
                      id: 'centro_costo',
                      builder: (_) => DropdownSearchWidget(
                        label: 'Centro',
                        error: _.errorCentroCosto,
                        labelText: 'name',
                        labelValue: '_id',
                        selectedItem: _.nuevaSeleccion?.centroCosto == null
                            ? null
                            : {
                                'name':
                                    '${_.nuevaSeleccion.centroCosto.detallecentrocosto.trim()} ${_.nuevaSeleccion.centroCosto.codigoempresa}',
                                '_id': _.nuevaSeleccion.centroCosto.idcentrocosto,
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
                    GetBuilder<NuevaSeleccionController>(
                      id: 'actividades',
                      builder: (_) => DropdownSearchWidget(
                        label: 'Actividad',
                        labelText: 'name',
                        error: _.errorActividad,
                        labelValue: '_id',
                        selectedItem: _.nuevaSeleccion?.actividad == null
                            ? null
                            : {
                                'name':
                                    _.nuevaSeleccion.actividad.descripcion.trim(),
                                '_id': _.nuevaSeleccion.actividad.idactividad,
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
                    GetBuilder<NuevaSeleccionController>(
                      id: 'labores',
                      builder: (_) => DropdownSearchWidget(
                        label: 'Labor',
                        labelText: 'name',
                        labelValue: '_id',
                        error: _.errorLabor,
                        onChanged: _.changeLabor,
                        selectedItem: _.nuevaSeleccion?.labor == null
                            ? null
                            : {
                                'name': '${_.nuevaSeleccion.labor.descripcion}',
                                '_id': _.nuevaSeleccion.labor.idlabor,
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
                    GetBuilder<NuevaSeleccionController>(
                      id: 'supervisors',
                      builder: (_) => DropdownSearchWidget(
                          label: 'Supervisor',
                          labelText: 'name',
                          labelValue: 'codigoempresa',
                          error: _.errorSupervisor,
                          onChanged: _.changeSupervisor,
                          selectedItem: _.nuevaSeleccion?.supervisor == null
                              ? null
                              : {
                                  'name':
                                      '${_.nuevaSeleccion.supervisor.apellidopaterno} ${_.nuevaSeleccion.supervisor.apellidomaterno}, ${_.nuevaSeleccion.supervisor.nombres}',
                                  '_id': _.nuevaSeleccion.supervisor.codigoempresa,
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
                    GetBuilder<NuevaSeleccionController>(
                      id: 'digitadors',
                      builder: (_) => DropdownSearchWidget(
                          label: 'Digitador',
                          labelText: 'name',
                          labelValue: 'codigoempresa',
                          error: _.errorDigitador,
                          onChanged: _.changeDigitador,
                          selectedItem: _.nuevaSeleccion?.digitador == null
                              ? null
                              : {
                                  'name':
                                      '${_.nuevaSeleccion.digitador.apellidopaterno} ${_.nuevaSeleccion.digitador.apellidomaterno}, ${_.nuevaSeleccion.digitador.nombres}',
                                  '_id': _.nuevaSeleccion.digitador.codigoempresa,
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
                    GetBuilder<NuevaSeleccionController>(
                      id: 'turno',
                      builder: (_) => DropdownSearchWidget(
                          label: 'Turno',
                          labelText: 'name',
                          labelValue: '_id',
                          selectedItem: {
                            'name': _.nuevaSeleccion.turnotareo == 'D'
                                ? 'Dia'
                                : 'Noche',
                            '_id': _.nuevaSeleccion.turnotareo
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
                    GetBuilder<NuevaSeleccionController>(
                      id: 'dia_siguiente',
                      builder: (_) => ItemConfiguracionSwitchWidget(
                        onChanged: _.changeDiaSiguiente,
                        size: size,
                        label: 'Dia siguiente',
                        tituloTrue: 'Es dia siguiente',
                        tituloFalse: 'No es dia siguiente',
                        value: _.nuevaSeleccion.diasiguiente ?? false,
                      ),
                    ),
                    GetBuilder<NuevaSeleccionController>(
                      id: 'hora_inicio',
                      builder: (_) => InputLabelWidget(
                          enabled: false,
                          error: _.errorHoraInicio,
                          onTap: () async {
                            _.nuevaSeleccion.horainicio = await DatePickerWidget(
                              onlyDate: true,
                              dateSelected: DateTime.now(),
                            ).selectTime(context, _.nuevaSeleccion.horainicio);
                            _.changeHoraInicio();
                          },
                          label: 'Hora inicio',
                          textEditingController: TextEditingController(
                              text: formatoHora(_.nuevaSeleccion.horainicio)),
                          hintText: 'Hora inicio'),
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    GetBuilder<NuevaSeleccionController>(
                      id: 'hora_fin',
                      builder: (_) => InputLabelWidget(
                          enabled: false,
                          error: _.errorHoraFin,
                          onTap: () async {
                            _.nuevaSeleccion.horafin = await DatePickerWidget(
                              onlyDate: true,
                              //minDate: _.nuevaPreTarea?.turnotareo=='D' ?  _.nuevaPreTarea.horainicio : null,
                              minDate: null,
                              dateSelected: _.nuevaSeleccion?.horafin ?? DateTime.now(),
                              onChanged: () {},
                            ).selectTime(context, _.nuevaSeleccion.horafin);
                            _.changeHoraFin();
                          },
                          label: 'Hora fin',
                          textEditingController: TextEditingController(
                              text: formatoHora(_.nuevaSeleccion.horafin)),
                          hintText: 'Hora fin'),
                    ),
                    GetBuilder<NuevaSeleccionController>(
                        id: 'inicio_pausa',
                        builder: (_) => (_.nuevaSeleccion.horainicio != null &&
                                _.nuevaSeleccion.horafin != null)
                            ? Column(
                                children: [
                                  InputLabelWidget(
                                      enabled: false,
                                      error: _.errorPausaInicio,
                                      iconOverlay: Icons.delete,
                                      onPressedIconOverlay: _.deleteInicioPausa,
                                      onTap: () async {
                                        _.nuevaSeleccion.pausainicio = await DatePickerWidget(
                                          onlyDate: true,
                                          dateSelected: _.nuevaSeleccion?.pausainicio ?? DateTime.now(),
                                          onChanged: () {},
                                        ).selectTime(
                                            context, null );
                                        _.changeInicioPausa();
                                      },
                                      textEditingController:
                                          TextEditingController(
                                              text: formatoHora(_.nuevaSeleccion.pausainicio)),
                                      label: 'Inicio de pausa',
                                      hintText: 'Inicio de pausa'),
                                  SizedBox(
                                    height: size.height * 0.01,
                                  ),
                                ],
                              )
                            : Container()),
                    GetBuilder<NuevaSeleccionController>(
                        id: 'fin_pausa',
                        builder: (_) => (_.nuevaSeleccion.horainicio != null &&
                                _.nuevaSeleccion.horafin != null)
                            ? InputLabelWidget(
                                enabled: false,
                                iconOverlay: Icons.delete,
                                onPressedIconOverlay: _.deleteFinPausa,
                                error: _.errorPausaFin,
                                onTap: () async {
                                  _.nuevaSeleccion.pausafin = await DatePickerWidget(
                                    onlyDate: true,
                                    dateSelected: DateTime.now(),
                                    //minDate: _.nuevaPreTarea.horainicio,
                                    minDate: null,
                                  ).selectTime(context, null);
                                  _.changeFinPausa();
                                },
                                textEditingController: TextEditingController(
                                    text: formatoHora(_.nuevaSeleccion.pausafin)),
                                label: 'Fin de pausa',
                                hintText: 'Fin de pausa')
                            : Container()),
                    GetBuilder<NuevaSeleccionController>(
                      id: 'kilos_avance',
                      builder: (_) => InputLabelWidget(
                        hintText: 'Kilos avance',
                        initialValue: _.nuevaSeleccion.kilosavance == null ? '' : _.nuevaSeleccion.kilosavance.toString(),
                        error: _.errorKilosavance,
                        onChanged: _.changeCantidadAvance,
                        textInputType: TextInputType.number,
                        label: 'Kilos avance',
                      ),
                    ),
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
          GetBuilder<NuevaSeleccionController>(
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
              child: GetBuilder<NuevaSeleccionController>(
                id: 'personal',
                builder: (_) => Container(
                  alignment: Alignment.center,
                  child: Text(
                    '${_.nuevaSeleccion.sizeDetails} personas',
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
                        onPressed: null, // controller.goListadoPersonas,
                        icon: Icon(Icons.search, size: 40),
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
