
import 'package:flutter_tareo/domain/entities/personal_pre_tarea_esparrago_entity.dart';
import 'package:flutter_tareo/domain/repositories/personal_pre_tarea_esparrago_repository.dart';

class CreatePersonalPreTareaEsparragoUseCase{
  final PersonalPreTareaEsparragoRepository _repository;

  CreatePersonalPreTareaEsparragoUseCase(this._repository);

  Future<int> execute(String box, PersonalPreTareaEsparragoEntity detalle) async{
    return await _repository.create(box, detalle);
  }
}