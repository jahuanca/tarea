
import 'dart:io';
import 'package:flutter_tareo/domain/entities/pre_tareo_proceso_uva_entity.dart';

abstract class PreTareoProcesoUvaRepository{

  Future<List<PreTareoProcesoUvaEntity>> getAll();
  Future<List<PreTareoProcesoUvaEntity>> getAllByValue(Map<String,dynamic> valores);
  Future<int> create(PreTareoProcesoUvaEntity preTareaProcesoUvaEntity);
  Future<PreTareoProcesoUvaEntity> migrar(PreTareoProcesoUvaEntity preTareaProcesoUvaEntity);
  Future<PreTareoProcesoUvaEntity> uploadFile(PreTareoProcesoUvaEntity preTareaProcesoUvaEntity, File fileLocal);
  Future<void> update(PreTareoProcesoUvaEntity preTareaProcesoUvaEntity , int key);
  Future<void> delete(int key);
}