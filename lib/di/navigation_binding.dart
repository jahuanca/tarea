
import 'package:flutter_tareo/di/home_binding.dart';
import 'package:flutter_tareo/di/tareas_binding.dart';
import 'package:flutter_tareo/ui/pages/navigation/navigation_controller.dart';
import 'package:get/get.dart';

class NavigationBinding extends Bindings{


  @override
  void dependencies() {

    HomeBinding().dependencies();
    TareasBinding().dependencies();

    Get.lazyPut<NavigationController>(() => NavigationController());
    
  }

}