import 'package:flutter/material.dart';
import 'package:flutter_tareo/core/utils/colors.dart';
import 'package:flutter_tareo/ui/control_asistencia/utils/ids.dart';
import 'package:flutter_tareo/ui/esparrago_varios/control_lanzada/reporte/reporte_lanzada_controller.dart';
import 'package:flutter_tareo/ui/utils/string_formats.dart';
import 'package:flutter_tareo/ui/widgets/app_bar_widget.dart';
import 'package:get/get.dart';

class ReporteLanzadaPage extends StatelessWidget {
  const ReporteLanzadaPage();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return GetBuilder<ReporteLanzadaController>(
      init: ReporteLanzadaController(Get.find()),
      id: VALIDANDO_ID,
      builder: (_) => Scaffold(
        appBar: getAppBar('Reporte lanzada', []),
        backgroundColor: secondColor,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: size.height * 0.05,
                    horizontal: size.width * 0.05),
                child: (_.reporte == null)
                    ? Container()
                    : Container(
                        color: Colors.white,
                        padding: EdgeInsets.symmetric(
                            vertical: size.height * 0.05,
                            horizontal: size.width * 0.05),
                        child: Column(
                          children: [
                            _itemTitle(
                                'Fecha:', formatoFecha(_.reporte.header.fecha)),
                            _itemTitle('Turno:', _.reporte.header.turno),
                            _itemTitle(
                                'Linea:', _.reporte.header.linea.toString()),
                            _itemTitle(
                                'Mesa:', _.reporte.header.grupo.toString()),
                            _itemTitle('Personal en mesa:',
                                _.reporte.header.sizePersonalMesa.toString()),
                            _itemTitle('Personal en pesado:',
                                _.reporte.header.sizeDetails.toString()),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Tipos de labor:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Column(
                              children: _.reporte.labors
                                  .map((e) => _itemTitle(
                                      e.descripcion, e.sizeDetails.toString()))
                                  .toList(),
                            )
                          ],
                        ),
                      ),
              ),
            ),
            GetBuilder<ReporteLanzadaController>(
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

  Widget _itemTitle(String title, String description) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Container(
              child: Text(title),
            ),
            flex: 1,
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Text(description),
            ),
            flex: 1,
          )
        ],
      ),
    );
  }
}
