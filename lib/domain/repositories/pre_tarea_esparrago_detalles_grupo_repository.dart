
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_detalle_grupo_entity.dart';

abstract class PreTareaEsparragoDetallesGrupoRepository{

  Future<List<PreTareaEsparragoDetalleGrupoEntity>> getAll(String box);
  Future<int> create(String box, PreTareaEsparragoDetalleGrupoEntity detalle);
  Future<void> update(String box, int key, PreTareaEsparragoDetalleGrupoEntity detalle);
  Future<void> delete(String box, int key);
  Future<void> deleteAll(String box);
}