
import 'package:flutter_tareo/data/repositories/centro_costo_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/personal_empresa_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/subdivision_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/tipo_tarea_repository_implementation.dart';
import 'package:flutter_tareo/domain/repositories/centro_costo_repository.dart';
import 'package:flutter_tareo/domain/repositories/personal_empresa_repository.dart';
import 'package:flutter_tareo/domain/repositories/subdivision_repository.dart';
import 'package:flutter_tareo/domain/repositories/tipo_tarea_repository.dart';
import 'package:flutter_tareo/domain/sincronizar/get_tipo_tareas_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_centro_costos_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_personal_empresa_by_subdivision_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_subdivisions_use_case.dart';
import 'package:flutter_tareo/ui/pages/nueva_pesado/nueva_pesado_controller.dart';
import 'package:get/get.dart';

class NuevaPesadoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SubdivisionRepository>(
        () => SubdivisionRepositoryImplementation());
    Get.lazyPut<PersonalEmpresaRepository>(
        () => PersonalEmpresaRepositoryImplementation());
    Get.lazyPut<CentroCostoRepository>(
        () => CentroCostoRepositoryImplementation());
    Get.lazyPut<TipoTareaRepository>(() => TipoTareaRepositoryImplementation());

    Get.lazyReplace<GetSubdivisonsUseCase>(
        () => GetSubdivisonsUseCase(Get.find()));
    Get.lazyReplace<GetPersonalsEmpresaBySubdivisionUseCase>(
        () => GetPersonalsEmpresaBySubdivisionUseCase(Get.find()));
    Get.lazyReplace<GetTipoTareasUseCase>(() => GetTipoTareasUseCase(Get.find()));
    Get.lazyReplace<GetCentroCostosUseCase>(
        () => GetCentroCostosUseCase(Get.find()));

    Get.lazyPut<NuevaPesadoController>(() => NuevaPesadoController(
          Get.find(),
          Get.find(),
          Get.find(),
          Get.find(),
        ));
  }
}
