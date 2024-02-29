import 'package:flutter_tareo/domain/packing/entities/pre_tareo_proceso_uva_entity.dart';
import 'package:flutter_tareo/domain/packing/repositories/personal_packing_repository.dart';
import 'package:flutter_tareo/domain/utils/failure.dart';
import 'package:flutter_tareo/domain/utils/result_type.dart';

class DeleteUvaDetalleUseCase {
  final PersonalPackingRepository _uvaDetalle;

  DeleteUvaDetalleUseCase(this._uvaDetalle);

  Future<ResultType<PreTareoProcesoUvaEntity, Failure>> execute(
      PreTareoProcesoUvaEntity header) async {
    return await _uvaDetalle.deleteAll(header);
  }
}
