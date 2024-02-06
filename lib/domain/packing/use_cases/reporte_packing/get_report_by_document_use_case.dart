import 'package:flutter_tareo/domain/packing/entities/pre_tareo_proceso_uva_detalle_entity.dart';
import 'package:flutter_tareo/domain/packing/entities/pre_tareo_proceso_uva_entity.dart';
import 'package:flutter_tareo/domain/packing/repositories/packing_repository.dart';

class GetReportByDocumentUseCase {
  final PackingRepository _repository;

  GetReportByDocumentUseCase(this._repository);

  Future<Map<int, List<PreTareoProcesoUvaDetalleEntity>>> execute(
      String code, PreTareoProcesoUvaEntity header) async {
    return await _repository.getReportByDocument(code, header);
  }
}
