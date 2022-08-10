




import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_detalle_entity.dart';
import 'package:flutter_tareo/domain/repositories/caja_detalle_repository.dart';

class UpdateCajaDetalleUseCase{
  final CajaDetalleRepository _cajaDetalleRepository;

  UpdateCajaDetalleUseCase(this._cajaDetalleRepository);

  Future<void> execute(String box, PreTareaEsparragoDetalleEntity personal, int key) async{
    return await _cajaDetalleRepository.update(box, personal ,key);
  }

}