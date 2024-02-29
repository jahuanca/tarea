import 'package:flutter_tareo/data/packing/datastores/packing_datastore_implementation.dart';
import 'package:flutter_tareo/data/packing/repositories/packing_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/centro_costo_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/cultivo_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/personal_empresa_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/subdivision_repository_implementation.dart';
import 'package:flutter_tareo/domain/packing/repositories/packing_repository.dart';
import 'package:flutter_tareo/domain/packing/use_cases/create_packing_use_case.dart';
import 'package:flutter_tareo/domain/packing/use_cases/update_packing_use_case.dart';
import 'package:flutter_tareo/domain/repositories/centro_costo_repository.dart';
import 'package:flutter_tareo/domain/repositories/cultivo_repository.dart';
import 'package:flutter_tareo/domain/repositories/personal_empresa_repository.dart';
import 'package:flutter_tareo/domain/repositories/subdivision_repository.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_centro_costos_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_cultivos_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_personal_empresa_by_subdivision_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_subdivisions_use_case.dart';
import 'package:flutter_tareo/ui/packing/nuevo_packing/nuevo_packing_controller.dart';
import 'package:get/get.dart';

class NuevoPackingBinding extends Bindings {
  @override
  void dependencies() {
    /*Get.lazyPut<PackingRepository>(() =>
        PackingRepositoryImplementation(PackingDataStoreHiveImplementation()));*/
    Get.lazyPut<PackingRepository>(() =>
        PackingRepositoryImplementation(PackingDataStoreImplementation()));
    Get.lazyReplace<CreatePackingUseCase>(
        () => CreatePackingUseCase(Get.find()));
    Get.lazyReplace<UpdatePackingUseCase>(
        () => UpdatePackingUseCase(Get.find()));

    Get.lazyPut<SubdivisionRepository>(
        () => SubdivisionRepositoryImplementation());
    Get.lazyPut<PersonalEmpresaRepository>(
        () => PersonalEmpresaRepositoryImplementation());
    Get.lazyPut<CentroCostoRepository>(
        () => CentroCostoRepositoryImplementation());
    Get.lazyPut<CultivoRepository>(() => CultivoRepositoryImplementation());

    Get.lazyReplace<GetSubdivisonsUseCase>(
        () => GetSubdivisonsUseCase(Get.find()));
    Get.lazyReplace<GetPersonalsEmpresaBySubdivisionUseCase>(
        () => GetPersonalsEmpresaBySubdivisionUseCase(Get.find()));
    Get.lazyReplace<GetCultivosUseCase>(() => GetCultivosUseCase(Get.find()));
    Get.lazyReplace<GetCentroCostosUseCase>(
        () => GetCentroCostosUseCase(Get.find()));

    Get.lazyPut<NuevoPackingController>(() => NuevoPackingController(
          Get.find(),
          Get.find(),
          Get.find(),
          Get.find(),
          Get.find(),
          Get.find(),
        ));
  }
}
