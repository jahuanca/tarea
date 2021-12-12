import 'package:flutter_tareo/data/http_manager/app_http_manager.dart';
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_detalle_varios_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_varios_entity.dart';
import 'package:flutter_tareo/domain/repositories/resumen_varios_repository.dart';
import 'package:flutter_tareo/ui/utils/conecction_state.dart';
import 'package:hive/hive.dart';

class ResumenVariosRepositoryImplementation extends ResumenVariosRepository {
  final urlModule = '/resumen_varios';

  @override
  Future<void> migrar() async {

    if(!(await hasInternet())){
      return;
    }
    var tareas = await Hive.openBox<PreTareaEsparragoVariosEntity>(
        'pesados_sincronizar');
    final AppHttpManager http = AppHttpManager();

    for (var i = 0; i < tareas.length; i++) {
      var element = tareas.values.toList()[i];
      if (element.estadoLocal != 'M') {
        try {
          await http.post(
            mostrarError: false,
            url: '$urlModule/create',
            body: {
              'imei': element.imei,
              'turno': element.turnotareo,
              /* 'idlabor': element.idestado, */
              'fecha': element.fecha?.toIso8601String(),
              'cantidad_cajas': element.sizeTipoCaja,
              'cantidad_personas': element.sizeTipoPersona,
            },
          );
        } catch (e) {}
      }
    }

    /* return res == null ? null : tareaProcesoEntity; */

    await tareas.close();

    return;
  }
}
