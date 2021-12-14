import 'package:flutter_tareo/domain/entities/personal_tarea_proceso_entity.dart';
import 'package:flutter_tareo/domain/repositories/personal_tarea_proceso_repository.dart';
import 'package:hive/hive.dart';

class PersonalTareaProcesoRepositoryImplementation
    extends PersonalTareaProcesoRepository {
  @override
  Future<List<PersonalTareaProcesoEntity>> getAll(String box) async {
    Box<PersonalTareaProcesoEntity> dataHive =
        await Hive.openBox<PersonalTareaProcesoEntity>(
            box);
    List<PersonalTareaProcesoEntity> local = [];
    dataHive.toMap().forEach((key, value) => local.add(value));
    await dataHive.close();
    return local;
  }

  @override
  Future<int> create(
      String box, PersonalTareaProcesoEntity detalle) async {
    Box<PersonalTareaProcesoEntity> tareas = await Hive.openBox<PersonalTareaProcesoEntity>(
        box);
    int id = await tareas.add(detalle);
    detalle.key = id;
    await tareas.put(id, detalle);
    await tareas.close();
    return id;
  }

  @override
  Future<void> delete(String box, int key) async {
    var tareas = await Hive.openBox<PersonalTareaProcesoEntity>(
        box);
    await tareas.delete(key);

    await tareas.close();
    return;
  }

  @override
  Future<void> deleteAll(String box) async {
    var tareas = await Hive.openBox<PersonalTareaProcesoEntity>(
        box);
    await tareas.deleteFromDisk();
    await tareas.close();
    return;
  }

  @override
  Future<void> update(
      String box, int key, PersonalTareaProcesoEntity detalle) async {
    var tareas = await Hive.openBox<PersonalTareaProcesoEntity>(
        box);
    await tareas.put(key, detalle);
    await tareas.close();
    return;
  }
}
