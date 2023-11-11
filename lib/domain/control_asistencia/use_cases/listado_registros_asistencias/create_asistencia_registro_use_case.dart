import 'package:flutter_tareo/domain/control_asistencia/repositories/asistencia_registro_repository.dart';
import 'package:flutter_tareo/domain/entities/asistencia_registro_personal_entity.dart';

class CreateAsistenciaRegistroUseCase {
  final AsistenciaRegistroRepository _repository;

  CreateAsistenciaRegistroUseCase(this._repository);

  Future<int> execute(int key, AsistenciaRegistroPersonalEntity detalle) async {
    return await _repository.create(key, detalle);
  }
}
