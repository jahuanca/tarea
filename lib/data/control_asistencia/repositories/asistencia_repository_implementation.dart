import 'dart:io';
import 'package:flutter_tareo/domain/control_asistencia/datastores/asistencia_data_store.dart';
import 'package:flutter_tareo/domain/control_asistencia/repositories/asistencia_repository.dart';
import 'package:flutter_tareo/domain/entities/asistencia_fecha_turno_entity.dart';

class AsistenciaRepositoryImplementation extends AsistenciaRepository {
  final AsistenciaDataStore dataStore;
  AsistenciaRepositoryImplementation(
    this.dataStore,
  );

  @override
  Future<List<AsistenciaFechaTurnoEntity>> getAll() async {
    return await dataStore.getAll();
  }

  @override
  Future<List<AsistenciaFechaTurnoEntity>> getAllByValue(
      Map<String, dynamic> valores) async {
    return dataStore.getAllByValue(valores);
  }

  @override
  Future<int> create(AsistenciaFechaTurnoEntity asistencia) async {
    return await dataStore.create(asistencia);
  }

  @override
  Future<void> delete(int key) async {
    await dataStore.delete(key);
  }

  @override
  Future<void> update(
      AsistenciaFechaTurnoEntity tareaProcesoEntity, int index) async {
    return await dataStore.update(tareaProcesoEntity, index);
  }

  @override
  Future<AsistenciaFechaTurnoEntity> migrar(
      AsistenciaFechaTurnoEntity asistencia) async {
    return await dataStore.migrar(asistencia);
  }

  @override
  Future<AsistenciaFechaTurnoEntity> uploadFile(
      AsistenciaFechaTurnoEntity tareaProcesoEntity, File fileLocal) async {
    return await dataStore.uploadFile(tareaProcesoEntity, fileLocal);
  }
}
