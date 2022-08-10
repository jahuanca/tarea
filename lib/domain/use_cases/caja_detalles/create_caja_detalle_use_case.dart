


import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_detalle_entity.dart';
import 'package:flutter_tareo/domain/repositories/caja_detalle_repository.dart';

class CreateCajaDetalleUseCase{
  final CajaDetalleRepository _cajaDetalleRepository;

  CreateCajaDetalleUseCase(this._cajaDetalleRepository);

  Future<int> execute(String box, PreTareaEsparragoDetalleEntity personal) async{
    return await _cajaDetalleRepository.create(box, personal);
  }

}