
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_detalle_grupo_entity.dart';
import 'package:flutter_tareo/domain/repositories/pre_tarea_esparrago_detalles_grupo_repository.dart';

class GetAllSeleccionDetallesUseCase{
  final PreTareaEsparragoDetallesGrupoRepository _seleccionDetalle;

  GetAllSeleccionDetallesUseCase(this._seleccionDetalle);

  Future<List<PreTareaEsparragoDetalleGrupoEntity>> execute(String box) async{
    return await _seleccionDetalle.getAll(box);
  }

}