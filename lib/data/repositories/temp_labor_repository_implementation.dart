import 'package:flutter_tareo/data/http_manager/app_http_manager.dart';
import 'package:flutter_tareo/domain/entities/temp_labor_entity.dart';
import 'package:flutter_tareo/domain/repositories/temp_labor_repository.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:hive/hive.dart';

class TempLaborRepositoryImplementation extends TempLaborRepository {
  final urlModule = '/temp_labor';

  @override
  Future<List<TempLaborEntity>> getAll() async{

    if(PreferenciasUsuario().offLine){
      Box dataHive = await Hive.openBox<TempLaborEntity>('labores_sincronizar');
      List<TempLaborEntity> local=[];
      dataHive.toMap().forEach((key, value)=> local.add(value));
      dataHive.close();
      return local;
    }

    final AppHttpManager http = AppHttpManager();

    final res = await http.get(
      url: urlModule,
    );

    return tempLaborEntityFromJson((res));
  }
}
 