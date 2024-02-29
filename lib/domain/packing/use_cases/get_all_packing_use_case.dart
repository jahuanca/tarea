import 'package:flutter_tareo/domain/packing/entities/pre_tareo_proceso_uva_entity.dart';
import 'package:flutter_tareo/domain/packing/repositories/packing_repository.dart';
import 'package:flutter_tareo/domain/utils/failure.dart';
import 'package:flutter_tareo/domain/utils/result_type.dart';

class GetAllPackingUseCase {
  final PackingRepository _preTareoProcesoUvaRepository;

  GetAllPackingUseCase(this._preTareoProcesoUvaRepository);

  Future<ResultType<List<PreTareoProcesoUvaEntity>, Failure>> execute() async {
    return await _preTareoProcesoUvaRepository.getAll();
  }
}
