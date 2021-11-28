
import 'package:flutter_tareo/domain/repositories/pre_tareo_proceso_uva_detalles_repository.dart';

class DeleteUvaDetalleUseCase{
  final PreTareoProcesoUvaDetallesRepository _uvaDetalle;

  DeleteUvaDetalleUseCase(this._uvaDetalle);

  Future<void> execute(String box) async{
    return await _uvaDetalle.deleteAll(box);
  }

}