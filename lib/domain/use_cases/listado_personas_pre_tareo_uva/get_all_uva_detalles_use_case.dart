
import 'package:flutter_tareo/domain/entities/pre_tareo_proceso_uva_detalle_entity.dart';
import 'package:flutter_tareo/domain/repositories/pre_tareo_proceso_uva_detalles_repository.dart';

class GetAllUvaDetallesUseCase{
  final PreTareoProcesoUvaDetallesRepository _uvaDetalle;

  GetAllUvaDetallesUseCase(this._uvaDetalle);

  Future<List<PreTareoProcesoUvaDetalleEntity>> execute(String box) async{
    return await _uvaDetalle.getAll(box);
  }

}