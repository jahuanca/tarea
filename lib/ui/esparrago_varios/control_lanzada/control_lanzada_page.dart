import 'package:awesome_select/awesome_select.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tareo/core/utils/colors.dart';
import 'package:flutter_tareo/core/utils/dimens.dart';
import 'package:flutter_tareo/core/utils/numbers.dart';
import 'package:flutter_tareo/ui/control_asistencia/utils/ids.dart';
import 'package:flutter_tareo/ui/esparrago_varios/control_lanzada/control_lanzada_controller.dart';
import 'package:flutter_tareo/ui/utils/constants.dart';
import 'package:flutter_tareo/ui/utils/string_formats.dart';
import 'package:flutter_tareo/ui/widgets/app_bar_widget.dart';
import 'package:flutter_tareo/ui/widgets/date_picker_widget.dart';
import 'package:get/get.dart';

class ControlLanzadaPage extends StatelessWidget {
  final ControlLanzadaController controller =
      Get.find<ControlLanzadaController>();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return GetBuilder<ControlLanzadaController>(
        init: controller,
        builder: (_) => Stack(
              children: [
                Scaffold(
                  appBar: getAppBar('Elegir grupo', []),
                  backgroundColor: secondColor,
                  body: Column(
                    children: [
                      Expanded(
                        flex: 8,
                        child: RefreshIndicator(
                          onRefresh: _.getListadoDia,
                          child: GetBuilder<ControlLanzadaController>(
                            id: 'listado',
                            builder: (_) => ListView.builder(
                              itemCount: _.currentList.length + 1,
                              itemBuilder: (BuildContext context, int index) =>
                                  (index == 0)
                                      ? itemBusqueda(size, context)
                                      : itemActividad(size, context, index - 1),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                GetBuilder<ControlLanzadaController>(
                  id: VALIDANDO_ID,
                  builder: (_) => _.validando
                      ? Container(
                          color: Colors.black45,
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : Container(),
                ),
              ],
            ));
  }

  Widget itemBusqueda(Size size, BuildContext context) {
    return Column(
      children: [
        Container(
          width: size.width,
          height: size.height * 0.09,
          child: Row(
            children: [
              Flexible(
                  child: GetBuilder<ControlLanzadaController>(
                id: 'fecha',
                builder: (_) => GestureDetector(
                    onTap: () async {
                      await DatePickerWidget(
                        onlyDate: BOOLEAN_TRUE_VALUE,
                        minDate: DateTime.now().subtract(Duration(days: 10)),
                        dateSelected: _.fecha ?? DateTime.now(),
                        onChanged: () {},
                      )
                          .selectDate(context)
                          .then((value) => _.changeFecha(value));
                    },
                    child: _item('', formatoFechaExplore(_.fecha, 0, 0), size)),
              )),
              Flexible(
                  child: smartSelect(
                idWidget: 'turnos',
                modalTitle: 'Turnos:',
                size: size,
                title: '',
                items: TURNOS_ARRAY,
                valueSelected: controller.turnoSelected,
              )),
              Flexible(
                  child: GetBuilder<ControlLanzadaController>(
                      id: 'lineas',
                      builder: (_) => _.lineas.isEmpty
                          ? Container()
                          : smartSelect(
                              idWidget: 'lineas',
                              modalTitle: 'Lineas:',
                              size: size,
                              title: 'Lin:',
                              items: _.lineas.map((e) => e.toJson()).toList(),
                              valueSelected: _.lineaSelected?.toJson(),
                              labelName: 'linea',
                              labelValue: 'itemagruparpersonal'))),
              Flexible(
                  child: GetBuilder<ControlLanzadaController>(
                      id: 'mesas',
                      builder: (_) =>
                          _.mesas.isBlank ? Container() : Container()))
              /*: smartSelect(
                              idWidget: 'mesas',
  modalTitle: 'Mesas:',
                              size: size,
                              title: 'Mesa:',
                              items: _.mesas.map((e) => e.toJson()).toList(),
                              valueSelected: _.mesaSelected?.toJson(),
                              labelName: 'grupo',
                              labelValue: 'itemagruparpersonal'))),*/
            ],
          ),
        ),
        if (controller.currentList.isEmpty)
          Container(
            width: size.width,
            height: size.height * 0.6,
            child: Container(
              alignment: Alignment.center,
              child: Text('No existen lineas.'),
            ),
          )
      ],
    );
  }

  Widget smartSelect({
    Size size,
    String title,
    List items,
    Map<String, dynamic> valueSelected,
    String labelName = 'name',
    String labelValue = '_id',
    String idWidget,
    String modalTitle,
  }) {
    return Container(
      child: SmartSelect<String>.single(
        modalTitle: modalTitle,
        builder: S2SingleBuilder<String>(
            tile: (context, value) => Container(
                child: GestureDetector(
                    onTap: value.resolveChoices,
                    child: GestureDetector(
                      onTap: value.showModal,
                      child: _item(
                          value.title,
                          valueSelected != null
                              ? '${valueSelected[labelName]}' == '-1'
                                  ? 'Todas'
                                  : '${valueSelected[labelName]}'
                              : controller.empty.first['_id'],
                          size),
                    )))),
        selectedValue: valueSelected != null
            ? '${valueSelected[labelValue]}'
            : '${controller.empty.first['_id']}',
        title: title,
        placeholder: 'Elige una fecha',
        modalType: S2ModalType.bottomSheet,
        choiceItems: items.isBlank
            ? controller.empty
                .map((e) => S2Choice<String>(value: e['_id'], title: e['name']))
                .toList()
            : items
                .map((e) => S2Choice<String>(
                      value: '${e[labelValue]}',
                      title: '${e[labelName]}' == '-1'
                          ? 'Todas'
                          : '${e[labelName]}',
                    ))
                .toList(),
        onChange: (val) => controller.changeValue(idWidget, val.value),
      ),
    );
  }

  Widget _item(String text, String value, Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            color: white,
            border: Border.all(width: 0.4)),
        alignment: Alignment.center,
        height: size.height * 0.07,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
            Text(
              ' $value',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget itemActividad(Size size, BuildContext context, int index) {
    final flexSpaceItem = 6;
    return GetBuilder<ControlLanzadaController>(
      id: SELECCIONADO_ID,
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: secondColor,
          border: Border.all(color: Colors.transparent),
        ),
        padding: EdgeInsets.symmetric(
            vertical: size.width * 0.03, horizontal: size.width * 0.05),
        child: GestureDetector(
          //onTap: () => _.goListadoPersonasPreTareaEsparrago(index),
          child: Container(
            height: size.height * 0.17,
            decoration: BoxDecoration(
                color: cardColor,
                border: Border.all(width: 0.5),
                borderRadius: BorderRadius.circular(borderRadius)),
            child: Column(
              children: [
                Flexible(
                    flex: 2,
                    child: Container(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                          '      Lin: ${_.currentList[index].linea} - Mesa: ${_.currentList[index].grupo}'),
                    )),
                Flexible(
                  flex: 4,
                  child: Container(
                    child: Row(
                      children: [
                        Flexible(
                          child: Container(),
                          flex: 1,
                        ),
                        Flexible(
                          child: Container(
                            child: Row(
                              children: [
                                Flexible(
                                    child: Container(
                                  alignment: Alignment.center,
                                  child: Icon(_.currentList[index].turno == 'D'
                                      ? Icons.wb_sunny_outlined
                                      : Icons.nightlight_outlined),
                                )),
                              ],
                            ),
                          ),
                          flex: flexSpaceItem,
                        ),
                        Flexible(
                          child: Container(),
                          flex: 1,
                        ),
                        Flexible(
                          child: Container(
                            child: Row(
                              children: [
                                Container(
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.people_outline,
                                      ),
                                      Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: Text((_.currentList[index]
                                                      .sizePersonalMesa ??
                                                  0)
                                              .toString())),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          flex: flexSpaceItem,
                        ),
                        Flexible(
                          child: Container(),
                          flex: 1,
                        ),
                        Flexible(
                          child: Container(
                            child: Row(
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.check,
                                        color: successColor,
                                      ),
                                      Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: Text((_.currentList[index]
                                                      .sizeDetails ??
                                                  0)
                                              .toString())),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          flex: flexSpaceItem,
                        ),
                        Flexible(
                          child: CircleAvatar(
                            child: IconButton(
                              onPressed: () =>
                                  _.goListadoPersonasPreTareaEsparrago(index),
                              icon: Icon(
                                Icons.qr_code_2_outlined,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          //child: Container(),
                          flex: flexSpaceItem,
                        ),
                        Flexible(
                          child: Container(),
                          flex: 2,
                        ),
                        Flexible(
                          child: CircleAvatar(
                            backgroundColor: alertColor,
                            child: IconButton(
                              onPressed: () => _.goReporteLanzada(index),
                              icon: Icon(
                                Icons.analytics,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          flex: flexSpaceItem,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
