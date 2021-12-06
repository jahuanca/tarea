
import 'package:flutter_tareo/domain/repositories/pre_tarea_esparrago_detalles_grupo_repository.dart';

class DeleteAllSeleccionDetalleUseCase{
  final PreTareaEsparragoDetallesGrupoRepository _seleccionDetalle;

  DeleteAllSeleccionDetalleUseCase(this._seleccionDetalle);

  Future<void> execute(String box) async{
    return await _seleccionDetalle.deleteAll(box);
  }

}