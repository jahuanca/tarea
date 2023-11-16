import 'package:flutter_tareo/domain/control_asistencia/repositories/asistencia_registro_repository.dart';
import 'package:flutter_tareo/domain/entities/asistencia_registro_personal_entity.dart';

class UpdateAsistenciaRegistroUseCase {
  final AsistenciaRegistroRepository _repository;

  UpdateAsistenciaRegistroUseCase(this._repository);

  Future<bool> execute(
      int keyBox, int key, AsistenciaRegistroPersonalEntity detalle) async {
    return await _repository.update(keyBox, key, detalle);
  }
}
