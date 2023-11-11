import 'package:flutter_tareo/domain/control_asistencia/repositories/asistencia_repository.dart';
import 'package:flutter_tareo/domain/entities/asistencia_fecha_turno_entity.dart';

class UpdateAsistenciaUseCase {
  final AsistenciaRepository _repository;

  UpdateAsistenciaUseCase(this._repository);

  Future<void> execute(AsistenciaFechaTurnoEntity asistencia, int index) async {
    return await _repository.update(asistencia, index);
  }
}
