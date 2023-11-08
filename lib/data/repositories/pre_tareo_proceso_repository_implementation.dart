import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter_tareo/core/utils/config.dart';
import 'package:flutter_tareo/data/utils/app_http_manager.dart';
import 'package:flutter_tareo/domain/entities/pre_tareo_proceso_entity.dart';
import 'package:flutter_tareo/domain/repositories/pre_tareo_proceso_repository.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:hive/hive.dart';
import 'package:mime_type/mime_type.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class PreTareoProcesoRepositoryImplementation
    extends PreTareoProcesoRepository {
  final urlModule = '/pre_tareo_proceso';

  @override
  Future<List<PreTareoProcesoEntity>> getAll() async {
    if (PreferenciasUsuario().offLine) {
      Box dataHive =
          await Hive.openBox<PreTareoProcesoEntity>('pre_tareos_sincronizar');
      List<PreTareoProcesoEntity> local = [];
      dataHive.toMap().forEach((key, value) => local.add(value));
      local.sort((a, b) => b.fechamod.compareTo(a.fechamod));
      await dataHive.compact();
      await dataHive.close();
      return local;
    }

    final AppHttpManager http = AppHttpManager();

    final res = await http.get(
      url: urlModule,
    );

    return preTareoProcesoEntityFromJson((res));
  }

  @override
  Future<List<PreTareoProcesoEntity>> getAllByValue(
      Map<String, dynamic> valores) async {
    if (PreferenciasUsuario().offLine) {
      Box<PreTareoProcesoEntity> dataHive =
          await Hive.openBox<PreTareoProcesoEntity>('pre_tareos_sincronizar');
      List<PreTareoProcesoEntity> local = [];

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
  Future<void> create(PreTareoProcesoEntity tareaProcesoEntity) async {
    var tareas =
        await Hive.openBox<PreTareoProcesoEntity>('pre_tareos_sincronizar');
    await tareas.add(tareaProcesoEntity);

    await tareas.close();
    return;
  }

  @override
  Future<void> delete(int index) async {
    var tareas =
        await Hive.openBox<PreTareoProcesoEntity>('pre_tareos_sincronizar');
    await tareas.deleteAt(index);

    await tareas.close();
    return;
  }

  @override
  Future<void> update(
      PreTareoProcesoEntity tareaProcesoEntity, int index) async {
    var tareas =
        await Hive.openBox<PreTareoProcesoEntity>('pre_tareos_sincronizar');
    await tareas.putAt(index, tareaProcesoEntity);

    await tareas.close();
    return;
  }

  @override
  Future<PreTareoProcesoEntity> migrar(
      PreTareoProcesoEntity tareaProcesoEntity) async {
    final AppHttpManager http = AppHttpManager();
    final res = await http.post(
      url: '$urlModule/createAll',
      body: tareaProcesoEntity.toJson(),
    );

    return res == null ? null : tareaProcesoEntity;
  }

  @override
  Future<PreTareoProcesoEntity> uploadFile(
      PreTareoProcesoEntity tareaProcesoEntity, File fileLocal) async {
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
      PreTareoProcesoEntity respuesta =
          PreTareoProcesoEntity.fromJson(jsonDecode(response.body));
      tareaProcesoEntity.firmaSupervisor = respuesta.firmaSupervisor;
      return tareaProcesoEntity;
    } catch (e) {
      print('Error');
      log(e.toString());
      return null;
    }
  }
}
