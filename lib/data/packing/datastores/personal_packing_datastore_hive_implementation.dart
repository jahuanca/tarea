import 'package:flutter_tareo/core/utils/strings/hiveDB.dart';
import 'package:flutter_tareo/domain/packing/datastores/personal_packing_datastore.dart';
import 'package:flutter_tareo/domain/packing/entities/pre_tareo_proceso_uva_detalle_entity.dart';
import 'package:flutter_tareo/domain/packing/entities/pre_tareo_proceso_uva_entity.dart';
import 'package:flutter_tareo/domain/utils/failure.dart';
import 'package:flutter_tareo/domain/utils/result_type.dart';
import 'package:hive/hive.dart';

class PersonalPackingDataStoreHiveImplementation
    extends PersonalPackingDatastore {
  @override
  Future<ResultType<List<PreTareoProcesoUvaDetalleEntity>, Failure>> getAll(
      PreTareoProcesoUvaEntity header) async {
    Box<PreTareoProcesoUvaDetalleEntity> dataHive =
        await Hive.openBox<PreTareoProcesoUvaDetalleEntity>(
            '$PACKING_PERSONAL_INIT_HIVE_STRING${header.key}');
    List<PreTareoProcesoUvaDetalleEntity> local = [];
    dataHive.toMap().forEach((key, value) => local.add(value));
    await dataHive.close();
    return Success(data: local);
  }

  @override
  Future<ResultType<PreTareoProcesoUvaDetalleEntity, Failure>> create(
      PreTareoProcesoUvaDetalleEntity detalle) async {
    Box<PreTareoProcesoUvaDetalleEntity> tareas =
        await Hive.openBox<PreTareoProcesoUvaDetalleEntity>(
            '$PACKING_PERSONAL_INIT_HIVE_STRING${detalle.keyParent}');
    int id = await tareas.add(detalle);
    detalle.key = id;
    await tareas.put(id, detalle);
    await tareas.close();
    return Success(data: detalle);
  }

  @override
  Future<ResultType<PreTareoProcesoUvaDetalleEntity, Failure>> createAll(
      String box, List<PreTareoProcesoUvaDetalleEntity> detalles) async {
    Box<PreTareoProcesoUvaDetalleEntity> tareas =
        await Hive.openBox<PreTareoProcesoUvaDetalleEntity>(box);
    await tareas.addAll(detalles);
    await tareas.close();
    return Success(data: detalles);
  }

  @override
  Future<ResultType<PreTareoProcesoUvaDetalleEntity, Failure>> delete(
      PreTareoProcesoUvaDetalleEntity detalle) async {
    var tareas = await Hive.openBox<PreTareoProcesoUvaDetalleEntity>(
        '$PACKING_PERSONAL_INIT_HIVE_STRING${detalle.keyParent}');
    await tareas.delete(detalle.key);

    await tareas.close();
    return Success(data: detalle);
  }

  @override
  Future<ResultType<PreTareoProcesoUvaEntity, Failure>> deleteAll(
      PreTareoProcesoUvaEntity header) async {
    var tareas = await Hive.openBox<PreTareoProcesoUvaDetalleEntity>(
        '$PACKING_PERSONAL_INIT_HIVE_STRING${header.key}');
    await tareas.deleteFromDisk();
    await tareas.close();
    return Success(data: header);
  }

  @override
  Future<ResultType<PreTareoProcesoUvaDetalleEntity, Failure>> update(
      PreTareoProcesoUvaDetalleEntity detalle) async {
    var tareas = await Hive.openBox<PreTareoProcesoUvaDetalleEntity>(
        '$PACKING_PERSONAL_INIT_HIVE_STRING${detalle.keyParent}');
    await tareas.put(detalle.key, detalle);
    await tareas.close();
    return Success(data: detalle);
  }
}
