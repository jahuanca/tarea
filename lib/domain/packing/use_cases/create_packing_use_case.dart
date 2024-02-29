import 'package:flutter_tareo/domain/packing/entities/pre_tareo_proceso_uva_entity.dart';
import 'package:flutter_tareo/domain/packing/repositories/packing_repository.dart';
import 'package:flutter_tareo/domain/utils/failure.dart';
import 'package:flutter_tareo/domain/utils/result_type.dart';

class CreatePackingUseCase {
  final PackingRepository _preTareoProcesoUvaRepository;

  CreatePackingUseCase(this._preTareoProcesoUvaRepository);

  Future<ResultType<PreTareoProcesoUvaEntity, Failure>> execute(
      PreTareoProcesoUvaEntity preTareoProcesoUvaEntity) async {
    return await _preTareoProcesoUvaRepository.create(preTareoProcesoUvaEntity);
  }
}
