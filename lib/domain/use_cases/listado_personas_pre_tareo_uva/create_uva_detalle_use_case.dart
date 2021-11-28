
import 'package:flutter_tareo/domain/entities/pre_tareo_proceso_uva_detalle_entity.dart';
import 'package:flutter_tareo/domain/repositories/pre_tareo_proceso_uva_detalles_repository.dart';

class CreateUvaDetalleUseCase{
  final PreTareoProcesoUvaDetallesRepository _uvaDetalle;

  CreateUvaDetalleUseCase(this._uvaDetalle);

  Future<int> execute(String box, PreTareoProcesoUvaDetalleEntity detalle) async{
    return await _uvaDetalle.create(box, detalle);
  }
}