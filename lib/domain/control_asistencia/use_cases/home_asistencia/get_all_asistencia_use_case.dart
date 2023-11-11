import 'package:flutter_tareo/domain/control_asistencia/repositories/asistencia_repository.dart';
import 'package:flutter_tareo/domain/entities/asistencia_fecha_turno_entity.dart';

class GetAllAsistenciaUseCase {
  final AsistenciaRepository _repository;

  GetAllAsistenciaUseCase(this._repository);

  Future<List<AsistenciaFechaTurnoEntity>> execute() async {
    return await _repository.getAll();
  }
}
