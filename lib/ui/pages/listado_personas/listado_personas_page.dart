import 'package:dropdown_below/dropdown_below.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tareo/core/colors.dart';
import 'package:flutter_tareo/core/dimens.dart';
import 'package:flutter_tareo/ui/pages/listado_personas/listado_personas_controller.dart';
import 'package:flutter_tareo/ui/utils/string_formats.dart';
import 'package:flutter_tareo/ui/widgets/app_bar_widget.dart';
import 'package:flutter_tareo/ui/widgets/empty_data_widget.dart';
import 'package:get/get.dart';

class ListadoPersonasPage extends StatelessWidget {
  final ListadoPersonasController controller =
      Get.find<ListadoPersonasController>();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return GetBuilder<ListadoPersonasController>(
      init: controller,
      id: 'personal_seleccionado',
      builder: (_) => WillPopScope(
        onWillPop:  () async{
            /* _.onWillPop(); */
            Navigator.pop(Get.overlayContext, _.personalSeleccionado.length);
            return new Future(() => false);
        } ,
        child: Stack(
          children: [
            Scaffold(
              appBar: getAppBar(
                  '${_.personalSeleccionado.length}',
                  [
                    IconButton(
                        onPressed: _.goLectorCode, icon: Icon(Icons.qr_code)),
                    //IconButton(onPressed: () {}, icon: Icon(Icons.search)),
                  ],
                  true),
              backgroundColor: secondColor,
              body: RefreshIndicator(
                onRefresh: () async => _.getPersonal,
                child: GetBuilder<ListadoPersonasController>(
                  id: 'seleccionado',
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
                        child: GetBuilder<ListadoPersonasController>(
                          id: 'listado',
                          builder: (_) => _.personalSeleccionado.isEmpty
                              ? EmptyDataWidget(
                                  titulo: 'No existe equipo asociado.',
                                  onPressed: () async=> _.getPersonal,
                                  size: size)
                              : ListView.builder(
                                  itemCount: _.personalSeleccionado.length,
                                  itemBuilder:
                                      (BuildContext context, int index) =>
                                          itemActividad(size, context, index),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: _.goNuevoPersonaTareaProceso,
                child: Icon(Icons.add),
              ),
            ),
            GetBuilder<ListadoPersonasController>(
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

  Widget itemActividad(Size size, context, index) {
    final items = [
      {'key': 1, 'value': 'Editar'},
      {'key': 2, 'value': 'Eliminar'},
    ];

    return GetBuilder<ListadoPersonasController>(
        id: 'seleccionado',
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
                                  child: Text(_.personalSeleccionado[index]
                                          .personal?.nrodocumento ??
                                      ''),
                                ),
                                flex: 10,
                              ),
                              Flexible(child: Container(), flex: 1),
                              Flexible(
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(_.personalSeleccionado[index]
                                          .personal?.nombreCompleto ??
                                      ''),
                                ),
                                flex: 25,
                              ),
                              Flexible(child: Container(), flex: 1),
                              Flexible(
                                  child: Container(
                                    child: _.seleccionados.length>0 ? Container() : DropdownBelow(
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
                                      value: 1,
                                      items: items == null
                                          ? []
                                          : items
                                              .map((e) => DropdownMenuItem(
                                                  value: e['key'],
                                                  child: Text(e['value'])))
                                              .toList(),
                                      onChanged: (value) => _.changeOptions(value, _.personalSeleccionado[index].key),
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
                                  child: Text(toHorasMinutos(_.personalSeleccionado[index].cantidadHoras ?? 0)),
                                ),
                                flex: 10,
                              ),
                              Flexible(child: Container(), flex: 1),
                              Flexible(
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                      formatoFechaOnlyHoras(
                                            _.personalSeleccionado[index]
                                                .horainicio,
                                            _.personalSeleccionado[index]
                                                .horafin,
                                          ) ??
                                          '-Sin horas-',
                                      style: TextStyle(
                                          color: (_.personalSeleccionado[index]
                                                          .horainicio ==
                                                      null ||
                                                  _.personalSeleccionado[index]
                                                          .horafin ==
                                                      null)
                                              ? dangerColor
                                              : Colors.black87)),
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
                                  child: Text('PAUSA:'),
                                ),
                                flex: 4,
                              ),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    (formatoFechaOnlyHoras(
                                          _.personalSeleccionado[index]
                                              .pausainicio,
                                          _.personalSeleccionado[index]
                                              .pausafin,
                                        ) ??
                                        '-Sin pausas-'),
                                    style: TextStyle(
                                        color: (_.personalSeleccionado[index]
                                                        .pausainicio ==
                                                    null ||
                                                _.personalSeleccionado[index]
                                                        .pausainicio ==
                                                    null)
                                            ? Colors.grey
                                            : Colors.black87),
                                  ),
                                ),
                                flex: 8,
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
      {'key': 3, 'value': 'Actualizar datos'},
    ];

    return GetBuilder<ListadoPersonasController>(
      id: 'seleccionado',
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
