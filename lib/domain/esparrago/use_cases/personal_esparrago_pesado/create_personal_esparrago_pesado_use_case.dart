import 'package:flutter_tareo/domain/entities/personal_pre_tarea_esparrago_entity.dart';
import 'package:flutter_tareo/domain/esparrago/repositories/personal_esparrago_pesado_repository.dart';
import 'package:flutter_tareo/domain/utils/result_type.dart';
import 'package:flutter_tareo/domain/utils/failure.dart';

class CreatePersonalEsparragoPesadoUseCase {
  final PersonalEsparragoPesadoRepository _repository;

  CreatePersonalEsparragoPesadoUseCase(this._repository);

  Future<ResultType<PersonalPreTareaEsparragoEntity, Failure>> execute(
      String box, PersonalPreTareaEsparragoEntity detalle) async {
    return await _repository.create(box, detalle);
  }
}
