
import 'dart:io';
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_entity.dart';

abstract class PreTareaEsparragoRepository{

  Future<List<PreTareaEsparragoEntity>> getAll();
  Future<List<PreTareaEsparragoEntity>> getAllByValue(Map<String,dynamic> valores);
  Future<void> create(PreTareaEsparragoEntity pesado);
  Future<PreTareaEsparragoEntity> migrar(int key);
  Future<PreTareaEsparragoEntity> uploadFile(PreTareaEsparragoEntity pesado, File fileLocal);
  Future<void> update(PreTareaEsparragoEntity pesado , int key);
  Future<void> delete(int index);
}