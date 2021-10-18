
import 'package:flutter_tareo/domain/entities/pre_tareo_proceso_uva_entity.dart';
import 'package:flutter_tareo/domain/repositories/pre_tareo_proceso_uva_repository.dart';

class UpdatePreTareoProcesoUvaUseCase{
  final PreTareoProcesoUvaRepository _preTareoProcesoUvaRepository;

  UpdatePreTareoProcesoUvaUseCase(this._preTareoProcesoUvaRepository);

  Future<void> execute(PreTareoProcesoUvaEntity preTareoProcesoUvaEntity, int index) async{
    return await _preTareoProcesoUvaRepository.update(preTareoProcesoUvaEntity ,index);
  }

}