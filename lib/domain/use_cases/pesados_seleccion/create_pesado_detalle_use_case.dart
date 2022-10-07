
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_detalle_varios_entity.dart';
import 'package:flutter_tareo/domain/repositories/pesado_detalles_repository.dart';

class CreatePesadoDetalleUseCase{
  final PesadoDetallesRepository _pesadoDetallesRepository;

  CreatePesadoDetalleUseCase(this._pesadoDetallesRepository);

  Future<int> execute(String box, PreTareaEsparragoDetalleVariosEntity detalle) async{
    return await _pesadoDetallesRepository.create(box, detalle);
  }
}