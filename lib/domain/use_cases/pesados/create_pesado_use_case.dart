
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_varios_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tareo_proceso_entity.dart';
import 'package:flutter_tareo/domain/repositories/pre_tarea_esparrago_varios_repository.dart';

class CreatePesadoUseCase{
  final PreTareaEsparragoVariosRepository _repository;

  CreatePesadoUseCase(this._repository);

  Future<void> execute(PreTareaEsparragoVariosEntity pesado) async{
    return await _repository.create(pesado);
  }

}