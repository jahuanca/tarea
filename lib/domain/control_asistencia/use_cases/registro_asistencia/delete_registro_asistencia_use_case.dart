import 'package:flutter_tareo/domain/control_asistencia/repositories/registro_asistencia.dart';

class DeleteRegistroAsistenciaUseCase {
  final RegistroAsistenciaRepository _repository;

  DeleteRegistroAsistenciaUseCase(this._repository);

  Future<void> execute(String box, int key) async {
    return await _repository.delete(box, key);
  }
}
