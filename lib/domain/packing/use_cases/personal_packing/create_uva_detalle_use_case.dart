import 'package:flutter_tareo/domain/packing/entities/pre_tareo_proceso_uva_detalle_entity.dart';
import 'package:flutter_tareo/domain/packing/repositories/personal_packing_repository.dart';

class CreateUvaDetalleUseCase {
  final PersonalPackingRepository _uvaDetalle;

  CreateUvaDetalleUseCase(this._uvaDetalle);

  Future<int> execute(
      String box, PreTareoProcesoUvaDetalleEntity detalle) async {
    return await _uvaDetalle.create(box, detalle);
  }
}
