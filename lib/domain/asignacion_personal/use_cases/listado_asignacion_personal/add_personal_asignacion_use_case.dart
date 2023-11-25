import 'package:flutter_tareo/domain/asignacion_personal/respositories/listado_asignacion_personal_repository.dart';
import 'package:flutter_tareo/domain/entities/esparrago_agrupa_personal_detalle_entity.dart';
import 'package:flutter_tareo/domain/entities/esparrago_agrupa_personal_entity.dart';
import 'package:flutter_tareo/domain/utils/failure.dart';
import 'package:flutter_tareo/domain/utils/result_type.dart';

class GetAllPersonalAsignacionUse {
  final ListadoAsignacionPersonalRepository _repository;

  GetAllPersonalAsignacionUse(this._repository);

  Future<ResultType<EsparragoAgrupaPersonalDetalleEntity, Failure>> execute(
      EsparragoAgrupaPersonalEntity asignacion,
      EsparragoAgrupaPersonalDetalleEntity detalle) async {
    return await _repository.addDetalle(asignacion, detalle);
  }
}
