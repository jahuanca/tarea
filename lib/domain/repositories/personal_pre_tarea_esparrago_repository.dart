
import 'package:flutter_tareo/domain/entities/personal_pre_tarea_esparrago_entity.dart';

abstract class PersonalPreTareaEsparragoRepository{

  Future<List<PersonalPreTareaEsparragoEntity>> getAll(String box);
  Future<int> create(String box, PersonalPreTareaEsparragoEntity detalle);
  Future<void> update(String box, int key, PersonalPreTareaEsparragoEntity detalle);
  Future<void> delete(String box, int key);
  Future<void> deleteAll(String box);
}