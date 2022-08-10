import 'package:dropdown_below/dropdown_below.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tareo/core/colors.dart';
import 'package:flutter_tareo/core/dimens.dart';
import 'package:flutter_tareo/ui/pages/listado_cajas/listado_cajas_controller.dart';
import 'package:flutter_tareo/ui/utils/string_formats.dart';
import 'package:flutter_tareo/ui/widgets/app_bar_widget.dart';
import 'package:flutter_tareo/ui/widgets/empty_data_widget.dart';
import 'package:get/get.dart';

class ListadoCajasPage extends StatelessWidget {
  
  final ListadoCajasController controller =
      Get.find<ListadoCajasController>();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return GetBuilder<ListadoCajasController>(
      init: controller,
      id: 'personal_seleccionado',
      builder: (_) => WillPopScope(
        onWillPop: _.onWillPop,
        child: Stack(
          children: [
            Scaffold(
              appBar: getAppBar(
                  '${_.personalSeleccionado.length}',
                  [
                    IconButton(
                        onPressed: _.goLectorCode, icon: Icon(Icons.qr_code)),
                    IconButton(onPressed: () {}, icon: Icon(Icons.search)),
                  ],
                  true),
              backgroundColor: secondColor,
              body: RefreshIndicator(
                onRefresh: () async => _.update(['listado']),
                child: GetBuilder<ListadoCajasController>(
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
                        child: GetBuilder<ListadoCajasController>(
                          id: 'listado',
                          builder: (_) => _.personalSeleccionado.isEmpty
                              ? EmptyDataWidget(
                                  titulo: 'No existen cajas registradas.',
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
            ),
            GetBuilder<ListadoCajasController>(
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

    return GetBuilder<ListadoCajasController>(
      id: 'seleccionado',
      builder: (_) => GestureDetector(
        onLongPress: () => _.seleccionar(index),
        child: GetBuilder<ListadoCajasController>(
          id: 'item_$index',
          builder: (_) => Container(
            decoration: BoxDecoration(
              color:
                  (_.seleccionados.contains(index)) ? Colors.blue : secondColor,
              border: (_.seleccionados.contains(index))
                  ? Border.all()
                  : Border.all(color: Colors.transparent),
            ),
            padding: EdgeInsets.symmetric(
                vertical: size.width * 0.03, horizontal: size.width * 0.05),
            child: Container(
              height: size.height * 0.27,
              decoration: BoxDecoration(
                  color: cardColor,
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(borderRadius)),
              child: Column(
                children: [
                  Flexible(
                    child: Container(),
                    flex: 1,
                  ),
                  Flexible(
                    child: Container(
                      child: Row(
                        children: [
                          Flexible(child: Container(), flex: 1),
                          Flexible(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: Container(
                                  child: Text(_.personalSeleccionado[index].correlativo.toString()),
                                  //color: primaryColor,
                                ),
                              ),
                              flex: 3),
                          Flexible(child: Container(), flex: 1),
                          Flexible(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                formatoFecha(_.personalSeleccionado[index].fecha),
                                style: TextStyle(
                                    fontWeight: FontWeight.normal, fontSize: 14),
                              ),
                            ),
                            flex: 10,
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
                                    value: 1,
                                    items: items == null
                                        ? []
                                        : items
                                            .map((e) => DropdownMenuItem(
                                                value: e['key'],
                                                child: Text(e['value'])))
                                            .toList(),
                                    onChanged: (value) =>{}
                                        /* _.onChangedMenu(value, index) */),
                              ),
                              flex: 4),
                          Flexible(child: Container(), flex: 1),
                        ],
                      ),
                    ),
                    flex: 4,
                  ),
                  Flexible(
                    child: Container(
                      child: Row(
                        children: [
                          Flexible(child: Container(), flex: 1),
                          Flexible(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text(_.personalSeleccionado[index].cliente?.descripcion ??
                                  ''),
                            ),
                            flex: 10,
                          ),
                          Flexible(child: Container(), flex: 1),
                          Flexible(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text(_.personalSeleccionado[index].labor.descripcion ?? ''),
                            ),
                            flex: 10,
                          ),
                          Flexible(child: Container(), flex: 1),
                        ],
                      ),
                    ),
                    flex: 4,
                  ),
                  Flexible(
                    child: Container(
                      child: Row(
                        children: [
                          Flexible(child: Container(), flex: 1),
                          Flexible(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      child: Text((_
                                          .personalSeleccionado[index]?.sizeDetails ?? 0).toString()
                                          .toString())),
                                  Icon(
                                    Icons.people,
                                    color: Colors.black45,
                                  )
                                ],
                              ),
                            ),
                            flex: 10,
                          ),
                          Flexible(child: Container(), flex: 1),
                        ],
                      ),
                    ),
                    flex: 4,
                  ),
                  Flexible(child: Container(), flex: 1),
                  Flexible(
                    child: Container(
                      child: Row(
                        children: (true)
                            ? [
                                
                                Flexible(child: Container(), flex: 1),
                                Flexible(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: CircleAvatar(
                                      backgroundColor: infoColor,
                                      child: IconButton(
                                          onPressed: () async => _.goListadoDetalles(index),
                                          icon: Icon(
                                            Icons.search,
                                            color: Colors.white,
                                          )),
                                    ),
                                  ),
                                  flex: 7,
                                ),
                                Flexible(child: Container(), flex: 1),
                                Flexible(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: CircleAvatar(
                                      backgroundColor: successColor,
                                      child: IconButton(
                                        onPressed: null,
                                            // ()=> _.goAprobar(index),
                                        icon: Icon(Icons.remove_red_eye),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  flex: 7,
                                ),
                                Flexible(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: CircleAvatar(
                                      backgroundColor: dangerColor,
                                      child: IconButton(
                                        onPressed: () => _.goEliminar(
                                          _.personalSeleccionado[index].key
                                          ),
                                        icon: Icon(Icons.delete),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  flex: 7,
                                ),
                                Flexible(child: Container(), flex: 1),
                              ]
                            : [
                                Flexible(child: Container(), flex: 1),
                                Flexible(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: CircleAvatar(
                                      backgroundColor: infoColor,
                                      child: IconButton(
                                          onPressed: () {},
                                              //_.goListadoCajas(index),
                                          icon: Icon(
                                            Icons.search,
                                            color: Colors.white,
                                          )),
                                    ),
                                  ),
                                  flex: 7,
                                ),
                                Flexible(child: Container(), flex: 1),
                                Flexible(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: CircleAvatar(
                                      backgroundColor: successColor,
                                      child: IconButton(
                                        onPressed: () {},
                                            //_.goAprobar(index),
                                        icon: Icon(Icons.check_rounded),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  flex: 7,
                                ),
                                
                                Flexible(child: Container(), flex: 1),
                                Flexible(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: CircleAvatar(
                                      backgroundColor: alertColor,
                                      child: IconButton(
                                        onPressed: (){}, // => _.goEditar(index),
                                        icon: Icon(Icons.edit),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  flex: 7,
                                ),
                                Flexible(child: Container(), flex: 1),
                              ],
                      ),
                    ),
                    flex: 4,
                  ),
                  Flexible(
                    child: Container(),
                    flex: 1,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  
  }

  Widget _opcionesSeleccionados() {
    final items = [
      {'key': 1, 'value': 'Seleccionar todos'},
      {'key': 2, 'value': 'Quitar todos'},
      {'key': 3, 'value': 'Actualizar datos'},
    ];

    return GetBuilder<ListadoCajasController>(
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
