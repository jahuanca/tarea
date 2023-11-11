import 'package:flutter_tareo/data/control_asistencia/repositories/asistencia_registro_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/personal_empresa_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/pre_tarea_esparrago_detalles_grupo_repository_implementation.dart';
import 'package:flutter_tareo/domain/control_asistencia/repositories/asistencia_registro_repository.dart';
import 'package:flutter_tareo/domain/control_asistencia/use_cases/listado_registros_asistencias/create_asistencia_registro_use_case.dart';
import 'package:flutter_tareo/domain/control_asistencia/use_cases/listado_registros_asistencias/delete_asistencia_registro_use_case.dart';
import 'package:flutter_tareo/domain/control_asistencia/use_cases/listado_registros_asistencias/get_all_asistencia_registro_use_case.dart';
import 'package:flutter_tareo/domain/control_asistencia/use_cases/listado_registros_asistencias/update_asistencia_registro_use_case.dart';
import 'package:flutter_tareo/domain/repositories/personal_empresa_repository.dart';
import 'package:flutter_tareo/domain/repositories/pre_tarea_esparrago_detalles_grupo_repository.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_personal_empresa_by_subdivision_use_case.dart';
import 'package:flutter_tareo/ui/control_asistencia/listado_asistencia_registro/listado_asistencia_registro_controller.dart';
import 'package:get/get.dart';

class ListadoRegistroAsistenciaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PersonalEmpresaRepository>(
        () => PersonalEmpresaRepositoryImplementation());
    Get.lazyPut<PreTareaEsparragoDetallesGrupoRepository>(
        () => PreTareaEsparragoDetallesGrupoRepositoryImplementation());

    Get.lazyPut<AsistenciaRegistroRepository>(
        () => AsistenciaRegistroRepositoryImplementation());

    Get.lazyPut<GetPersonalsEmpresaBySubdivisionUseCase>(
        () => GetPersonalsEmpresaBySubdivisionUseCase(Get.find()));
    Get.lazyPut<GetAllAsistenciaRegistroUseCase>(
        () => GetAllAsistenciaRegistroUseCase(Get.find()));
    Get.lazyPut<CreateAsistenciaRegistroUseCase>(
        () => CreateAsistenciaRegistroUseCase(Get.find()));
    Get.lazyPut<UpdateAsistenciaRegistroUseCase>(
        () => UpdateAsistenciaRegistroUseCase(Get.find()));
    Get.lazyPut<DeleteAsistenciaRegistroUseCase>(
        () => DeleteAsistenciaRegistroUseCase(Get.find()));

    Get.lazyPut<ListadoAsistenciaRegistroController>(() =>
        ListadoAsistenciaRegistroController(
            Get.find(), Get.find(), Get.find(), Get.find(), Get.find()));
  }
}
