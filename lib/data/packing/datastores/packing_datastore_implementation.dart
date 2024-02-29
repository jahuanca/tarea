import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter_tareo/core/utils/config.dart';
import 'package:flutter_tareo/core/utils/strings/hiveDB.dart';
import 'package:flutter_tareo/data/packing/urls.dart';
import 'package:flutter_tareo/data/utils/app_http_manager.dart';
import 'package:flutter_tareo/domain/entities/labor_entity.dart';
import 'package:flutter_tareo/domain/entities/message_entity.dart';
import 'package:flutter_tareo/domain/packing/datastores/packing_datastore.dart';
import 'package:flutter_tareo/domain/packing/entities/pre_tareo_proceso_uva_detalle_entity.dart';
import 'package:flutter_tareo/domain/packing/entities/pre_tareo_proceso_uva_entity.dart';
import 'package:flutter_tareo/domain/utils/failure.dart';
import 'package:flutter_tareo/domain/utils/result_type.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:hive/hive.dart';
import 'package:mime_type/mime_type.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class PackingDataStoreImplementation extends PackingDataStore {
  @override
  Future<ResultType<List<PreTareoProcesoUvaEntity>, Failure>> getAll() async {
    final AppHttpManager http = AppHttpManager();
    final res = await http.get(
        url: URL_GET_ALL_PACKINGS_STRING,
        query: {'idusuario': PreferenciasUsuario().idUsuario});
    if (res is MessageEntity) {
      return Error(error: res);
    } else {
      return Success(data: preTareoProcesoUvaEntityFromJson(res));
    }
  }

  @override
  Future<ResultType<List<PreTareoProcesoUvaEntity>, Failure>> getAllByValue(
      Map<String, dynamic> valores) async {
    final AppHttpManager http = AppHttpManager();
    final res = await http.get(
      url: URL_GET_ALL_PACKINGS_STRING,
    );
    if (res is MessageEntity) {
      return Error(error: res);
    } else {
      return Success(data: PreTareoProcesoUvaEntity.fromJson(jsonDecode(res)));
    }
  }

  @override
  Future<ResultType<PreTareoProcesoUvaEntity, Failure>> create(
      PreTareoProcesoUvaEntity packing) async {
    final AppHttpManager http = AppHttpManager();
    final res =
        await http.post(url: URL_CREATE_PACKING_STRING, body: packing.toJson());
    if (res is MessageEntity) {
      return Error(error: res);
    } else {
      return Success(data: PreTareoProcesoUvaEntity.fromJson(jsonDecode(res)));
    }
  }

  @override
  Future<ResultType<PreTareoProcesoUvaEntity, Failure>> delete(
      PreTareoProcesoUvaEntity packing) async {
    final AppHttpManager http = AppHttpManager();
    final res = await http.delete(
      url: '$URL_DELETE_PACKING_STRING${packing.getId}',
    );
    if (res is MessageEntity) {
      return Error(error: res);
    } else {
      return Success(data: packing);
    }
  }

  @override
  Future<ResultType<PreTareoProcesoUvaEntity, Failure>> update(
      PreTareoProcesoUvaEntity packing) async {
    final AppHttpManager http = AppHttpManager();
    final res =
        await http.put(url: URL_UPDATE_PACKING_STRING, body: packing.toJson());
    if (res is MessageEntity) {
      return Error(error: res);
    } else {
      return Success(data: packing);
    }
  }

  @override
  Future<ResultType<PreTareoProcesoUvaEntity, Failure>> migrar(
      PreTareoProcesoUvaEntity packing) async {
    Box<PreTareoProcesoUvaEntity> tareas =
        await Hive.openBox<PreTareoProcesoUvaEntity>(PACKING_HIVE_STRING);
    PreTareoProcesoUvaEntity data = await tareas.get(packing.key);
    if (data.detalles == null) data.detalles = [];
    await tareas.close();

    Box<PreTareoProcesoUvaDetalleEntity> detalles =
        await Hive.openBox<PreTareoProcesoUvaDetalleEntity>(
            'uva_detalle_${packing.key}');
    data.detalles = detalles.values.toList();
    await detalles.close();

    final AppHttpManager http = AppHttpManager();
    final res = await http.post(
      url: URL_MIGRATE_PACKING_STRING,
      body: data.toJson(),
    );

    return Success(data: PreTareoProcesoUvaEntity.fromJson(jsonDecode(res)));
  }

  @override
  Future<ResultType<PreTareoProcesoUvaEntity, Failure>> uploadFile(
      PreTareoProcesoUvaEntity packing, File fileLocal) async {
    http.MultipartFile file;
    final mimeType = mime(fileLocal.path).split('/');
    file = await http.MultipartFile.fromPath('file', fileLocal.path,
        contentType: MediaType(mimeType[0], mimeType[1]));
    print(file.contentType.toString());
    try {
      var request = http.MultipartRequest(
          'PUT', Uri.http(URL_SERVER_SHORT, URL_FILE_PACKING_STRING));
      request.files.add(file);
      request.headers[HttpHeaders.acceptHeader] = 'application/json';
      request.headers[HttpHeaders.contentTypeHeader] = 'multipart/form-data';

      for (var i = 0; i < packing.toJson().entries.length; i++) {
        MapEntry map = packing.toJson().entries.elementAt(i);
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
      PreTareoProcesoUvaEntity respuesta =
          PreTareoProcesoUvaEntity.fromJson(jsonDecode(response.body));
      packing.firmaSupervisor = respuesta.firmaSupervisor;
      return Success(data: packing);
    } catch (e) {
      if (SHOW_LOG) {
        print('Error');
        log(e.toString());
      }
      return null;
    }
  }

  @override
  Future<ResultType<List<LaborEntity>, Failure>> getReportByDocument(
      String code, PreTareoProcesoUvaEntity header) async {
    final AppHttpManager http = AppHttpManager();
    final res = await http.get(url: URL_REPORT_PACKING_STRING, query: {
      'codigoempresa': code,
      'itempretareaprocesouva': header.itempretareaprocesouva
    });
    if (res is MessageEntity) {
      return Error(error: res);
    } else {
      return Success(data: laborEntityFromJson(res));
    }
  }
}

extension IterableBase<E> on Iterable<E> {
  Map<K, List<E>> groupBy<K>(K Function(E) keyFunction) => fold(
      <K, List<E>>{},
      (Map<K, List<E>> map, E element) =>
          map..putIfAbsent(keyFunction(element), () => <E>[]).add(element));
}
