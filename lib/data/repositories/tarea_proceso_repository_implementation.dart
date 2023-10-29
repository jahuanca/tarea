import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter_tareo/core/utils/strings.dart';
import 'package:flutter_tareo/data/utils/app_http_manager.dart';
import 'package:flutter_tareo/domain/entities/personal_tarea_proceso_entity.dart';
import 'package:flutter_tareo/domain/entities/tarea_proceso_entity.dart';
import 'package:flutter_tareo/domain/repositories/tarea_proceso_repository.dart';
import 'package:hive/hive.dart';
import 'package:mime_type/mime_type.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class TareaProcesoRepositoryImplementation extends TareaProcesoRepository {
  final urlModule = '/tarea_proceso';

  @override
  Future<int> create(TareaProcesoEntity tareaProcesoEntity) async {
    var tareas = await Hive.openBox<TareaProcesoEntity>('tarea_proceso');
    int id = await tareas.add(tareaProcesoEntity);
    tareaProcesoEntity.key = id;
    await tareas.put(id, tareaProcesoEntity);

    await tareas.close();
    return id;
  }

  @override
  Future<List<TareaProcesoEntity>> getAll() async {
    var tareas = await Hive.openBox<TareaProcesoEntity>('tarea_proceso');
    return tareas.values.toList();
  }

  @override
  Future<void> delete(int key) async {
    var tareas = await Hive.openBox<TareaProcesoEntity>('tarea_proceso');
    await tareas.delete(key);

    await tareas.close();
    return;
  }

  @override
  Future<void> update(TareaProcesoEntity tareaProcesoEntity, int key) async {
    var tareas = await Hive.openBox<TareaProcesoEntity>('tarea_proceso');
    await tareas.put(key, tareaProcesoEntity);

    await tareas.close();
    return;
  }

  @override
  Future<TareaProcesoEntity> migrar(int key) async {
    Box<TareaProcesoEntity> tareas =
        await Hive.openBox<TareaProcesoEntity>('tarea_proceso');
    TareaProcesoEntity t = tareas.get(key);

    if (t.personal == null) t.personal = [];

    Box<PersonalTareaProcesoEntity> detalles =
        await Hive.openBox<PersonalTareaProcesoEntity>(
            'personal_tarea_proceso_${t.key}');
    t.personal = detalles.values.toList();
    log(t.toJson().toString());
    final AppHttpManager http = AppHttpManager();
    final res = await http.post(
      url: '$urlModule/createAll',
      body: t.toJson(),
    );

    return res == null ? null : TareaProcesoEntity.fromJson(jsonDecode(res));
  }

  @override
  Future<TareaProcesoEntity> uploadFile(
      TareaProcesoEntity tareaProcesoEntity, File fileLocal) async {
    http.MultipartFile file;
    final mimeType = mime(fileLocal.path).split('/');
    file = await http.MultipartFile.fromPath('file', fileLocal.path,
        contentType: MediaType(mimeType[0], mimeType[1]));
    print(file.contentType.toString());
    try {
      var request = http.MultipartRequest(
          'PUT', Uri.http(serverUrlCorta, '$urlModule/updateFile'));
      request.files.add(file);
      request.headers[HttpHeaders.acceptHeader] = 'application/json';
      request.headers[HttpHeaders.contentTypeHeader] = 'multipart/form-data';
      //request.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';

      for (var i = 0; i < tareaProcesoEntity.toJson().entries.length; i++) {
        MapEntry map = tareaProcesoEntity.toJson().entries.elementAt(i);
        request.fields.addAll({map.key: map.value.toString()});
      }

      print("Fields: ${request.fields.toString()}");

      print("Api ${request.method} request ${request.url}, with");
      log(request.toString());
      http.Response response =
          await http.Response.fromStream(await request.send());
      print("Result: ${response.statusCode}");
      log(response.body);
      TareaProcesoEntity respuesta =
          TareaProcesoEntity.fromJson(jsonDecode(response.body));
      tareaProcesoEntity.firmaSupervisor = respuesta.firmaSupervisor;
      return tareaProcesoEntity;
    } catch (e) {
      print('Error');
      log(e.toString());
      return null;
    }
  }
}
