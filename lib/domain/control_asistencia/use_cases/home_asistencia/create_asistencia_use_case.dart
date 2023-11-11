import 'package:flutter_tareo/domain/control_asistencia/repositories/asistencia_repository.dart';
import 'package:flutter_tareo/domain/entities/asistencia_fecha_turno_entity.dart';

class CreateAsistenciaUseCase {
  final AsistenciaRepository _repository;

  CreateAsistenciaUseCase(this._repository);

  Future<int> execute(AsistenciaFechaTurnoEntity asistencia) async {
    return await _repository.create(asistencia);
  }
}
