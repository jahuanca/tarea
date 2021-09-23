
import 'package:flutter_tareo/data/repositories/subdivision_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/temp_actividad_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/temp_labor_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/usuario_repository_implementation.dart';
import 'package:flutter_tareo/domain/repositories/subdivision_repository.dart';
import 'package:flutter_tareo/domain/repositories/temp_actividad_repository.dart';
import 'package:flutter_tareo/domain/repositories/temp_labor_repository.dart';
import 'package:flutter_tareo/domain/repositories/usuario_repository.dart';
import 'package:flutter_tareo/domain/sincronizar/get_usuarios_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_subdivisions_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_temp_actividads_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_temp_labors_use_case.dart';
import 'package:flutter_tareo/ui/pages/sincronizar/sincronizar_controller.dart';
import 'package:get/get.dart';

class SincronizarBinding extends Bindings{


  @override
  void dependencies() {

    Get.lazyPut<TempActividadRepository>(() => TempActividadRepositoryImplementation());
    Get.lazyPut<SubdivisionRepository>(() => SubdivisionRepositoryImplementation());
    Get.lazyPut<TempLaborRepository>(() => TempLaborRepositoryImplementation());
    Get.lazyPut<UsuarioRepository>(() => UsuarioRepositoryImplementation());

    Get.lazyPut<GetTempActividadsUseCase>(() => GetTempActividadsUseCase(Get.find()));
    Get.lazyPut<GetSubdivisonsUseCase>(() => GetSubdivisonsUseCase(Get.find()));
    Get.lazyPut<GetTempLaborsUseCase>(() => GetTempLaborsUseCase(Get.find()));
    Get.lazyPut<GetUsuariosUseCase>(() => GetUsuariosUseCase(Get.find()));

    Get.lazyPut<SincronizarController>(() => SincronizarController(Get.find(), Get.find(), Get.find(), Get.find()));
    
  }

}