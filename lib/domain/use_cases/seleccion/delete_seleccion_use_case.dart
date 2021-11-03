
import 'package:flutter_tareo/domain/repositories/pre_tarea_esparrago_grupo_repository.dart';

class DeleteSeleccionUseCase{
  final PreTareaEsparragoGrupoRepository _repository;

  DeleteSeleccionUseCase(this._repository);

  Future<void> execute(int index) async{
    return await _repository.delete(index);
  }

}