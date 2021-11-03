
import 'package:flutter_tareo/domain/repositories/pre_tarea_esparrago_varios_repository.dart';

class DeletePesadoUseCase{
  final PreTareaEsparragoVariosRepository _repository;

  DeletePesadoUseCase(this._repository);

  Future<void> execute(int index) async{
    return await _repository.delete(index);
  }

}