import 'package:flutter_tareo/data/http_manager/app_http_manager.dart';
import 'package:flutter_tareo/domain/entities/tipo_tarea_entity.dart';
import 'package:flutter_tareo/domain/repositories/tipo_tarea_repository.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:hive/hive.dart';

class TipoTareaRepositoryImplementation extends TipoTareaRepository {
  final urlModule = '/tipo_tarea';

  @override
  Future<List<TipoTareaEntity>> getAll() async {
    if (PreferenciasUsuario().offLine) {
      Box dataHive =
          await Hive.openBox<TipoTareaEntity>('tipo_tareas_sincronizar');
      List<TipoTareaEntity> local = [];
      dataHive.toMap().forEach((key, value) => local.add(value));
      await dataHive.close();
      return local;
    }

    final AppHttpManager http = AppHttpManager();

    final res = await http.get(
      url: urlModule,
    );

    return tipoTareaEntityFromJson((res));
  }

  @override
  Future<List<TipoTareaEntity>> getAllByValue(
      Map<String, dynamic> valores) async {
    if (PreferenciasUsuario().offLine) {
      Box<TipoTareaEntity> dataHive =
          await Hive.openBox<TipoTareaEntity>('tipo_tareas_sincronizar');
      List<TipoTareaEntity> local = [];

      dataHive.values.forEach((e) {
        bool guardar = true;
        valores.forEach((key, value) {
          if (e.toJson()[key] != value) {
            guardar = false;
          }
        });
        if (guardar) local.add(e);
      });
      await dataHive.close();
      return local;
    }

    return [];
  }
}
