
import 'package:flutter_tareo/domain/repositories/pesado_detalles_repository.dart';

class DeletePesadoDetalleUseCase{
  final PesadoDetallesRepository _pesadoDetallesRepository;

  DeletePesadoDetalleUseCase(this._pesadoDetallesRepository);

  Future<void> execute(String box, int key) async{
    return await _pesadoDetallesRepository.delete(box, key);
  }

}