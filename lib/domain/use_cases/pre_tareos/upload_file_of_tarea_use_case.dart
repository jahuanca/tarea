
import 'dart:io';
import 'package:flutter_tareo/domain/entities/pre_tareo_proceso_entity.dart';
import 'package:flutter_tareo/domain/repositories/pre_tareo_proceso_repository.dart';

class UploadFileOfPreTareoUseCase{
  final PreTareoProcesoRepository _preTareoProcesoRepository;

  UploadFileOfPreTareoUseCase(this._preTareoProcesoRepository);

  Future<PreTareoProcesoEntity> execute(PreTareoProcesoEntity PreTareoProcesoEntity, File file)async{
    return await _preTareoProcesoRepository.uploadFile(PreTareoProcesoEntity, file);
  } 
}