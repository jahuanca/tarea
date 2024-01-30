import 'package:flutter_tareo/data/control_lanzada/urls.dart';
import 'package:flutter_tareo/data/utils/app_http_manager.dart';
import 'package:flutter_tareo/domain/control_lanzada/datastores/control_lanzada_datastore.dart';
import 'package:flutter_tareo/domain/control_lanzada/entities/reporte_pesado_linea_mesa_entity.dart';
import 'package:flutter_tareo/domain/entities/message_entity.dart';
import 'package:flutter_tareo/domain/utils/result_type.dart';
import 'package:flutter_tareo/domain/utils/failure.dart';
import 'package:flutter_tareo/domain/control_lanzada/entities/resumen_lanzada_entity.dart';

class ControlLanzadaDataStoreImplementation extends ControlLanzadaDataStore {
  @override
  Future<ResultType<List<ResumenLanzadaEntity>, Failure>> getResumen(
      int itempretareaesparragovarios) async {
    final http = AppHttpManager();
    final res = await http.get(url: GET_RESUMEN_LANZADA, query: {
      'itempretareaesparragovarios': itempretareaesparragovarios,
    });
    if (res is MessageEntity) {
      return Error(error: res);
    } else {
      return Success(data: resumenLanzadaEntityFromJson(res));
    }
  }

  @override
  Future<ResultType<ReportePesadoLineaMesaEntity, Failure>>
      getReportePesadoLineaMesa(Map<String, dynamic> value) async {
    final http = AppHttpManager();
    final res =
        await http.get(url: GET_REPORTE_PESADO_LINEA_MESA, query: value);
    if (res is MessageEntity) {
      return Error(error: res);
    } else {
      return Success(data: reportePesadoLineaMesaEntityFromJson(res));
    }
  }
}
