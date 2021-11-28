import 'package:flutter_tareo/data/http_manager/app_http_manager.dart';
import 'package:flutter_tareo/domain/entities/actividad_entity.dart';
import 'package:flutter_tareo/domain/repositories/actividad_repository.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:hive/hive.dart';

class ActividadRepositoryImplementation extends ActividadRepository {
  final urlModule = '/actividad';

  @override
  Future<List<ActividadEntity>> getAll() async {
    if (PreferenciasUsuario().offLine) {
      Box dataHive =
          await Hive.openBox<ActividadEntity>('actividades_sincronizar');
      List<ActividadEntity> local = [];
      dataHive.toMap().forEach((key, value) => local.add(value));
      await dataHive.compact();
      await dataHive.close();
      return local;
    }

    final AppHttpManager http = AppHttpManager();

    final res = await http.get(
      url: urlModule,
    );

    return actividadEntityFromJson((res));
  }

  @override
  Future<List<ActividadEntity>> getAllByValue(
      Map<String, dynamic> valores) async {
    if (PreferenciasUsuario().offLine) {
      Box<ActividadEntity> dataHive =
          await Hive.openBox<ActividadEntity>('actividades_sincronizar');
      List<ActividadEntity> local = [];

      dataHive.values.forEach((e) {
        bool guardar = true;
        valores.forEach((key, value) {
          if (e.toJson()[key] != value) {
            guardar = false;
          }
        });
        if (guardar) local.add(e);
      });
      await dataHive.compact();
      await dataHive.close();
      return local;
    }

    return [];
  }
}
