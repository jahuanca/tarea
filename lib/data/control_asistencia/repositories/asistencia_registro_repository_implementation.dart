import 'package:flutter_tareo/core/utils/strings/hiveDB.dart';
import 'package:flutter_tareo/domain/control_asistencia/repositories/asistencia_registro_repository.dart';
import 'package:flutter_tareo/domain/entities/asistencia_registro_personal_entity.dart';
import 'package:hive/hive.dart';

class AsistenciaRegistroRepositoryImplementation
    extends AsistenciaRegistroRepository {
  @override
  Future<List<AsistenciaRegistroPersonalEntity>> getAll(int key) async {
    Box<AsistenciaRegistroPersonalEntity> dataHive =
        await Hive.openBox<AsistenciaRegistroPersonalEntity>(
            '${REGISTRO_ASISTENCIA_HIVE_STRING}_$key');
    List<AsistenciaRegistroPersonalEntity> local = [];
    dataHive.toMap().forEach((key, value) => local.add(value));
    await dataHive.close();
    return local;
  }

  @override
  Future<int> create(int key, AsistenciaRegistroPersonalEntity detalle) async {
    Box<AsistenciaRegistroPersonalEntity> tareas =
        await Hive.openBox<AsistenciaRegistroPersonalEntity>(
            '${REGISTRO_ASISTENCIA_HIVE_STRING}_$key');
    int id = await tareas.add(detalle);
    detalle.key = id;
    await tareas.put(id, detalle);
    await tareas.close();
    return id;
  }

  @override
  Future<void> delete(int keyBox, int key) async {
    var tareas = await Hive.openBox<AsistenciaRegistroPersonalEntity>(
        '${REGISTRO_ASISTENCIA_HIVE_STRING}_$keyBox');
    await tareas.delete(key);
    await tareas.close();
    return;
  }

  @override
  Future<void> deleteAll(int key) async {
    Box<AsistenciaRegistroPersonalEntity> tareas =
        await Hive.openBox<AsistenciaRegistroPersonalEntity>(
            '${REGISTRO_ASISTENCIA_HIVE_STRING}_$key');
    await tareas.deleteFromDisk();
    await tareas.close();
    return;
  }

  @override
  Future<void> update(
      int keyBox, int key, AsistenciaRegistroPersonalEntity detalle) async {
    Box<AsistenciaRegistroPersonalEntity> tareas =
        await Hive.openBox<AsistenciaRegistroPersonalEntity>(
            '${REGISTRO_ASISTENCIA_HIVE_STRING}_$keyBox');
    await tareas.put(key, detalle);
    await tareas.close();
    return;
  }
}
