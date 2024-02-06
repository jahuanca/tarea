import 'dart:io';
import 'package:flutter_tareo/domain/packing/entities/pre_tareo_proceso_uva_detalle_entity.dart';
import 'package:flutter_tareo/domain/packing/entities/pre_tareo_proceso_uva_entity.dart';

abstract class PackingRepository {
  Future<List<PreTareoProcesoUvaEntity>> getAll();
  Future<List<PreTareoProcesoUvaEntity>> getAllByValue(
      Map<String, dynamic> valores);
  Future<int> create(PreTareoProcesoUvaEntity preTareaProcesoUvaEntity);
  Future<PreTareoProcesoUvaEntity> migrar(int key);
  Future<PreTareoProcesoUvaEntity> uploadFile(
      PreTareoProcesoUvaEntity preTareaProcesoUvaEntity, File fileLocal);
  Future<void> update(
      PreTareoProcesoUvaEntity preTareaProcesoUvaEntity, int key);
  Future<void> delete(int key);
  Future<Map<int, List<PreTareoProcesoUvaDetalleEntity>>> getReportByDocument(
      String code, PreTareoProcesoUvaEntity header);
}
