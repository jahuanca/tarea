import 'package:flutter_tareo/domain/entities/asistencia_registro_personal_entity.dart';

abstract class AsistenciaRegistroDataStore {
  Future<List<AsistenciaRegistroPersonalEntity>> getAll(int key);
  Future<int> create(int key, AsistenciaRegistroPersonalEntity detalle);
  Future<void> update(
      int keyBox, int key, AsistenciaRegistroPersonalEntity detalle);
  Future<void> delete(int keyBox, int key);
  Future<void> deleteAll(int key);
}
