import 'dart:io';
import 'package:flutter_tareo/domain/entities/labor_entity.dart';
import 'package:flutter_tareo/domain/packing/entities/pre_tareo_proceso_uva_entity.dart';
import 'package:flutter_tareo/domain/utils/failure.dart';
import 'package:flutter_tareo/domain/utils/result_type.dart';

abstract class PackingDataStore {
  Future<ResultType<List<PreTareoProcesoUvaEntity>, Failure>> getAll();
  Future<ResultType<List<PreTareoProcesoUvaEntity>, Failure>> getAllByValue(
      Map<String, dynamic> valores);
  Future<ResultType<PreTareoProcesoUvaEntity, Failure>> create(
      PreTareoProcesoUvaEntity packing);
  Future<ResultType<PreTareoProcesoUvaEntity, Failure>> migrar(
      PreTareoProcesoUvaEntity packing);
  Future<ResultType<PreTareoProcesoUvaEntity, Failure>> uploadFile(
      PreTareoProcesoUvaEntity packing, File fileLocal);
  Future<ResultType<PreTareoProcesoUvaEntity, Failure>> update(
      PreTareoProcesoUvaEntity packing);
  Future<ResultType<PreTareoProcesoUvaEntity, Failure>> delete(
      PreTareoProcesoUvaEntity packing);
  Future<ResultType<List<LaborEntity>, Failure>> getReportByDocument(
      String code, PreTareoProcesoUvaEntity header);
}
