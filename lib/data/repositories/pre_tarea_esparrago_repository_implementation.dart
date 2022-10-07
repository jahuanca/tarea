import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter_tareo/core/strings.dart';
import 'package:flutter_tareo/data/http_manager/app_http_manager.dart';
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_detalle_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_formato_entity.dart';
import 'package:flutter_tareo/domain/repositories/pre_tarea_esparrago_repository.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:hive/hive.dart';
import 'package:mime_type/mime_type.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class PreTareaEsparragoRepositoryImplementation
    extends PreTareaEsparragoRepository {
  final urlModule = '/pre_tarea_esparrago';

  @override
  Future<List<PreTareaEsparragoEntity>> getAll() async {
    if (PreferenciasUsuario().offLine) {
      Box dataHive = await Hive.openBox<PreTareaEsparragoEntity>(
          'clasificacion_sincronizar');
      List<PreTareaEsparragoEntity> local = [];
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

    return preTareaEsparragoEntityFromJson((res));
  }

  @override
  Future<List<PreTareaEsparragoEntity>> getAllByValue(
      Map<String, dynamic> valores) async {
    if (PreferenciasUsuario().offLine) {
      Box<PreTareaEsparragoEntity> dataHive =
          await Hive.openBox<PreTareaEsparragoEntity>(
              'clasificacion_sincronizar');
      List<PreTareaEsparragoEntity> local = [];

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
  Future<int> create(PreTareaEsparragoEntity pesado) async {
    var tareas = await Hive.openBox<PreTareaEsparragoEntity>(
        'clasificacion_sincronizar');
    int id = await tareas.add(pesado);
    pesado.key = id;
    await tareas.put(id, pesado);
    await tareas.close();
    return id;
  }

  @override
  Future<void> delete(int key) async {
    var tareas = await Hive.openBox<PreTareaEsparragoEntity>(
        'clasificacion_sincronizar');
    await tareas.delete(key);
    var cajas = await Hive.openBox<PreTareaEsparragoFormatoEntity>(
        'clasificado_caja_${key}');
    for (var i = 0; i < cajas.values.length; i++) {
      cajas.values.toList()[i];
      var detalles = await Hive.openBox<PreTareaEsparragoDetalleEntity>(
          'caja_detalle_${key}');
      detalles.deleteFromDisk();
    }
    await tareas.close();
    return;
  }

  @override
  Future<void> update(PreTareaEsparragoEntity pesado, int key) async {
    var tareas = await Hive.openBox<PreTareaEsparragoEntity>(
        'clasificacion_sincronizar');
    await tareas.put(key, pesado);

    await tareas.close();
    return;
  }

  @override
  Future<PreTareaEsparragoEntity> migrar(int key) async {
    final AppHttpManager http = AppHttpManager();

    Box<PreTareaEsparragoEntity> tareas =
        await Hive.openBox<PreTareaEsparragoEntity>(
            'clasificacion_sincronizar');
    var t = tareas.get(key);
    var cajas = await Hive.openBox<PreTareaEsparragoFormatoEntity>(
        'clasificado_caja_${key}');
    if (t.detalles == null) t.detalles = [];
    print(cajas.length);
    for (var i = 0; i < cajas.values.length; i++) {
      var c = cajas.values.toList()[i];
      var detalles = await Hive.openBox<PreTareaEsparragoDetalleEntity>(
          'caja_detalle_${key}');
      if (c.detalles == null) c.detalles = [];
      c.detalles = detalles.values.toList();
      t.detalles.add(c);
      await detalles.close();
    }
    await cajas.close();
    await tareas.close();

    final res = await http.post(
      url: '$urlModule/createAll',
      body: t?.toJson(),
    );

    return res == null
        ? null
        : PreTareaEsparragoEntity.fromJson(jsonDecode(res));
  }

  @override
  Future<PreTareaEsparragoEntity> uploadFile(
      PreTareaEsparragoEntity pesado, File fileLocal) async {
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

      for (var i = 0; i < pesado.toJson().entries.length; i++) {
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
      PreTareaEsparragoEntity respuesta =
          PreTareaEsparragoEntity.fromJson(jsonDecode(response.body));
      pesado.firmaSupervisor = respuesta.firmaSupervisor;
      return pesado;
    } catch (e) {
      if (mostrarLog) {
        print('Error');
        log(e.toString());
      }
      return null;
    }
  }
}
