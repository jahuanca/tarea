import 'package:flutter_tareo/domain/entities/personal_pre_tarea_esparrago_entity.dart';
import 'package:flutter_tareo/domain/repositories/personal_pre_tarea_esparrago_repository.dart';
import 'package:hive/hive.dart';

class PersonalPreTareaEsparragoRepositoryImplementation
    extends PersonalPreTareaEsparragoRepository {
  @override
  Future<List<PersonalPreTareaEsparragoEntity>> getAll(String box) async {
    Box<PersonalPreTareaEsparragoEntity> dataHive =
        await Hive.openBox<PersonalPreTareaEsparragoEntity>(
            box);
    List<PersonalPreTareaEsparragoEntity> local = [];
    dataHive.toMap().forEach((key, value) => local.add(value));
    await dataHive.close();
    return local;
  }

  @override
  Future<int> create(
      String box, PersonalPreTareaEsparragoEntity detalle) async {
    Box<PersonalPreTareaEsparragoEntity> tareas = await Hive.openBox<PersonalPreTareaEsparragoEntity>(
        box);
    int id = await tareas.add(detalle);
    detalle.key = id;
    await tareas.put(id, detalle);
    await tareas.close();
    return id;
  }

  @override
  Future<void> delete(String box, int key) async {
    var tareas = await Hive.openBox<PersonalPreTareaEsparragoEntity>(
        box);
    await tareas.delete(key);
    await tareas.close();
    return;
  }

  @override
  Future<void> deleteAll(String box) async {
    var tareas = await Hive.openBox<PersonalPreTareaEsparragoEntity>(
        box);
    await tareas.deleteFromDisk();

    await tareas.close();
    return;
  }

  @override
  Future<void> update(
      String box, int key, PersonalPreTareaEsparragoEntity detalle) async {
    var tareas = await Hive.openBox<PersonalPreTareaEsparragoEntity>(
        box);
    await tareas.put(key, detalle);

    await tareas.close();
    return;
  }
}
