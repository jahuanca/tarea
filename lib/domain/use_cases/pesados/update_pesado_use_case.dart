
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_varios_entity.dart';
import 'package:flutter_tareo/domain/repositories/pre_tarea_esparrago_varios_repository.dart';

class UpdatePesadoUseCase{
  final PreTareaEsparragoVariosRepository _repository;

  UpdatePesadoUseCase(this._repository);

  Future<void> execute(PreTareaEsparragoVariosEntity pesado, int index) async{
    return await _repository.update(pesado ,index);
  }

}