import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter_tareo/core/utils/config.dart';
import 'package:flutter_tareo/core/utils/strings/hiveDB.dart';
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

class PackingDataStoreHiveImplementation extends PackingDataStore {
  final urlModule = '/pre_tareo_proceso_uva';

  @override
  Future<ResultType<List<PreTareoProcesoUvaEntity>, Failure>> getAll() async {
    if (PreferenciasUsuario().offLine) {
      Box<PreTareoProcesoUvaEntity> dataHive =
          await Hive.openBox<PreTareoProcesoUvaEntity>(PACKING_HIVE_STRING);
      List<PreTareoProcesoUvaEntity> local = dataHive.values.toList();
      await dataHive.close();
      for (var value in local) {
        Box<PreTareoProcesoUvaDetalleEntity> detailsHive =
            await Hive.openBox<PreTareoProcesoUvaDetalleEntity>(
                '$PACKING_PERSONAL_INIT_HIVE_STRING${value.key}');
        value.sizeDetails = detailsHive.length;
        await detailsHive.close();
      }
      local.sort((a, b) => b.fechamod.compareTo(a.fechamod));
      return Success(data: local);
    }
    return Error(error: MessageEntity(message: 'No se pudo obtener los datos'));
  }

  @override
  Future<ResultType<List<PreTareoProcesoUvaEntity>, Failure>> getAllByValue(
      Map<String, dynamic> valores) async {
    if (PreferenciasUsuario().offLine) {
      Box<PreTareoProcesoUvaEntity> dataHive =
          await Hive.openBox<PreTareoProcesoUvaEntity>(PACKING_HIVE_STRING);
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
      return Success(data: local);
    }

    return Error(error: MessageEntity(message: 'No se pudo obtener'));
  }

  @override
  Future<ResultType<PreTareoProcesoUvaEntity, Failure>> create(
      PreTareoProcesoUvaEntity packing) async {
    var tareas =
        await Hive.openBox<PreTareoProcesoUvaEntity>(PACKING_HIVE_STRING);
    int id = await tareas.add(packing);
    packing.key = id;
    await tareas.put(id, packing);

    await tareas.close();
    return Success(data: packing);
  }

  @override
  Future<ResultType<PreTareoProcesoUvaEntity, Failure>> delete(
      PreTareoProcesoUvaEntity packing) async {
    Box<PreTareoProcesoUvaEntity> tareas =
        await Hive.openBox<PreTareoProcesoUvaEntity>(PACKING_HIVE_STRING);
    await tareas.delete(packing.key);
    await tareas.close();

    Box<PreTareoProcesoUvaDetalleEntity> detalles =
        await Hive.openBox<PreTareoProcesoUvaDetalleEntity>(
            'uva_detalle_${packing.key}');
    await detalles.deleteFromDisk();
    return Success(data: packing);
  }

  @override
  Future<ResultType<PreTareoProcesoUvaEntity, Failure>> update(
      PreTareoProcesoUvaEntity packing) async {
    Box<PreTareoProcesoUvaEntity> tareas =
        await Hive.openBox<PreTareoProcesoUvaEntity>(PACKING_HIVE_STRING);
    await tareas.put(packing.key, packing);

    await tareas.close();
    return Success(data: packing);
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
      url: '$urlModule/createAll',
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
          'PUT', Uri.http(URL_SERVER_SHORT, '$urlModule/updateFile'));
      request.files.add(file);
      request.headers[HttpHeaders.acceptHeader] = 'application/json';
      request.headers[HttpHeaders.contentTypeHeader] = 'multipart/form-data';
      //request.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';

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
    Box<PreTareoProcesoUvaEntity> tareas =
        await Hive.openBox<PreTareoProcesoUvaEntity>(PACKING_HIVE_STRING);
    PreTareoProcesoUvaEntity data = await tareas.get(header.key);
    if (data.detalles == null) data.detalles = [];
    await tareas.close();

    Box<PreTareoProcesoUvaDetalleEntity> detalles =
        await Hive.openBox<PreTareoProcesoUvaDetalleEntity>(
            'uva_detalle_${header.key}');
    data.detalles = detalles.values.toList();
    await detalles.close();
    data.detalles.removeWhere((e) => e.codigoempresa != code);
    final releaseDateMap = data.detalles.groupBy((m) => m.idlabor);
    return Success(data: releaseDateMap);
  }
}

extension IterableBase<E> on Iterable<E> {
  Map<K, List<E>> groupBy<K>(K Function(E) keyFunction) => fold(
      <K, List<E>>{},
      (Map<K, List<E>> map, E element) =>
          map..putIfAbsent(keyFunction(element), () => <E>[]).add(element));
}
