

import 'package:flutter_tareo/domain/entities/tarea_proceso_entity.dart';
import 'package:flutter_tareo/domain/repositories/tarea_proceso_repository.dart';

class GetAllTareaProcesoUseCase{
  final TareaProcesoRepository _tareaProcesoRepository;

  GetAllTareaProcesoUseCase(this._tareaProcesoRepository);

  Future<List<TareaProcesoEntity>> execute() async{
    return await _tareaProcesoRepository.getAll();
  }

}