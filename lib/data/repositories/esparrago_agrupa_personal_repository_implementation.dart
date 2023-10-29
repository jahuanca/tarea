import 'package:flutter_tareo/data/utils/app_http_manager.dart';
import 'package:flutter_tareo/domain/entities/esparrago_agrupa_personal_entity.dart';
import 'package:flutter_tareo/domain/repositories/esparrago_agrupa_personal_repository.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:hive/hive.dart';

class EsparragoAgrupaPersonalRepositoryImplementation
    extends EsparragoAgrupaPersonalRepository {
  final urlModule = '/esparrago_agrupa_personal';

  @override
  Future<List<EsparragoAgrupaPersonalEntity>> getAll() async {
    if (PreferenciasUsuario().offLine) {
      Box dataHive = await Hive.openBox<EsparragoAgrupaPersonalEntity>(
          'esparrago_agrupa_sincronizar');
      List<EsparragoAgrupaPersonalEntity> local = [];
      dataHive.toMap().forEach((key, value) => local.add(value));
      await dataHive.close();
      return local;
    }

    final AppHttpManager http = AppHttpManager();

    final res = await http.get(
      url: urlModule,
    );

    return esparragoAgrupaPersonalEntityFromJson((res));
  }

  @override
  Future<List<EsparragoAgrupaPersonalEntity>> getAllByValue(
      Map<String, dynamic> valores) async {
    if (PreferenciasUsuario().offLine) {
      Box<EsparragoAgrupaPersonalEntity> dataHive =
          await Hive.openBox<EsparragoAgrupaPersonalEntity>(
              'esparrago_agrupa_sincronizar');
      List<EsparragoAgrupaPersonalEntity> local = [];

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
