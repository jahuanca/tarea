
import 'package:flutter_tareo/domain/repositories/clasificado_cajas_repository.dart';

class DeleteAllClasificadoCajaUseCase{
  final ClasificadoCajasRepository _clasificadoCajasRepository;

  DeleteAllClasificadoCajaUseCase(this._clasificadoCajasRepository);

  Future<void> execute(String box) async{
    return await _clasificadoCajasRepository.deleteAll(box);
  }

}