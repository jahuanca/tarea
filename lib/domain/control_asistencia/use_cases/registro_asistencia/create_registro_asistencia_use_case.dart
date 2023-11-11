import 'package:flutter_tareo/domain/control_asistencia/repositories/registro_asistencia.dart';
import 'package:flutter_tareo/domain/entities/asistencia_registro_personal_entity.dart';

class CreateRegistroAsistenciaUseCase {
  final RegistroAsistenciaRepository _repository;

  CreateRegistroAsistenciaUseCase(this._repository);

  Future<int> execute(
      String box, AsistenciaRegistroPersonalEntity detalle) async {
    return await _repository.create(box, detalle);
  }
}
