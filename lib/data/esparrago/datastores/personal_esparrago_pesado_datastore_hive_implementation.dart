import 'package:flutter_tareo/core/utils/strings/hiveDB.dart';
import 'package:flutter_tareo/core/utils/strings/sqLiteDB.dart';
import 'package:flutter_tareo/domain/entities/message_entity.dart';
import 'package:flutter_tareo/domain/entities/personal_pre_tarea_esparrago_entity.dart';
import 'package:flutter_tareo/domain/esparrago/datastores/personal_esparrago_pesado_datastore.dart';
import 'package:flutter_tareo/domain/utils/failure.dart';
import 'package:flutter_tareo/domain/utils/result_type.dart';
import 'package:flutter_tareo/ui/utils/constants.dart';
import 'package:hive/hive.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class PersonalEsparragoPesadoDatastoreHiveImplementation
    extends PersonalEsparragoPesadoDatastore {
  @override
  Future<ResultType<List<PersonalPreTareaEsparragoEntity>, Failure>> getAll(
      Map<String, dynamic> query) async {
    if (query[KEY_BOX_HIVE] != null) {
      Box<PersonalPreTareaEsparragoEntity> dataHive =
          await Hive.openBox<PersonalPreTareaEsparragoEntity>(
              query[KEY_BOX_HIVE]);
      List<PersonalPreTareaEsparragoEntity> local = [];
      dataHive.toMap().forEach((key, value) => local.add(value));
      await dataHive.close();
      return Success(data: local);
    } else {
      return Error(error: MessageEntity(message: 'No se encontro keyBoxHive'));
    }
  }

  @override
  Future<ResultType<PersonalPreTareaEsparragoEntity, Failure>> create(
      String box, PersonalPreTareaEsparragoEntity detalle) async {
    Box<PersonalPreTareaEsparragoEntity> tareas =
        await Hive.openBox<PersonalPreTareaEsparragoEntity>(box);
    int id = await tareas.add(detalle);
    detalle.key = id;

    Database database = await openDatabase(
        join(await getDatabasesPath(), 'tareo_esparrago.db'));
    int idDB = await database.insert(
      TABLE_NAME_PERSONAL_PRE_TAREA_ESPARRAGO,
      detalle.toDB(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    detalle.idSQLite = idDB;

    await tareas.put(id, detalle);
    await database.close();
    await tareas.close();
    return Success(data: detalle);
  }

  @override
  Future<ResultType<PersonalPreTareaEsparragoEntity, Failure>> delete(
      PersonalPreTareaEsparragoEntity detalle) async {
    try {
      Box tareas = await Hive.openBox<PersonalPreTareaEsparragoEntity>(
          '$PERSONAL_PESADO_INIT_HIVE_STRING${detalle.keyParent}');
      int idSQLite = (await tareas.get(detalle.key)).idSQLite;

      await tareas.delete(detalle.key);

      Database database = await openDatabase(
          join(await getDatabasesPath(), 'tareo_esparrago.db'));
      await database.delete(
        TABLE_NAME_PERSONAL_PRE_TAREA_ESPARRAGO,
        where: "id = ?",
        whereArgs: [idSQLite],
      );

      await database.close();
      await tareas.close();
      return Success(data: detalle);
    } catch (e) {
      return Error(
          error: MessageEntity(message: 'No se pudo eliminar este registro'));
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
