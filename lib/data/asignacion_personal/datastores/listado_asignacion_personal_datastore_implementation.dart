import 'dart:convert';

import 'package:flutter_tareo/data/asignacion_personal/utils/constants.dart';
import 'package:flutter_tareo/data/utils/app_http_manager.dart';
import 'package:flutter_tareo/domain/asignacion_personal/datastores/listado_asignacion_personal_datastore.dart';
import 'package:flutter_tareo/domain/entities/esparrago_agrupa_personal_detalle_entity.dart';
import 'package:flutter_tareo/domain/entities/esparrago_agrupa_personal_entity.dart';
import 'package:flutter_tareo/domain/entities/message_entity.dart';
import 'package:flutter_tareo/domain/utils/failure.dart';
import 'package:flutter_tareo/domain/utils/result_type.dart';

class ListadoAsignacionPersonalDatastoreImplementation
    extends ListadoAsignacionPersonalDatastore {
  @override
  Future<ResultType<EsparragoAgrupaPersonalDetalleEntity, Failure>> addDetalle(
      EsparragoAgrupaPersonalEntity asignacion,
      EsparragoAgrupaPersonalDetalleEntity detalle) async {
    final http = new AppHttpManager();
    final res = await http.post(
        url: ADD_DETALLE_ASIGNACION_URL, query: {}, body: detalle.toJson());

    if (res is MessageEntity) {
      return new Error(error: res);
    }
    return new Success(
        data: EsparragoAgrupaPersonalDetalleEntity.fromJson(jsonDecode(res)));
  }

  @override
  Future<List<EsparragoAgrupaPersonalDetalleEntity>> getDetalles(
      int idAsignacion) async {
    final http = new AppHttpManager();
    final res = await http.get(
        url: GET_DETALLES_ASIGNACION_URL,
        query: {'itemagruparpersonal': idAsignacion});
    return EsparragoAgrupaPersonalDetalleEntityFromJson(res);
  }

  @override
  Future<EsparragoAgrupaPersonalDetalleEntity> removeDetalle(
      EsparragoAgrupaPersonalDetalleEntity detalle) {
    // TODO: implement removeDetalle
    throw UnimplementedError();
  }
}
