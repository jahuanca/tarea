import 'package:flutter_tareo/domain/packing/entities/pre_tareo_proceso_uva_detalle_entity.dart';
import 'package:flutter_tareo/domain/packing/repositories/personal_packing_repository.dart';

class CreateUvaAllDetalleUseCase {
  final PersonalPackingRepository _uvaDetalle;

  CreateUvaAllDetalleUseCase(this._uvaDetalle);

  Future<void> execute(
      String box, List<PreTareoProcesoUvaDetalleEntity> detalle) async {
    return await _uvaDetalle.createAll(box, detalle);
  }
}
