import 'dart:convert';

import 'package:flutter_tareo/core/utils/strings/sqLiteDB.dart';
import 'package:flutter_tareo/data/utils/app_http_manager.dart';
import 'package:flutter_tareo/domain/entities/message_entity.dart';
import 'package:flutter_tareo/domain/entities/personal_pre_tarea_esparrago_entity.dart';
import 'package:flutter_tareo/domain/esparrago/datastores/personal_esparrago_pesado_datastore.dart';
import 'package:flutter_tareo/domain/utils/failure.dart';
import 'package:flutter_tareo/domain/utils/result_type.dart';
import 'package:hive/hive.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class PersonalEsparragoPesadoDatastoreImplementation
    extends PersonalEsparragoPesadoDatastore {
  AppHttpManager http;

  PersonalEsparragoPesadoDatastoreImplementation() {
    this.http = AppHttpManager();
  }

  @override
  Future<ResultType<List<PersonalPreTareaEsparragoEntity>, Failure>> getAll(
      Map<String, dynamic> query) async {
    final res = await http.get(url: '/pesado/personal', query: query);
    if (res is MessageEntity) {
      return Error(error: res);
    } else {
      return Success(data: personalPreTareaEsparragoEntityFromJson(res));
    }
  }

  @override
  Future<ResultType<PersonalPreTareaEsparragoEntity, Failure>> create(
      String box, PersonalPreTareaEsparragoEntity detalle) async {
    final res =
        await http.post(url: '/pesado/createPersonal', body: detalle.toJson());
    if (res is MessageEntity) {
      return Error(error: res);
    } else {
      return Success(
          data: PersonalPreTareaEsparragoEntity.fromJson(jsonDecode(res)));
    }
  }

  @override
  Future<ResultType<PersonalPreTareaEsparragoEntity, Failure>> delete(
      PersonalPreTareaEsparragoEntity detalle) async {
    final res = await http.post(
        url: '/pesado/deletePersonal/$detalle.id', body: detalle.toJson());
    if (res is MessageEntity) {
      return Error(error: res);
    } else {
      return Success(
          data: PersonalPreTareaEsparragoEntity.fromJson(jsonDecode(res)));
    }
  }

  @override
  Future<void> deleteAll(String box) async {
    var tareas = await Hive.openBox<PersonalPreTareaEsparragoEntity>(box);
    await tareas.deleteFromDisk();

    await tareas.close();
    return;
  }

  @override
  Future<void> update(
      String box, int key, PersonalPreTareaEsparragoEntity detalle) async {
    var tareas = await Hive.openBox<PersonalPreTareaEsparragoEntity>(box);
    await tareas.put(key, detalle);

    Database database = await openDatabase(
        join(await getDatabasesPath(), 'tareo_esparrago.db'));
    await database.update(
      TABLE_NAME_PERSONAL_PRE_TAREA_ESPARRAGO,
      detalle.toDB(),
      where: "id = ?",
      whereArgs: [detalle.idSQLite],
    );
    await database.close();

    await tareas.close();
    return;
  }
}
