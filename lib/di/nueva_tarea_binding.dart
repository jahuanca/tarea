
import 'package:flutter_tareo/data/repositories/actividad_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/centro_costo_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/personal_empresa_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/subdivision_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/labor_repository_implementation.dart';
import 'package:flutter_tareo/domain/repositories/actividad_repository.dart';
import 'package:flutter_tareo/domain/repositories/centro_costo_repository.dart';
import 'package:flutter_tareo/domain/repositories/personal_empresa_repository.dart';
import 'package:flutter_tareo/domain/repositories/subdivision_repository.dart';
import 'package:flutter_tareo/domain/repositories/labor_repository.dart';
import 'package:flutter_tareo/domain/sincronizar/get_labores_cultivo_packing_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/agregar_persona/get_personal_empresa_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_actividads_by_key_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_centro_costos_by_key_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_labors_by_key_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_personal_empresa_by_subdivision_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_subdivisions_use_case.dart';
import 'package:flutter_tareo/ui/pages/nueva_tarea/nueva_tarea_controller.dart';
import 'package:get/get.dart';

class NuevaTareaBinding extends Bindings{

  @override
  void dependencies() {

    Get.lazyPut<ActividadRepository>(() => ActividadRepositoryImplementation());
    Get.lazyPut<LaborRepository>(() => LaborRepositoryImplementation());
    Get.lazyPut<SubdivisionRepository>(() => SubdivisionRepositoryImplementation());
    Get.lazyPut<PersonalEmpresaRepository>(() => PersonalEmpresaRepositoryImplementation());
    Get.lazyPut<CentroCostoRepository>(() => CentroCostoRepositoryImplementation());

    Get.lazyReplace<GetPersonalsEmpresaUseCase>(() => GetPersonalsEmpresaUseCase(Get.find()));
    Get.lazyReplace<GetActividadsByKeyUseCase>(() => GetActividadsByKeyUseCase(Get.find()));
    Get.lazyReplace<GetLaborsByKeyUseCase>(() => GetLaborsByKeyUseCase(Get.find()));
    Get.lazyReplace<GetSubdivisonsUseCase>(() => GetSubdivisonsUseCase(Get.find()));
    Get.lazyReplace<GetPersonalsEmpresaBySubdivisionUseCase>(() => GetPersonalsEmpresaBySubdivisionUseCase(Get.find()));
    Get.lazyReplace<GetCentroCostosByKeyUseCase>(() => GetCentroCostosByKeyUseCase(Get.find()));
    Get.lazyReplace<GetLaboresCultivoPackingUseCase>(() => GetLaboresCultivoPackingUseCase(Get.find()));

    Get.lazyPut<NuevaTareaController>(() => NuevaTareaController(
        Get.find(),
        Get.find(),
        Get.find(),
        Get.find(),
        Get.find(),
        Get.find(),
      )
    );
    
  }

}