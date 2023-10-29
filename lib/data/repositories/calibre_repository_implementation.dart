import 'package:flutter_tareo/data/utils/app_http_manager.dart';
import 'package:flutter_tareo/domain/entities/calibre_entity.dart';
import 'package:flutter_tareo/domain/repositories/calibre_repository.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:hive/hive.dart';

class CalibreRepositoryImplementation extends CalibreRepository {
  final urlModule = '/calibre';

  @override
  Future<List<CalibreEntity>> getAll() async {
    if (PreferenciasUsuario().offLine) {
      Box dataHive = await Hive.openBox<CalibreEntity>('calibres_sincronizar');
      List<CalibreEntity> local = [];
      dataHive.toMap().forEach((key, value) => local.add(value));
      await dataHive.compact();
      await dataHive.close();
      return local;
    }

    final AppHttpManager http = AppHttpManager();

    final res = await http.get(
      url: urlModule,
    );

    return calibreEntityFromJson((res));
  }

  @override
  Future<List<CalibreEntity>> getAllByValue(
      Map<String, dynamic> valores) async {
    if (PreferenciasUsuario().offLine) {
      Box<CalibreEntity> dataHive =
          await Hive.openBox<CalibreEntity>('calibres_sincronizar');
      List<CalibreEntity> local = [];

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
