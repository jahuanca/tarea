
import 'package:flutter_tareo/data/repositories/pre_tareo_proceso_uva_repository_implementation.dart';
import 'package:flutter_tareo/domain/repositories/pre_tareo_proceso_uva_repository.dart';
import 'package:flutter_tareo/domain/use_cases/pre_tareos_uva/create_pre_tareo_proceso_uva_use_case.dart';
import 'package:flutter_tareo/ui/pages/herramientas/herramientas_controller.dart';
import 'package:get/get.dart';

class HerramientasBinding extends Bindings{
  @override
  void dependencies() {


    Get.lazyPut<PreTareoProcesoUvaRepository>(() => PreTareoProcesoUvaRepositoryImplementation());
    Get.lazyPut<CreatePreTareoProcesoUvaUseCase>(() => CreatePreTareoProcesoUvaUseCase(Get.find()));
    Get.lazyPut<HerramientasController>(() => HerramientasController(Get.find()));
  }

}