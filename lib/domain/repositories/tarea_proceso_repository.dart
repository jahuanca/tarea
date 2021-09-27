
import 'package:flutter_tareo/domain/entities/tarea_proceso_entity.dart';

abstract class TareaProcesoRepository{

  Future<List<TareaProcesoEntity>> getAll();
  Future<void> create(TareaProcesoEntity tareaProcesoEntity);
  Future<void> migrar(TareaProcesoEntity tareaProcesoEntity);
  Future<void> update(TareaProcesoEntity tareaProcesoEntity , int index);
  Future<void> delete(int index);
}