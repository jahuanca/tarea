import 'package:flutter_tareo/domain/entities/personal_pre_tarea_esparrago_entity.dart';
import 'package:flutter_tareo/domain/esparrago/repositories/personal_esparrago_pesado_repository.dart';

class UpdatePersonalEsparragoPesadoUseCase {
  final PersonalEsparragoPesadoRepository _repository;

  UpdatePersonalEsparragoPesadoUseCase(this._repository);

  Future<void> execute(
      String box, int key, PersonalPreTareaEsparragoEntity detalle) async {
    return await _repository.update(box, key, detalle);
  }
}
