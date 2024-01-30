import 'package:flutter_tareo/domain/entities/personal_pre_tarea_esparrago_entity.dart';
import 'package:flutter_tareo/domain/esparrago/repositories/personal_esparrago_pesado_repository.dart';
import 'package:flutter_tareo/domain/utils/failure.dart';
import 'package:flutter_tareo/domain/utils/result_type.dart';

class DeletePersonalEsparragoPesadoUseCase {
  final PersonalEsparragoPesadoRepository _repository;

  DeletePersonalEsparragoPesadoUseCase(this._repository);

  Future<ResultType<PersonalPreTareaEsparragoEntity, Failure>> execute(
          PersonalPreTareaEsparragoEntity detalle) async =>
      await _repository.delete(detalle);
}
