import 'package:flutter_tareo/domain/control_asistencia/repositories/ubicacion_repository.dart';
import 'package:flutter_tareo/domain/entities/asistencia_ubicacion_entity.dart';

class GetUbicacionsByKeyUseCase {
  final UbicacionRepository _repository;

  GetUbicacionsByKeyUseCase(this._repository);

  Future<List<AsistenciaUbicacionEntity>> execute(
      Map<String, dynamic> valores) async {
    return await _repository.getAllByValue(valores);
  }
}
