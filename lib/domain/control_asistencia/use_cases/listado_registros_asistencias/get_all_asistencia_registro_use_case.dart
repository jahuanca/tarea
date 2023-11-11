import 'package:flutter_tareo/domain/control_asistencia/repositories/asistencia_registro_repository.dart';
import 'package:flutter_tareo/domain/entities/asistencia_registro_personal_entity.dart';

class GetAllAsistenciaRegistroUseCase {
  final AsistenciaRegistroRepository _repository;

  GetAllAsistenciaRegistroUseCase(this._repository);

  Future<List<AsistenciaRegistroPersonalEntity>> execute(int key) async {
    return await _repository.getAll(key);
  }
}
