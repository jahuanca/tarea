
import 'package:flutter_tareo/data/repositories/actividad_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/centro_costo_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/current_time_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/labor_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/personal_empresa_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/subdivision_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/temp_labor_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/usuario_repository_implementation.dart';
import 'package:flutter_tareo/domain/repositories/actividad_repository.dart';
import 'package:flutter_tareo/domain/repositories/centro_costo_repository.dart';
import 'package:flutter_tareo/domain/repositories/current_time_repository.dart';
import 'package:flutter_tareo/domain/repositories/personal_empresa_repository.dart';
import 'package:flutter_tareo/domain/repositories/subdivision_repository.dart';
import 'package:flutter_tareo/domain/repositories/labor_repository.dart';
import 'package:flutter_tareo/domain/repositories/usuario_repository.dart';
import 'package:flutter_tareo/domain/sincronizar/get_current_time_world_use_case.dart';
import 'package:flutter_tareo/domain/sincronizar/get_labors_use_case.dart';
import 'package:flutter_tareo/domain/sincronizar/get_usuarios_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/agregar_persona/get_personal_empresa_use_case.dart';
import 'package:flutter_tareo/domain/sincronizar/get_actividads_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_centro_costos_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_subdivisions_use_case.dart';
import 'package:flutter_tareo/ui/pages/sincronizar/sincronizar_controller.dart';
import 'package:get/get.dart';

class SincronizarBinding extends Bindings{


  @override
  void dependencies() {

    Get.lazyPut<ActividadRepository>(() => ActividadRepositoryImplementation());
    Get.lazyPut<SubdivisionRepository>(() => SubdivisionRepositoryImplementation());
    Get.lazyPut<LaborRepository>(() => LaborRepositoryImplementation());
    Get.lazyPut<UsuarioRepository>(() => UsuarioRepositoryImplementation());
    Get.lazyPut<PersonalEmpresaRepository>(() => PersonalEmpresaRepositoryImplementation());
    Get.lazyPut<CentroCostoRepository>(() => CentroCostoRepositoryImplementation());
    Get.lazyPut<CurrentTimeRepository>(() => CurrentTimeRepositoryImplementation());

    Get.lazyPut<GetActividadsUseCase>(() => GetActividadsUseCase(Get.find()));
    Get.lazyPut<GetSubdivisonsUseCase>(() => GetSubdivisonsUseCase(Get.find()));
    Get.lazyPut<GetLaborsUseCase>(() => GetLaborsUseCase(Get.find()));
    Get.lazyPut<GetUsuariosUseCase>(() => GetUsuariosUseCase(Get.find()));
    Get.lazyPut<GetCentroCostosUseCase>(() => GetCentroCostosUseCase(Get.find()));
    Get.lazyPut<GetPersonalsEmpresaUseCase>(() => GetPersonalsEmpresaUseCase(Get.find()));
    Get.lazyReplace<GetCurrentTimeWorldUseCase>(() => GetCurrentTimeWorldUseCase(Get.find()));

    Get.lazyPut<SincronizarController>(() => SincronizarController(Get.find(), Get.find(), Get.find(), Get.find(), Get.find(), Get.find(), Get.find()));
    
  }

}