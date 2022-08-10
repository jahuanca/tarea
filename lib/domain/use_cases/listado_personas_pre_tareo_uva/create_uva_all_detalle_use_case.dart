
import 'package:flutter_tareo/domain/entities/pre_tareo_proceso_uva_detalle_entity.dart';
import 'package:flutter_tareo/domain/repositories/pre_tareo_proceso_uva_detalles_repository.dart';

class CreateUvaAllDetalleUseCase{
  final PreTareoProcesoUvaDetallesRepository _uvaDetalle;

  CreateUvaAllDetalleUseCase(this._uvaDetalle);

  Future<void> execute(String box, List<PreTareoProcesoUvaDetalleEntity> detalle) async{
    return await _uvaDetalle.createAll(box, detalle);
  }
}