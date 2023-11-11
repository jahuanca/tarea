import 'package:flutter_tareo/domain/control_asistencia/repositories/asistencia_registro_repository.dart';

class DeleteAsistenciaRegistroUseCase {
  final AsistenciaRegistroRepository _repository;

  DeleteAsistenciaRegistroUseCase(this._repository);

  Future<void> execute(int keyBox, int key) async {
    return await _repository.delete(keyBox, key);
  }
}
