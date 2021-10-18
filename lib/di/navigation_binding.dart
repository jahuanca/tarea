import 'package:flutter_tareo/di/aprobar_binding.dart';
import 'package:flutter_tareo/di/home_binding.dart';
import 'package:flutter_tareo/di/migrar_binding.dart';
import 'package:flutter_tareo/di/pre_tareos_binding.dart';
import 'package:flutter_tareo/di/pre_tareos_uva_binding.dart';
import 'package:flutter_tareo/di/tareas_binding.dart';
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

    Get.lazyPut<NavigationController>(() => NavigationController());
  }
}
