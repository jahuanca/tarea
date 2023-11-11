import 'package:flutter_tareo/domain/control_asistencia/repositories/registro_asistencia.dart';
import 'package:flutter_tareo/domain/entities/asistencia_registro_personal_entity.dart';

class UpdateRegistroAsistenciaUseCase {
  final RegistroAsistenciaRepository _repository;

  UpdateRegistroAsistenciaUseCase(this._repository);

  Future<void> execute(
      String box, int key, AsistenciaRegistroPersonalEntity detalle) async {
    return await _repository.update(box, key, detalle);
  }
}
