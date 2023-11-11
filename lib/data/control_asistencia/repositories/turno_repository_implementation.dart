import 'package:flutter_tareo/core/utils/strings/hiveDB.dart';
import 'package:flutter_tareo/data/utils/app_http_manager.dart';
import 'package:flutter_tareo/domain/control_asistencia/repositories/turno_repository.dart';
import 'package:flutter_tareo/domain/entities/turno_entity.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:hive/hive.dart';

class TurnoRepositoryImplementation extends TurnoRepository {
  final urlModule = '/turno';

  @override
  Future<List<TurnoEntity>> getAll() async {
    if (PreferenciasUsuario().offLine) {
      Box dataHive = await Hive.openBox<TurnoEntity>(TURNO_HIVE_STRING);
      List<TurnoEntity> local = [];
      dataHive.toMap().forEach((key, value) => local.add(value));
      await dataHive.close();
      return local;
    }

    final AppHttpManager http = AppHttpManager();

    final res = await http.get(
      url: urlModule,
    );

    return turnoEntityFromJson((res));
  }

  @override
  Future<List<TurnoEntity>> getAllByValue(Map<String, dynamic> valores) async {
    if (PreferenciasUsuario().offLine) {
      Box<TurnoEntity> dataHive =
          await Hive.openBox<TurnoEntity>(TURNO_HIVE_STRING);
      List<TurnoEntity> local = [];

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
