import 'package:flutter_tareo/domain/packing/entities/pre_tareo_proceso_uva_detalle_entity.dart';
import 'package:flutter_tareo/domain/packing/repositories/personal_packing_repository.dart';
import 'package:hive/hive.dart';

class PreTareoProcesoUvaDetallesRepositoryImplementation
    extends PersonalPackingRepository {
  @override
  Future<List<PreTareoProcesoUvaDetalleEntity>> getAll(String box) async {
    Box<PreTareoProcesoUvaDetalleEntity> dataHive =
        await Hive.openBox<PreTareoProcesoUvaDetalleEntity>(box);
    List<PreTareoProcesoUvaDetalleEntity> local = [];
    dataHive.toMap().forEach((key, value) => local.add(value));
    await dataHive.close();
    return local;
  }

  @override
  Future<int> create(
      String box, PreTareoProcesoUvaDetalleEntity detalle) async {
    Box<PreTareoProcesoUvaDetalleEntity> tareas =
        await Hive.openBox<PreTareoProcesoUvaDetalleEntity>(box);
    int id = await tareas.add(detalle);
    detalle.key = id;
    await tareas.put(id, detalle);
    await tareas.close();
    return id;
  }

  @override
  Future<void> createAll(
      String box, List<PreTareoProcesoUvaDetalleEntity> detalles) async {
    Box<PreTareoProcesoUvaDetalleEntity> tareas =
        await Hive.openBox<PreTareoProcesoUvaDetalleEntity>(box);
    await tareas.addAll(detalles);
    await tareas.close();
    return;
  }

  @override
  Future<void> delete(String box, int key) async {
    var tareas = await Hive.openBox<PreTareoProcesoUvaDetalleEntity>(box);
    await tareas.delete(key);

    await tareas.close();
    return;
  }

  @override
  Future<void> deleteAll(String box) async {
    var tareas = await Hive.openBox<PreTareoProcesoUvaDetalleEntity>(box);
    await tareas.deleteFromDisk();

    await tareas.close();
    return;
  }

  @override
  Future<void> update(
      String box, int key, PreTareoProcesoUvaDetalleEntity detalle) async {
    var tareas = await Hive.openBox<PreTareoProcesoUvaDetalleEntity>(box);
    await tareas.put(key, detalle);

    await tareas.close();
    return;
  }
}
