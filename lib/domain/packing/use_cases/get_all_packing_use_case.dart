import 'package:flutter_tareo/domain/packing/entities/pre_tareo_proceso_uva_entity.dart';
import 'package:flutter_tareo/domain/packing/repositories/packing_repository.dart';

class GetAllPackingUseCase {
  final PackingRepository _preTareoProcesoUvaRepository;

  GetAllPackingUseCase(this._preTareoProcesoUvaRepository);

  Future<List<PreTareoProcesoUvaEntity>> execute() async {
    return await _preTareoProcesoUvaRepository.getAll();
  }
}
