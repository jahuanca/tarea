import 'dart:io';
import 'package:flutter_tareo/domain/entities/labor_entity.dart';
import 'package:flutter_tareo/domain/packing/datastores/packing_datastore.dart';
import 'package:flutter_tareo/domain/packing/entities/pre_tareo_proceso_uva_entity.dart';
import 'package:flutter_tareo/domain/packing/repositories/packing_repository.dart';
import 'package:flutter_tareo/domain/utils/result_type.dart';
import 'package:flutter_tareo/domain/utils/failure.dart';

class PackingRepositoryImplementation extends PackingRepository {
  PackingDataStore dataStore;
  PackingRepositoryImplementation(this.dataStore);

  @override
  Future<ResultType<PreTareoProcesoUvaEntity, Failure>> create(
      PreTareoProcesoUvaEntity packing) async {
    return await dataStore.create(packing);
  }

  @override
  Future<ResultType<PreTareoProcesoUvaEntity, Failure>> delete(
      PreTareoProcesoUvaEntity packing) async {
    return await dataStore.delete(packing);
  }

  @override
  Future<ResultType<List<PreTareoProcesoUvaEntity>, Failure>> getAll() async {
    return await dataStore.getAll();
  }

  @override
  Future<ResultType<List<PreTareoProcesoUvaEntity>, Failure>> getAllByValue(
      Map<String, dynamic> valores) async {
    return await dataStore.getAllByValue(valores);
  }

  @override
  Future<ResultType<List<LaborEntity>, Failure>> getReportByDocument(
      String code, PreTareoProcesoUvaEntity header) async {
    return await dataStore.getReportByDocument(code, header);
  }

  @override
  Future<ResultType<PreTareoProcesoUvaEntity, Failure>> migrar(
      PreTareoProcesoUvaEntity packing) async {
    return await dataStore.migrar(packing);
  }

  @override
  Future<ResultType<PreTareoProcesoUvaEntity, Failure>> update(
      PreTareoProcesoUvaEntity packing) async {
    return await dataStore.update(packing);
  }

  @override
  Future<ResultType<PreTareoProcesoUvaEntity, Failure>> uploadFile(
      PreTareoProcesoUvaEntity packing, File fileLocal) async {
    return await dataStore.uploadFile(packing, fileLocal);
  }
}
