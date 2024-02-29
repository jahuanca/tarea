import 'package:flutter_tareo/domain/asignacion_personal/entities/buscar_linea_mesa_entity.dart';
import 'package:flutter_tareo/domain/asignacion_personal/respositories/asignacion_personal_repository.dart';
import 'package:flutter_tareo/domain/entities/esparrago_agrupa_personal_entity.dart';
import 'package:flutter_tareo/domain/utils/failure.dart';
import 'package:flutter_tareo/domain/utils/result_type.dart';

class GetLineaMesaUseCase {
  AsignacionPersonalRepository _repository;

  GetLineaMesaUseCase(this._repository);

  Future<ResultType<List<EsparragoAgrupaPersonalEntity>, Failure>> execute(
      BuscarLineaMesaEntity query) async {
    return await _repository.getLineaMesas(query);
  }
}
