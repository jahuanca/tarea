import 'package:flutter_tareo/domain/asignacion_personal/datastores/listado_asignacion_personal_datastore.dart';
import 'package:flutter_tareo/domain/asignacion_personal/respositories/listado_asignacion_personal_repository.dart';
import 'package:flutter_tareo/domain/entities/esparrago_agrupa_personal_detalle_entity.dart';
import 'package:flutter_tareo/domain/entities/esparrago_agrupa_personal_entity.dart';
import 'package:flutter_tareo/domain/utils/failure.dart';
import 'package:flutter_tareo/domain/utils/result_type.dart';

class ListadoAsignacionPersonalRepositoryImplementation
    extends ListadoAsignacionPersonalRepository {
  ListadoAsignacionPersonalDatastore _datastore;
  ListadoAsignacionPersonalRepositoryImplementation(this._datastore);

  @override
  Future<ResultType<EsparragoAgrupaPersonalDetalleEntity, Failure>> addDetalle(
      EsparragoAgrupaPersonalEntity asignacion,
      EsparragoAgrupaPersonalDetalleEntity detalle) async {
    return await _datastore.addDetalle(asignacion, detalle);
  }

  @override
  Future<List<EsparragoAgrupaPersonalDetalleEntity>> getDetalles(
      int idAsignacion) async {
    return await _datastore.getDetalles(idAsignacion);
  }

  @override
  Future<EsparragoAgrupaPersonalDetalleEntity> removeDetalle(
      EsparragoAgrupaPersonalDetalleEntity detalle) {
    // TODO: implement removeDetalle
    throw UnimplementedError();
  }
}
