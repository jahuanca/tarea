
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_formato_entity.dart';
import 'package:flutter_tareo/domain/repositories/clasificado_cajas_repository.dart';
import 'package:hive/hive.dart';

class ClasificadoCajasRepositoryImplementation
    extends ClasificadoCajasRepository {
  @override
  Future<List<PreTareaEsparragoFormatoEntity>> getAll(String box) async {
    Box<PreTareaEsparragoFormatoEntity> dataHive =
        await Hive.openBox<PreTareaEsparragoFormatoEntity>(
            box);
    List<PreTareaEsparragoFormatoEntity> local = [];
    dataHive.toMap().forEach((key, value) => local.add(value));
    await dataHive.close();
    return local;
  }

  @override
  Future<int> create(
      String box, PreTareaEsparragoFormatoEntity detalle) async {
    Box<PreTareaEsparragoFormatoEntity> tareas = await Hive.openBox<PreTareaEsparragoFormatoEntity>(
        box);
    int id = await tareas.add(detalle);
    detalle.key = id;
    await tareas.put(id, detalle);
    await tareas.close();
    return id;
  }

  @override
  Future<void> delete(String box, int key) async {
    var tareas = await Hive.openBox<PreTareaEsparragoFormatoEntity>(
        box);
    await tareas.delete(key);
    await tareas.close();
    return;
  }

  @override
  Future<void> deleteAll(String box) async {
    var tareas = await Hive.openBox<PreTareaEsparragoFormatoEntity>(
        box);
    await tareas.deleteFromDisk();

    await tareas.close();
    return;
  }

  @override
  Future<void> update(
      String box, int key, PreTareaEsparragoFormatoEntity detalle) async {
    var tareas = await Hive.openBox<PreTareaEsparragoFormatoEntity>(
        box);
    await tareas.put(key, detalle);

    await tareas.close();
    return;
  }
}
