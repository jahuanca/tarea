import 'package:flutter_tareo/domain/packing/entities/pre_tareo_proceso_uva_entity.dart';
import 'package:flutter_tareo/domain/packing/repositories/packing_repository.dart';

class MigrarAllPackingUseCase {
  final PackingRepository _preTareoProcesoUvaRepository;

  MigrarAllPackingUseCase(this._preTareoProcesoUvaRepository);

  Future<PreTareoProcesoUvaEntity> execute(int key) async {
    return await _preTareoProcesoUvaRepository.migrar(key);
  }
}
