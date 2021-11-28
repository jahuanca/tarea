
import 'package:flutter_tareo/domain/entities/pre_tareo_proceso_uva_entity.dart';
import 'package:flutter_tareo/domain/repositories/pre_tareo_proceso_uva_repository.dart';

class MigrarAllPreTareoUvaUseCase{
  final PreTareoProcesoUvaRepository _preTareoProcesoUvaRepository;

  MigrarAllPreTareoUvaUseCase(this._preTareoProcesoUvaRepository);

  Future<PreTareoProcesoUvaEntity> execute(int key)async{
    return await _preTareoProcesoUvaRepository.migrar(key);
  } 
}