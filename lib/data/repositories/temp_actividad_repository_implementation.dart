import 'package:flutter_tareo/data/http_manager/app_http_manager.dart';
import 'package:flutter_tareo/domain/entities/temp_actividad_entity.dart';
import 'package:flutter_tareo/domain/repositories/temp_actividad_repository.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:hive/hive.dart';

class TempActividadRepositoryImplementation extends TempActividadRepository {
  final urlModule = '/temp_actividad';

  @override
  Future<List<TempActividadEntity>> getAll() async{

    if(PreferenciasUsuario().offLine){
      Box dataHive = await Hive.openBox<TempActividadEntity>('actividades_sincronizar');
      List<TempActividadEntity> local=[];
      dataHive.toMap().forEach((key, value)=> local.add(value));
      await dataHive.close();
      return local;
    }

    final AppHttpManager http = AppHttpManager();

    final res = await http.get(
      url: urlModule,
    );

    return tempActividadEntityFromJson((res));
  }
}
 