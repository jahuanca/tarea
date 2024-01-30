import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_varios_entity.dart';
import 'package:flutter_tareo/domain/utils/failure.dart';
import 'package:flutter_tareo/domain/utils/result_type.dart';

abstract class EsparragoPesadoDataStore {
  Future<ResultType<List<PreTareaEsparragoVariosEntity>, Failure>> getAll();
  Future<ResultType<PreTareaEsparragoVariosEntity, Failure>> createPesado(
      PreTareaEsparragoVariosEntity pesado);
  Future<ResultType<PreTareaEsparragoVariosEntity, Failure>> updatePesado(
      PreTareaEsparragoVariosEntity pesado, int key);
  Future<ResultType<PreTareaEsparragoVariosEntity, Failure>> deletePesado(
      PreTareaEsparragoVariosEntity pesado);
}
