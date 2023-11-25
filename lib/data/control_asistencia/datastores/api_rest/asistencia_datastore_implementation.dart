import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter_tareo/core/utils/config.dart';
import 'package:flutter_tareo/data/utils/app_http_manager.dart';
import 'package:flutter_tareo/domain/control_asistencia/datastores/asistencia_data_store.dart';
import 'package:flutter_tareo/domain/entities/asistencia_fecha_turno_entity.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:mime_type/mime_type.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class AsistenciaDataStoreImplementation extends AsistenciaDataStore {
  final urlModule = '/asistencia_fecha_turno';

  @override
  Future<List<AsistenciaFechaTurnoEntity>> getAll() async {
    final AppHttpManager http = AppHttpManager();

    final res = await http.get(
        url: urlModule, query: {'idusuario': PreferenciasUsuario().idUsuario});
    return asistenciaFechaTurnoEntityFromJson(res);
  }

  @override
  Future<List<AsistenciaFechaTurnoEntity>> getAllByValue(
      Map<String, dynamic> valores) async {
    final AppHttpManager http = AppHttpManager();

    final res = await http.get(
      url: urlModule,
    );

    return asistenciaFechaTurnoEntityFromJson(res);
  }

  @override
  Future<int> create(AsistenciaFechaTurnoEntity asistencia) async {
    final AppHttpManager http = AppHttpManager();

    final res = await http.post(
      url: '$urlModule/create',
      body: asistencia.toJson(),
    );

    return AsistenciaFechaTurnoEntity.fromJson(jsonDecode(res))
        .idasistenciaturno;
  }

  @override
  Future<void> delete(int key) async {
    final AppHttpManager http = AppHttpManager();

    final res = await http.delete(
      url: '${urlModule}/delete/$key',
    );

    return AsistenciaFechaTurnoEntity.fromJson(jsonDecode(res));
  }

  @override
  Future<void> update(AsistenciaFechaTurnoEntity data, int index) async {
    final AppHttpManager http = AppHttpManager();

    final res = await http.put(url: '${urlModule}/update', body: data.toJson());

    return AsistenciaFechaTurnoEntity.fromJson(jsonDecode(res));
  }

  @override
  Future<AsistenciaFechaTurnoEntity> migrar(
      AsistenciaFechaTurnoEntity asistencia) async {
    final AppHttpManager http = AppHttpManager();
    asistencia.estadoLocal = 'M';
    final res = await http.put(
      url: '$urlModule/update',
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
