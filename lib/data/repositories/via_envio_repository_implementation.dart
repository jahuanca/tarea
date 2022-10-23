import 'package:flutter_tareo/data/http_manager/app_http_manager.dart';
import 'package:flutter_tareo/domain/entities/via_envio_entity.dart';
import 'package:flutter_tareo/domain/repositories/via_envio_repository.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:hive/hive.dart';

class ViaEnvioRepositoryImplementation extends ViaEnvioRepository {
  final urlModule = '/via_envio';

  @override
  Future<List<ViaEnvioEntity>> getAll() async {
    if (PreferenciasUsuario().offLine) {
      Box dataHive =
          await Hive.openBox<ViaEnvioEntity>('via_envios_sincronizar');
      List<ViaEnvioEntity> local = [];
      dataHive.toMap().forEach((key, value) => local.add(value));
      await dataHive.compact();
      await dataHive.close();
      return local;
    }

    final AppHttpManager http = AppHttpManager();

    final res = await http.get(
      url: urlModule,
    );

    return viaEnvioEntityFromJson((res));
  }

  @override
  Future<List<ViaEnvioEntity>> getAllByValue(
      Map<String, dynamic> valores) async {
    if (PreferenciasUsuario().offLine) {
      Box<ViaEnvioEntity> dataHive =
          await Hive.openBox<ViaEnvioEntity>('via_envios_sincronizar');
      List<ViaEnvioEntity> local = [];

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