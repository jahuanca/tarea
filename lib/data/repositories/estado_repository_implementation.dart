import 'package:flutter_tareo/core/utils/strings/hiveDB.dart';
import 'package:flutter_tareo/data/utils/app_http_manager.dart';
import 'package:flutter_tareo/domain/entities/estado_entity.dart';
import 'package:flutter_tareo/domain/repositories/estado_repository.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:hive/hive.dart';

class EstadoRepositoryImplementation extends EstadoRepository {
  final urlModule = '/estado';

  @override
  Future<List<EstadoEntity>> getAll() async {
    if (PreferenciasUsuario().offLine) {
      Box dataHive = await Hive.openBox<EstadoEntity>(ESTADOS_HIVE_STRING);
      List<EstadoEntity> local = [];
      dataHive.toMap().forEach((key, value) => local.add(value));
      await dataHive.compact();
      await dataHive.close();
      return local;
    }

    final AppHttpManager http = AppHttpManager();

    final res = await http.get(
      url: urlModule,
    );

    return estadoEntityFromJson((res));
  }

  @override
  Future<List<EstadoEntity>> getAllByValue(Map<String, dynamic> valores) async {
    if (PreferenciasUsuario().offLine) {
      Box<EstadoEntity> dataHive =
          await Hive.openBox<EstadoEntity>(ESTADOS_HIVE_STRING);
      List<EstadoEntity> local = [];

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
