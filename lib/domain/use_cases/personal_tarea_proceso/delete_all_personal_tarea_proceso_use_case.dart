
import 'package:flutter_tareo/domain/repositories/personal_tarea_proceso_repository.dart';

class DeleteAllPersonalTareaProcesoUseCase{
  final PersonalTareaProcesoRepository _personalTareaProcesoRepository;

  DeleteAllPersonalTareaProcesoUseCase(this._personalTareaProcesoRepository);

  Future<void> execute(String box) async{
    return await _personalTareaProcesoRepository.deleteAll(box);
  }

}