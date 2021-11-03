
import 'dart:io';
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_entity.dart';
import 'package:flutter_tareo/domain/repositories/pre_tarea_esparrago_repository.dart';

class UploadFileOfClasificacionUseCase{
  final PreTareaEsparragoRepository _repository;

  UploadFileOfClasificacionUseCase(this._repository);

  Future<PreTareaEsparragoEntity> execute(PreTareaEsparragoEntity pesado, File file)async{
    return await _repository.uploadFile(pesado, file);
  } 
}