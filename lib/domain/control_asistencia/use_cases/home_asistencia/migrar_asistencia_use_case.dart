import 'package:flutter_tareo/domain/control_asistencia/repositories/asistencia_repository.dart';
import 'package:flutter_tareo/domain/entities/asistencia_fecha_turno_entity.dart';

class MigrarAsistenciaUseCase {
  final AsistenciaRepository _repository;

  MigrarAsistenciaUseCase(this._repository);

  Future<AsistenciaFechaTurnoEntity> execute(
      AsistenciaFechaTurnoEntity asistencia) async {
    return await _repository.migrar(asistencia);
  }
}
