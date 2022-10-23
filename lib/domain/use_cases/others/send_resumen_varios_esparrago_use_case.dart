
import 'package:flutter_tareo/domain/repositories/resumen_varios_repository.dart';

class SendResumenVariosEsparragoUseCase{
  final ResumenVariosRepository _repository;

  SendResumenVariosEsparragoUseCase(this._repository);

  Future<void> execute()async{
    return await _repository.migrarEsparrago();
  } 
}