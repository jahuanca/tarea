import 'package:flutter_tareo/domain/control_asistencia/repositories/registro_asistencia.dart';
import 'package:flutter_tareo/domain/entities/asistencia_registro_personal_entity.dart';
import 'package:hive/hive.dart';

class RegistroAsistenciaRepositoryImplementation
    extends RegistroAsistenciaRepository {
  @override
  Future<List<AsistenciaRegistroPersonalEntity>> getAll(String box) async {
    Box<AsistenciaRegistroPersonalEntity> dataHive =
        await Hive.openBox<AsistenciaRegistroPersonalEntity>(box);
    List<AsistenciaRegistroPersonalEntity> local = [];
    dataHive.toMap().forEach((key, value) => local.add(value));
    await dataHive.close();
    return local;
  }

  @override
  Future<int> create(
      String box, AsistenciaRegistroPersonalEntity detalle) async {
    Box<AsistenciaRegistroPersonalEntity> tareas =
        await Hive.openBox<AsistenciaRegistroPersonalEntity>(box);
    int id = await tareas.add(detalle);

    await tareas.put(id, detalle);
    await tareas.close();
    return id;
  }

  @override
  Future<void> delete(String box, int key) async {
    var tareas = await Hive.openBox<AsistenciaRegistroPersonalEntity>(box);
    await tareas.delete(key);
    await tareas.close();
    return;
  }

  @override
  Future<void> deleteAll(String box) async {
    var tareas = await Hive.openBox<AsistenciaRegistroPersonalEntity>(box);
    await tareas.deleteFromDisk();

    await tareas.close();
    return;
  }

  @override
  Future<void> update(
      String box, int key, AsistenciaRegistroPersonalEntity detalle) async {
    var tareas = await Hive.openBox<AsistenciaRegistroPersonalEntity>(box);
    await tareas.put(key, detalle);
    await tareas.close();
    return;
  }
}
