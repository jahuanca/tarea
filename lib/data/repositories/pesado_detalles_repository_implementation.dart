import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_detalle_varios_entity.dart';
import 'package:flutter_tareo/domain/repositories/pesado_detalles_repository.dart';
import 'package:hive/hive.dart';

class PesadoDetallesRepositoryImplementation
    extends PesadoDetallesRepository {
  @override
  Future<List<PreTareaEsparragoDetalleVariosEntity>> getAll(String box) async {
    Box<PreTareaEsparragoDetalleVariosEntity> dataHive =
        await Hive.openBox<PreTareaEsparragoDetalleVariosEntity>(
            box);
    List<PreTareaEsparragoDetalleVariosEntity> local = [];
    dataHive.toMap().forEach((key, value) => local.add(value));
    await dataHive.close();
    return local;
  }

  @override
  Future<int> create(
      String box, PreTareaEsparragoDetalleVariosEntity detalle) async {
    Box<PreTareaEsparragoDetalleVariosEntity> tareas = await Hive.openBox<PreTareaEsparragoDetalleVariosEntity>(
        box);
    int id = await tareas.add(detalle);
    detalle.key = id;
    await tareas.put(id, detalle);
    await tareas.close();
    return id;
  }

  @override
  Future<void> delete(String box, int key) async {
    var tareas = await Hive.openBox<PreTareaEsparragoDetalleVariosEntity>(
        box);
    await tareas.delete(key);
    await tareas.close();
    return;
  }

  @override
  Future<void> deleteAll(String box) async {
    var tareas = await Hive.openBox<PreTareaEsparragoDetalleVariosEntity>(
        box);
    await tareas.deleteFromDisk();

    await tareas.close();
    return;
  }

  @override
  Future<void> update(
      String box, int key, PreTareaEsparragoDetalleVariosEntity detalle) async {
    var tareas = await Hive.openBox<PreTareaEsparragoDetalleVariosEntity>(
        box);
    await tareas.put(key, detalle);

    await tareas.close();
    return;
  }
}
