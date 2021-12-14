
import 'package:flutter_tareo/domain/entities/personal_tarea_proceso_entity.dart';
import 'package:flutter_tareo/domain/repositories/personal_tarea_proceso_repository.dart';

class GetAllPersonalTareaProcesoUseCase{
  final PersonalTareaProcesoRepository _personalTareaProcesoRepository;

  GetAllPersonalTareaProcesoUseCase(this._personalTareaProcesoRepository);

  Future<List<PersonalTareaProcesoEntity>> execute(String box) async{
    return await _personalTareaProcesoRepository.getAll(box);
  }

}