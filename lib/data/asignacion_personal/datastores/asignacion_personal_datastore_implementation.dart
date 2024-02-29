import 'package:flutter_tareo/data/asignacion_personal/utils/constants.dart';
import 'package:flutter_tareo/data/utils/app_http_manager.dart';
import 'package:flutter_tareo/domain/asignacion_personal/datastores/asignacion_personal_datastore.dart';
import 'package:flutter_tareo/domain/entities/esparrago_agrupa_personal_entity.dart';
import 'package:flutter_tareo/domain/asignacion_personal/entities/buscar_linea_mesa_entity.dart';
import 'package:flutter_tareo/domain/utils/failure.dart';
import 'package:flutter_tareo/domain/utils/result_type.dart';

class AsignacionPersonalDataStoreImplementation
    implements AsignacionPersonalDataStore {
  @override
  Future<ResultType<List<EsparragoAgrupaPersonalEntity>, Failure>>
      getLineaMesas(BuscarLineaMesaEntity query) async {
    final http = AppHttpManager();
    query;
    final res = await http.get(url: GET_LINEAMESA_URL, query: query.toJson());
    return Success(data: esparragoAgrupaPersonalEntityFromJson(res));
  }
}
