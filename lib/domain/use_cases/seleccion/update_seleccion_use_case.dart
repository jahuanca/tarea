
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_grupo_entity.dart';
import 'package:flutter_tareo/domain/repositories/pre_tarea_esparrago_grupo_repository.dart';

class UpdateSeleccionUseCase{
  final PreTareaEsparragoGrupoRepository _repository;

  UpdateSeleccionUseCase(this._repository);

  Future<void> execute(PreTareaEsparragoGrupoEntity pesado, int index) async{
    return await _repository.update(pesado ,index);
  }

}