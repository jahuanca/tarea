import 'package:flutter_tareo/domain/control_asistencia/repositories/asistencia_registro_repository.dart';

class DeleteAllAsistenciaRegistroProcesoUseCase {
  final AsistenciaRegistroRepository _repository;

  DeleteAllAsistenciaRegistroProcesoUseCase(this._repository);

  Future<void> execute(int key) async {
    return await _repository.deleteAll(key);
  }
}
