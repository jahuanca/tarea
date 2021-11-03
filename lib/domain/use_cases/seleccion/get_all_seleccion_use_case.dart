

import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_grupo_entity.dart';
import 'package:flutter_tareo/domain/repositories/pre_tarea_esparrago_grupo_repository.dart';

class GetAllSeleccionUseCase{
  final PreTareaEsparragoGrupoRepository _repository;

  GetAllSeleccionUseCase(this._repository);

  Future<List<PreTareaEsparragoGrupoEntity>> execute() async{
    return await _repository.getAll();
  }

}