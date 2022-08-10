
import 'package:flutter_tareo/domain/repositories/clasificado_cajas_repository.dart';
import 'package:flutter_tareo/domain/repositories/pesado_detalles_repository.dart';
import 'package:flutter_tareo/domain/repositories/pre_tarea_esparrago_detalles_grupo_repository.dart';

class DeleteClasificadoCajaUseCase{
  final ClasificadoCajasRepository _clasificadoCajasRepository;

  DeleteClasificadoCajaUseCase(this._clasificadoCajasRepository);

  Future<void> execute(String box, int key) async{
    return await _clasificadoCajasRepository.delete(box, key);
  }

}