import 'dart:convert';

import 'package:flutter_tareo/core/utils/strings/hiveDB.dart';
import 'package:flutter_tareo/data/utils/app_http_manager.dart';
import 'package:flutter_tareo/domain/control_asistencia/datastores/asistencia_registro_data_store.dart';
import 'package:flutter_tareo/domain/entities/asistencia_registro_personal_entity.dart';
import 'package:hive/hive.dart';

class AsistenciaRegistroDataStoreImplementation
    extends AsistenciaRegistroDataStore {
  final urlModule = '/asistencia_registro_personal';
  @override
  Future<List<AsistenciaRegistroPersonalEntity>> getAll(int key) async {
    final AppHttpManager http = AppHttpManager();

    final res = await http.get(url: urlModule, query: {
      'idasistenciaturno': key,
    });

    return asistenciaRegistroPersonalEntityFromJson(res);
  }

  @override
  Future<int> create(int key, AsistenciaRegistroPersonalEntity detalle) async {
    final AppHttpManager http = AppHttpManager();

    final res =
        await http.post(url: '${urlModule}/create', body: detalle.toJson());

    return AsistenciaRegistroPersonalEntity.fromJson(jsonDecode(res))
        .idasistencia;
  }

  @override
  Future<void> delete(int keyBox, int key) async {
    final AppHttpManager http = AppHttpManager();

    final res = await http.delete(url: '${urlModule}/delete/${key}');

    return AsistenciaRegistroPersonalEntity.fromJson(jsonDecode(res))
        .idasistencia;
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
    final AppHttpManager http = AppHttpManager();

    final res =
        await http.put(url: '${urlModule}/update', body: detalle.toJson());

    return AsistenciaRegistroPersonalEntity.fromJson(jsonDecode(res))
        .idasistencia;
  }
}
