import 'package:flutter/material.dart';
import 'package:flutter_tareo/ui/control_asistencia/utils/ids.dart';
import 'package:flutter_tareo/ui/pages/sincronizar/sincronizar_controller.dart';
import 'package:flutter_tareo/ui/widgets/app_bar_widget.dart';
import 'package:get/get.dart';

class SincronizarPage extends StatelessWidget {
  final SincronizarController controller = Get.find<SincronizarController>();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return GetBuilder<SincronizarController>(
      init: controller,
      id: 'version',
      builder: (_) => Stack(
        children: [
          Scaffold(
            appBar: getAppBar('Sincronizar', [], true),
            body: ListView(
              children: [
                itemEncabezado(size),
                GetBuilder<SincronizarController>(
                    id: ACTIVIDADS_ID,
                    builder: (context) => itemSincronizado(
                        size, 'Actividades', _.sizeActividads)),
                GetBuilder<SincronizarController>(
                    id: SEDES_ID,
                    builder: (context) =>
                        itemSincronizado(size, 'Sedes', _.sizeSedes)),
                GetBuilder<SincronizarController>(
                    id: LABORS_ID,
                    builder: (context) =>
                        itemSincronizado(size, 'Labores', _.sizeLabores)),
                GetBuilder<SincronizarController>(
                    id: CENTRO_COSTOS_ID,
                    builder: (context) => itemSincronizado(
                        size, 'Centros de costo', _.sizeCentroCostos)),
                GetBuilder<SincronizarController>(
                    id: USUARIOS_ID,
                    builder: (context) =>
                        itemSincronizado(size, 'Usuarios', _.sizeUsuarios)),
                GetBuilder<SincronizarController>(
                    id: PERSONAL_EMPRESAS_ID,
                    builder: (context) =>
                        itemSincronizado(size, 'Personal', _.sizePersonal)),
                /* GetBuilder<SincronizarController>(
                  id: 'pre_tareos',
                  builder: (_)=> itemSincronizado(size, 'pre_tareos', 'Arándanos' , _.preTareos.length.toString() )), */
                GetBuilder<SincronizarController>(
                    id: CULTIVOS_ID,
                    builder: (context) =>
                        itemSincronizado(size, 'Cultivos', _.sizeCultivos)),
                GetBuilder<SincronizarController>(
                    id: CLIENTES_ID,
                    builder: (context) =>
                        itemSincronizado(size, 'Clientes', _.sizeClientes)),
                GetBuilder<SincronizarController>(
                    id: ESTADOS_ID,
                    builder: (context) =>
                        itemSincronizado(size, 'Estados', _.sizeEstados)),
                GetBuilder<SincronizarController>(
                    id: CALIBRES_ID,
                    builder: (context) =>
                        itemSincronizado(size, 'Calibres', _.sizeCalibres)),
                GetBuilder<SincronizarController>(
                    id: 'via_envios',
                    builder: (_) => itemSincronizado(
                        size, 'Vias de envio', _.viaEnvios.length)),
                GetBuilder<SincronizarController>(
                    id: 'tipo_tareas',
                    builder: (_) => itemSincronizado(
                        size, 'Tipos de tareas', _.tipoTareas.length)),
                GetBuilder<SincronizarController>(
                    id: 'esparrago_agrupa',
                    builder: (_) => itemSincronizado(
                        size, 'Grupos esparrago', _.agrupaPersonals.length)),
                GetBuilder<SincronizarController>(
                    id: TURNOS_ID,
                    builder: (context) =>
                        itemSincronizado(size, 'Turnos', _.sizeTurnos)),
                GetBuilder<SincronizarController>(
                    id: UBICACIONS_ID,
                    builder: (context) => itemSincronizado(
                        size, 'Ubicaciones', _.sizeUbicacions)),
              ],
            ),
          ),
          GetBuilder<SincronizarController>(
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
    );
  }

  Widget itemEncabezado(Size size) {
    return Container(
      height: size.height * 0.05,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Text(
                'Tabla',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Expanded(
              child: Container(
                  alignment: Alignment.center, child: Text('Resultado'))),
        ],
      ),
    );
  }

  Widget itemSincronizado(Size size, String title, int count) {
    return Container(
      height: size.height * 0.04,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(child: Container(), flex: 1),
          Expanded(
              flex: 10,
              child: Container(
                  alignment: Alignment.centerLeft, child: Text(title))),
          Expanded(child: Container(), flex: 1),
          Expanded(
              flex: 10,
              child: Container(
                  alignment: Alignment.center, child: Text("$count"))),
          Expanded(child: Container(), flex: 1),
        ],
      ),
    );
  }
}
