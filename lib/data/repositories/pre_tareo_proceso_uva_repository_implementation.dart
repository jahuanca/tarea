import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter_tareo/core/strings.dart';
import 'package:flutter_tareo/data/http_manager/app_http_manager.dart';
import 'package:flutter_tareo/domain/entities/pre_tareo_proceso_uva_entity.dart';
import 'package:flutter_tareo/domain/repositories/pre_tareo_proceso_uva_repository.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:hive/hive.dart';
import 'package:mime_type/mime_type.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class PreTareoProcesoUvaRepositoryImplementation
    extends PreTareoProcesoUvaRepository {
  final urlModule = '/pre_tareo_proceso_uva';

  @override
  Future<List<PreTareoProcesoUvaEntity>> getAll() async {
    if (PreferenciasUsuario().offLine) {
      Box dataHive = await Hive.openBox<PreTareoProcesoUvaEntity>(
          'pre_tareos_uva_sincronizar');
      List<PreTareoProcesoUvaEntity> local = [];
      dataHive.toMap().forEach((key, value) => local.add(value));
      local.sort((a, b) => b.fechamod.compareTo(a.fechamod));
      await dataHive.close();
      return local;
    }

    final AppHttpManager http = AppHttpManager();

    final res = await http.get(
      url: urlModule,
    );

    return preTareoProcesoUvaEntityFromJson((res));
  }

  @override
  Future<List<PreTareoProcesoUvaEntity>> getAllByValue(
      Map<String, dynamic> valores) async {
    if (PreferenciasUsuario().offLine) {
      Box<PreTareoProcesoUvaEntity> dataHive =
          await Hive.openBox<PreTareoProcesoUvaEntity>(
              'pre_tareos_uva_sincronizar');
      List<PreTareoProcesoUvaEntity> local = [];

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
  Future<void> create(PreTareoProcesoUvaEntity tareaProcesoEntity) async {
    var tareas = await Hive.openBox<PreTareoProcesoUvaEntity>(
        'pre_tareos_uva_sincronizar');
    return await tareas.add(tareaProcesoEntity);
  }

  @override
  Future<void> delete(int index) async {
    var tareas = await Hive.openBox<PreTareoProcesoUvaEntity>(
        'pre_tareos_uva_sincronizar');
    return await tareas.deleteAt(index);
  }

  @override
  Future<void> update(
      PreTareoProcesoUvaEntity tareaProcesoEntity, int index) async {
    var tareas = await Hive.openBox<PreTareoProcesoUvaEntity>(
        'pre_tareos_uva_sincronizar');
    return await tareas.putAt(index, tareaProcesoEntity);
  }

  @override
  Future<PreTareoProcesoUvaEntity> migrar(
      PreTareoProcesoUvaEntity tareaProcesoEntity) async {
    final AppHttpManager http = AppHttpManager();
    final res = await http.post(
      url: '$urlModule/createAll',
      body: tareaProcesoEntity.toJson(),
    );

    return res == null ? null : tareaProcesoEntity;
  }

  @override
  Future<PreTareoProcesoUvaEntity> uploadFile(
      PreTareoProcesoUvaEntity tareaProcesoEntity, File fileLocal) async {
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
      PreTareoProcesoUvaEntity respuesta =
          PreTareoProcesoUvaEntity.fromJson(jsonDecode(response.body));
      tareaProcesoEntity.firmaSupervisor = respuesta.firmaSupervisor;
      return tareaProcesoEntity;
    } catch (e) {
      print('Error');
      log(e.toString());
      return null;
    }
  }
}
