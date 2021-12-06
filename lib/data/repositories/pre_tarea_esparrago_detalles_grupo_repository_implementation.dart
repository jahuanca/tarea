import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_detalle_grupo_entity.dart';
import 'package:flutter_tareo/domain/repositories/pre_tarea_esparrago_detalles_grupo_repository.dart';
import 'package:hive/hive.dart';

class PreTareaEsparragoDetallesGrupoRepositoryImplementation
    extends PreTareaEsparragoDetallesGrupoRepository {
  @override
  Future<List<PreTareaEsparragoDetalleGrupoEntity>> getAll(String box) async {
    Box<PreTareaEsparragoDetalleGrupoEntity> dataHive =
        await Hive.openBox<PreTareaEsparragoDetalleGrupoEntity>(
            box);
    List<PreTareaEsparragoDetalleGrupoEntity> local = [];
    dataHive.toMap().forEach((key, value) => local.add(value));
    await dataHive.close();
    return local;
  }

  @override
  Future<int> create(
      String box, PreTareaEsparragoDetalleGrupoEntity detalle) async {
    Box<PreTareaEsparragoDetalleGrupoEntity> tareas = await Hive.openBox<PreTareaEsparragoDetalleGrupoEntity>(
        box);
    int id = await tareas.add(detalle);
    detalle.key = id;
    await tareas.put(id, detalle);
    await tareas.close();
    return id;
  }

  @override
  Future<void> delete(String box, int key) async {
    var tareas = await Hive.openBox<PreTareaEsparragoDetalleGrupoEntity>(
        box);
    await tareas.delete(key);

    await tareas.close();
    return;
  }

  @override
  Future<void> deleteAll(String box) async {
    var tareas = await Hive.openBox<PreTareaEsparragoDetalleGrupoEntity>(
        box);
    await tareas.deleteFromDisk();

    await tareas.close();
    return;
  }

  @override
  Future<void> update(
      String box, int key, PreTareaEsparragoDetalleGrupoEntity detalle) async {
    var tareas = await Hive.openBox<PreTareaEsparragoDetalleGrupoEntity>(
        box);
    await tareas.put(key, detalle);

    await tareas.close();
    return;
  }
}
