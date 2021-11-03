import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter_tareo/core/strings.dart';
import 'package:flutter_tareo/data/http_manager/app_http_manager.dart';
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_varios_entity.dart';
import 'package:flutter_tareo/domain/repositories/pre_tarea_esparrago_varios_repository.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:hive/hive.dart';
import 'package:mime_type/mime_type.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class PreTareaEsparragoVariosRepositoryImplementation
    extends PreTareaEsparragoVariosRepository{
  final urlModule = '/pre_tarea_esparrago_varios';

  @override
  Future<List<PreTareaEsparragoVariosEntity>> getAll() async {
    if (PreferenciasUsuario().offLine) {
      Box dataHive = await Hive.openBox<PreTareaEsparragoVariosEntity>(
          'pesados_sincronizar');
      List<PreTareaEsparragoVariosEntity> local = [];
      dataHive.toMap().forEach((key, value) => local.add(value));
      local.sort((a, b) => b.fecha.compareTo(a.fecha));
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
    await tareas.put(id, pesado);
    return id;
  }

  @override
  Future<void> delete(int uuid) async {
    var tareas = await Hive.openBox<PreTareaEsparragoVariosEntity>(
        'pesados_sincronizar');
    return await tareas.delete(uuid);
  }

  @override
  Future<void> update(
      PreTareaEsparragoVariosEntity pesado, int id) async {
    var tareas = await Hive.openBox<PreTareaEsparragoVariosEntity>(
        'pesados_sincronizar');
    return await tareas.put(id, pesado);
  }

  @override
  Future<PreTareaEsparragoVariosEntity> migrar(
      PreTareaEsparragoVariosEntity pesado) async {
    final AppHttpManager http = AppHttpManager();
    final res = await http.post(
      url: '$urlModule/createAll',
      body: pesado.toJson(),
    );

    return res == null ? null : PreTareaEsparragoVariosEntity.fromJson(jsonDecode(res));
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
          'PUT', Uri.http(serverUrlCorta, '$urlModule/updateFile'));
      request.files.add(file);
      request.headers[HttpHeaders.acceptHeader] = 'application/json';
      request.headers[HttpHeaders.contentTypeHeader] = 'multipart/form-data';
      //request.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';

      for (var i = 0;
          i < pesado.toJson().entries.length;
          i++) {
        MapEntry map = pesado.toJson().entries.elementAt(i);
        request.fields.addAll({map.key: map.value.toString()});
      }

      print("Fields: ${request.fields.toString()}");

      print("Api ${request.method} request ${request.url}, with");
      if (mostrarLog) {
        log(request.toString());
      }
      http.Response response =
          await http.Response.fromStream(await request.send());
      if (mostrarLog) {
        print("Result: ${response.statusCode}");
        log(response.body);
      }
      PreTareaEsparragoVariosEntity respuesta =
          PreTareaEsparragoVariosEntity.fromJson(jsonDecode(response.body));
      pesado.firmaSupervisor = respuesta.firmaSupervisor;
      return pesado;
    } catch (e) {
      if(mostrarLog){
        print('Error');
        log(e.toString());
      }
      return null;
    }
  }
}
