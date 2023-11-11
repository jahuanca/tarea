import 'package:flutter_tareo/domain/control_asistencia/repositories/turno_repository.dart';
import 'package:flutter_tareo/domain/entities/turno_entity.dart';

class GetAllTurnosUseCase {
  final TurnoRepository _repository;

  GetAllTurnosUseCase(this._repository);

  Future<List<TurnoEntity>> execute() async {
    return await _repository.getAll();
  }
}
