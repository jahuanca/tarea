
import 'package:flutter_tareo/data/repositories/actividad_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/caja_detalle_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/labor_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/personal_empresa_repository_implementation.dart';
import 'package:flutter_tareo/domain/repositories/actividad_repository.dart';
import 'package:flutter_tareo/domain/repositories/caja_detalle_repository.dart';
import 'package:flutter_tareo/domain/repositories/labor_repository.dart';
import 'package:flutter_tareo/domain/repositories/personal_empresa_repository.dart';
import 'package:flutter_tareo/domain/use_cases/sincronizar/get_actividads_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/sincronizar/get_labors_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/caja_detalles/create_caja_detalle_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/caja_detalles/delete_caja_detalle_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/caja_detalles/get_all_caja_detalle_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/caja_detalles/update_caja_detalle_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/clasificacion/update_clasificacion_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_personal_empresa_by_subdivision_use_case.dart';
import 'package:flutter_tareo/ui/pages/listado_personas_clasificacion/listado_personas_clasificacion_controller.dart';
import 'package:get/get.dart';

class ListadoPersonasClasificacionBinding extends Bindings{


  @override
  void dependencies() {

    Get.lazyPut<PersonalEmpresaRepository>(() => PersonalEmpresaRepositoryImplementation());
    Get.lazyPut<ActividadRepository>(() => ActividadRepositoryImplementation());
    Get.lazyPut<LaborRepository>(() => LaborRepositoryImplementation());
    Get.lazyPut<CajaDetalleRepository>(() => CajaDetalleRepositoryImplementation());

    Get.lazyPut<GetPersonalsEmpresaBySubdivisionUseCase>(() => GetPersonalsEmpresaBySubdivisionUseCase(Get.find()));
    Get.lazyPut<UpdateClasificacionUseCase>(() => UpdateClasificacionUseCase(Get.find()));
    Get.lazyPut<GetActividadsUseCase>(() => GetActividadsUseCase(Get.find()));
    Get.lazyPut<GetLaborsUseCase>(() => GetLaborsUseCase(Get.find()));
    Get.lazyPut<CreateCajaDetalleUseCase>(() => CreateCajaDetalleUseCase(Get.find()));
    Get.lazyPut<UpdateCajaDetalleUseCase>(() => UpdateCajaDetalleUseCase(Get.find()));
    Get.lazyPut<DeleteCajaDetalleUseCase>(() => DeleteCajaDetalleUseCase(Get.find()));
    Get.lazyPut<GetAllCajaDetalleUseCase>(() => GetAllCajaDetalleUseCase(Get.find()));

    Get.lazyPut<ListadoPersonasClasificacionController>(() => ListadoPersonasClasificacionController(
      Get.find(),
      Get.find(),
      Get.find(),
      Get.find(),
      Get.find(),
      Get.find()));
    
  }

}