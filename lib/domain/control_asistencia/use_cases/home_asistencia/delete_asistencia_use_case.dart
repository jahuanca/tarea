import 'package:flutter_tareo/domain/control_asistencia/repositories/asistencia_repository.dart';

class DeleteAsistenciaUseCase {
  final AsistenciaRepository _repository;

  DeleteAsistenciaUseCase(this._repository);

  Future<void> execute(int key) async {
    return await _repository.delete(key);
  }
}
