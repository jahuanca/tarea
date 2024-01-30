import 'package:flutter_tareo/domain/packing/entities/pre_tareo_proceso_uva_detalle_entity.dart';
import 'package:flutter_tareo/domain/packing/repositories/personal_packing_repository.dart';

class GetAllUvaDetallesUseCase {
  final PersonalPackingRepository _uvaDetalle;

  GetAllUvaDetallesUseCase(this._uvaDetalle);

  Future<List<PreTareoProcesoUvaDetalleEntity>> execute(String box) async {
    return await _uvaDetalle.getAll(box);
  }
}
