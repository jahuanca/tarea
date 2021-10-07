
import 'dart:io';
import 'package:flutter_tareo/domain/entities/pre_tareo_proceso_entity.dart';

abstract class PreTareoProcesoRepository{

  Future<List<PreTareoProcesoEntity>> getAll();
  Future<List<PreTareoProcesoEntity>> getAllByValue(Map<String,dynamic> valores);
  Future<void> create(PreTareoProcesoEntity tareaProcesoEntity);
  Future<PreTareoProcesoEntity> migrar(PreTareoProcesoEntity tareaProcesoEntity);
  Future<PreTareoProcesoEntity> uploadFile(PreTareoProcesoEntity tareaProcesoEntity, File fileLocal);
  Future<void> update(PreTareoProcesoEntity tareaProcesoEntity , int index);
  Future<void> delete(int index);
}