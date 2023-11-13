import 'package:flutter/material.dart';
import 'package:flutter_tareo/core/utils/colors.dart';
import 'package:flutter_tareo/core/utils/dimens.dart';
import 'package:flutter_tareo/ui/pages/nueva_pesado/nueva_pesado_controller.dart';
import 'package:flutter_tareo/ui/utils/string_formats.dart';
import 'package:flutter_tareo/ui/widgets/app_bar_widget.dart';
import 'package:flutter_tareo/ui/widgets/date_picker_widget.dart';
import 'package:flutter_tareo/ui/widgets/dropdown_search_widget.dart';
import 'package:flutter_tareo/ui/widgets/input_label_widget.dart';
import 'package:flutter_tareo/ui/widgets/item_configuracion_swicth_widget.dart';
import 'package:get/get.dart';

class NuevaPesadoPage extends StatelessWidget {
  final NuevaPesadoController controller = Get.find<NuevaPesadoController>();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return GetBuilder<NuevaPesadoController>(
      init: controller,
      builder: (_) => Stack(
        children: [
          Scaffold(
            appBar: getAppBar(
                controller.editando ? 'Editando Pesado' : 'Nuevo Pesado',
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
                    GetBuilder<NuevaPesadoController>(
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
                    GetBuilder<NuevaPesadoController>(
                      id: 'tipo_tarea',
                      builder: (_) => DropdownSearchWidget(
                        label: 'Tipo de tarea',
                        error: _.errorTipoTarea,
                        labelText: 'name',
                        labelValue: '_id',
                        selectedItem: _.nuevaPreTarea?.tipoTarea == null
                            ? null
                            : {
                                'name':
                                    '${_.nuevaPreTarea.tipoTarea.descripcion.trim()}',
                                '_id': _.nuevaPreTarea.tipoTarea.idtipotarea,
                              },
                        onChanged: _.changeTipoTarea,
                        items: controller.tiposTarea.length == 0
                            ? []
                            : controller.tiposTarea
                                .map((e) => {
                                      'name': '${e.descripcion.trim()}',
                                      '_id': e.idtipotarea,
                                    })
                                .toList(),
                      ),
                    ),
                    GetBuilder<NuevaPesadoController>(
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
                                    '${_.nuevaPreTarea?.centroCosto?.detallecentrocosto?.trim()} ${_.nuevaPreTarea.centroCosto?.codigoempresa}',
                                '_id':
                                    _.nuevaPreTarea.centroCosto?.idcentrocosto,
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
                    GetBuilder<NuevaPesadoController>(
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
                    GetBuilder<NuevaPesadoController>(
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
                    GetBuilder<NuevaPesadoController>(
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
                    GetBuilder<NuevaPesadoController>(
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
                    GetBuilder<NuevaPesadoController>(
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
                    GetBuilder<NuevaPesadoController>(
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
                    GetBuilder<NuevaPesadoController>(
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
                    GetBuilder<NuevaPesadoController>(
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
          GetBuilder<NuevaPesadoController>(
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
              child: GetBuilder<NuevaPesadoController>(
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
                      child: Icon(Icons.search, size: 40),
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
