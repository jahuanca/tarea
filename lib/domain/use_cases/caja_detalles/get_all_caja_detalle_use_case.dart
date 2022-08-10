


import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_detalle_entity.dart';
import 'package:flutter_tareo/domain/repositories/caja_detalle_repository.dart';

class GetAllCajaDetalleUseCase{
  final CajaDetalleRepository _cajaDetalleRepository;

  GetAllCajaDetalleUseCase(this._cajaDetalleRepository);

  Future<List<PreTareaEsparragoDetalleEntity>> execute(String box) async{
    return await _cajaDetalleRepository.getAll(box);
  }

}