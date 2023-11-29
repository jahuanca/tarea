import 'package:flutter_tareo/domain/entities/esparrago_agrupa_personal_detalle_entity.dart';
import 'package:flutter_tareo/domain/entities/esparrago_agrupa_personal_entity.dart';
import 'package:flutter_tareo/domain/utils/failure.dart';
import 'package:flutter_tareo/domain/utils/result_type.dart';

abstract class ListadoAsignacionPersonalDatastore {
  Future<List<EsparragoAgrupaPersonalDetalleEntity>> getDetalles(
      int idAsignacion);
  Future<ResultType<EsparragoAgrupaPersonalDetalleEntity, Failure>> addDetalle(
      EsparragoAgrupaPersonalEntity asignacion,
      EsparragoAgrupaPersonalDetalleEntity detalle);
  Future<ResultType<EsparragoAgrupaPersonalDetalleEntity, Failure>>
      removeDetalle(int id);
}
