import 'package:flutter_tareo/domain/control_asistencia/repositories/asistencia_registro_repository.dart';
import 'package:flutter_tareo/domain/entities/asistencia_registro_personal_entity.dart';
import 'package:flutter_tareo/domain/utils/failure.dart';
import 'package:flutter_tareo/domain/utils/result_type.dart';

class RegistrarAsistenciaRegistroUseCase {
  final AsistenciaRegistroRepository _repository;

  RegistrarAsistenciaRegistroUseCase(this._repository);

  Future<ResultType<AsistenciaRegistroPersonalEntity, Failure>> execute(
      AsistenciaRegistroPersonalEntity detalle) async {
    return await _repository.registrar(detalle);
  }
}
