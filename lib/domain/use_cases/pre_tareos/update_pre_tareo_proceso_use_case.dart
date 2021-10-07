
import 'package:flutter_tareo/domain/entities/pre_tareo_proceso_entity.dart';
import 'package:flutter_tareo/domain/repositories/pre_tareo_proceso_repository.dart';

class UpdatePreTareoProcesoUseCase{
  final PreTareoProcesoRepository _preTareoProcesoRepository;

  UpdatePreTareoProcesoUseCase(this._preTareoProcesoRepository);

  Future<void> execute(PreTareoProcesoEntity preTareoProcesoEntity, int index) async{
    return await _preTareoProcesoRepository.update(preTareoProcesoEntity ,index);
  }

}