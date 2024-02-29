import 'package:flutter_tareo/domain/packing/entities/pre_tareo_proceso_uva_detalle_entity.dart';
import 'package:flutter_tareo/domain/packing/entities/pre_tareo_proceso_uva_entity.dart';
import 'package:flutter_tareo/domain/utils/failure.dart';
import 'package:flutter_tareo/domain/utils/result_type.dart';

abstract class PersonalPackingDatastore {
  Future<ResultType<List<PreTareoProcesoUvaDetalleEntity>, Failure>> getAll(
      PreTareoProcesoUvaEntity header);
  Future<ResultType<PreTareoProcesoUvaDetalleEntity, Failure>> create(
      PreTareoProcesoUvaDetalleEntity detalle);
  Future<ResultType<PreTareoProcesoUvaDetalleEntity, Failure>> createAll(
      String box, List<PreTareoProcesoUvaDetalleEntity> detalles);
  Future<ResultType<PreTareoProcesoUvaDetalleEntity, Failure>> update(
      PreTareoProcesoUvaDetalleEntity detalle);
  Future<ResultType<PreTareoProcesoUvaDetalleEntity, Failure>> delete(
      PreTareoProcesoUvaDetalleEntity detalle);
  Future<ResultType<PreTareoProcesoUvaEntity, Failure>> deleteAll(
      PreTareoProcesoUvaEntity header);
}
