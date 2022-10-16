
import 'package:flutter_tareo/domain/entities/personal_pre_tarea_esparrago_entity.dart';
import 'package:flutter_tareo/domain/repositories/personal_pre_tarea_esparrago_repository.dart';

class GetAllPersonalPreTareaEsparragoUseCase{
  final PersonalPreTareaEsparragoRepository _repository;

  GetAllPersonalPreTareaEsparragoUseCase(this._repository);

  Future<List<PersonalPreTareaEsparragoEntity>> execute(String box) async{
    return await _repository.getAll(box);
  }

}