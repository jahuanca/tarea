import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter_tareo/core/utils/strings.dart';
import 'package:flutter_tareo/data/utils/app_http_manager.dart';
import 'package:flutter_tareo/domain/entities/pre_tareo_proceso_uva_detalle_entity.dart';
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
      Box<PreTareoProcesoUvaEntity> dataHive =
          await Hive.openBox<PreTareoProcesoUvaEntity>(
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
      await dataHive.compact();
      await dataHive.close();
      return local;
    }

    return [];
  }

  @override
  Future<int> create(PreTareoProcesoUvaEntity preTareaProcesoUvaEntity) async {
    var tareas = await Hive.openBox<PreTareoProcesoUvaEntity>(
        'pre_tareos_uva_sincronizar');
    int id = await tareas.add(preTareaProcesoUvaEntity);
    preTareaProcesoUvaEntity.key = id;
    await tareas.put(id, preTareaProcesoUvaEntity);

    await tareas.close();
    return id;
  }

  @override
  Future<void> delete(int key) async {
    Box<PreTareoProcesoUvaEntity> tareas =
        await Hive.openBox<PreTareoProcesoUvaEntity>(
            'pre_tareos_uva_sincronizar');
    await tareas.delete(key);
    await tareas.close();

    Box<PreTareoProcesoUvaDetalleEntity> detalles =
        await Hive.openBox<PreTareoProcesoUvaDetalleEntity>(
            'uva_detalle_${key}');
    await detalles.deleteFromDisk();
    return;
  }

  @override
  Future<void> update(
      PreTareoProcesoUvaEntity preTareaProcesoUvaEntity, int id) async {
    Box<PreTareoProcesoUvaEntity> tareas =
        await Hive.openBox<PreTareoProcesoUvaEntity>(
            'pre_tareos_uva_sincronizar');
    await tareas.put(id, preTareaProcesoUvaEntity);

    await tareas.close();
    return;
  }

  @override
  Future<PreTareoProcesoUvaEntity> migrar(int key) async {
    Box<PreTareoProcesoUvaEntity> tareas =
        await Hive.openBox<PreTareoProcesoUvaEntity>(
            'pre_tareos_uva_sincronizar');
    PreTareoProcesoUvaEntity data = await tareas.get(key);
    if (data.detalles == null) data.detalles = [];
    await tareas.close();

    Box<PreTareoProcesoUvaDetalleEntity> detalles =
        await Hive.openBox<PreTareoProcesoUvaDetalleEntity>(
            'uva_detalle_${key}');
    data.detalles = detalles.values.toList();
    await detalles.close();

    final AppHttpManager http = AppHttpManager();
    final res = await http.post(
      url: '$urlModule/createAll',
      body: data.toJson(),
    );

    return res == null
        ? null
        : PreTareoProcesoUvaEntity.fromJson(jsonDecode(res));
  }

  @override
  Future<PreTareoProcesoUvaEntity> uploadFile(
      PreTareoProcesoUvaEntity preTareaProcesoUvaEntity, File fileLocal) async {
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
          i < preTareaProcesoUvaEntity.toJson().entries.length;
          i++) {
        MapEntry map = preTareaProcesoUvaEntity.toJson().entries.elementAt(i);
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
      PreTareoProcesoUvaEntity respuesta =
          PreTareoProcesoUvaEntity.fromJson(jsonDecode(response.body));
      preTareaProcesoUvaEntity.firmaSupervisor = respuesta.firmaSupervisor;
      return preTareaProcesoUvaEntity;
    } catch (e) {
      if (mostrarLog) {
        print('Error');
        log(e.toString());
      }
      return null;
    }
  }
}
