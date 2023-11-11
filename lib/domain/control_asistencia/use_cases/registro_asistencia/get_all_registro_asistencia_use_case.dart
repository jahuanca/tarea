import 'package:flutter_tareo/domain/control_asistencia/repositories/registro_asistencia.dart';
import 'package:flutter_tareo/domain/entities/asistencia_registro_personal_entity.dart';

class GetAllRegistroAsistenciaUseCase {
  final RegistroAsistenciaRepository _repository;

  GetAllRegistroAsistenciaUseCase(this._repository);

  Future<List<AsistenciaRegistroPersonalEntity>> execute(String box) async {
    return await _repository.getAll(box);
  }
}
