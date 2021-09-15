import 'package:flutter_tareo/data/http_manager/app_http_manager.dart';
import 'package:flutter_tareo/domain/entities/temp_labor_entity.dart';
import 'package:flutter_tareo/domain/repositories/temp_labor_repository.dart';

class TempLaborRepositoryImplementation extends TempLaborRepository {
  final urlModule = '/temp_labor';

  @override
  Future<List<TempLaborEntity>> getAll() async{
    final AppHttpManager http = AppHttpManager();

    final res = await http.get(
      url: urlModule,
    );

    return tempLaborEntityFromJson((res));
  }
}
 