

import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_varios_entity.dart';
import 'package:flutter_tareo/domain/repositories/pre_tarea_esparrago_varios_repository.dart';

class GetAllPesadoUseCase{
  final PreTareaEsparragoVariosRepository _repository;

  GetAllPesadoUseCase(this._repository);

  Future<List<PreTareaEsparragoVariosEntity>> execute() async{
    return await _repository.getAll();
  }

}