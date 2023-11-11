import 'package:flutter_tareo/domain/control_asistencia/repositories/registro_asistencia.dart';

class DeleteRegistroAsistenciaProcesoUseCase {
  final RegistroAsistenciaRepository _repository;

  DeleteRegistroAsistenciaProcesoUseCase(this._repository);

  Future<void> execute(String box) async {
    return await _repository.deleteAll(box);
  }
}
