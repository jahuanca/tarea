
import 'dart:io';
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_grupo_entity.dart';
import 'package:flutter_tareo/domain/repositories/pre_tarea_esparrago_grupo_repository.dart';

class UploadFileOfSeleccionUseCase{
  final PreTareaEsparragoGrupoRepository _repository;

  UploadFileOfSeleccionUseCase(this._repository);

  Future<PreTareaEsparragoGrupoEntity> execute(PreTareaEsparragoGrupoEntity pesado, File file)async{
    return await _repository.uploadFile(pesado, file);
  } 
}