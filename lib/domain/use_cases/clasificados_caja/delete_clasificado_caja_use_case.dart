
import 'package:flutter_tareo/domain/repositories/clasificado_cajas_repository.dart';

class DeleteClasificadoCajaUseCase{
  final ClasificadoCajasRepository _clasificadoCajasRepository;

  DeleteClasificadoCajaUseCase(this._clasificadoCajasRepository);

  Future<void> execute(String box, int key) async{
    return await _clasificadoCajasRepository.delete(box, key);
  }

}