
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_varios_entity.dart';
import 'package:flutter_tareo/domain/repositories/pre_tarea_esparrago_varios_repository.dart';

class MigrarAllPesadoUseCase{
  final PreTareaEsparragoVariosRepository _repository;

  MigrarAllPesadoUseCase(this._repository);

  Future<PreTareaEsparragoVariosEntity> execute(PreTareaEsparragoVariosEntity pesado)async{
    return await _repository.migrar(pesado);
  } 
}