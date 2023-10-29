
import 'dart:convert';

import 'package:flutter_tareo/data/utils/app_http_manager.dart';
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_detalle_entity.dart';
import 'package:flutter_tareo/domain/repositories/caja_detalle_repository.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:hive/hive.dart';

class CajaDetalleRepositoryImplementation
    extends CajaDetalleRepository {
  
  final urlModule = '/personal_vehiculo';

  @override
  Future<List<PreTareaEsparragoDetalleEntity>> getAll(String box) async {
    Box<PreTareaEsparragoDetalleEntity> dataHive =
        await Hive.openBox<PreTareaEsparragoDetalleEntity>(
            box);
    List<PreTareaEsparragoDetalleEntity> local = [];
    dataHive.toMap().forEach((key, value) => local.add(value));
    /* local.sort((a, b) => b.fechamod.compareTo(a.fechamod)); */
    await dataHive.close();
    return local;
  }

  @override
  Future<List<PreTareaEsparragoDetalleEntity>> getAllByValues(
      String box, Map<String, dynamic> valores) async {
    if (PreferenciasUsuario().offLine) {
      Box<PreTareaEsparragoDetalleEntity> dataHive =
          await Hive.openBox<PreTareaEsparragoDetalleEntity>(
              box);
      List<PreTareaEsparragoDetalleEntity> local = [];

      dataHive.values.forEach((e) {
        bool guardar = true;
        valores.forEach((key, value) {
          if (e.toJson()[key] != value) {
            guardar = false;
          }
        });
        if (guardar) local.add(e);
      });
      await dataHive.close();
      return local;
    }

    return [];
  }

  @override
  Future<int> create(String box, PreTareaEsparragoDetalleEntity detalle) async {
    var tareas = await Hive.openBox<PreTareaEsparragoDetalleEntity>(
        box);
    int key = await tareas.add(detalle);
    detalle.key = key;
    tareas.put(key, detalle);
    return key;
  }

  @override
  Future<void> delete(String box, int index) async {
    var tareas = await Hive.openBox<PreTareaEsparragoDetalleEntity>(
        box);
    await tareas.deleteAt(index);
    return tareas.close();
  }

  @override
  Future<void> update(
      String box, PreTareaEsparragoDetalleEntity vehiculo, int index) async {
    var tareas = await Hive.openBox<PreTareaEsparragoDetalleEntity>(
        box);
    return await tareas.put(index, vehiculo);
  }

  @override
  Future<List<PreTareaEsparragoDetalleEntity>> getAllRegistrados(String box) async{
    Box<PreTareaEsparragoDetalleEntity> dataHive =
        await Hive.openBox<PreTareaEsparragoDetalleEntity>(
            box);
    List<PreTareaEsparragoDetalleEntity> local = [];
    dataHive.toMap().forEach((key, value) => local.add(value));
    /* local.sort((a, b) => b.fechamod.compareTo(a.fechamod)); */
    await dataHive.close();
    return local;
  }

  @override
  Future<int> getAllByCaja() async{

    final AppHttpManager http = AppHttpManager();

    final res = await http.get(
      url: '$urlModule/bytemporada'
    );

    var j=jsonDecode(res);
    int cantidad=0;
    for (var entry in j.entries) {

      var d=await Hive.openBox<PreTareaEsparragoDetalleEntity>('personal_vehiculo_sincronizar_${entry.key}');
      await d.deleteFromDisk();
      Box dataHive = await Hive.openBox<PreTareaEsparragoDetalleEntity>('personal_vehiculo_sincronizar_${entry.key}');
      await dataHive.addAll((PreTareaEsparragoDetalleEntityFromJson(jsonEncode(entry.value))).toList());
      cantidad=cantidad+ entry.value.length;
      await dataHive.close();
    }
    return cantidad;
  }

  @override
  Future<List<PreTareaEsparragoDetalleEntity>> getByCaja(int keyCaja) async{
    Box<PreTareaEsparragoDetalleEntity> dataHive =
        await Hive.openBox<PreTareaEsparragoDetalleEntity>(
            'personal_vehiculo_sincronizar_$keyCaja');
    List<PreTareaEsparragoDetalleEntity> local = [];
    dataHive.toMap().forEach((key, value) => local.add(value));
    await dataHive.close();
    return local;
  }
}
