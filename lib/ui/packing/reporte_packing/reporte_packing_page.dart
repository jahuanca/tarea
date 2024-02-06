import 'package:flutter/material.dart';
import 'package:flutter_tareo/core/utils/colors.dart';
import 'package:flutter_tareo/ui/control_asistencia/utils/ids.dart';
import 'package:flutter_tareo/ui/packing/reporte_packing/reporte_packing_controller.dart';
import 'package:flutter_tareo/ui/utils/string_formats.dart';
import 'package:flutter_tareo/ui/widgets/app_bar_widget.dart';
import 'package:get/get.dart';

class ReportePackingPage extends StatelessWidget {
  const ReportePackingPage();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return GetBuilder<ReportePackingController>(
      init: ReportePackingController(Get.find(), Get.find()),
      id: VALIDANDO_ID,
      builder: (_) => Scaffold(
        appBar: getAppBar('Reporte packing',
            [IconButton(onPressed: _.goScanner, icon: Icon(Icons.qr_code))]),
        backgroundColor: secondColor,
        body: Stack(
          children: [
            (_.reporte == null)
                ? _emptyReport(size)
                : SingleChildScrollView(
                    child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: size.height * 0.05,
                            horizontal: size.width * 0.05),
                        child: _report(_, size)),
                  ),
            GetBuilder<ReportePackingController>(
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

  Widget _emptyReport(Size size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          //color: Colors.white,
          child: Text('Escanee el fotocheck del usuario.'),
        ),
      ],
    );
  }

  Widget _report(ReportePackingController _, Size size) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: size.height * 0.05, horizontal: size.width * 0.05),
      color: Colors.white,
      child: Column(
        children: [
          _itemTitle('Apellido:', (_.reporte.personal.apellidopaterno)),
          _itemTitle('Nombre:', (_.reporte.personal.nombres)),
          _itemTitle('Documento:', (_.reporte.personal.nrodocumento)),
          _itemTitle('Fecha:', formatoFecha(_.reporte.header.fecha)),
          _itemTitle('Turno:', _.reporte.header.turnotareo),
          if (_.reporte.header.linea != null)
            _itemTitle('Linea:', _.reporte.header.linea.toString()),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            alignment: Alignment.centerLeft,
            child: Text(
              'Avance:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Column(
              children: _.reporte.labors.values
                  .map((e) => _itemTitle(
                      e.first.labor.descripcion, e.length.toString()))
                  .toList())
        ],
      ),
    );
  }
}
