import 'package:flutter_tareo/data/http_manager/app_http_manager.dart';
import 'package:flutter_tareo/domain/entities/personal_pre_tarea_esparrago_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_detalle_varios_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_varios_entity.dart';
import 'package:flutter_tareo/domain/repositories/resumen_varios_repository.dart';
import 'package:flutter_tareo/ui/utils/conecction_state.dart';
import 'package:hive/hive.dart';

class ResumenVariosRepositoryImplementation extends ResumenVariosRepository {
  final urlModule = '/resumen_varios';

  @override
  Future<void> migrar() async {
    if (!(await hasInternet())) {
      return;
    }
    var tareas = await Hive.openBox<PreTareaEsparragoVariosEntity>(
        'pesados_sincronizar');
    final AppHttpManager http = AppHttpManager();

    for (var i = 0; i < tareas.length; i++) {
      var element = tareas.values?.toList()[i];
      var detalles = await Hive.openBox<PreTareaEsparragoDetalleVariosEntity>(
          'pesado_detalles_${element.key}');
      print(detalles.length);
      Map<int, List<int>> laboresCantidad = {};
      for (var j = 0; j < detalles.length; j++) {
        var d = detalles.values.toList()[j];
        print('labor ${d.idlabor}');
        if (laboresCantidad.containsKey(d.idlabor)) {
          List<int> cantidad = laboresCantidad[d.idlabor];
          (d.esCaja)
              ? cantidad[0] = (cantidad[0]) + 1
              : cantidad[1] = (cantidad[1]) + 1;
          laboresCantidad[d.idlabor] = cantidad;
        } else {
          List<int> cantidad = [];
          (d.esCaja) ? cantidad = [1, 0] : cantidad = [0, 1];
          laboresCantidad.addAll({d.idlabor: cantidad});
        }
      }
      print(laboresCantidad);
      if (element?.estadoLocal != 'M') {
        try {
          laboresCantidad.forEach((key, value) async {
            await http.post(
              mostrarError: false,
              url: '$urlModule/create',
              body: {
                'imei': element.imei,
                'turno': element.turnotareo,
                'idlabor': key,
                'fecha': element.fecha?.toIso8601String(),
                'cantidad_cajas': value[0],
                'cantidad_personas': value[1],
              },
            );
          });
        } catch (e) {}
      }
      await detalles.close();
    }

    /* return res == null ? null : tareaProcesoEntity; */

    await tareas.close();

    return;
  }

  @override
  Future<void> migrarEsparrago() async {
    if (!(await hasInternet())) {
      return;
    }

    var tareas = await Hive.openBox<PreTareaEsparragoVariosEntity>(
        'pesados_sincronizar');
    final AppHttpManager http = AppHttpManager();

    for (var i = 0; i < tareas.length; i++) {
      var element = tareas.values?.toList()[i];
      var detalles = await Hive.openBox<PersonalPreTareaEsparragoEntity>(
          'personal_pre_tarea_esparrago_${element.key}');
      Map<String, int> resumen = {};
      for (var j = 0; j < detalles.length; j++) {
        var d = detalles.values.toList()[j];
        resumen[d.keyString()] = 1 + (resumen[d.keyString()] ?? 0);
      }

      /* if (element?.estadoLocal != 'M') { */
        try {
          resumen.forEach((key, value) async {
            List<String> keys = key.split('!');
            print('enviando resumen varios esparrago');
            await http.post(
              mostrarError: false,
              url: '${urlModule}_esparrago/create',
              body: {
                'imei': element.imei,
                'fecha': element.fecha?.toIso8601String(),
                'idcliente': keys[1],
                'idlabor': keys[2],
                'mesa': keys[3],
                'linea': keys[4],
                'cantidad': value,
              },
            );
          });
        } catch (e) {
          print(e.toString());
        }
      /* } */
      await detalles.close();
    }

    /* return res == null ? null : tareaProcesoEntity; */
    await tareas.close();
    return;
  }
}
