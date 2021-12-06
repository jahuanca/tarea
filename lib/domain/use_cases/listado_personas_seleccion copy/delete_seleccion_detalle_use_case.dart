
import 'package:flutter_tareo/domain/repositories/pre_tarea_esparrago_detalles_grupo_repository.dart';

class DeleteSeleccionDetalleUseCase{
  final PreTareaEsparragoDetallesGrupoRepository _seleccionDetalle;

  DeleteSeleccionDetalleUseCase(this._seleccionDetalle);

  Future<void> execute(String box, int key) async{
    return await _seleccionDetalle.delete(box, key);
  }

}