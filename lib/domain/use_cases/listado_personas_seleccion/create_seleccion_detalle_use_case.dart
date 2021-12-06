
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_detalle_grupo_entity.dart';
import 'package:flutter_tareo/domain/repositories/pre_tarea_esparrago_detalles_grupo_repository.dart';

class CreateSeleccionDetalleUseCase{
  final PreTareaEsparragoDetallesGrupoRepository _seleccionDetalle;

  CreateSeleccionDetalleUseCase(this._seleccionDetalle);

  Future<int> execute(String box, PreTareaEsparragoDetalleGrupoEntity detalle) async{
    return await _seleccionDetalle.create(box, detalle);
  }
}