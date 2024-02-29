import 'dart:convert';

import 'package:flutter_tareo/data/packing/urls.dart';
import 'package:flutter_tareo/data/utils/app_http_manager.dart';
import 'package:flutter_tareo/domain/entities/message_entity.dart';
import 'package:flutter_tareo/domain/packing/datastores/personal_packing_datastore.dart';
import 'package:flutter_tareo/domain/packing/entities/pre_tareo_proceso_uva_detalle_entity.dart';
import 'package:flutter_tareo/domain/packing/entities/pre_tareo_proceso_uva_entity.dart';
import 'package:flutter_tareo/domain/utils/failure.dart';
import 'package:flutter_tareo/domain/utils/result_type.dart';

class PersonalPackingDataStoreImplementation extends PersonalPackingDatastore {
  AppHttpManager http;

  PersonalPackingDataStoreImplementation() {
    this.http = AppHttpManager();
  }

  @override
  Future<ResultType<PreTareoProcesoUvaDetalleEntity, Failure>> create(
      PreTareoProcesoUvaDetalleEntity detalle) async {
    final res = await http.post(
        url: URL_CREATE_PACKING_PERSONAL_STRING, body: detalle.toJson());
    if (res is MessageEntity) {
      return Error(error: res);
    } else {
      return Success(
          data: PreTareoProcesoUvaDetalleEntity.fromJson(jsonDecode(res)));
    }
  }

  @override
  Future<ResultType<PreTareoProcesoUvaDetalleEntity, Failure>> createAll(
      String box, List<PreTareoProcesoUvaDetalleEntity> detalles) async {
    final res = await http.post(
        url: URL_CREATE_PACKING_PERSONAL_STRING,
        body: {'data': jsonEncode(detalles)});
    if (res is MessageEntity) {
      return Error(error: res);
    } else {
      return Success(data: PreTareoProcesoUvaEntity.fromJson(jsonDecode(res)));
    }
  }

  @override
  Future<ResultType<PreTareoProcesoUvaDetalleEntity, Failure>> delete(
      PreTareoProcesoUvaDetalleEntity detalle) async {
    final res = await http.delete(
        url: '$URL_DELETE_PACKING_PERSONAL_STRING${detalle.getId}');
    if (res is MessageEntity) {
      return Error(error: res);
    } else {
      return Success(data: detalle);
    }
  }

  @override
  Future<ResultType<PreTareoProcesoUvaEntity, Failure>> deleteAll(
      PreTareoProcesoUvaEntity header) async {
    final res = await http.delete(
        url: '$URL_DELETE_ALL_PACKING_PERSONAL_STRING${header.getId}');
    if (res is MessageEntity) {
      return Error(error: res);
    } else {
      return Success(data: PreTareoProcesoUvaEntity.fromJson(jsonDecode(res)));
    }
  }

  @override
  Future<ResultType<List<PreTareoProcesoUvaDetalleEntity>, Failure>> getAll(
      PreTareoProcesoUvaEntity header) async {
    final res = await http.get(
        url: '$URL_GET_ALL_PACKING_PERSONAL_STRING${header.getId}');
    if (res is MessageEntity) {
      return Error(error: res);
    } else {
      return Success(data: preTareoProcesoUvaDetalleEntityFromJson(res));
    }
  }

  @override
  Future<ResultType<PreTareoProcesoUvaDetalleEntity, Failure>> update(
      PreTareoProcesoUvaDetalleEntity detalle) async {
    final res = await http.put(
        url: URL_UPDATE_PACKING_PERSONAL_STRING, body: detalle.toJson());
    if (res is MessageEntity) {
      return Error(error: res);
    } else {
      return Success(data: PreTareoProcesoUvaEntity.fromJson(jsonDecode(res)));
    }
  }
}
