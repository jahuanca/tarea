
import 'package:flutter_tareo/domain/entities/pre_tareo_proceso_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tareo_proceso_uva_entity.dart';
import 'package:flutter_tareo/domain/repositories/pre_tareo_proceso_uva_repository.dart';

class CreatePreTareoProcesoUvaUseCase{
  final PreTareoProcesoUvaRepository _preTareoProcesoUvaRepository;

  CreatePreTareoProcesoUvaUseCase(this._preTareoProcesoUvaRepository);

  Future<void> execute(PreTareoProcesoUvaEntity preTareoProcesoUvaEntity) async{
    return await _preTareoProcesoUvaRepository.create(preTareoProcesoUvaEntity);
  }

}