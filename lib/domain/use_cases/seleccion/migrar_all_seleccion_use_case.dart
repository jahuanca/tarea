
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_grupo_entity.dart';

import 'package:flutter_tareo/domain/repositories/pre_tarea_esparrago_grupo_repository.dart';

class MigrarAllSeleccionUseCase{
  final PreTareaEsparragoGrupoRepository _repository;

  MigrarAllSeleccionUseCase(this._repository);

  Future<PreTareaEsparragoGrupoEntity> execute(int key)async{
    return await _repository.migrar(key);
  } 
}