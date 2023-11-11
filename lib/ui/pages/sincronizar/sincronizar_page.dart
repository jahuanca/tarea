import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
                itemSincronizado(size, 'actividades', 'Actividades',
                    _.sizeActividads.toString()),
                GetBuilder<SincronizarController>(
                    id: 'sedes',
                    builder: (_) => itemSincronizado(
                        size, 'sedes', 'Sedes', _.sedes.length.toString())),
                GetBuilder<SincronizarController>(
                    id: 'labores',
                    builder: (_) => itemSincronizado(size, 'labores', 'Labores',
                        _.labores.length.toString())),
                GetBuilder<SincronizarController>(
                    id: 'centro_costo',
                    builder: (_) => itemSincronizado(size, 'centro_costo',
                        'Centros de costo', _.centrosCosto.length.toString())),
                GetBuilder<SincronizarController>(
                    id: 'usuarios',
                    builder: (_) => itemSincronizado(size, 'usuarios',
                        'Usuarios', _.usuarios.length.toString())),
                itemSincronizado(size, 'personal_empresa', 'Personal',
                    _.sizePersonal.toString()),
                /* GetBuilder<SincronizarController>(
                  id: 'pre_tareos',
                  builder: (_)=> itemSincronizado(size, 'pre_tareos', 'Arándanos' , _.preTareos.length.toString() )), */
                GetBuilder<SincronizarController>(
                    id: 'cultivos',
                    builder: (_) => itemSincronizado(size, 'cultivos',
                        'Cultivos', _.cultivos.length.toString())),
                GetBuilder<SincronizarController>(
                    id: 'clientes',
                    builder: (_) => itemSincronizado(size, 'clientes',
                        'Clientes', _.clientes.length.toString())),
                GetBuilder<SincronizarController>(
                    id: 'estados',
                    builder: (_) => itemSincronizado(size, 'estados', 'Estados',
                        _.estados.length.toString())),
                GetBuilder<SincronizarController>(
                    id: 'calibres',
                    builder: (_) => itemSincronizado(size, 'calibres',
                        'Calibres', _.calibres.length.toString())),
                GetBuilder<SincronizarController>(
                    id: 'via_envios',
                    builder: (_) => itemSincronizado(size, 'via_envios',
                        'Vias de envio', _.viaEnvios.length.toString())),
                GetBuilder<SincronizarController>(
                    id: 'tipo_tareas',
                    builder: (_) => itemSincronizado(size, 'tipo_tareas',
                        'Tipos de tareas', _.tipoTareas.length.toString())),
                GetBuilder<SincronizarController>(
                    id: 'esparrago_agrupa',
                    builder: (_) => itemSincronizado(
                        size,
                        'esparrago_agrupa',
                        'Grupos esparrago',
                        _.agrupaPersonals.length.toString())),
                itemSincronizado(size, 'esparrago_agrupa', 'Turnos',
                    _.sizeTurnos.toString()),
                itemSincronizado(size, 'esparrago_agrupa', 'Ubicacions',
                    _.sizeUbicacions.toString()),
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

  Widget itemSincronizado(
      Size size, String titleBuilder, String title, String count) {
    return GetBuilder<SincronizarController>(
      id: titleBuilder,
      builder: (_) => Container(
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
                child:
                    Container(alignment: Alignment.center, child: Text(count))),
            Expanded(child: Container(), flex: 1),
          ],
        ),
      ),
    );
  }
}
