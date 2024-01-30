import 'package:flutter_tareo/data/control_lanzada/datastores/control_lanzada_datastore_implementation.dart';
import 'package:flutter_tareo/data/control_lanzada/repositories/control_lanzada_repository_implementation.dart';
import 'package:flutter_tareo/domain/control_lanzada/datastores/control_lanzada_datastore.dart';
import 'package:flutter_tareo/domain/control_lanzada/repositories/control_lanzada_repository.dart';
import 'package:flutter_tareo/domain/control_lanzada/use_cases/get_reporte_pesado_linea_mesa_use_case.dart';
import 'package:get/get.dart';

class ControlLanzadaEsparragoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ControlLanzadaDataStore>(
        () => ControlLanzadaDataStoreImplementation());

    Get.lazyPut<ControlLanzadaRepository>(
        () => ControlLanzadaRepositoryImplementation(Get.find()));

    Get.lazyReplace<GetReportePesadoLineaMesaUseCase>(
        () => GetReportePesadoLineaMesaUseCase(Get.find()));

    /*Get.lazyPut<ReporteLanzadaController>(
        () => ReporteLanzadaController(Get.find()));*/
  }
}
