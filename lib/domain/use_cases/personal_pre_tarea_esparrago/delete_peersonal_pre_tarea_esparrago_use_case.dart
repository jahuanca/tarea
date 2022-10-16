
import 'package:flutter_tareo/domain/repositories/personal_pre_tarea_esparrago_repository.dart';

class DeletePersonalPreTareaEsparragoUseCase{
  final PersonalPreTareaEsparragoRepository _repository;

  DeletePersonalPreTareaEsparragoUseCase(this._repository);

  Future<void> execute(String box, int key) async{
    return await _repository.delete(box, key);
  }

}