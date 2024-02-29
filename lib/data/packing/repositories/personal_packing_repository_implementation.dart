import 'package:flutter_tareo/domain/packing/datastores/personal_packing_datastore.dart';
import 'package:flutter_tareo/domain/packing/entities/pre_tareo_proceso_uva_detalle_entity.dart';
import 'package:flutter_tareo/domain/packing/entities/pre_tareo_proceso_uva_entity.dart';
import 'package:flutter_tareo/domain/packing/repositories/personal_packing_repository.dart';
import 'package:flutter_tareo/domain/utils/result_type.dart';
import 'package:flutter_tareo/domain/utils/failure.dart';

class PersonalPackingRepositoryImplementation
    extends PersonalPackingRepository {
  PersonalPackingDatastore datastore;

  PersonalPackingRepositoryImplementation(this.datastore);

  @override
  Future<ResultType<PreTareoProcesoUvaDetalleEntity, Failure>> create(
      PreTareoProcesoUvaDetalleEntity detalle) async {
    return await datastore.create(detalle);
  }

  @override
  Future<ResultType<PreTareoProcesoUvaDetalleEntity, Failure>> createAll(
      String box, List<PreTareoProcesoUvaDetalleEntity> detalles) async {
    return await datastore.createAll(box, detalles);
  }

  @override
  Future<ResultType<PreTareoProcesoUvaDetalleEntity, Failure>> delete(
      PreTareoProcesoUvaDetalleEntity detalle) async {
    return await datastore.delete(detalle);
  }

  @override
  Future<ResultType<PreTareoProcesoUvaEntity, Failure>> deleteAll(
      PreTareoProcesoUvaEntity header) async {
    return await datastore.deleteAll(header);
  }

  @override
  Future<ResultType<List<PreTareoProcesoUvaDetalleEntity>, Failure>> getAll(
      PreTareoProcesoUvaEntity header) async {
    return await datastore.getAll(header);
  }

  @override
  Future<ResultType<PreTareoProcesoUvaDetalleEntity, Failure>> update(
      PreTareoProcesoUvaDetalleEntity detalle) async {
    return await datastore.update(detalle);
  }
}
