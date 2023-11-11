import 'package:flutter_tareo/domain/entities/asistencia_registro_personal_entity.dart';

abstract class RegistroAsistenciaRepository {
  Future<List<AsistenciaRegistroPersonalEntity>> getAll(String box);
  Future<int> create(String box, AsistenciaRegistroPersonalEntity detalle);
  Future<void> update(
      String box, int key, AsistenciaRegistroPersonalEntity detalle);
  Future<void> delete(String box, int key);
  Future<void> deleteAll(String box);
}
