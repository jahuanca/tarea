import 'package:flutter_tareo/domain/packing/entities/pre_tareo_proceso_uva_entity.dart';
import 'package:flutter_tareo/domain/packing/repositories/packing_repository.dart';

class UpdatePackingUseCase {
  final PackingRepository _preTareoProcesoUvaRepository;

  UpdatePackingUseCase(this._preTareoProcesoUvaRepository);

  Future<void> execute(
      PreTareoProcesoUvaEntity preTareoProcesoUvaEntity, int key) async {
    return await _preTareoProcesoUvaRepository.update(
        preTareoProcesoUvaEntity, key);
  }
}
