
import 'package:flutter_tareo/domain/entities/via_envio_entity.dart';
import 'package:flutter_tareo/domain/repositories/via_envio_repository.dart';

class GetViaEnviosUseCase{
  final ViaEnvioRepository _repository;

  GetViaEnviosUseCase(this._repository);

  Future<List<ViaEnvioEntity>> execute() async{
    return await _repository.getAll();
  }
  
}