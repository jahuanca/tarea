import 'package:flutter_tareo/domain/entities/personal_pre_tarea_esparrago_entity.dart';
import 'package:flutter_tareo/domain/utils/failure.dart';
import 'package:flutter_tareo/domain/utils/result_type.dart';

abstract class PersonalEsparragoPesadoDatastore {
  Future<ResultType<List<PersonalPreTareaEsparragoEntity>, Failure>> getAll(
      Map<String, dynamic> query);
  Future<ResultType<PersonalPreTareaEsparragoEntity, Failure>> create(
      String box, PersonalPreTareaEsparragoEntity detalle);
  Future<void> update(
      String box, int key, PersonalPreTareaEsparragoEntity detalle);
  Future<ResultType<PersonalPreTareaEsparragoEntity, Failure>> delete(
      PersonalPreTareaEsparragoEntity detalle);
  Future<void> deleteAll(String box);
}
