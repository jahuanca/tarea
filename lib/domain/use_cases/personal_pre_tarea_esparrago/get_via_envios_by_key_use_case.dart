
import 'package:flutter_tareo/domain/entities/labor_entity.dart';
import 'package:flutter_tareo/domain/entities/via_envio_entity.dart';
import 'package:flutter_tareo/domain/repositories/via_envio_repository.dart';

class GetViaEnvioByKeyUseCase{
  final ViaEnvioRepository _repository;

  GetViaEnvioByKeyUseCase(this._repository);

  Future<List<ViaEnvioEntity>> execute(Map<String,dynamic> valores) async{
    return await _repository.getAllByValue(valores);
  }
  
}