
import 'package:flutter_tareo/domain/entities/pre_tareo_proceso_uva_detalle_entity.dart';
import 'package:flutter_tareo/domain/repositories/pre_tareo_proceso_uva_detalles_repository.dart';

class UpdateUvaDetalleUseCase{
  final PreTareoProcesoUvaDetallesRepository _uvaDetalle;

  UpdateUvaDetalleUseCase(this._uvaDetalle);

  Future<void> execute(String box, int key, PreTareoProcesoUvaDetalleEntity detalle) async{
    return await _uvaDetalle.update(box, key, detalle);
  }

}