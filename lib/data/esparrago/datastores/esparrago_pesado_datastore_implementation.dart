import 'dart:convert';

import 'package:flutter_tareo/data/esparrago/urls.dart';
import 'package:flutter_tareo/data/utils/app_http_manager.dart';
import 'package:flutter_tareo/domain/entities/message_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_varios_entity.dart';
import 'package:flutter_tareo/domain/esparrago/datastores/esparrago_pesado_datastore.dart';
import 'package:flutter_tareo/domain/utils/result_type.dart';
import 'package:flutter_tareo/domain/utils/failure.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';

class EsparragoPesadoDataStoreImplementation extends EsparragoPesadoDataStore {
  @override
  Future<ResultType<PreTareaEsparragoVariosEntity, Failure>> createPesado(
      PreTareaEsparragoVariosEntity pesado) async {
    final http = AppHttpManager();
    final res = await http.post(url: CREATE_PESADO_URL, body: pesado.toJson());
    if (res is MessageEntity) {
      return Error(error: res);
    } else {
      return Success(
          data: PreTareaEsparragoVariosEntity.fromJson(jsonDecode(res)));
    }
  }

  @override
  Future<ResultType<PreTareaEsparragoVariosEntity, Failure>> deletePesado(
      PreTareaEsparragoVariosEntity pesado) async {
    final http = AppHttpManager();
    final res = await http.delete(
      url: "$DELETE_PESADO_URL/${pesado.itempretareaesparragovarios}",
    );
    if (res is MessageEntity) {
      return Error(error: res);
    } else {
      return Success(data: pesado);
    }
  }

  @override
  Future<ResultType<List<PreTareaEsparragoVariosEntity>, Failure>>
      getAll() async {
    final http = AppHttpManager();
    final res = await http.get(url: GET_PESADOS_URL, query: {
      'idusuario': PreferenciasUsuario().idUsuario,
    });
    if (res is MessageEntity) {
      return Error(error: res);
    } else {
      return Success(data: preTareaEsparragoVariosEntityFromJson(res));
    }
  }

  @override
  Future<ResultType<PreTareaEsparragoVariosEntity, Failure>> updatePesado(
      PreTareaEsparragoVariosEntity pesado, int key) {
    throw UnimplementedError();
  }
}
