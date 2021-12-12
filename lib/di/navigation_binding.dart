import 'package:flutter_tareo/data/repositories/resumen_varios_repository_implementation.dart';
import 'package:flutter_tareo/di/aprobar_binding.dart';
import 'package:flutter_tareo/di/esparragos_binding.dart';
import 'package:flutter_tareo/di/herramientas_binding.dart';
import 'package:flutter_tareo/di/home_binding.dart';
import 'package:flutter_tareo/di/migrar_binding.dart';
import 'package:flutter_tareo/di/pre_tareos_binding.dart';
import 'package:flutter_tareo/di/pre_tareos_uva_binding.dart';
import 'package:flutter_tareo/di/tareas_binding.dart';
import 'package:flutter_tareo/domain/repositories/resumen_varios_repository.dart';
import 'package:flutter_tareo/domain/use_cases/others/send_resumen_varios_use_case.dart';
import 'package:flutter_tareo/ui/pages/navigation/navigation_controller.dart';
import 'package:get/get.dart';

class NavigationBinding extends Bindings {
  @override
  void dependencies() {
    HomeBinding().dependencies();
    TareasBinding().dependencies();
    AprobarBinding().dependencies();
    MigrarBinding().dependencies();
    PreTareosBinding().dependencies();
    PreTareosUvaBinding().dependencies();
    EsparragosBinding().dependencies();
    HerramientasBinding().dependencies();

    Get.lazyPut<ResumenVariosRepository>(() => ResumenVariosRepositoryImplementation());

    Get.lazyReplace<SendResumenVariosUseCase>(
        () => SendResumenVariosUseCase(Get.find()));

    Get.lazyPut<NavigationController>(() => NavigationController(Get.find()));
  }
}
