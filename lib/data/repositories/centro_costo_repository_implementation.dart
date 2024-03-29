import 'package:flutter_tareo/data/http_manager/app_http_manager.dart';
import 'package:flutter_tareo/domain/entities/centro_costo_entity.dart';
import 'package:flutter_tareo/domain/repositories/centro_costo_repository.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:hive/hive.dart';

class CentroCostoRepositoryImplementation extends CentroCostoRepository {
  final urlModule = '/centro_costo';

  @override
  Future<List<CentroCostoEntity>> getAll() async {
    if (PreferenciasUsuario().offLine) {
      Box sedesHive =
          await Hive.openBox<CentroCostoEntity>('centros_costo_sincronizar');
      List<CentroCostoEntity> local = [];
      sedesHive.toMap().forEach((key, value) => local.add(value));
      await sedesHive.compact();
      await sedesHive.close();
      return local;
    }

    final AppHttpManager http = AppHttpManager();
    final res = await http.get(
      url: urlModule,
    );

    return centroCostoEntityFromJson((res));
  }

  @override
  Future<List<CentroCostoEntity>> getAllByValue(Map<String, dynamic> valores) async{
    if (PreferenciasUsuario().offLine) {
      Box<CentroCostoEntity> dataHive =
          await Hive.openBox<CentroCostoEntity>('centros_costo_sincronizar');
      List<CentroCostoEntity> local = [];

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
