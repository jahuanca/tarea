
import 'package:flutter_tareo/domain/entities/tarea_proceso_entity.dart';
import 'package:flutter_tareo/domain/repositories/tarea_proceso_repository.dart';

class UpdateTareaProcesoUseCase{
  final TareaProcesoRepository _tareaProcesoRepository;

  UpdateTareaProcesoUseCase(this._tareaProcesoRepository);

  Future<void> execute(TareaProcesoEntity tareaProcesoEntity, int index) async{
    return await _tareaProcesoRepository.update(tareaProcesoEntity ,index);
  }

}