
import 'package:flutter_tareo/data/repositories/personal_empresa_repository_implementation.dart';
import 'package:flutter_tareo/domain/repositories/personal_empresa_repository.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_personal_empresa_by_subdivision_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pre_tareos/update_pre_tareo_proceso_use_case.dart';
import 'package:flutter_tareo/ui/pages/listado_personas_pre_tareo/listado_personas_pre_tareo_controller.dart';
import 'package:get/get.dart';

class ListadoPersonasPreTareoBinding extends Bindings{


  @override
  void dependencies() {

    Get.lazyPut<PersonalEmpresaRepository>(() => PersonalEmpresaRepositoryImplementation());

    Get.lazyPut<GetPersonalsEmpresaBySubdivisionUseCase>(() => GetPersonalsEmpresaBySubdivisionUseCase(Get.find()));
    Get.lazyPut<UpdatePreTareoProcesoUseCase>(() => UpdatePreTareoProcesoUseCase(Get.find()));

    Get.lazyPut<ListadoPersonasPreTareoController>(() => ListadoPersonasPreTareoController(Get.find(), Get.find()));
    
  }

}