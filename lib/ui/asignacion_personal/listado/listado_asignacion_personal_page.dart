import 'package:dropdown_below/dropdown_below.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tareo/core/utils/colors.dart';
import 'package:flutter_tareo/core/utils/dimens.dart';
import 'package:flutter_tareo/core/utils/numbers.dart';
import 'package:flutter_tareo/ui/asignacion_personal/listado/listado_asignacion_personal_controller.dart';
import 'package:flutter_tareo/ui/control_asistencia/utils/ids.dart';
import 'package:flutter_tareo/ui/control_asistencia/utils/strings.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:flutter_tareo/ui/utils/string_formats.dart';
import 'package:flutter_tareo/ui/widgets/app_bar_widget.dart';
import 'package:flutter_tareo/ui/widgets/empty_data_widget.dart';
import 'package:get/get.dart';

class ListadoAsignacionPersonalPage extends StatelessWidget {
  final ListadoAsignacionPersonalController controller =
      Get.find<ListadoAsignacionPersonalController>();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return GetBuilder<ListadoAsignacionPersonalController>(
      init: controller,
      id: PERSONAL_SELECCIONADO_ID,
      builder: (_) => WillPopScope(
        onWillPop: _.onWillPop,
        child: Stack(
          children: [
            Scaffold(
              appBar: getAppBarWidget(
                  GetBuilder<ListadoAsignacionPersonalController>(
                    id: CONTADOR_ID,
                    builder: (_) => Text(
                      '${_.registrosSeleccionados.length}',
                      style: TextStyle(
                          fontSize: 17,
                          color: PreferenciasUsuario().modoDark
                              ? Colors.white
                              : Colors.black),
                    ),
                  ),
                  [
                    IconButton(
                        onPressed: _.goLectorCode, icon: Icon(Icons.qr_code))
                  ],
                  BOOLEAN_TRUE_VALUE),
              backgroundColor: secondColor,
              body: RefreshIndicator(
                onRefresh: _.getDetalles,
                child: GetBuilder<ListadoAsignacionPersonalController>(
                  id: SELECCIONADO_ID,
                  builder: (_) => Column(
                    children: [
                      if (_.seleccionados.length > 0)
                        Flexible(
                          flex: 1,
                          child: AnimatedContainer(
                              child: _opcionesSeleccionados(),
                              duration: Duration(seconds: 1)),
                        ),
                      Flexible(
                        flex: 8,
                        child: GetBuilder<ListadoAsignacionPersonalController>(
                          id: LISTADO_ASISTENCIA_REGISTRO_ID,
                          builder: (_) => _.registrosSeleccionados.isEmpty
                              ? EmptyDataWidget(
                                  titulo: EMPTY_REGISTROS_ASIGNACION_STRING,
                                  onPressed: _.getDetalles,
                                  size: size)
                              : ListView.builder(
                                  itemCount: _.registrosSeleccionados.length,
                                  itemBuilder: (BuildContext context,
                                          int index) =>
                                      GetBuilder<
                                              ListadoAsignacionPersonalController>(
                                          id:
                                              '${LISTADO_ASISTENCIA_REGISTRO_ID}_${_.registrosSeleccionados[index].getId}',
                                          builder: (_) => itemActividad(
                                              size, context, index)),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            GetBuilder<ListadoAsignacionPersonalController>(
              id: VALIDANDO_ID,
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

  Widget itemActividad(Size size, context, index) {
    final items = [
      {'key': 2, 'value': 'Eliminar'},
    ];

    return GetBuilder<ListadoAsignacionPersonalController>(
        id: SELECCIONADO_ID,
        builder: (_) => GestureDetector(
              onLongPress: _.seleccionados.length > 0
                  ? null
                  : () => _.seleccionar(index),
              onTap: _.seleccionados.length > 0
                  ? () => _.seleccionar(index)
                  : null,
              child: Container(
                decoration: BoxDecoration(
                  color: (_.seleccionados.contains(index))
                      ? Colors.blue
                      : secondColor,
                  border: (_.seleccionados.contains(index))
                      ? Border.all()
                      : Border.all(color: Colors.transparent),
                ),
                padding: EdgeInsets.all(size.width * 0.05),
                child: Container(
                  height: size.height * 0.2,
                  decoration: BoxDecoration(
                      color: cardColor,
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(borderRadius)),
                  child: Column(
                    children: [
                      Flexible(
                        child: Container(
                          child: Row(
                            children: [
                              Flexible(child: Container(), flex: 1),
                              Flexible(
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(_.registrosSeleccionados[index]
                                          .codigoempresa ??
                                      ''),
                                ),
                                flex: 10,
                              ),
                              Flexible(child: Container(), flex: 1),
                              Flexible(
                                child: Container(
                                  child: Text(formatoFecha(_
                                          .registrosSeleccionados[index]
                                          .fecha) ??
                                      '-Sin fecha-'),
                                ),
                                flex: 20,
                              ),
                              Flexible(child: Container(), flex: 1),
                              Flexible(
                                  child: Container(
                                    child: DropdownBelow(
                                      itemWidth: 200,
                                      itemTextstyle: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black),
                                      boxTextstyle: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: cardColor),
                                      boxPadding:
                                          EdgeInsets.fromLTRB(13, 12, 0, 12),
                                      boxHeight: 45,
                                      boxWidth: 150,
                                      icon: Icon(
                                        Icons.more_horiz,
                                        color: primaryColor,
                                      ),
                                      value: 2,
                                      items: items == null
                                          ? []
                                          : items
                                              .map((e) => DropdownMenuItem(
                                                  value: e['key'],
                                                  child: Text(e['value'])))
                                              .toList(),
                                      onChanged: (value) => _.changeOptions(
                                          value,
                                          _.registrosSeleccionados[index]
                                              .getId),
                                    ),
                                  ),
                                  flex: 5),
                              Flexible(child: Container(), flex: 1),
                            ],
                          ),
                        ),
                        flex: 1,
                      ),
                      Flexible(
                        child: Container(
                          child: Row(
                            children: [
                              Flexible(child: Container(), flex: 1),
                              Flexible(
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                      'Linea : ${_.registrosSeleccionados[index].linea}'),
                                ),
                                flex: 10,
                              ),
                              Flexible(child: Container(), flex: 1),
                              Flexible(
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                      'Mesa : ${_.registrosSeleccionados[index].grupo}'),
                                ),
                                flex: 10,
                              ),
                              Flexible(child: Container(), flex: 1),
                            ],
                          ),
                        ),
                        flex: 1,
                      ),
                      Flexible(
                        child: Container(
                          child: Row(
                            children: [
                              Expanded(child: Container(), flex: 1),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                      (_.registrosSeleccionados.length - index)
                                          .toString()),
                                ),
                                flex: 2,
                              ),
                              Expanded(
                                child: Container(
                                  child: Text(
                                    _.registrosSeleccionados[index].personal
                                            ?.nombreCompleto ??
                                        '-sin nombre-',
                                    style: TextStyle(
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                ),
                                flex: 12,
                              ),
                              Expanded(child: Container(), flex: 1),
                            ],
                          ),
                        ),
                        flex: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }

  Widget _opcionesSeleccionados() {
    final items = [
      {'key': 1, 'value': 'Seleccionar todos'},
      {'key': 2, 'value': 'Quitar todos'},
      {'key': 3, 'value': 'Eliminar'},
    ];

    return GetBuilder<ListadoAsignacionPersonalController>(
      id: SELECCIONADO_ID,
      builder: (_) => Container(
        decoration: BoxDecoration(color: Colors.white, border: Border.all()),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Flexible(child: Container(), flex: 1),
            Flexible(
              child: Container(
                child: Text(
                  '${_.seleccionados.length} seleccionados',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
              flex: 12,
            ),
            Flexible(child: Container(), flex: 6),
            Flexible(
              child: Container(
                alignment: Alignment.center,
                child: DropdownBelow(
                  itemWidth: 200,
                  itemTextstyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.black),
                  boxTextstyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: cardColor),
                  boxPadding: EdgeInsets.fromLTRB(13, 12, 0, 12),
                  boxHeight: 45,
                  boxWidth: 150,
                  icon: Icon(
                    Icons.more_horiz,
                    color: primaryColor,
                  ),
                  value: 1,
                  items: items == null
                      ? []
                      : items
                          .map((e) => DropdownMenuItem(
                              value: e['key'], child: Text(e['value'])))
                          .toList(),
                  onChanged: _.changeOptionsGlobal,
                ),
              ),
              flex: 4,
            ),
            Flexible(child: Container(), flex: 1),
          ],
        ),
      ),
    );
  }
}
