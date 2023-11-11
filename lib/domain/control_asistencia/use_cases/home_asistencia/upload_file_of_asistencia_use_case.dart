import 'dart:io';

import 'package:flutter_tareo/domain/control_asistencia/repositories/asistencia_repository.dart';
import 'package:flutter_tareo/domain/entities/asistencia_fecha_turno_entity.dart';

class UploadFileOfAsistenciaUseCase {
  final AsistenciaRepository _repository;

  UploadFileOfAsistenciaUseCase(this._repository);

  Future<AsistenciaFechaTurnoEntity> execute(
      AsistenciaFechaTurnoEntity _asistencia, File file) async {
    return await _repository.uploadFile(_asistencia, file);
  }
}
