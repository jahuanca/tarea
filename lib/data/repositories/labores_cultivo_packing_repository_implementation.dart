import 'package:flutter_tareo/data/utils/app_http_manager.dart';
import 'package:flutter_tareo/domain/entities/labores_cultivo_packing_entity.dart';
import 'package:flutter_tareo/domain/repositories/labores_cultivo_packing_repository.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:hive/hive.dart';

class LaboresCultivoPackingRepositoryImplementation
    extends LaboresCultivoPackingRepository {
  final urlModule = '/labores_cultivo_packing';

  @override
  Future<List<LaboresCultivoPackingEntity>> getAll() async {
    if (PreferenciasUsuario().offLine) {
      Box dataHive = await Hive.openBox<LaboresCultivoPackingEntity>(
          'labores_cultivo_packing_sincronizar');
      List<LaboresCultivoPackingEntity> local = [];
      dataHive.toMap().forEach((key, value) => local.add(value));
      await dataHive.close();
      return local;
    }

    final AppHttpManager http = AppHttpManager();

    final res = await http.get(
      url: urlModule,
    );

    return laboresCultivoPackingEntityFromJson((res));
  }

  @override
  Future<List<LaboresCultivoPackingEntity>> getAllByValue(
      Map<String, dynamic> valores) async {
    if (PreferenciasUsuario().offLine) {
      Box<LaboresCultivoPackingEntity> dataHive =
          await Hive.openBox<LaboresCultivoPackingEntity>(
              'labores_cultivo_packing_sincronizar');
      List<LaboresCultivoPackingEntity> local = [];

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
