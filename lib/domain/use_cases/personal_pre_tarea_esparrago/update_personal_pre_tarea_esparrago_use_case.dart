
import 'package:flutter_tareo/domain/entities/personal_pre_tarea_esparrago_entity.dart';
import 'package:flutter_tareo/domain/repositories/personal_pre_tarea_esparrago_repository.dart';

class UpdatePersonalPreTareaEsparragoUseCase{
  final PersonalPreTareaEsparragoRepository _repository;

  UpdatePersonalPreTareaEsparragoUseCase(this._repository);

  Future<void> execute(String box, int key, PersonalPreTareaEsparragoEntity detalle) async{
    return await _repository.update(box, key, detalle);
  }

}