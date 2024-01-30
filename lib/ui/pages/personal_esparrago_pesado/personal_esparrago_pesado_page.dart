import 'package:dropdown_below/dropdown_below.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tareo/core/utils/colors.dart';
import 'package:flutter_tareo/core/utils/dimens.dart';
import 'package:flutter_tareo/core/utils/numbers.dart';
import 'package:flutter_tareo/ui/pages/personal_esparrago_pesado/personal_esparrago_pesado_controller.dart';
import 'package:flutter_tareo/ui/utils/string_formats.dart';
import 'package:flutter_tareo/ui/widgets/app_bar_widget.dart';
import 'package:flutter_tareo/ui/widgets/empty_data_widget.dart';
import 'package:get/get.dart';

class PersonalEsparragoPesadoPage extends StatelessWidget {
  final PersonalEsparragoPesadoController controller =
      Get.find<PersonalEsparragoPesadoController>();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return GetBuilder<PersonalEsparragoPesadoController>(
      init: controller,
      id: 'personal_seleccionado',
      builder: (_) => WillPopScope(
        onWillPop: _.onWillPop,
        child: Stack(
          children: [
            Scaffold(
              appBar: getAppBar(
                  'L${_.mesaSelected.linea}M${_.mesaSelected.grupo}: ${_.personalSeleccionado.length ?? 0}',
                  [
                    IconButton(
                        onPressed: () async => _.goLectorCode(),
                        icon: Icon(Icons.qr_code)),
                  ],
                  BOOLEAN_TRUE_VALUE),
              backgroundColor: secondColor,
              body: RefreshIndicator(
                onRefresh: () async => _.update(['listado']),
                child: GetBuilder<PersonalEsparragoPesadoController>(
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
                        child: GetBuilder<PersonalEsparragoPesadoController>(
                          id: 'listado',
                          builder: (_) => _.personalSeleccionado.isEmpty
                              ? EmptyDataWidget(
                                  titulo: 'No existe equipo asociado.',
                                  onPressed: () => _.update(['listado']),
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
              /* floatingActionButton: FloatingActionButton(
                child: IconButton(
                    onPressed: _.goNuevoPersonaTareaProceso,
                    icon: Icon(Icons.add)),
              ), */
            ),
            GetBuilder<PersonalEsparragoPesadoController>(
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
      /* {'key': 1, 'value': 'Editar'}, */
      {'key': 2, 'value': 'Eliminar'},
    ];

    return GetBuilder<PersonalEsparragoPesadoController>(
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
                  child: ((_.personalSeleccionado[index]?.esperandoCierre ??
                              BOOLEAN_TRUE_VALUE) &&
                          _.personalSeleccionado[index].codigotkmesa == null)
                      ? Column(
                          children: [
                            Expanded(
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  child: IconButton(
                                      onPressed: () async =>
                                          _.goCancelarEsperando(index),
                                      icon: Icon(Icons.close,
                                          color: dangerColor)),
                                ),
                                flex: 1),
                            Expanded(
                                child: Container(
                                    child: CircularProgressIndicator()),
                                flex: 2),
                            Expanded(child: Container(), flex: 1),
                            Expanded(
                                child: Container(
                                    child: Text(
                                  'Esperando etiqueta de cierre...',
                                  style: TextStyle(
                                      color: Colors.black45, fontSize: 12),
                                )),
                                flex: 1),
                            Expanded(child: Container(), flex: 1),
                          ],
                        )
                      : Column(
                          children: [
                            Flexible(
                              child: Container(
                                child: Row(
                                  children: [
                                    Flexible(child: Container(), flex: 1),
                                    Flexible(
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text('${index + 1}'),
                                      ),
                                      flex: 5,
                                    ),
                                    Flexible(child: Container(), flex: 1),
                                    Flexible(
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(_
                                                .personalSeleccionado[index]
                                                .labor
                                                ?.descripcion ??
                                            'Sin descripción'),
                                      ),
                                      flex: 25,
                                    ),
                                    Flexible(child: Container(), flex: 1),
                                    if (_.preTarea?.estadoLocal != 'A')
                                      Flexible(
                                          child: Container(
                                            child: _.seleccionados.length > 0
                                                ? Container()
                                                : DropdownBelow(
                                                    itemWidth: 200,
                                                    itemTextstyle: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.black),
                                                    boxTextstyle: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: cardColor),
                                                    boxPadding:
                                                        EdgeInsets.fromLTRB(
                                                            13, 12, 0, 12),
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
                                                            .map((e) =>
                                                                DropdownMenuItem(
                                                                    value: e[
                                                                        'key'],
                                                                    child: Text(
                                                                        e['value'])))
                                                            .toList(),
                                                    onChanged: (value) =>
                                                        _.changeOptions(
                                                            value,
                                                            _
                                                                .personalSeleccionado[
                                                                    index]
                                                                .key),
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
                                        child: Text(_
                                                .personalSeleccionado[index]
                                                .cliente
                                                ?.descripcion ??
                                            'Sin nombre'),
                                      ),
                                      flex: 10,
                                    ),
                                    Flexible(child: Container(), flex: 1),
                                    Flexible(
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                            formatoHora(_
                                                    .personalSeleccionado[index]
                                                    .hora) ??
                                                '-Sin hora-',
                                            style: TextStyle(
                                                color:
                                                    (_.personalSeleccionado[index]
                                                                .hora ==
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
                                        child: Text(
                                            'M-${_.personalSeleccionado[index].mesa}'),
                                      ),
                                      flex: 4,
                                    ),
                                    Expanded(child: Container(), flex: 1),
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                            'L-${_.personalSeleccionado[index].linea}'),
                                      ),
                                      flex: 4,
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

    return GetBuilder<PersonalEsparragoPesadoController>(
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
            if (_.preTarea?.estadoLocal != 'A')
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