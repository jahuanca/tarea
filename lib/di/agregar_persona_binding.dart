
import 'package:flutter_tareo/data/repositories/personal_empresa_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/personal_tarea_proceso_repository_implementation.dart';
import 'package:flutter_tareo/domain/repositories/personal_empresa_repository.dart';
import 'package:flutter_tareo/domain/repositories/personal_tarea_proceso_repository.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_personal_empresa_by_subdivision_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/personal_tarea_proceso/create_personal_tarea_proceso_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/personal_tarea_proceso/update_personal_tarea_proceso_use_case.dart';
import 'package:flutter_tareo/ui/pages/agregar_persona/agregar_persona_controller.dart';
import 'package:get/get.dart';

class AgregarPersonaBinding extends Bindings{


  @override
  void dependencies() {

    Get.lazyPut<PersonalEmpresaRepository>(() => PersonalEmpresaRepositoryImplementation());
    Get.lazyPut<PersonalTareaProcesoRepository>(() => PersonalTareaProcesoRepositoryImplementation());

    Get.lazyPut<GetPersonalsEmpresaBySubdivisionUseCase>(() => GetPersonalsEmpresaBySubdivisionUseCase(Get.find()));
    Get.lazyPut<CreatePersonalTareaProcesoUseCase>(() => CreatePersonalTareaProcesoUseCase(Get.find()));
    Get.lazyPut<UpdatePersonalTareaProcesoUseCase>(() => UpdatePersonalTareaProcesoUseCase(Get.find()));
    
    Get.lazyPut<AgregarPersonaController>(() => AgregarPersonaController(Get.find(), Get.find(), Get.find()));
    
  }

}