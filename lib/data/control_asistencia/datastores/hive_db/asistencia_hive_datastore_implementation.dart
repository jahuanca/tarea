import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter_tareo/core/utils/config.dart';
import 'package:flutter_tareo/core/utils/strings/hiveDB.dart';
import 'package:flutter_tareo/data/utils/app_http_manager.dart';
import 'package:flutter_tareo/domain/control_asistencia/datastores/asistencia_data_store.dart';
import 'package:flutter_tareo/domain/entities/asistencia_fecha_turno_entity.dart';
import 'package:flutter_tareo/domain/entities/asistencia_registro_personal_entity.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:hive/hive.dart';
import 'package:mime_type/mime_type.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class AsistenciaHiveDataStoreImplementation extends AsistenciaDataStore {
  final urlModule = '/asistencia_fecha_turno';

  @override
  Future<List<AsistenciaFechaTurnoEntity>> getAll() async {
    Box dataHive =
        await Hive.openBox<AsistenciaFechaTurnoEntity>(ASISTENCIA_HIVE_STRING);
    List<AsistenciaFechaTurnoEntity> local = [];
    dataHive.toMap().forEach((key, value) => local.add(value));
    local?.sort((a, b) => b?.fechamod?.compareTo(a?.fechamod));
    await dataHive.compact();
    await dataHive.close();
    return local;
  }

  @override
  Future<List<AsistenciaFechaTurnoEntity>> getAllByValue(
      Map<String, dynamic> valores) async {
    if (PreferenciasUsuario().offLine) {
      Box<AsistenciaFechaTurnoEntity> dataHive =
          await Hive.openBox<AsistenciaFechaTurnoEntity>(
              ASISTENCIA_HIVE_STRING);
      List<AsistenciaFechaTurnoEntity> local = [];

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
  Future<int> create(AsistenciaFechaTurnoEntity asistencia) async {
    var tareas =
        await Hive.openBox<AsistenciaFechaTurnoEntity>(ASISTENCIA_HIVE_STRING);
    int id = await tareas.add(asistencia);
    asistencia.key = id;
    await tareas.put(id, asistencia);
    await tareas.close();
    return id;
  }

  @override
  Future<void> delete(int key) async {
    Box<AsistenciaFechaTurnoEntity> tareas =
        await Hive.openBox<AsistenciaFechaTurnoEntity>(ASISTENCIA_HIVE_STRING);
    await tareas.delete(key);
    await tareas.close();

    Box<AsistenciaRegistroPersonalEntity> registros =
        await Hive.openBox<AsistenciaRegistroPersonalEntity>(
            '${REGISTRO_ASISTENCIA_HIVE_STRING}_$key');
    await registros.deleteFromDisk();
    await registros.close();
    return;
  }

  @override
  Future<void> update(
      AsistenciaFechaTurnoEntity tareaProcesoEntity, int index) async {
    var tareas =
        await Hive.openBox<AsistenciaFechaTurnoEntity>(ASISTENCIA_HIVE_STRING);
    await tareas.putAt(index, tareaProcesoEntity);

    await tareas.close();
    return;
  }

  @override
  Future<AsistenciaFechaTurnoEntity> migrar(
      AsistenciaFechaTurnoEntity asistencia) async {
    final AppHttpManager http = AppHttpManager();

    Box<AsistenciaRegistroPersonalEntity> detalles =
        await Hive.openBox<AsistenciaRegistroPersonalEntity>(
            '${REGISTRO_ASISTENCIA_HIVE_STRING}_${asistencia.key}');

    if (asistencia.detalles == null) asistencia.detalles = [];
    asistencia.detalles = detalles.values.toList();

    final res = await http.post(
      url: '$urlModule/createAll',
      body: asistencia.toJson(),
    );

    return res == null ? null : asistencia;
  }

  @override
  Future<AsistenciaFechaTurnoEntity> uploadFile(
      AsistenciaFechaTurnoEntity tareaProcesoEntity, File fileLocal) async {
    http.MultipartFile file;
    final mimeType = mime(fileLocal.path).split('/');
    file = await http.MultipartFile.fromPath('file', fileLocal.path,
        contentType: MediaType(mimeType[0], mimeType[1]));
    try {
      var request = http.MultipartRequest(
          'PUT', Uri.http(URL_SERVER_SHORT, '$urlModule/updateFile'));
      request.files.add(file);
      request.headers[HttpHeaders.acceptHeader] = 'application/json';
      request.headers[HttpHeaders.contentTypeHeader] = 'multipart/form-data';

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
      AsistenciaFechaTurnoEntity respuesta =
          AsistenciaFechaTurnoEntity.fromJson(jsonDecode(response.body));
      tareaProcesoEntity.firmaSupervisor = respuesta.firmaSupervisor;
      return tareaProcesoEntity;
    } catch (e) {
      print('Error');
      log('Error ${e.toString()}');
      return null;
    }
  }
}
