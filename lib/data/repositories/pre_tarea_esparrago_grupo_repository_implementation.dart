import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter_tareo/core/utils/config.dart';
import 'package:flutter_tareo/data/utils/app_http_manager.dart';
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_detalle_grupo_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_grupo_entity.dart';
import 'package:flutter_tareo/domain/repositories/pre_tarea_esparrago_grupo_repository.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:hive/hive.dart';
import 'package:mime_type/mime_type.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class PreTareaEsparragoGrupoRepositoryImplementation
    extends PreTareaEsparragoGrupoRepository {
  final urlModule = '/pre_tarea_esparrago_grupo';

  @override
  Future<List<PreTareaEsparragoGrupoEntity>> getAll() async {
    if (PreferenciasUsuario().offLine) {
      Box dataHive = await Hive.openBox<PreTareaEsparragoGrupoEntity>(
          'seleccion_sincronizar');
      List<PreTareaEsparragoGrupoEntity> local = [];
      dataHive.toMap().forEach((key, value) => local.add(value));
      local.sort((a, b) => b.fecha.compareTo(a.fecha));
      await dataHive.close();
      return local;
    }

    final AppHttpManager http = AppHttpManager();

    final res = await http.get(
      url: urlModule,
    );

    return preTareaEsparragoGrupoEntityFromJson((res));
  }

  @override
  Future<List<PreTareaEsparragoGrupoEntity>> getAllByValue(
      Map<String, dynamic> valores) async {
    if (PreferenciasUsuario().offLine) {
      Box<PreTareaEsparragoGrupoEntity> dataHive =
          await Hive.openBox<PreTareaEsparragoGrupoEntity>(
              'seleccion_sincronizar');
      List<PreTareaEsparragoGrupoEntity> local = [];

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
  Future<int> create(PreTareaEsparragoGrupoEntity pesado) async {
    var tareas = await Hive.openBox<PreTareaEsparragoGrupoEntity>(
        'seleccion_sincronizar');
    int id = await tareas.add(pesado);
    pesado.key = id;
    await tareas.put(id, pesado);

    await tareas.close();
    return id;
  }

  @override
  Future<void> delete(int key) async {
    Box<PreTareaEsparragoDetalleGrupoEntity> d =
        await Hive.openBox<PreTareaEsparragoDetalleGrupoEntity>(
            'seleccion_detalles_$key');
    await d.deleteFromDisk();

    Box<PreTareaEsparragoGrupoEntity> tareas =
        await Hive.openBox<PreTareaEsparragoGrupoEntity>(
            'seleccion_sincronizar');
    await tareas.delete(key);

    await tareas.close();
    return;
  }

  @override
  Future<void> update(PreTareaEsparragoGrupoEntity pesado, int id) async {
    var tareas = await Hive.openBox<PreTareaEsparragoGrupoEntity>(
        'seleccion_sincronizar');
    await tareas.put(id, pesado);

    await tareas.close();
    return;
  }

  @override
  Future<PreTareaEsparragoGrupoEntity> migrar(int key) async {
    final AppHttpManager http = AppHttpManager();

    Box<PreTareaEsparragoGrupoEntity> tareas =
        await Hive.openBox<PreTareaEsparragoGrupoEntity>(
            'seleccion_sincronizar');
    Box<PreTareaEsparragoDetalleGrupoEntity> detalles =
        await Hive.openBox<PreTareaEsparragoDetalleGrupoEntity>(
            'seleccion_detalles_$key');

    PreTareaEsparragoGrupoEntity tarea = tareas.get(key);

    if (tarea.detalles == null) tarea.detalles = [];
    tarea.detalles = detalles.values.toList();

    final res = await http.post(
      url: '$urlModule/createAll',
      body: tarea?.toJson(),
    );

    return res == null
        ? null
        : PreTareaEsparragoGrupoEntity.fromJson(jsonDecode(res));
  }

  @override
  Future<PreTareaEsparragoGrupoEntity> uploadFile(
      PreTareaEsparragoGrupoEntity pesado, File fileLocal) async {
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
      //request.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';

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
      PreTareaEsparragoGrupoEntity respuesta =
          PreTareaEsparragoGrupoEntity.fromJson(jsonDecode(response.body));
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
