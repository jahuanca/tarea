
import 'package:flutter_tareo/domain/repositories/pesado_detalles_repository.dart';

class DeleteAllPesadoDetalleUseCase{
  final PesadoDetallesRepository _pesadoDetallesRepository;

  DeleteAllPesadoDetalleUseCase(this._pesadoDetallesRepository);

  Future<void> execute(String box) async{
    return await _pesadoDetallesRepository.deleteAll(box);
  }

}