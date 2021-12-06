
import 'package:flutter_tareo/data/repositories/personal_empresa_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/pre_tarea_esparrago_detalles_grupo_repository_implementation.dart';
import 'package:flutter_tareo/domain/repositories/personal_empresa_repository.dart';
import 'package:flutter_tareo/domain/repositories/pre_tarea_esparrago_detalles_grupo_repository.dart';
import 'package:flutter_tareo/domain/use_cases/listado_personas_seleccion/create_seleccion_detalle_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/listado_personas_seleccion/delete_seleccion_detalle_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/listado_personas_seleccion/get_all_seleccion_detalles_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_personal_empresa_by_subdivision_use_case.dart';
import 'package:flutter_tareo/ui/pages/listado_personas_seleccion/listado_personas_seleccion_controller.dart';
import 'package:get/get.dart';

class ListadoPersonasSeleccionBinding extends Bindings{


  @override
  void dependencies() {

    Get.lazyPut<PersonalEmpresaRepository>(() => PersonalEmpresaRepositoryImplementation());
    Get.lazyPut<PreTareaEsparragoDetallesGrupoRepository>(() => PreTareaEsparragoDetallesGrupoRepositoryImplementation());

    Get.lazyPut<GetPersonalsEmpresaBySubdivisionUseCase>(() => GetPersonalsEmpresaBySubdivisionUseCase(Get.find()));
    Get.lazyPut<GetAllSeleccionDetallesUseCase>(() => GetAllSeleccionDetallesUseCase(Get.find()));
    Get.lazyPut<CreateSeleccionDetalleUseCase>(() => CreateSeleccionDetalleUseCase(Get.find()));
    Get.lazyPut<DeleteSeleccionDetalleUseCase>(() => DeleteSeleccionDetalleUseCase(Get.find()));

    Get.lazyPut<ListadoPersonasSeleccionController>(() => ListadoPersonasSeleccionController(Get.find(), Get.find(), Get.find(), Get.find()));
    
  }

}