import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_varios_entity.dart';
import 'package:flutter_tareo/domain/esparrago/repositories/esparrago_pesado_repository.dart';
import 'package:flutter_tareo/domain/utils/failure.dart';
import 'package:flutter_tareo/domain/utils/result_type.dart';

class GetAllPesadoUseCase {
  final EsparragoPesadoRepository _repository;

  GetAllPesadoUseCase(this._repository);

  Future<ResultType<List<PreTareaEsparragoVariosEntity>, Failure>>
      execute() async {
    return await _repository.getAll();
  }
}
