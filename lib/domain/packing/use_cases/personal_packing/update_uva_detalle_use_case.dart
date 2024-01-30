import 'package:flutter_tareo/domain/packing/entities/pre_tareo_proceso_uva_detalle_entity.dart';
import 'package:flutter_tareo/domain/packing/repositories/personal_packing_repository.dart';

class UpdateUvaDetalleUseCase {
  final PersonalPackingRepository _uvaDetalle;

  UpdateUvaDetalleUseCase(this._uvaDetalle);

  Future<void> execute(
      String box, int key, PreTareoProcesoUvaDetalleEntity detalle) async {
    return await _uvaDetalle.update(box, key, detalle);
  }
}
