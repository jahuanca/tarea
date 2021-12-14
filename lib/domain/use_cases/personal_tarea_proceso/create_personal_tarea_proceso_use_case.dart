
import 'package:flutter_tareo/domain/entities/personal_tarea_proceso_entity.dart';
import 'package:flutter_tareo/domain/repositories/personal_tarea_proceso_repository.dart';

class CreatePersonalTareaProcesoUseCase{
  final PersonalTareaProcesoRepository _personalTareaoProcesoRepository;

  CreatePersonalTareaProcesoUseCase(this._personalTareaoProcesoRepository);

  Future<int> execute(String box, PersonalTareaProcesoEntity detalle) async{
    return await _personalTareaoProcesoRepository.create(box, detalle);
  }
}