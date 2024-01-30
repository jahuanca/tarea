import 'package:awesome_select/awesome_select.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tareo/core/utils/colors.dart';
import 'package:flutter_tareo/core/utils/dimens.dart';
import 'package:flutter_tareo/ui/control_asistencia/utils/ids.dart';
import 'package:flutter_tareo/ui/esparrago_varios/resumen_lanzada/control_lanzada_controller.dart';
import 'package:flutter_tareo/ui/utils/constants.dart';
import 'package:flutter_tareo/ui/utils/string_formats.dart';
import 'package:flutter_tareo/ui/widgets/app_bar_widget.dart';
import 'package:flutter_tareo/ui/widgets/date_picker_widget.dart';
import 'package:flutter_tareo/ui/widgets/empty_data_widget.dart';
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
                  appBar: getAppBar('Reporte', []),
                  body: Column(
                    children: [
                      Expanded(
                        flex: 8,
                        child: RefreshIndicator(
                          onRefresh: _.getResumenMesaLinea,
                          child: GetBuilder<ControlLanzadaController>(
                            id: 'listado',
                            builder: (_) => _.listado.isEmpty
                                ? EmptyDataWidget(
                                    titulo: 'No existen valores por mostrar.',
                                    size: size,
                                    onPressed: _.getResumenMesaLinea)
                                : ListView.builder(
                                    itemCount: _.listado.length + 1,
                                    itemBuilder:
                                        (BuildContext context, int index) =>
                                            (index == 0)
                                                ? itemBusqueda(size, context)
                                                : itemActividad(
                                                    size, context, index - 1),
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
    return Container(
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
                    onlyDate: true,
                    minDate: DateTime.now().subtract(Duration(days: 10)),
                    dateSelected: _.fecha ?? DateTime.now(),
                    onChanged: () {},
                  ).selectDate(context).then((value) => _.changeFecha(value));
                },
                child: _item('', formatoFechaExplore(_.fecha, 0, 0), size)),
          )),
          Flexible(
              child: smartSelect(
                  size, '', TURNOS_ARRAY, controller.turnoSelected['_id'])),
          Flexible(
              child: GetBuilder<ControlLanzadaController>(
                  id: 'lineas',
                  builder: (_) => smartSelect(
                      size, 'Lin:', _.lineas, _.lineaSelected?.linea))),
          Flexible(
              child: GetBuilder<ControlLanzadaController>(
                  id: 'mesas',
                  builder: (_) => smartSelect(
                      size, 'Mesa:', _.mesas, _.mesaSelected?.mesa))),
        ],
      ),
    );
  }

  Widget smartSelect(
      Size size, String title, List items, String valueSelected) {
    return Container(
      child: SmartSelect<String>.single(
        builder: S2SingleBuilder<String>(
            tile: (context, value) => Container(
                child: GestureDetector(
                    onTap: value.resolveChoices,
                    child: GestureDetector(
                      onTap: value.showModal,
                      child: _item(value.title, value.selected.title, size),
                    )))),
        selectedValue: valueSelected ?? controller.empty.first['_id'],
        title: title,
        placeholder: 'Elige una fecha',
        modalType: S2ModalType.bottomSheet,
        choiceItems: items.isBlank
            ? controller.empty
                .map((e) => S2Choice<String>(value: e['_id'], title: e['name']))
                .toList()
            : items
                .map((e) => S2Choice<String>(value: e['_id'], title: e['name']))
                .toList(),
        onChange: (val) => {},
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
    return GetBuilder<ControlLanzadaController>(
      id: 'seleccionado',
      builder: (_) => GestureDetector(
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
            height: size.height * 0.17,
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
                        Flexible(child: Container(), flex: 2),
                        Flexible(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Linea: ${_.listado[index].linea}',
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
                              'Mesa: ${_.listado[index].mesa}',
                              style: TextStyle(
                                  fontWeight: FontWeight.normal, fontSize: 14),
                            ),
                          ),
                          flex: 10,
                        ),
                        Flexible(child: Container(), flex: 2),
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
                            child: Text(_.listado[index]
                                    .itempersonalpretareaesparrago ??
                                ''),
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
                        Flexible(child: Container(), flex: 1),
                        Flexible(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check,
                                  color: successColor,
                                ),
                                Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5),
                                    child: Text(
                                        (_.listado[index].sizeDetails ?? 0)
                                            .toString())),
                              ],
                            ),
                          ),
                          flex: 5,
                        ),
                        Flexible(child: Container(), flex: 1),
                        Flexible(
                          child: Container(
                            alignment: Alignment.topCenter,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: infoColor,
                            ),
                            child: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.remove_red_eye_sharp,
                                color: Colors.white,
                                size: 20.0,
                              ),
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
}
