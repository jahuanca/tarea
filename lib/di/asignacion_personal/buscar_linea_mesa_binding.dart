import 'package:flutter_tareo/data/asignacion_personal/datastores/asignacion_personal_datastore_implementation.dart';
import 'package:flutter_tareo/data/asignacion_personal/repositories/asignacion_personal_repository_implementacion.dart';
import 'package:flutter_tareo/data/control_asistencia/repositories/turno_repository_implementation.dart';
import 'package:flutter_tareo/domain/asignacion_personal/datastores/asignacion_personal_datastore.dart';
import 'package:flutter_tareo/domain/asignacion_personal/respositories/asignacion_personal_repository.dart';
import 'package:flutter_tareo/domain/asignacion_personal/use_cases/buscar_linea_mesa/get_linea_mesa_use_case.dart';
import 'package:flutter_tareo/domain/control_asistencia/repositories/turno_repository.dart';
import 'package:flutter_tareo/domain/control_asistencia/use_cases/turno/get_all_turnos_use_case.dart';
import 'package:flutter_tareo/ui/asignacion_personal/buscar_linea_mesa/buscar_linea_mesa_controller.dart';
import 'package:get/get.dart';

class BuscarLineaMesaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TurnoRepository>(() => TurnoRepositoryImplementation());
    Get.lazyPut<AsignacionPersonalDataStore>(
        () => AsignacionPersonalDataStoreImplementation());
    Get.lazyPut<AsignacionPersonalRepository>(
        () => AsignacionPersonalRepositoryImplementation(Get.find()));

    Get.lazyReplace<GetAllTurnosUseCase>(() => GetAllTurnosUseCase(Get.find()));
    Get.lazyReplace<GetLineaMesaUseCase>(() => GetLineaMesaUseCase(Get.find()));

    Get.lazyPut<BuscarLineaMesaController>(
        () => BuscarLineaMesaController(Get.find()));
  }
}
