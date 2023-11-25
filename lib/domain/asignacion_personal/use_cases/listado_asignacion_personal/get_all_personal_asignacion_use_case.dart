import 'package:flutter_tareo/domain/asignacion_personal/respositories/listado_asignacion_personal_repository.dart';
import 'package:flutter_tareo/domain/entities/esparrago_agrupa_personal_detalle_entity.dart';

class GetAllPersonalAsignacionUseCase {
  final ListadoAsignacionPersonalRepository _repository;

  GetAllPersonalAsignacionUseCase(this._repository);

  Future<List<EsparragoAgrupaPersonalDetalleEntity>> execute(
      int idAsignacion) async {
    return await _repository.getDetalles(idAsignacion);
  }
}
