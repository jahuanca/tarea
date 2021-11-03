
import 'dart:io';
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_varios_entity.dart';
import 'package:flutter_tareo/domain/repositories/pre_tarea_esparrago_varios_repository.dart';

class UploadFileOfPesadoUseCase{
  final PreTareaEsparragoVariosRepository _repository;

  UploadFileOfPesadoUseCase(this._repository);

  Future<PreTareaEsparragoVariosEntity> execute(PreTareaEsparragoVariosEntity pesado, File file)async{
    return await _repository.uploadFile(pesado, file);
  } 
}