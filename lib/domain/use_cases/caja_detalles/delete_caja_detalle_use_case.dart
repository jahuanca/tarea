
import 'package:flutter_tareo/domain/repositories/caja_detalle_repository.dart';

class DeleteCajaDetalleUseCase{
  final CajaDetalleRepository _cajaDetalleRepository;

  DeleteCajaDetalleUseCase(this._cajaDetalleRepository);

  Future<void> execute(String box, int key) async{
    return await _cajaDetalleRepository.delete(box, key);
  }

}