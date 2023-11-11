import 'package:flutter_tareo/data/control_asistencia/repositories/turno_repository_implementation.dart';
import 'package:flutter_tareo/data/control_asistencia/repositories/ubicacion_repository_implementation.dart';
import 'package:flutter_tareo/domain/control_asistencia/repositories/turno_repository.dart';
import 'package:flutter_tareo/domain/control_asistencia/repositories/ubicacion_repository.dart';
import 'package:flutter_tareo/domain/control_asistencia/use_cases/turno/get_all_turnos_use_case.dart';
import 'package:flutter_tareo/domain/control_asistencia/use_cases/ubicacion/get_all_ubicacions_use_case.dart';
import 'package:flutter_tareo/ui/control_asistencia/nueva_asistencia/nueva_asistencia_controller.dart';
import 'package:get/get.dart';

class NuevaAsistenciaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TurnoRepository>(() => TurnoRepositoryImplementation());

    Get.lazyPut<UbicacionRepository>(() => UbicacionRepositoryImplementation());

    Get.lazyReplace<GetAllTurnosUseCase>(() => GetAllTurnosUseCase(Get.find()));
    Get.lazyReplace<GetAllUbicacionsUseCase>(
        () => GetAllUbicacionsUseCase(Get.find()));

    Get.lazyPut<NuevaAsistenciaController>(
        () => NuevaAsistenciaController(Get.find(), Get.find()));
  }
}
