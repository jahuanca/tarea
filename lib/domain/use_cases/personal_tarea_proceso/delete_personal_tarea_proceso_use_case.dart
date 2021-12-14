
import 'package:flutter_tareo/domain/repositories/personal_tarea_proceso_repository.dart';

class DeletePersonalTareaProcesoUseCase{
  final PersonalTareaProcesoRepository _personalTareaProcesoRepository;

  DeletePersonalTareaProcesoUseCase(this._personalTareaProcesoRepository);

  Future<void> execute(String box, int key) async{
    return await _personalTareaProcesoRepository.delete(box, key);
  }

}