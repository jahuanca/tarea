import 'package:flutter_tareo/data/http_manager/app_http_manager.dart';
import 'package:flutter_tareo/domain/entities/labor_entity.dart';
import 'package:flutter_tareo/domain/repositories/labor_repository.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:hive/hive.dart';

class LaborRepositoryImplementation extends LaborRepository {
  final urlModule = '/labor';

  @override
  Future<List<LaborEntity>> getAll() async {
    if (PreferenciasUsuario().offLine) {
      Box dataHive = await Hive.openBox<LaborEntity>('labores_sincronizar');
      List<LaborEntity> local = [];
      dataHive.toMap().forEach((key, value) => local.add(value));
      await dataHive.close();
      return local;
    }

    final AppHttpManager http = AppHttpManager();

    final res = await http.get(
      url: urlModule,
    );

    return laborEntityFromJson((res));
  }

  @override
  Future<List<LaborEntity>> getAllByValue(Map<String, dynamic> valores) async {
    if (PreferenciasUsuario().offLine) {
      Box<LaborEntity> dataHive =
          await Hive.openBox<LaborEntity>('labores_sincronizar');
      List<LaborEntity> local = [];

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
