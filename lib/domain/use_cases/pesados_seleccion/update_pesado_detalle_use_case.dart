
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_detalle_varios_entity.dart';
import 'package:flutter_tareo/domain/repositories/pesado_detalles_repository.dart';

class UpdatePesadoDetalleUseCase{
  final PesadoDetallesRepository _pesadoDetallesRepository;

  UpdatePesadoDetalleUseCase(this._pesadoDetallesRepository);

  Future<void> execute(String box, int key, PreTareaEsparragoDetalleVariosEntity detalle) async{
    return await _pesadoDetallesRepository.update(box, key, detalle);
  }

}