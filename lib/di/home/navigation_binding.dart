import 'package:flutter_tareo/di/aprobar_binding.dart';
import 'package:flutter_tareo/di/asignacion_personal/buscar_linea_mesa_binding.dart';
import 'package:flutter_tareo/di/control_asistencia/asistencias_binding.dart';
import 'package:flutter_tareo/di/esparrago_varios/esparragos_binding.dart';
import 'package:flutter_tareo/di/herramientas_binding.dart';
import 'package:flutter_tareo/di/home/home_binding.dart';
import 'package:flutter_tareo/di/migrar_binding.dart';
import 'package:flutter_tareo/di/pre_tareos_binding.dart';
import 'package:flutter_tareo/di/packing/packing_binding.dart';
import 'package:flutter_tareo/di/tareas_binding.dart';
import 'package:flutter_tareo/ui/home/controllers/navigation_controller.dart';
import 'package:get/get.dart';

class NavigationBinding extends Bindings {
  @override
  void dependencies() {
    HomeBinding().dependencies();
    TareasBinding().dependencies();
    AprobarBinding().dependencies();
    MigrarBinding().dependencies();
    PreTareosBinding().dependencies();
    PackingBinding().dependencies();
    EsparragosBinding().dependencies();
    HerramientasBinding().dependencies();
    AsistenciaBinding().dependencies();
    BuscarLineaMesaBinding().dependencies();

    Get.lazyPut<NavigationController>(() => NavigationController());
  }
}
