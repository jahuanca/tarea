import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_varios_entity.dart';
import 'package:flutter_tareo/domain/esparrago/repositories/esparrago_pesado_repository.dart';
import 'package:flutter_tareo/domain/utils/failure.dart';
import 'package:flutter_tareo/domain/utils/result_type.dart';

class UpdatePesadoUseCase {
  final EsparragoPesadoRepository _repository;

  UpdatePesadoUseCase(this._repository);

  Future<ResultType<PreTareaEsparragoVariosEntity, Failure>> execute(
      PreTareaEsparragoVariosEntity pesado, int key) async {
    return await _repository.updatePesado(pesado, key);
  }
}
