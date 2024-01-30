import 'package:flutter_tareo/data/repositories/pre_tareo_proceso_uva_detalles_repository_implementation.dart';
import 'package:flutter_tareo/data/repositories/pre_tareo_proceso_uva_repository_implementation.dart';
import 'package:flutter_tareo/domain/packing/use_cases/create_packing_use_case.dart';
import 'package:flutter_tareo/domain/packing/repositories/personal_packing_repository.dart';
import 'package:flutter_tareo/domain/packing/repositories/packing_repository.dart';
import 'package:flutter_tareo/domain/packing/use_cases/personal_packing/create_uva_all_detalle_use_case.dart';
import 'package:flutter_tareo/ui/pages/herramientas/herramientas_controller.dart';
import 'package:get/get.dart';

class HerramientasBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PackingRepository>(
        () => PreTareoProcesoUvaRepositoryImplementation());
    Get.lazyPut<PersonalPackingRepository>(
        () => PreTareoProcesoUvaDetallesRepositoryImplementation());
    Get.lazyPut<CreatePackingUseCase>(() => CreatePackingUseCase(Get.find()));
    Get.lazyPut<CreateUvaAllDetalleUseCase>(
        () => CreateUvaAllDetalleUseCase(Get.find()));
    Get.lazyPut<HerramientasController>(
        () => HerramientasController(Get.find(), Get.find()));
  }
}
