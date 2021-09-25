
import 'package:flutter_tareo/data/repositories/actividad_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/personal_empresa_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/subdivision_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/temp_actividad_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/temp_labor_repository_implementation.dart';
import 'package:flutter_tareo/domain/repositories/actividad_repository.dart';
import 'package:flutter_tareo/domain/repositories/personal_empresa_repository.dart';
import 'package:flutter_tareo/domain/repositories/subdivision_repository.dart';
import 'package:flutter_tareo/domain/repositories/temp_actividad_repository.dart';
import 'package:flutter_tareo/domain/repositories/temp_labor_repository.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_Tarea/get_temp_actividads_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_Tarea/get_temp_labors_use_case.dart';
import 'package:flutter_tareo/domain/sincronizar/get_actividads_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_actividads_by_key_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_personal_empresa_by_subdivision_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_subdivisions_use_case.dart';
import 'package:flutter_tareo/ui/pages/nueva_tarea/nueva_tarea_controller.dart';
import 'package:get/get.dart';

class NuevaTareaBinding extends Bindings{


  @override
  void dependencies() {

    Get.lazyPut<ActividadRepository>(() => ActividadRepositoryImplementation());
    Get.lazyPut<TempLaborRepository>(() => TempLaborRepositoryImplementation());
    Get.lazyPut<SubdivisionRepository>(() => SubdivisionRepositoryImplementation());
    Get.lazyPut<PersonalEmpresaRepository>(() => PersonalEmpresaRepositoryImplementation());

    Get.lazyReplace<GetActividadsByKeyUseCase>(() => GetActividadsByKeyUseCase(Get.find()));
    Get.lazyReplace<GetTempLaborsUseCase>(() => GetTempLaborsUseCase(Get.find()));
    Get.lazyReplace<GetSubdivisonsUseCase>(() => GetSubdivisonsUseCase(Get.find()));
    Get.lazyReplace<GetPersonalsEmpresaBySubdivisionUseCase>(() => GetPersonalsEmpresaBySubdivisionUseCase(Get.find()));

    Get.lazyPut<NuevaTareaController>(() => NuevaTareaController(Get.find(), Get.find(), Get.find(), Get.find()));
    
  }

}