
import 'package:flutter_tareo/domain/entities/personal_tarea_proceso_entity.dart';

abstract class PersonalTareaProcesoRepository{
  Future<List<PersonalTareaProcesoEntity>> getAll(String box);
  Future<int> create(String box, PersonalTareaProcesoEntity detalle);
  Future<void> update(String box, int key, PersonalTareaProcesoEntity detalle);
  Future<void> delete(String box, int key);
  Future<void> deleteAll(String box);
}