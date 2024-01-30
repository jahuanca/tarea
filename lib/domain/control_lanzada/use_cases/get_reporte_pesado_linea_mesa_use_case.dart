import 'package:flutter_tareo/domain/control_lanzada/entities/reporte_pesado_linea_mesa_entity.dart';
import 'package:flutter_tareo/domain/control_lanzada/repositories/control_lanzada_repository.dart';
import 'package:flutter_tareo/domain/utils/failure.dart';
import 'package:flutter_tareo/domain/utils/result_type.dart';

class GetReportePesadoLineaMesaUseCase {
  final ControlLanzadaRepository _repository;

  GetReportePesadoLineaMesaUseCase(this._repository);

  Future<ResultType<ReportePesadoLineaMesaEntity, Failure>> execute(
      Map<String, dynamic> values) async {
    return await _repository.getReportePesadoLineaMesa(values);
  }
}
