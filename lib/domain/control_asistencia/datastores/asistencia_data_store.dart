import 'dart:io';

import 'package:flutter_tareo/domain/entities/asistencia_fecha_turno_entity.dart';

abstract class AsistenciaDataStore {
  Future<List<AsistenciaFechaTurnoEntity>> getAll();
  Future<List<AsistenciaFechaTurnoEntity>> getAllByValue(
      Map<String, dynamic> valores);
  Future<int> create(AsistenciaFechaTurnoEntity asistencia);
  Future<AsistenciaFechaTurnoEntity> migrar(
      AsistenciaFechaTurnoEntity asistencia);
  Future<AsistenciaFechaTurnoEntity> uploadFile(
      AsistenciaFechaTurnoEntity asistencia, File fileLocal);
  Future<void> update(AsistenciaFechaTurnoEntity asistencia, int key);
  Future<void> delete(int key);
}
