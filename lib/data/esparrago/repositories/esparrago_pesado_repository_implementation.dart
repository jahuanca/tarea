import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_varios_entity.dart';
import 'package:flutter_tareo/domain/esparrago/datastores/esparrago_pesado_datastore.dart';
import 'package:flutter_tareo/domain/esparrago/repositories/esparrago_pesado_repository.dart';
import 'package:flutter_tareo/domain/utils/result_type.dart';
import 'package:flutter_tareo/domain/utils/failure.dart';

class EsparragoPesadoRepositoryImplementation
    extends EsparragoPesadoRepository {
  EsparragoPesadoDataStore _dataStore;

  EsparragoPesadoRepositoryImplementation(this._dataStore);

  @override
  Future<ResultType<PreTareaEsparragoVariosEntity, Failure>> createPesado(
      PreTareaEsparragoVariosEntity pesado) async {
    return await _dataStore.createPesado(pesado);
  }

  @override
  Future<ResultType<PreTareaEsparragoVariosEntity, Failure>> deletePesado(
      PreTareaEsparragoVariosEntity detalle) async {
    return await _dataStore.deletePesado(detalle);
  }

  @override
  Future<ResultType<List<PreTareaEsparragoVariosEntity>, Failure>>
      getAll() async {
    return await _dataStore.getAll();
  }

  @override
  Future<ResultType<PreTareaEsparragoVariosEntity, Failure>> updatePesado(
      PreTareaEsparragoVariosEntity pesado, key) async {
    return await _dataStore.updatePesado(pesado, key);
  }
}
