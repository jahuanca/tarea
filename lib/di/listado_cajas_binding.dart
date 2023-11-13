import 'package:flutter_tareo/data/repositories/actividad_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/clasificado_cajas_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/cliente_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/labor_repository_implementation.dart';
import 'package:flutter_tareo/domain/repositories/actividad_repository.dart';
import 'package:flutter_tareo/domain/repositories/clasificado_cajas_repository.dart';
import 'package:flutter_tareo/domain/repositories/cliente_repository.dart';
import 'package:flutter_tareo/domain/repositories/labor_repository.dart';
import 'package:flutter_tareo/domain/use_cases/sincronizar/get_actividads_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/sincronizar/get_clientes_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/sincronizar/get_labors_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/clasificados_caja/create_clasificado_caja_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/clasificados_caja/delete_clasificado_caja_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/clasificados_caja/get_all_clasificado_caja_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/clasificados_caja/update_clasificado_caja_use_case.dart';
import 'package:flutter_tareo/ui/pages/listado_cajas/listado_cajas_controller.dart';
import 'package:get/get.dart';

class ListadoCajasBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClienteRepository>(() => ClienteRepositoryImplementation());
    Get.lazyPut<ActividadRepository>(() => ActividadRepositoryImplementation());
    Get.lazyPut<LaborRepository>(() => LaborRepositoryImplementation());
    Get.lazyPut<ClasificadoCajasRepository>(
        () => ClasificadoCajasRepositoryImplementation());

    Get.lazyPut<GetClientesUseCase>(() => GetClientesUseCase(Get.find()));
    Get.lazyPut<GetActividadsUseCase>(() => GetActividadsUseCase(Get.find()));
    Get.lazyPut<GetLaborsUseCase>(() => GetLaborsUseCase(Get.find()));
    Get.lazyPut<CreateClasificadoCajaUseCase>(
        () => CreateClasificadoCajaUseCase(Get.find()));
    Get.lazyPut<UpdateClasificadoCajaUseCase>(
        () => UpdateClasificadoCajaUseCase(Get.find()));
    Get.lazyPut<DeleteClasificadoCajaUseCase>(
        () => DeleteClasificadoCajaUseCase(Get.find()));
    Get.lazyPut<GetAllClasificadoCajasUseCase>(
        () => GetAllClasificadoCajasUseCase(Get.find()));

    Get.lazyPut<ListadoCajasController>(() => ListadoCajasController(
        Get.find(),
        Get.find(),
        Get.find(),
        Get.find(),
        Get.find(),
        Get.find(),
        Get.find()));
  }
}
