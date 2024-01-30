import 'package:flutter_tareo/domain/control_lanzada/entities/resumen_lanzada_entity.dart';
import 'package:flutter_tareo/domain/control_lanzada/repositories/control_lanzada_repository.dart';
import 'package:flutter_tareo/domain/utils/failure.dart';
import 'package:flutter_tareo/domain/utils/result_type.dart';

class GetResumenLanzaUseCase {
  final ControlLanzadaRepository _repository;

  GetResumenLanzaUseCase(this._repository);

  Future<ResultType<List<ResumenLanzadaEntity>, Failure>> execute(
      int itempretareaesparragovarios) async {
    return await _repository.getResumen(itempretareaesparragovarios);
  }
}
