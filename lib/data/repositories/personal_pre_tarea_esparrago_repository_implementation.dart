import 'package:flutter_tareo/core/utils/strings/sqLiteDB.dart';
import 'package:flutter_tareo/domain/entities/personal_pre_tarea_esparrago_entity.dart';
import 'package:flutter_tareo/domain/repositories/personal_pre_tarea_esparrago_repository.dart';
import 'package:hive/hive.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class PersonalPreTareaEsparragoRepositoryImplementation
    extends PersonalPreTareaEsparragoRepository {
  @override
  Future<List<PersonalPreTareaEsparragoEntity>> getAll(String box) async {
    Box<PersonalPreTareaEsparragoEntity> dataHive =
        await Hive.openBox<PersonalPreTareaEsparragoEntity>(box);
    List<PersonalPreTareaEsparragoEntity> local = [];
    dataHive.toMap().forEach((key, value) => local.add(value));
    await dataHive.close();
    return local;
  }

  @override
  Future<int> create(
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
    return id;
  }

  @override
  Future<void> delete(String box, int key) async {
    var tareas = await Hive.openBox<PersonalPreTareaEsparragoEntity>(box);
    int idSQLite = (await tareas.get(key)).idSQLite;
    await tareas.delete(key);

    Database database = await openDatabase(
        join(await getDatabasesPath(), 'tareo_esparrago.db'));
    await database.delete(
      TABLE_NAME_PERSONAL_PRE_TAREA_ESPARRAGO,
      where: "id = ?",
      whereArgs: [idSQLite],
    );

    await database.close();
    await tareas.close();
    return;
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
