import 'package:flutter_tareo/domain/asignacion_personal/respositories/listado_asignacion_personal_repository.dart';
import 'package:flutter_tareo/domain/entities/esparrago_agrupa_personal_detalle_entity.dart';
import 'package:flutter_tareo/domain/utils/failure.dart';
import 'package:flutter_tareo/domain/utils/result_type.dart';

class DeletePersonalAsignacionUseCase {
  final ListadoAsignacionPersonalRepository _repository;

  DeletePersonalAsignacionUseCase(this._repository);

  Future<ResultType<EsparragoAgrupaPersonalDetalleEntity, Failure>> execute(
      int id) async {
    return await _repository.removeDetalle(id);
  }
}
