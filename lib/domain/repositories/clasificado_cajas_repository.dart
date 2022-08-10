
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_formato_entity.dart';

abstract class ClasificadoCajasRepository{

  Future<List<PreTareaEsparragoFormatoEntity>> getAll(String box);
  Future<int> create(String box, PreTareaEsparragoFormatoEntity detalle);
  Future<void> update(String box, int key, PreTareaEsparragoFormatoEntity detalle);
  Future<void> delete(String box, int key);
  Future<void> deleteAll(String box);
}