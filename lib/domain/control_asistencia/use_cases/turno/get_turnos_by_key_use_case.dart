import 'package:flutter_tareo/domain/control_asistencia/repositories/turno_repository.dart';
import 'package:flutter_tareo/domain/entities/turno_entity.dart';

class GetTurnosByKeyUseCase {
  final TurnoRepository _repository;

  GetTurnosByKeyUseCase(this._repository);

  Future<List<TurnoEntity>> execute(Map<String, dynamic> valores) async {
    return await _repository.getAllByValue(valores);
  }
}
