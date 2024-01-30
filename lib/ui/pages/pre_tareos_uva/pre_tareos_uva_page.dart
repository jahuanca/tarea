import 'package:dropdown_below/dropdown_below.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tareo/core/utils/colors.dart';
import 'package:flutter_tareo/core/utils/dimens.dart';
import 'package:flutter_tareo/ui/control_asistencia/utils/ids.dart';
import 'package:flutter_tareo/ui/pages/pre_tareos_uva/pre_tareos_uva_controller.dart';
import 'package:flutter_tareo/ui/utils/constants.dart';
import 'package:flutter_tareo/ui/widgets/empty_data_widget.dart';
import 'package:get/get.dart';

class PreTareosUvaPage extends StatelessWidget {
  final PreTareosUvaController controller = PreTareosUvaController(Get.find(),
      Get.find(), Get.find(), Get.find(), Get.find(), Get.find(), Get.find());

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return GetBuilder<PreTareosUvaController>(
      init: controller,
      id: ALL_PAGE_ID,
      builder: (_) => Stack(
        children: [
          Scaffold(
            backgroundColor: secondColor,
            body: GetBuilder<PreTareosUvaController>(
              id: EVENT_CHOOSE_ELEMENT_ID,
              builder: (_) => Column(
                children: [
                  if (_.seleccionados.length > EMPTY_ARRAY_LENGTH)
                    Expanded(
                      flex: 1,
                      child: AnimatedContainer(
                          child: _opcionesSeleccionados(),
                          duration: Duration(seconds: 1)),
                    ),
                  Expanded(
                    flex: 8,
                    child: RefreshIndicator(
                      onRefresh: () async => _.getTareas(),
                      child: GetBuilder<PreTareosUvaController>(
                        id: ALL_LIST_ID,
                        builder: (_) => _.preTareosUva.isEmpty
                            ? EmptyDataWidget(
                                titulo: 'No existen actividades.',
                                size: size,
                                onPressed: _.getTareas)
                            : ListView.builder(
                                itemCount: _.preTareosUva.length,
                                itemBuilder:
                                    (BuildContext context, int index) =>
                                        itemActividad(size, context, index),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: _.goNuevaPreTarea,
              child: Icon(Icons.add),
            ),
          ),
          GetBuilder<PreTareosUvaController>(
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
    );
  }

  Widget itemActividad(Size size, BuildContext context, int index) {
    final items = [
      {'key': 1, 'value': 'Sincronizar'},
      {'key': 3, 'value': 'Eliminar'},
      {'key': 4, 'value': 'Exportar a EXCEL'},
    ];

    return GetBuilder<PreTareosUvaController>(
      id: '$ELEMENT_OF_LIST_ID${controller.preTareosUva[index].key}',
      builder: (_) => GestureDetector(
        onLongPress: () => _.seleccionar(index),
        child: Container(
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
                                color: _.preTareosUva[index].colorEstado,
                              ),
                            ),
                            flex: 1),
                        Flexible(child: Container(), flex: 1),
                        Flexible(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              _.preTareosUva[index].fechaHora,
                              style: TextStyle(
                                  fontWeight: FontWeight.normal, fontSize: 14),
                            ),
                          ),
                          flex: 10,
                        ),
                        Flexible(child: Container(), flex: 1),
                        Flexible(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              _.preTareosUva[index]?.cultivo?.detallecultivo ??
                                  EMPTY_STRING,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          flex: 15,
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
                                  onChanged: (value) async => _.onChangedMenu(
                                      value, _.preTareosUva[index].key)),
                            ),
                            flex: 5),
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
                            child: Text(_.preTareosUva[index].centroCosto
                                    ?.detallecentrocosto ??
                                EMPTY_STRING),
                          ),
                          flex: 20,
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
                                    child: Text(
                                        (_.preTareosUva[index].sizeDetails ??
                                                EMPTY_ARRAY_LENGTH)
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
                        Flexible(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(_.preTareosUva[index].sede
                                    ?.detallesubdivision ??
                                EMPTY_STRING),
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
                      children: (_.preTareosUva[index].estadoLocal != 'P' &&
                              _.preTareosUva[index].estadoLocal != 'PC')
                          ? [
                              Flexible(child: Container(), flex: 1),
                              if (_.preTareosUva[index].estadoLocal != 'M')
                                Flexible(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: CircleAvatar(
                                      backgroundColor: infoColor,
                                      child: IconButton(
                                          onPressed: () => _.goMigrar(
                                              _.preTareosUva[index].key),
                                          icon: Icon(
                                            Icons.sync,
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
                                          _.preTareosUva[index].key),
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
                                        onPressed: () => _.goListadoPersonas(
                                            _.preTareosUva[index].key),
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
                                      onPressed: () => _
                                          .goAprobar(_.preTareosUva[index].key),
                                      icon: Icon(Icons.check_rounded),
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                flex: 7,
                              ),
                              if (_.preTareosUva[index].estadoLocal == 'PC')
                                Flexible(child: Container(), flex: 1),
                              if (_.preTareosUva[index].estadoLocal == 'PC')
                                Flexible(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: CircleAvatar(
                                      backgroundColor: alertColor,
                                      child: IconButton(
                                        onPressed: () => _.goEditar(
                                          _.preTareosUva[index].key,
                                        ),
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
    );
  }

  Widget _opcionesSeleccionados() {
    final items = [
      {'key': 1, 'value': 'Seleccionar todos'},
      {'key': 2, 'value': 'Quitar todos'},
      {'key': 3, 'value': 'Exportar en excel'},
    ];

    return GetBuilder<PreTareosUvaController>(
      id: EVENT_CHOOSE_ELEMENT_ID,
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
                  onChanged: (value) {},
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
