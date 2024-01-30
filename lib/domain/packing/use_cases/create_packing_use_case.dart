import 'package:flutter_tareo/domain/packing/entities/pre_tareo_proceso_uva_entity.dart';
import 'package:flutter_tareo/domain/packing/repositories/packing_repository.dart';

class CreatePackingUseCase {
  final PackingRepository _preTareoProcesoUvaRepository;

  CreatePackingUseCase(this._preTareoProcesoUvaRepository);

  Future<int> execute(PreTareoProcesoUvaEntity preTareoProcesoUvaEntity) async {
    return await _preTareoProcesoUvaRepository.create(preTareoProcesoUvaEntity);
  }
}
