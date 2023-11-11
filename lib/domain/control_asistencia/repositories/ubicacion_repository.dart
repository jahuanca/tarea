import 'package:flutter_tareo/domain/entities/asistencia_ubicacion_entity.dart';

abstract class UbicacionRepository {
  Future<List<AsistenciaUbicacionEntity>> getAll();
  Future<List<AsistenciaUbicacionEntity>> getAllByValue(
      Map<String, dynamic> valores);
}
