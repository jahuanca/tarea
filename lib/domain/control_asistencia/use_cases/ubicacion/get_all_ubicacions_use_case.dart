import 'package:flutter_tareo/domain/control_asistencia/repositories/ubicacion_repository.dart';
import 'package:flutter_tareo/domain/entities/asistencia_ubicacion_entity.dart';

class GetAllUbicacionsUseCase {
  final UbicacionRepository _repository;

  GetAllUbicacionsUseCase(this._repository);

  Future<List<AsistenciaUbicacionEntity>> execute() async {
    return await _repository.getAll();
  }
}
