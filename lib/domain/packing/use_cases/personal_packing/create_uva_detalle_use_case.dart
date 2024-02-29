import 'package:flutter_tareo/domain/packing/entities/pre_tareo_proceso_uva_detalle_entity.dart';
import 'package:flutter_tareo/domain/packing/repositories/personal_packing_repository.dart';
import 'package:flutter_tareo/domain/utils/failure.dart';
import 'package:flutter_tareo/domain/utils/result_type.dart';

class CreateUvaDetalleUseCase {
  final PersonalPackingRepository _uvaDetalle;

  CreateUvaDetalleUseCase(this._uvaDetalle);

  Future<ResultType<PreTareoProcesoUvaDetalleEntity, Failure>> execute(
      PreTareoProcesoUvaDetalleEntity detalle) async {
    return await _uvaDetalle.create(detalle);
  }
}
