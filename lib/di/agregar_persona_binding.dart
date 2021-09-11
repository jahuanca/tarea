
import 'package:flutter_tareo/data/repositories/personal_empresa_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/temp_actividad_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/temp_labor_repository_implementation.dart';
import 'package:flutter_tareo/domain/repositories/personal_empresa_repository.dart';
import 'package:flutter_tareo/domain/use_cases/agregar_persona/get_personal_empresa_use_case.dart';
import 'package:flutter_tareo/ui/pages/agregar_persona/agregar_persona_controller.dart';
import 'package:get/get.dart';

class AgregarPersonaBinding extends Bindings{


  @override
  void dependencies() {

    Get.lazyPut<PersonalEmpresaRepository>(() => PersonalEmpresaRepositoryImplementation());

    Get.lazyPut<GetPersonalsEmpresaUseCase>(() => GetPersonalsEmpresaUseCase(Get.find()));
    
    Get.lazyPut<AgregarPersonaController>(() => AgregarPersonaController(Get.find()));
    
  }

}