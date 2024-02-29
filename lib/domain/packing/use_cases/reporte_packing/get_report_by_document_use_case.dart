import 'package:flutter_tareo/domain/entities/labor_entity.dart';
import 'package:flutter_tareo/domain/packing/entities/pre_tareo_proceso_uva_entity.dart';
import 'package:flutter_tareo/domain/packing/repositories/packing_repository.dart';
import 'package:flutter_tareo/domain/utils/failure.dart';
import 'package:flutter_tareo/domain/utils/result_type.dart';

class GetReportByDocumentUseCase {
  final PackingRepository _repository;

  GetReportByDocumentUseCase(this._repository);

  Future<ResultType<List<LaborEntity>, Failure>> execute(
      String code, PreTareoProcesoUvaEntity header) async {
    return await _repository.getReportByDocument(code, header);
  }
}