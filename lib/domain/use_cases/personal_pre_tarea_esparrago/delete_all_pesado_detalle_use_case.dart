
import 'package:flutter_tareo/domain/repositories/personal_pre_tarea_esparrago_repository.dart';

class DeleteAllPersonalPreTareaEsparragoUseCase{
  final PersonalPreTareaEsparragoRepository _repository;

  DeleteAllPersonalPreTareaEsparragoUseCase(this._repository);

  Future<void> execute(String box) async{
    return await _repository.deleteAll(box);
  }

}