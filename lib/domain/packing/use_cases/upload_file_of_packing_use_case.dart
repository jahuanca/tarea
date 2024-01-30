import 'dart:io';
import 'package:flutter_tareo/domain/packing/entities/pre_tareo_proceso_uva_entity.dart';
import 'package:flutter_tareo/domain/packing/repositories/packing_repository.dart';

class UploadFileOfPackingUseCase {
  final PackingRepository _preTareoProcesoUvaRepository;

  UploadFileOfPackingUseCase(this._preTareoProcesoUvaRepository);

  Future<PreTareoProcesoUvaEntity> execute(
      PreTareoProcesoUvaEntity preTareoProcesoUvaEntity, File file) async {
    return await _preTareoProcesoUvaRepository.uploadFile(
        preTareoProcesoUvaEntity, file);
  }
}
