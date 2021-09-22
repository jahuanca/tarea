
import 'package:flutter_tareo/domain/repositories/tarea_proceso_repository.dart';

class DeleteTareaProcesoUseCase{
  final TareaProcesoRepository _tareaProcesoRepository;

  DeleteTareaProcesoUseCase(this._tareaProcesoRepository);

  Future<void> execute(int index) async{
    return await _tareaProcesoRepository.delete(index);
  }

}