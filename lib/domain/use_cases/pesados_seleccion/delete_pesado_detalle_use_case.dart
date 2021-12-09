
import 'package:flutter_tareo/domain/repositories/pesado_detalles_repository.dart';
import 'package:flutter_tareo/domain/repositories/pre_tarea_esparrago_detalles_grupo_repository.dart';

class DeletePesadoDetalleUseCase{
  final PesadoDetallesRepository _pesadoDetallesRepository;

  DeletePesadoDetalleUseCase(this._pesadoDetallesRepository);

  Future<void> execute(String box, int key) async{
    return await _pesadoDetallesRepository.delete(box, key);
  }

}