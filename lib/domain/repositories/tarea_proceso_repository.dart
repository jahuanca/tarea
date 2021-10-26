
import 'dart:io';

import 'package:flutter_tareo/domain/entities/tarea_proceso_entity.dart';

abstract class TareaProcesoRepository{

  Future<List<TareaProcesoEntity>> getAll();
  Future<int> create(TareaProcesoEntity tareaProcesoEntity);
  Future<TareaProcesoEntity> migrar(TareaProcesoEntity tareaProcesoEntity);
  Future<TareaProcesoEntity> uploadFile(TareaProcesoEntity tareaProcesoEntity, File fileLocal);
  Future<void> update(TareaProcesoEntity tareaProcesoEntity , int key);
  Future<void> delete(int key);
}