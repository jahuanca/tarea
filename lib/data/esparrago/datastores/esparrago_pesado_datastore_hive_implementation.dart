import 'package:flutter_tareo/core/utils/strings/sqLiteDB.dart';
import 'package:flutter_tareo/domain/entities/message_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_varios_entity.dart';
import 'package:flutter_tareo/domain/esparrago/datastores/esparrago_pesado_datastore.dart';
import 'package:flutter_tareo/domain/utils/result_type.dart';
import 'package:flutter_tareo/domain/utils/failure.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:hive/hive.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class EsparragoPesadoDataStoreHiveImplementation
    extends EsparragoPesadoDataStore {
  @override
  Future<ResultType<PreTareaEsparragoVariosEntity, Failure>> createPesado(
      PreTareaEsparragoVariosEntity pesado) async {
    Box tareas = await Hive.openBox<PreTareaEsparragoVariosEntity>(
        'pesados_sincronizar');
    int id = await tareas.add(pesado);
    pesado.key = id;

    Database database = await openDatabase(
        join(await getDatabasesPath(), 'tareo_esparrago.db'));
    int idDB = await database.insert(
      TABLE_NAME_PRE_TAREA_ESPARRAGO,
      pesado.toDB(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    print('Id: $idDB');
    pesado.idSQLite = idDB;

    await tareas.put(id, pesado);
    await database.close();
    await tareas.close();
    return Success(data: tareas.get(id));
  }

  @override
  Future<ResultType<PreTareaEsparragoVariosEntity, Failure>> updatePesado(
      PreTareaEsparragoVariosEntity pesado, int key) async {
    Box tareas = await Hive.openBox<PreTareaEsparragoVariosEntity>(
        'pesados_sincronizar');

    await tareas.put(key, pesado);
    PreTareaEsparragoVariosEntity tarea = tareas.get(key);
    Database database = await openDatabase(
        join(await getDatabasesPath(), 'tareo_esparrago.db'));
    await database.update(
      TABLE_NAME_PRE_TAREA_ESPARRAGO,
      pesado.toDB(),
      where: "id = ?",
      whereArgs: [pesado.idSQLite],
    );

    await database.close();
    await tareas.close();
    return Success(data: tarea);
  }

  @override
  Future<ResultType<PreTareaEsparragoVariosEntity, Failure>> deletePesado(
      PreTareaEsparragoVariosEntity pesado) async {
    int key = pesado.getId;
    Box tareas = await Hive.openBox<PreTareaEsparragoVariosEntity>(
        'pesados_sincronizar');
    int idSQLite = (await tareas.get(key)).idSQLite;
    await tareas.delete(key);

    Box detalles = await Hive.openBox<PreTareaEsparragoVariosEntity>(
        'pesado_detalles_$key');
    await detalles.deleteFromDisk();

    Database database = await openDatabase(
        join(await getDatabasesPath(), 'tareo_esparrago.db'));
    await database.delete(
      TABLE_NAME_PRE_TAREA_ESPARRAGO,
      where: "id = ?",
      whereArgs: [idSQLite],
    );
    await database.close();

    await tareas.close();
    return Success(data: pesado);
  }

  @override
  Future<ResultType<List<PreTareaEsparragoVariosEntity>, Failure>>
      getAll() async {
    if (PreferenciasUsuario().offLine) {
      Box dataHive = await Hive.openBox<PreTareaEsparragoVariosEntity>(
          'pesados_sincronizar');
      List<PreTareaEsparragoVariosEntity> local = [];
      dataHive.toMap().forEach((key, value) => local.add(value));
      local.sort((a, b) => b.fecha.compareTo(a.fecha));
      await dataHive.compact();
      await dataHive.close();
      return Success(data: local);
    }
    return Error(error: MessageEntity(message: 'No esta en modo OFFLINE'));
  }
}
