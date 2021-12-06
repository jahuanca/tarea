
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_detalle_grupo_entity.dart';
import 'package:flutter_tareo/domain/repositories/pre_tarea_esparrago_detalles_grupo_repository.dart';

class UpdateSeleccionDetalleUseCase{
  final PreTareaEsparragoDetallesGrupoRepository _seleccionDetalle;

  UpdateSeleccionDetalleUseCase(this._seleccionDetalle);

  Future<void> execute(String box, int key, PreTareaEsparragoDetalleGrupoEntity detalle) async{
    return await _seleccionDetalle.update(box, key, detalle);
  }

}