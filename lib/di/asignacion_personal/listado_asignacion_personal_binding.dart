import 'package:flutter_tareo/data/asignacion_personal/datastores/listado_asignacion_personal_datastore_implementation.dart';
import 'package:flutter_tareo/data/asignacion_personal/repositories/listado_asignacion_personal_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/personal_empresa_repository_implementation.dart';
import 'package:flutter_tareo/domain/asignacion_personal/datastores/listado_asignacion_personal_datastore.dart';
import 'package:flutter_tareo/domain/asignacion_personal/respositories/listado_asignacion_personal_repository.dart';
import 'package:flutter_tareo/domain/asignacion_personal/use_cases/listado_asignacion_personal/add_personal_asignacion_use_case.dart';
import 'package:flutter_tareo/domain/asignacion_personal/use_cases/listado_asignacion_personal/delete_personal_asignacion_use_case.dart';
import 'package:flutter_tareo/domain/asignacion_personal/use_cases/listado_asignacion_personal/get_all_personal_asignacion_use_case.dart';
import 'package:flutter_tareo/domain/repositories/personal_empresa_repository.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_personal_empresa_by_subdivision_use_case.dart';
import 'package:flutter_tareo/ui/asignacion_personal/listado/listado_asignacion_personal_controller.dart';
import 'package:get/get.dart';

class ListadoAsignacionPersonalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListadoAsignacionPersonalDatastore>(
        () => ListadoAsignacionPersonalDatastoreImplementation());

    Get.lazyPut<ListadoAsignacionPersonalRepository>(
        () => ListadoAsignacionPersonalRepositoryImplementation(Get.find()));

    Get.lazyPut<GetAllPersonalAsignacionUseCase>(
        () => GetAllPersonalAsignacionUseCase(Get.find()));
    Get.lazyPut<AddPersonalAsignacionUseCase>(
        () => AddPersonalAsignacionUseCase(Get.find()));
    Get.lazyPut<DeletePersonalAsignacionUseCase>(
        () => DeletePersonalAsignacionUseCase(Get.find()));

    Get.lazyPut<PersonalEmpresaRepository>(
        () => PersonalEmpresaRepositoryImplementation());

    Get.lazyPut<GetPersonalsEmpresaBySubdivisionUseCase>(
        () => GetPersonalsEmpresaBySubdivisionUseCase(Get.find()));

    Get.lazyPut<ListadoAsignacionPersonalController>(() =>
        ListadoAsignacionPersonalController(
            Get.find(), Get.find(), Get.find(), Get.find()));
  }
}
