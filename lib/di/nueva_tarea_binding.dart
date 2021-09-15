
import 'package:flutter_tareo/data/repositories/personal_empresa_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/subdivision_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/temp_actividad_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/temp_labor_repository_implementation.dart';
import 'package:flutter_tareo/domain/repositories/personal_empresa_repository.dart';
import 'package:flutter_tareo/domain/repositories/subdivision_repository.dart';
import 'package:flutter_tareo/domain/repositories/temp_actividad_repository.dart';
import 'package:flutter_tareo/domain/repositories/temp_labor_repository.dart';
import 'package:flutter_tareo/domain/use_cases/agregar_persona/get_personal_empresa_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_Tarea/get_temp_actividads_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_Tarea/get_temp_labors_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_personal_empresa_by_subdivision_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_subdivisions_use_case.dart';
import 'package:flutter_tareo/ui/pages/nueva_tarea/nueva_tarea_controller.dart';
import 'package:get/get.dart';

class NuevaTareaBinding extends Bindings{


  @override
  void dependencies() {

    Get.lazyPut<TempActividadRepository>(() => TempActividadRepositoryImplementation());
    Get.lazyPut<TempLaborRepository>(() => TempLaborRepositoryImplementation());
    Get.lazyPut<SubdivisionRepository>(() => SubdivisionRepositoryImplementation());
    Get.lazyPut<PersonalEmpresaRepository>(() => PersonalEmpresaRepositoryImplementation());

    Get.lazyPut<GetTempActividadsUseCase>(() => GetTempActividadsUseCase(Get.find()));
    Get.lazyPut<GetTempLaborsUseCase>(() => GetTempLaborsUseCase(Get.find()));
    Get.lazyPut<GetSubdivisonsUseCase>(() => GetSubdivisonsUseCase(Get.find()));
    Get.lazyPut<GetPersonalsEmpresaBySubdivisionUseCase>(() => GetPersonalsEmpresaBySubdivisionUseCase(Get.find()));

    Get.lazyPut<NuevaTareaController>(() => NuevaTareaController(Get.find(), Get.find(), Get.find(), Get.find()));
    
  }

}