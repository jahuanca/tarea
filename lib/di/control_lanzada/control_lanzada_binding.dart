import 'package:flutter_tareo/data/asignacion_personal/datastores/asignacion_personal_datastore_implementation.dart';
import 'package:flutter_tareo/data/asignacion_personal/repositories/asignacion_personal_repository_implementacion.dart';
import 'package:flutter_tareo/domain/asignacion_personal/datastores/asignacion_personal_datastore.dart';
import 'package:flutter_tareo/domain/asignacion_personal/respositories/asignacion_personal_repository.dart';
import 'package:flutter_tareo/domain/asignacion_personal/use_cases/buscar_linea_mesa/get_linea_mesa_use_case.dart';
import 'package:flutter_tareo/ui/esparrago_varios/control_lanzada/control_lanzada_controller.dart';
import 'package:flutter_tareo/ui/esparrago_varios/control_lanzada/reporte/reporte_lanzada_controller.dart';
import 'package:get/get.dart';

class ControlLanzadaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AsignacionPersonalDataStore>(
        () => AsignacionPersonalDataStoreImplementation());

    Get.lazyPut<AsignacionPersonalRepository>(
        () => AsignacionPersonalRepositoryImplementation(Get.find()));

    Get.lazyReplace<GetLineaMesaUseCase>(() => GetLineaMesaUseCase(Get.find()));

    Get.lazyPut<ControlLanzadaController>(
        () => ControlLanzadaController(Get.find()));

    Get.lazyPut<ReporteLanzadaController>(
        () => ReporteLanzadaController(Get.find()));
  }
}
