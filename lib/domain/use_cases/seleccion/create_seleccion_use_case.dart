
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_grupo_entity.dart';
import 'package:flutter_tareo/domain/repositories/pre_tarea_esparrago_grupo_repository.dart';

class CreateSeleccionUseCase{
  final PreTareaEsparragoGrupoRepository _repository;

  CreateSeleccionUseCase(this._repository);

  Future<void> execute(PreTareaEsparragoGrupoEntity pesado) async{
    return await _repository.create(pesado);
  }

}