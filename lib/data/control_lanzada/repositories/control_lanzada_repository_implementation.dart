import 'package:flutter_tareo/domain/control_lanzada/datastores/control_lanzada_datastore.dart';
import 'package:flutter_tareo/domain/control_lanzada/entities/reporte_pesado_linea_mesa_entity.dart';
import 'package:flutter_tareo/domain/control_lanzada/entities/resumen_lanzada_entity.dart';
import 'package:flutter_tareo/domain/control_lanzada/repositories/control_lanzada_repository.dart';
import 'package:flutter_tareo/domain/utils/result_type.dart';
import 'package:flutter_tareo/domain/utils/failure.dart';

class ControlLanzadaRepositoryImplementation extends ControlLanzadaRepository {
  ControlLanzadaDataStore _dataStore;

  ControlLanzadaRepositoryImplementation(this._dataStore);

  @override
  Future<ResultType<List<ResumenLanzadaEntity>, Failure>> getResumen(
      int itempretareaesparragovarios) {
    return _dataStore.getResumen(itempretareaesparragovarios);
  }

  @override
  Future<ResultType<ReportePesadoLineaMesaEntity, Failure>>
      getReportePesadoLineaMesa(Map<String, dynamic> value) {
    return _dataStore.getReportePesadoLineaMesa(value);
  }
}
