import 'package:flutter/material.dart';
import 'package:flutter_tareo/core/utils/colors.dart';
import 'package:flutter_tareo/ui/asignacion_personal/buscar_linea_mesa/buscar_linea_mesa_controller.dart';
import 'package:flutter_tareo/ui/asignacion_personal/utils/constants.dart';
import 'package:flutter_tareo/ui/control_asistencia/utils/ids.dart';
import 'package:flutter_tareo/ui/control_asistencia/utils/strings.dart';
import 'package:flutter_tareo/ui/utils/string_formats.dart';
import 'package:flutter_tareo/ui/widgets/date_picker_widget.dart';
import 'package:flutter_tareo/ui/widgets/dropdown_search_widget.dart';
import 'package:flutter_tareo/ui/widgets/input_label_widget.dart';
import 'package:get/get.dart';

class BuscarLineaMesaPage extends StatelessWidget {
  final BuscarLineaMesaController controller =
      Get.find<BuscarLineaMesaController>();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return GetBuilder<BuscarLineaMesaController>(
      init: controller,
      builder: (_) => Stack(
        children: [
          Scaffold(
            backgroundColor: secondColor,
            floatingActionButton: FloatingActionButton(
              onPressed: _.goListadoAsignacionPersonal,
              child: Icon(Icons.check),
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                child: Column(
                  children: [
                    GetBuilder<BuscarLineaMesaController>(
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
                    GetBuilder<BuscarLineaMesaController>(
                      id: TURNOS_ID,
                      builder: (_) => DropdownSearchWidget(
                        label: TURNO_LABEL,
                        labelText: NAME_LABEL,
                        labelValue: ID_LABEL,
                        error: _.errorTurno,
                        onChanged: _.changeTurno,
                        selectedItem: _.query?.turno == null
                            ? null
                            : {
                                NAME_LABEL: '${_.query.turno}',
                                ID_LABEL: _.query.turno,
                              },
                        items: controller.turnos.length == 0
                            ? []
                            : controller.turnos
                                .map((e) => {
                                      NAME_LABEL: '${e.turno}',
                                      ID_LABEL: e.idturno,
                                    })
                                .toList(),
                      ),
                    ),
                    GetBuilder<BuscarLineaMesaController>(
                      id: LINEAS_ID,
                      builder: (_) => _.lineas.isEmpty
                          ? Container()
                          : DropdownSearchWidget(
                              label: LINEAS_LABEL,
                              labelText: NAME_LABEL,
                              labelValue: ID_LABEL,
                              error: _.errorLinea,
                              onChanged: _.changeLinea,
                              selectedItem: _.query?.linea == null
                                  ? null
                                  : {
                                      NAME_LABEL: '${_.query.linea}',
                                      ID_LABEL: _.query.linea,
                                    },
                              items: controller.lineas.length == 0
                                  ? []
                                  : controller.lineas
                                      .map((e) => {
                                            NAME_LABEL: '${e.linea}',
                                            ID_LABEL: e.linea,
                                          })
                                      .toList(),
                            ),
                    ),
                    GetBuilder<BuscarLineaMesaController>(
                      id: MESAS_ID,
                      builder: (_) => _.mesas.isEmpty
                          ? Container()
                          : DropdownSearchWidget(
                              label: MESAS_LABEL,
                              labelText: NAME_LABEL,
                              labelValue: ID_LABEL,
                              error: _.errorMesa,
                              onChanged: _.changeMesa,
                              selectedItem: _.query?.grupo == null
                                  ? null
                                  : {
                                      NAME_LABEL:
                                          '#${_.query.grupo} --> ${_.query.sizeDetails} personas.',
                                      ID_LABEL: _.query.grupo,
                                    },
                              items: controller.mesas.length == 0
                                  ? []
                                  : controller.mesas
                                      .map((e) => {
                                            NAME_LABEL:
                                                '#${e.grupo} --> ${e.sizeDetails} personas.',
                                            ID_LABEL: e.grupo,
                                          })
                                      .toList(),
                            ),
                    ),
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                  ],
                ),
              ),
            ),
          ),
          GetBuilder<BuscarLineaMesaController>(
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
}
