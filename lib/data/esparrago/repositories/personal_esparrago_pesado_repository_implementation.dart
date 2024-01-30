import 'package:flutter_tareo/domain/entities/personal_pre_tarea_esparrago_entity.dart';
import 'package:flutter_tareo/domain/esparrago/datastores/personal_esparrago_pesado_datastore.dart';
import 'package:flutter_tareo/domain/esparrago/repositories/personal_esparrago_pesado_repository.dart';
import 'package:flutter_tareo/domain/utils/failure.dart';
import 'package:flutter_tareo/domain/utils/result_type.dart';

class PersonalEsparragoPesadoRepositoryImplementation
    extends PersonalEsparragoPesadoRepository {
  PersonalEsparragoPesadoDatastore _datastore;

  PersonalEsparragoPesadoRepositoryImplementation(this._datastore);

  @override
  Future<ResultType<List<PersonalPreTareaEsparragoEntity>, Failure>> getAll(
      Map<String, dynamic> query) async {
    return _datastore.getAll(query);
  }

  @override
  Future<ResultType<PersonalPreTareaEsparragoEntity, Failure>> create(
      String box, PersonalPreTareaEsparragoEntity detalle) async {
    return await _datastore.create(box, detalle);
  }

  @override
  Future<ResultType<PersonalPreTareaEsparragoEntity, Failure>> delete(
      PersonalPreTareaEsparragoEntity detalle) async {
    return await _datastore.delete(detalle);
  }

  @override
  Future<void> deleteAll(String box) async {
    return await _datastore.deleteAll(box);
  }

  @override
  Future<void> update(
      String box, int key, PersonalPreTareaEsparragoEntity detalle) async {
    return await _datastore.update(box, key, detalle);
  }
}
