
import 'package:flutter_tareo/data/repositories/actividad_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/centro_costo_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/cultivo_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/labor_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/personal_empresa_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/subdivision_repository_implementation.dart';
import 'package:flutter_tareo/domain/repositories/actividad_repository.dart';
import 'package:flutter_tareo/domain/repositories/centro_costo_repository.dart';
import 'package:flutter_tareo/domain/repositories/cultivo_repository.dart';
import 'package:flutter_tareo/domain/repositories/labor_repository.dart';
import 'package:flutter_tareo/domain/repositories/personal_empresa_repository.dart';
import 'package:flutter_tareo/domain/repositories/subdivision_repository.dart';
import 'package:flutter_tareo/domain/sincronizar/get_labors_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_actividads_by_key_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_centro_costos_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_cultivos_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_labors_by_key_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_personal_empresa_by_subdivision_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_subdivisions_use_case.dart';
import 'package:flutter_tareo/ui/pages/nueva_seleccion/nueva_seleccion_controller.dart';
import 'package:get/get.dart';

class NuevaSeleccionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SubdivisionRepository>(
        () => SubdivisionRepositoryImplementation());
    Get.lazyPut<PersonalEmpresaRepository>(
        () => PersonalEmpresaRepositoryImplementation());
    Get.lazyPut<CentroCostoRepository>(
        () => CentroCostoRepositoryImplementation());
    Get.lazyPut<LaborRepository>(() => LaborRepositoryImplementation());
    Get.lazyPut<ActividadRepository>(() => ActividadRepositoryImplementation());

    Get.lazyReplace<GetSubdivisonsUseCase>(
        () => GetSubdivisonsUseCase(Get.find()));

    Get.lazyReplace<GetPersonalsEmpresaBySubdivisionUseCase>(
        () => GetPersonalsEmpresaBySubdivisionUseCase(Get.find()));
    Get.lazyReplace<GetCentroCostosUseCase>(() => GetCentroCostosUseCase(Get.find()));
    Get.lazyReplace<GetLaborsByKeyUseCase>(
        () => GetLaborsByKeyUseCase(Get.find()));
    Get.lazyReplace<GetActividadsByKeyUseCase>(
        () => GetActividadsByKeyUseCase(Get.find()));

    Get.lazyPut<NuevaSeleccionController>(() => NuevaSeleccionController(
          Get.find(),
          Get.find(),
          Get.find(),
          Get.find(),
          Get.find(),
        ));
  }
}
