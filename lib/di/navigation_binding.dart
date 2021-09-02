
import 'package:flutter_tareo/ui/pages/navigation/navigation_controller.dart';
import 'package:get/get.dart';

class NavigationBinding extends Bindings{


  @override
  void dependencies() {

    Get.lazyPut<NavigationController>(() => NavigationController());
    
  }

}