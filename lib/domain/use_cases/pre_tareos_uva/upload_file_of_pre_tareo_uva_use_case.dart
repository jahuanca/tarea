
import 'dart:io';
import 'package:flutter_tareo/domain/entities/pre_tareo_proceso_uva_entity.dart';
import 'package:flutter_tareo/domain/repositories/pre_tareo_proceso_uva_repository.dart';

class UploadFileOfPreTareoUvaUseCase{
  final PreTareoProcesoUvaRepository _preTareoProcesoUvaRepository;

  UploadFileOfPreTareoUvaUseCase(this._preTareoProcesoUvaRepository);

  Future<PreTareoProcesoUvaEntity> execute(PreTareoProcesoUvaEntity preTareoProcesoUvaEntity, File file)async{
    return await _preTareoProcesoUvaRepository.uploadFile(preTareoProcesoUvaEntity, file);
  } 
}