import 'package:flutter_tareo/domain/packing/entities/pre_tareo_proceso_uva_detalle_entity.dart';
import 'package:flutter_tareo/domain/packing/entities/pre_tareo_proceso_uva_entity.dart';
import 'package:flutter_tareo/domain/packing/repositories/personal_packing_repository.dart';
import 'package:flutter_tareo/domain/utils/failure.dart';
import 'package:flutter_tareo/domain/utils/result_type.dart';

class GetAllUvaDetallesUseCase {
  final PersonalPackingRepository _uvaDetalle;

  GetAllUvaDetallesUseCase(this._uvaDetalle);

  Future<ResultType<List<PreTareoProcesoUvaDetalleEntity>, Failure>> execute(
      PreTareoProcesoUvaEntity header) async {
    return await _uvaDetalle.getAll(header);
  }
}
