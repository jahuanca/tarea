import 'package:flutter_tareo/core/utils/strings/hiveDB.dart';
import 'package:flutter_tareo/data/utils/app_http_manager.dart';
import 'package:flutter_tareo/domain/control_asistencia/repositories/ubicacion_repository.dart';
import 'package:flutter_tareo/domain/entities/asistencia_ubicacion_entity.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:hive/hive.dart';

class UbicacionRepositoryImplementation extends UbicacionRepository {
  final urlModule = '/ubicacion';

  @override
  Future<List<AsistenciaUbicacionEntity>> getAll() async {
    if (PreferenciasUsuario().offLine) {
      Box dataHive =
          await Hive.openBox<AsistenciaUbicacionEntity>(UBICACION_HIVE_STRING);
      List<AsistenciaUbicacionEntity> local = [];
      dataHive.toMap().forEach((key, value) => local.add(value));
      await dataHive.close();
      return local;
    }

    final AppHttpManager http = AppHttpManager();

    final res = await http.get(
      url: urlModule,
    );

    return asistenciaUbicacionEntityFromJson((res));
  }

  @override
  Future<List<AsistenciaUbicacionEntity>> getAllByValue(
      Map<String, dynamic> valores) async {
    if (PreferenciasUsuario().offLine) {
      Box<AsistenciaUbicacionEntity> dataHive =
          await Hive.openBox<AsistenciaUbicacionEntity>(UBICACION_HIVE_STRING);
      List<AsistenciaUbicacionEntity> local = [];

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
