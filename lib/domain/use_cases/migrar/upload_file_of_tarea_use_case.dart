
import 'dart:io';

import 'package:flutter_tareo/domain/entities/tarea_proceso_entity.dart';
import 'package:flutter_tareo/domain/repositories/tarea_proceso_repository.dart';

class UploadFileOfTareaUseCase{
  final TareaProcesoRepository _tareaProcesoRepository;

  UploadFileOfTareaUseCase(this._tareaProcesoRepository);

  Future<TareaProcesoEntity> execute(TareaProcesoEntity tareaProcesoEntity, File file)async{
    return await _tareaProcesoRepository.uploadFile(tareaProcesoEntity, file);
  } 
}