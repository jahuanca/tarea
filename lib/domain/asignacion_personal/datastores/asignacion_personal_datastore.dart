import 'package:flutter_tareo/domain/asignacion_personal/entities/buscar_linea_mesa_entity.dart';
import 'package:flutter_tareo/domain/entities/esparrago_agrupa_personal_entity.dart';
import 'package:flutter_tareo/domain/utils/failure.dart';
import 'package:flutter_tareo/domain/utils/result_type.dart';

abstract class AsignacionPersonalDataStore {
  Future<ResultType<List<EsparragoAgrupaPersonalEntity>, Failure>>
      getLineaMesas(BuscarLineaMesaEntity query);
}
