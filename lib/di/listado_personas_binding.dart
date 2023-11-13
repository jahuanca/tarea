import 'package:flutter_tareo/data/repositories/personal_empresa_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/personal_tarea_proceso_repository_implementation.dart';
import 'package:flutter_tareo/domain/repositories/personal_empresa_repository.dart';
import 'package:flutter_tareo/domain/repositories/personal_tarea_proceso_repository.dart';
import 'package:flutter_tareo/domain/use_cases/agregar_persona/get_personal_empresa_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/personal_tarea_proceso/create_personal_tarea_proceso_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/personal_tarea_proceso/delete_personal_tarea_proceso_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/personal_tarea_proceso/get_all_personal_tarea_proceso_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/personal_tarea_proceso/update_personal_tarea_proceso_use_case.dart';
import 'package:flutter_tareo/ui/pages/listado_personas/listado_personas_controller.dart';
import 'package:get/get.dart';

class ListadoPersonasBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PersonalEmpresaRepository>(
        () => PersonalEmpresaRepositoryImplementation());
    Get.lazyPut<PersonalTareaProcesoRepository>(
        () => PersonalTareaProcesoRepositoryImplementation());

    Get.lazyPut<GetPersonalsEmpresaUseCase>(
        () => GetPersonalsEmpresaUseCase(Get.find()));
    Get.lazyPut<GetAllPersonalTareaProcesoUseCase>(
        () => GetAllPersonalTareaProcesoUseCase(Get.find()));
    Get.lazyPut<CreatePersonalTareaProcesoUseCase>(
        () => CreatePersonalTareaProcesoUseCase(Get.find()));
    Get.lazyPut<UpdatePersonalTareaProcesoUseCase>(
        () => UpdatePersonalTareaProcesoUseCase(Get.find()));
    Get.lazyPut<DeletePersonalTareaProcesoUseCase>(
        () => DeletePersonalTareaProcesoUseCase(Get.find()));

    Get.lazyPut<ListadoPersonasController>(() => ListadoPersonasController(
          Get.find(),
          Get.find(),
          Get.find(),
          Get.find(),
          Get.find(),
        ));
  }
}
