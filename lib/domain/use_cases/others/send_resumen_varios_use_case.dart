
import 'package:flutter_tareo/domain/repositories/resumen_varios_repository.dart';

class SendResumenVariosUseCase{
  final ResumenVariosRepository _repository;

  SendResumenVariosUseCase(this._repository);

  Future<void> execute()async{
    return await _repository.migrar();
  } 
}