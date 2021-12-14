
import 'package:flutter_tareo/domain/entities/personal_tarea_proceso_entity.dart';
import 'package:flutter_tareo/domain/repositories/personal_tarea_proceso_repository.dart';

class UpdatePersonalTareaProcesoUseCase{
  final PersonalTareaProcesoRepository _personalTareaProcesoRepository;

  UpdatePersonalTareaProcesoUseCase(this._personalTareaProcesoRepository);

  Future<void> execute(String box, int key, PersonalTareaProcesoEntity detalle) async{
    return await _personalTareaProcesoRepository.update(box, key, detalle);
  }

}