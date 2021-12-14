
import 'package:flutter_tareo/domain/entities/tarea_proceso_entity.dart';
import 'package:flutter_tareo/domain/repositories/tarea_proceso_repository.dart';

class MigrarAllTareaUseCase{
  final TareaProcesoRepository _tareaProcesoRepository;

  MigrarAllTareaUseCase(this._tareaProcesoRepository);

  Future<TareaProcesoEntity> execute(int key)async{
    return await _tareaProcesoRepository.migrar(key);
  } 
}