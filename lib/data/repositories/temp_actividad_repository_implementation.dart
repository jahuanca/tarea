import 'package:flutter_tareo/data/http_manager/app_http_manager.dart';
import 'package:flutter_tareo/domain/entities/temp_actividad_entity.dart';
import 'package:flutter_tareo/domain/repositories/temp_actividad_repository.dart';

class TempActividadRepositoryImplementation extends TempActividadRepository {
  final urlModule = '/temp_actividad';

  @override
  Future<List<TempActividadEntity>> getAll() async{
    final AppHttpManager http = AppHttpManager();

    final res = await http.get(
      url: urlModule,
    );

    return tempActividadEntityFromJson((res));
  }
}
 