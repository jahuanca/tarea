import 'package:flutter_tareo/domain/control_lanzada/entities/reporte_pesado_linea_mesa_entity.dart';
import 'package:flutter_tareo/domain/control_lanzada/entities/resumen_lanzada_entity.dart';
import 'package:flutter_tareo/domain/utils/failure.dart';
import 'package:flutter_tareo/domain/utils/result_type.dart';

abstract class ControlLanzadaRepository {
  Future<ResultType<List<ResumenLanzadaEntity>, Failure>> getResumen(
      int itempretareaesparragovarios);

  Future<ResultType<ReportePesadoLineaMesaEntity, Failure>>
      getReportePesadoLineaMesa(Map<String, dynamic> value);
}
