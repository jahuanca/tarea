
import 'package:flutter_tareo/data/repositories/labor_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/personal_empresa_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/pre_tareo_proceso_uva_detalles_repository_implementation.dart';
import 'package:flutter_tareo/domain/repositories/labor_repository.dart';
import 'package:flutter_tareo/domain/repositories/personal_empresa_repository.dart';
import 'package:flutter_tareo/domain/repositories/pre_tareo_proceso_uva_detalles_repository.dart';
import 'package:flutter_tareo/domain/sincronizar/get_labors_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/listado_personas_pre_tareo_uva/create_uva_detalle_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/listado_personas_pre_tareo_uva/delete_uva_detalle_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/listado_personas_pre_tareo_uva/get_all_uva_detalles_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/listado_personas_pre_tareo_uva/update_uva_detalle_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_personal_empresa_by_subdivision_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pre_tareos_uva/update_pre_tareo_proceso_uva_use_case.dart';
import 'package:flutter_tareo/ui/pages/listado_personas_pre_tareo_uva/listado_personas_pre_tareo_uva_controller.dart';
import 'package:get/get.dart';

class ListadoPersonasPreTareoUvaBinding extends Bindings{


  @override
  void dependencies() {

    Get.lazyPut<PersonalEmpresaRepository>(() => PersonalEmpresaRepositoryImplementation());
    Get.lazyPut<LaborRepository>(() => LaborRepositoryImplementation());
    Get.lazyPut<PreTareoProcesoUvaDetallesRepository>(() => PreTareoProcesoUvaDetallesRepositoryImplementation());

    Get.lazyPut<GetPersonalsEmpresaBySubdivisionUseCase>(() => GetPersonalsEmpresaBySubdivisionUseCase(Get.find()));
    Get.lazyPut<GetLaborsUseCase>(() => GetLaborsUseCase(Get.find()));
    Get.lazyPut<CreateUvaDetalleUseCase>(() => CreateUvaDetalleUseCase(Get.find()));
    Get.lazyPut<UpdateUvaDetalleUseCase>(() => UpdateUvaDetalleUseCase(Get.find()));
    Get.lazyPut<DeleteUvaDetalleUseCase>(() => DeleteUvaDetalleUseCase(Get.find()));
    Get.lazyPut<GetAllUvaDetallesUseCase>(() => GetAllUvaDetallesUseCase(Get.find()));

    Get.lazyPut<ListadoPersonasPreTareoUvaController>(() => ListadoPersonasPreTareoUvaController(Get.find(), Get.find(), Get.find(), Get.find(), Get.find(), Get.find()));
    
  }

}