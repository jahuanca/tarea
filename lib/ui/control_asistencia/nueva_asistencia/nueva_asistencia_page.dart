import 'package:flutter/material.dart';
import 'package:flutter_tareo/core/utils/colors.dart';
import 'package:flutter_tareo/core/utils/numbers.dart';
import 'package:flutter_tareo/ui/control_asistencia/nueva_asistencia/nueva_asistencia_controller.dart';
import 'package:flutter_tareo/ui/control_asistencia/utils/ids.dart';
import 'package:flutter_tareo/ui/control_asistencia/utils/strings.dart';
import 'package:flutter_tareo/ui/utils/string_formats.dart';
import 'package:flutter_tareo/ui/widgets/app_bar_widget.dart';
import 'package:flutter_tareo/ui/widgets/date_picker_widget.dart';
import 'package:flutter_tareo/ui/widgets/dropdown_search_widget.dart';
import 'package:flutter_tareo/ui/widgets/input_label_widget.dart';
import 'package:get/get.dart';

class NuevaAsistenciaPage extends StatelessWidget {
  final NuevaAsistenciaController controller =
      Get.find<NuevaAsistenciaController>();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return GetBuilder<NuevaAsistenciaController>(
      init: controller,
      builder: (_) => Stack(
        children: [
          Scaffold(
            appBar: getAppBar(
                controller.editando
                    ? EDIT_ASISTENCIA_STRING
                    : NEW_ASISTENCIA_STRING,
                [],
                BOOLEAN_TRUE_VALUE),
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
                    GetBuilder<NuevaAsistenciaController>(
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
                    GetBuilder<NuevaAsistenciaController>(
                      id: UBICACIONS_ID,
                      builder: (_) => DropdownSearchWidget(
                        label: UBICACION_LABEL,
                        error: _.errorUbicacion,
                        labelText: NAME_LABEL,
                        labelValue: ID_LABEL,
                        selectedItem: _.nuevaAsistencia?.ubicacion == null
                            ? null
                            : {
                                NAME_LABEL:
                                    '${_.nuevaAsistencia.ubicacion?.ubicacion?.trim()}',
                                ID_LABEL:
                                    _.nuevaAsistencia.ubicacion.idubicacion,
                              },
                        onChanged: _.changeUbicacion,
                        items: controller.ubicacions.length == 0
                            ? []
                            : controller.ubicacions
                                .map((e) => {
                                      NAME_LABEL: '${e.ubicacion?.trim()}',
                                      ID_LABEL: e.idubicacion,
                                    })
                                .toList(),
                      ),
                    ),
                    GetBuilder<NuevaAsistenciaController>(
                      id: TURNOS_ID,
                      builder: (_) => DropdownSearchWidget(
                        label: TURNO_LABEL,
                        labelText: NAME_LABEL,
                        labelValue: ID_LABEL,
                        error: _.errorTurno,
                        onChanged: _.changeTurno,
                        selectedItem: _.nuevaAsistencia?.turno == null
                            ? null
                            : {
                                NAME_LABEL: '${_.nuevaAsistencia.turno.turno}',
                                ID_LABEL: _.nuevaAsistencia.turno.idturno,
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
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                  ],
                ),
              ),
            ),
          ),
          GetBuilder<NuevaAsistenciaController>(
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
