import 'package:dropdown_below/dropdown_below.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tareo/core/utils/colors.dart';
import 'package:flutter_tareo/core/utils/dimens.dart';
import 'package:flutter_tareo/core/utils/numbers.dart';
import 'package:flutter_tareo/ui/control_asistencia/utils/ids.dart';
import 'package:flutter_tareo/ui/packing/home_packing/extension_packing.dart';
import 'package:flutter_tareo/ui/packing/home_packing/home_packing_controller.dart';
import 'package:flutter_tareo/ui/utils/constants.dart';
import 'package:flutter_tareo/ui/widgets/empty_data_widget.dart';
import 'package:get/get.dart';

class HomePackingPage extends StatelessWidget {
  final HomePackingController controller = HomePackingController(Get.find(),
      Get.find(), Get.find(), Get.find(), Get.find(), Get.find(), Get.find());

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return GetBuilder<HomePackingController>(
      init: controller,
      id: ALL_PAGE_ID,
      builder: (_) => Stack(
        children: [
          Scaffold(
            backgroundColor: secondColor,
            body: GetBuilder<HomePackingController>(
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
                      child: GetBuilder<HomePackingController>(
                        id: ALL_LIST_ID,
                        builder: (_) => _.packings.isEmpty
                            ? EmptyDataWidget(
                                titulo: 'No existen actividades.',
                                size: size,
                                onPressed: _.getTareas)
                            : ListView.builder(
                                itemCount: _.packings.length,
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
          GetBuilder<HomePackingController>(
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
    final items = ExtensionHomePacking().getItemsSingle(index, controller);

    return GetBuilder<HomePackingController>(
      id: '$ELEMENT_OF_LIST_ID${controller.packings[index].getId}',
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
                                color: _.packings[index].colorEstado,
                              ),
                            ),
                            flex: 1),
                        Flexible(child: Container(), flex: 1),
                        Flexible(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              _.packings[index].fechaHora,
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
                              _.packings[index]?.cultivo?.detallecultivo ??
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
                                  value: items.first['key'],
                                  items: items == null
                                      ? []
                                      : items
                                          .where((e) => e['isShow'])
                                          .toList()
                                          .map((e) => DropdownMenuItem(
                                              value: e['key'],
                                              child: Text(e['value'])))
                                          .toList(),
                                  onChanged: (value) async => _.onChangedMenu(
                                      value, _.packings[index].getId)),
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
                            child: Text(_.packings[index].centroCosto
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
                                        (_.packings[index].sizeDetails ??
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
                            child: Text(
                                _.packings[index].sede?.detallesubdivision ??
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
                    children: ExtensionHomePacking().getActions(index, _),
                  )),
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
    final itemsGenerals = ExtensionHomePacking().getItemsGenerals();

    return GetBuilder<HomePackingController>(
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
                child: itemsGenerals.isBlank
                    ? Container()
                    : DropdownBelow(
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
                        value: itemsGenerals.first['key'],
                        items: itemsGenerals == null
                            ? []
                            : itemsGenerals
                                .where((e) => e['isShow'] == BOOLEAN_TRUE_VALUE)
                                .toList()
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
