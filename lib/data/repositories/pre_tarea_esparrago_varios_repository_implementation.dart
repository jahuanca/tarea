import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter_tareo/core/utils/config.dart';
import 'package:flutter_tareo/core/utils/strings.dart';
import 'package:flutter_tareo/data/utils/app_http_manager.dart';
import 'package:flutter_tareo/domain/entities/personal_pre_tarea_esparrago_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_varios_entity.dart';
import 'package:flutter_tareo/domain/repositories/pre_tarea_esparrago_varios_repository.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:hive/hive.dart';
import 'package:mime_type/mime_type.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class PreTareaEsparragoVariosRepositoryImplementation
    extends PreTareaEsparragoVariosRepository {
  final urlModule = '/pre_tarea_esparrago_varios';

  @override
  Future<List<PreTareaEsparragoVariosEntity>> getAll() async {
    if (PreferenciasUsuario().offLine) {
      Box dataHive = await Hive.openBox<PreTareaEsparragoVariosEntity>(
          'pesados_sincronizar');
      List<PreTareaEsparragoVariosEntity> local = [];
      dataHive.toMap().forEach((key, value) => local.add(value));
      local.sort((a, b) => b.fecha.compareTo(a.fecha));
      await dataHive.compact();
      await dataHive.close();
      return local;
    }

    final AppHttpManager http = AppHttpManager();

    final res = await http.get(
      url: urlModule,
    );

    return preTareaEsparragoVariosEntityFromJson((res));
  }

  @override
  Future<List<PreTareaEsparragoVariosEntity>> getAllByValue(
      Map<String, dynamic> valores) async {
    if (PreferenciasUsuario().offLine) {
      Box<PreTareaEsparragoVariosEntity> dataHive =
          await Hive.openBox<PreTareaEsparragoVariosEntity>(
              'pesados_sincronizar');
      List<PreTareaEsparragoVariosEntity> local = [];

      dataHive.values.forEach((e) {
        bool guardar = true;
        valores.forEach((key, value) {
          if (e.toJson()[key] != value) {
            guardar = false;
          }
        });
        if (guardar) local.add(e);
      });
      await dataHive.compact();
      await dataHive.close();
      return local;
    }

    return [];
  }

  @override
  Future<int> create(PreTareaEsparragoVariosEntity pesado) async {
    var tareas = await Hive.openBox<PreTareaEsparragoVariosEntity>(
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
    return id;
  }

  @override
  Future<void> delete(int key) async {
    var tareas = await Hive.openBox<PreTareaEsparragoVariosEntity>(
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
    return;
  }

  @override
  Future<void> update(PreTareaEsparragoVariosEntity pesado, int key) async {
    var tareas = await Hive.openBox<PreTareaEsparragoVariosEntity>(
        'pesados_sincronizar');
    await tareas.put(key, pesado);

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
    return;
  }

  @override
  Future<PreTareaEsparragoVariosEntity> migrar(int key) async {
    Box<PreTareaEsparragoVariosEntity> tareas =
        await Hive.openBox<PreTareaEsparragoVariosEntity>(
            'pesados_sincronizar');
    PreTareaEsparragoVariosEntity t = tareas.get(key);

    /* Box<PreTareaEsparragoDetalleVariosEntity> detalles = await Hive.openBox<PreTareaEsparragoDetalleVariosEntity>(
        'pesado_detalles_${key}'); */

    Box<PersonalPreTareaEsparragoEntity> detalles =
        await Hive.openBox<PersonalPreTareaEsparragoEntity>(
            'personal_pre_tarea_esparrago_${key}');

    if (t.detalles == null) t.detalles = [];
    t.detalles = detalles.values.toList();
    await tareas.close();
    await detalles.close();

    final AppHttpManager http = AppHttpManager();
    final res = await http.post(
      url: '$urlModule/createAll',
      body: t.toJson(),
    );

    return res == null
        ? null
        : PreTareaEsparragoVariosEntity.fromJson(jsonDecode(res));
  }

  @override
  Future<PreTareaEsparragoVariosEntity> uploadFile(
      PreTareaEsparragoVariosEntity pesado, File fileLocal) async {
    http.MultipartFile file;
    final mimeType = mime(fileLocal.path).split('/');
    file = await http.MultipartFile.fromPath('file', fileLocal.path,
        contentType: MediaType(mimeType[0], mimeType[1]));
    print(file.contentType.toString());
    try {
      var request = http.MultipartRequest(
          'PUT', Uri.http(URL_SERVER_SHORT, '$urlModule/updateFile'));
      request.files.add(file);
      request.headers[HttpHeaders.acceptHeader] = 'application/json';
      request.headers[HttpHeaders.contentTypeHeader] = 'multipart/form-data';

      for (var i = 0; i < pesado.toJson().entries.length; i++) {
        MapEntry map = pesado.toJson().entries.elementAt(i);
        request.fields.addAll({map.key: map.value.toString()});
      }

      print("Fields: ${request.fields.toString()}");

      print("Api ${request.method} request ${request.url}, with");
      if (SHOW_LOG) {
        log(request.toString());
      }
      http.Response response =
          await http.Response.fromStream(await request.send());
      if (SHOW_LOG) {
        print("Result: ${response.statusCode}");
        log(response.body);
      }
      PreTareaEsparragoVariosEntity respuesta =
          PreTareaEsparragoVariosEntity.fromJson(jsonDecode(response.body));
      pesado.firmaSupervisor = respuesta.firmaSupervisor;
      return pesado;
    } catch (e) {
      if (SHOW_LOG) {
        print('Error');
        log(e.toString());
      }
      return null;
    }
  }
}
