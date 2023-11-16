import 'package:flutter_tareo/domain/control_asistencia/datastores/asistencia_registro_data_store.dart';
import 'package:flutter_tareo/domain/control_asistencia/repositories/asistencia_registro_repository.dart';
import 'package:flutter_tareo/domain/entities/asistencia_registro_personal_entity.dart';
import 'package:flutter_tareo/domain/utils/result_type.dart';
import 'package:flutter_tareo/domain/utils/failure.dart';

class AsistenciaRegistroRepositoryImplementation
    extends AsistenciaRegistroRepository {
  final AsistenciaRegistroDataStore _asistenciaRegistroDataStore;

  AsistenciaRegistroRepositoryImplementation(this._asistenciaRegistroDataStore);

  @override
  Future<List<AsistenciaRegistroPersonalEntity>> getAll(int key) async {
    return await _asistenciaRegistroDataStore.getAll(key);
  }

  @override
  Future<AsistenciaRegistroPersonalEntity> create(
      int key, AsistenciaRegistroPersonalEntity detalle) async {
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
  Future<bool> update(
      int keyBox, int key, AsistenciaRegistroPersonalEntity detalle) async {
    return await _asistenciaRegistroDataStore.update(keyBox, key, detalle);
  }

  @override
  Future<ResultType<AsistenciaRegistroPersonalEntity, Failure>> registrar(
      AsistenciaRegistroPersonalEntity data) async {
    return await _asistenciaRegistroDataStore.registrar(data);
  }
}
