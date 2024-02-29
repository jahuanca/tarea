import 'package:flutter_tareo/data/packing/datastores/personal_packing_datastore_implementation.dart';
import 'package:flutter_tareo/data/repositories/labor_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/personal_empresa_repository_implementation.dart';
import 'package:flutter_tareo/data/packing/repositories/personal_packing_repository_implementation.dart';
import 'package:flutter_tareo/domain/packing/use_cases/personal_packing/create_uva_detalle_use_case.dart';
import 'package:flutter_tareo/domain/packing/use_cases/personal_packing/delete_uva_detalle_use_case.dart';
import 'package:flutter_tareo/domain/packing/use_cases/personal_packing/get_all_uva_detalles_use_case.dart';
import 'package:flutter_tareo/domain/repositories/labor_repository.dart';
import 'package:flutter_tareo/domain/repositories/personal_empresa_repository.dart';
import 'package:flutter_tareo/domain/packing/repositories/personal_packing_repository.dart';
import 'package:flutter_tareo/domain/use_cases/sincronizar/get_labors_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_personal_empresa_by_subdivision_use_case.dart';
import 'package:flutter_tareo/ui/packing/personal_packing/personal_packing_controller.dart';
import 'package:get/get.dart';

class PersonalPackingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PersonalEmpresaRepository>(
        () => PersonalEmpresaRepositoryImplementation());
    Get.lazyPut<LaborRepository>(() => LaborRepositoryImplementation());

    /*Get.lazyPut<PersonalPackingRepository>(() =>
        PersonalPackingRepositoryImplementation(
            PersonalPackingDataStoreHiveImplementation()));*/
    Get.lazyPut<PersonalPackingRepository>(() =>
        PersonalPackingRepositoryImplementation(
            PersonalPackingDataStoreImplementation()));

    Get.lazyPut<GetPersonalsEmpresaBySubdivisionUseCase>(
        () => GetPersonalsEmpresaBySubdivisionUseCase(Get.find()));
    Get.lazyPut<GetLaborsUseCase>(() => GetLaborsUseCase(Get.find()));
    Get.lazyPut<CreateUvaDetalleUseCase>(
        () => CreateUvaDetalleUseCase(Get.find()));
    Get.lazyPut<DeleteUvaDetalleUseCase>(
        () => DeleteUvaDetalleUseCase(Get.find()));
    Get.lazyPut<GetAllUvaDetallesUseCase>(
        () => GetAllUvaDetallesUseCase(Get.find()));

    Get.lazyPut<PersonalPackingController>(() => PersonalPackingController(
        Get.find(), Get.find(), Get.find(), Get.find(), Get.find()));
  }
}
