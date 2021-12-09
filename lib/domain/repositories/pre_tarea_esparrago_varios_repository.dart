
import 'dart:io';
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_varios_entity.dart';

abstract class PreTareaEsparragoVariosRepository{

  Future<List<PreTareaEsparragoVariosEntity>> getAll();
  Future<List<PreTareaEsparragoVariosEntity>> getAllByValue(Map<String,dynamic> valores);
  Future<void> create(PreTareaEsparragoVariosEntity pesado);
  Future<PreTareaEsparragoVariosEntity> migrar(int key);
  Future<PreTareaEsparragoVariosEntity> uploadFile(PreTareaEsparragoVariosEntity pesado, File fileLocal);
  Future<void> update(PreTareaEsparragoVariosEntity pesado , int key);
  Future<void> delete(int key);
}