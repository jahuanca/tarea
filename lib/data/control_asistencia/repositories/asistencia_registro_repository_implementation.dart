import 'package:flutter_tareo/domain/control_asistencia/datastores/asistencia_registro_data_store.dart';
import 'package:flutter_tareo/domain/control_asistencia/repositories/asistencia_registro_repository.dart';
import 'package:flutter_tareo/domain/entities/asistencia_registro_personal_entity.dart';

class AsistenciaRegistroRepositoryImplementation
    extends AsistenciaRegistroRepository {
  final AsistenciaRegistroDataStore _asistenciaRegistroDataStore;

  AsistenciaRegistroRepositoryImplementation(this._asistenciaRegistroDataStore);

  @override
  Future<List<AsistenciaRegistroPersonalEntity>> getAll(int key) async {
    return await _asistenciaRegistroDataStore.getAll(key);
  }

  @override
  Future<int> create(int key, AsistenciaRegistroPersonalEntity detalle) async {
    return await _asistenciaRegistroDataStore.create(key, detalle);
  }

  @override
  Future<void> delete(int keyBox, int key) async {
    return await _asistenciaRegistroDataStore.delete(keyBox, key);
  }

  @override
  Future<void> deleteAll(int key) async {
    return await _asistenciaRegistroDataStore.deleteAll(key);
  }

  @override
  Future<void> update(
      int keyBox, int key, AsistenciaRegistroPersonalEntity detalle) async {
    return await _asistenciaRegistroDataStore.update(keyBox, key, detalle);
  }
}
