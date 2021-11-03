
import 'package:flutter_tareo/data/repositories/personal_empresa_repository_implementation.dart';
import 'package:flutter_tareo/domain/repositories/personal_empresa_repository.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_personal_empresa_by_subdivision_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/seleccion/update_seleccion_use_case.dart';
import 'package:flutter_tareo/ui/pages/listado_personas_seleccion/listado_personas_seleccion_controller.dart';
import 'package:get/get.dart';

class ListadoPersonasSeleccionBinding extends Bindings{


  @override
  void dependencies() {

    Get.lazyPut<PersonalEmpresaRepository>(() => PersonalEmpresaRepositoryImplementation());

    Get.lazyPut<GetPersonalsEmpresaBySubdivisionUseCase>(() => GetPersonalsEmpresaBySubdivisionUseCase(Get.find()));
    Get.lazyPut<UpdateSeleccionUseCase>(() => UpdateSeleccionUseCase(Get.find()));

    Get.lazyPut<ListadoPersonasSeleccionController>(() => ListadoPersonasSeleccionController(Get.find(), Get.find()));
    
  }

}